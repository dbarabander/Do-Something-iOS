//
//  FISMultiCardView.m
//

#import "FISMultiCardView.h"

@interface FISMultiCardView () <UIGestureRecognizerDelegate>

@property (nonatomic) BOOL determinedRotationDirection;
@property (nonatomic) BOOL isRotatingUp;

@property (nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic) UITapGestureRecognizer *tapGestureRecognizer;

@end

#pragma mark -

@implementation FISMultiCardView

#pragma mark UIView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_panned:)];
        [_panGestureRecognizer setMinimumNumberOfTouches:1];
        [_panGestureRecognizer setMaximumNumberOfTouches:1];
        _panGestureRecognizer.delegate = self;

        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tapped:)];
        _tapGestureRecognizer.delegate = self;
    }
    return self;
}

#pragma mark FISMultiCardView

- (void)reloadCardViews
{
    [self _enumerateViewsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        view.userInteractionEnabled = YES;

        view.layer.borderWidth = 1.f;
        view.layer.borderColor = [UIColor lightGrayColor].CGColor;

        [self _setPositionForView:view offset:idx];
        [self addSubview:view];
        [self sendSubviewToBack:view];
    }];

    [self.frontmostCardView addGestureRecognizer:_panGestureRecognizer];
    [self.frontmostCardView addGestureRecognizer:_tapGestureRecognizer];
}

- (UIView *)frontmostCardView
{
    return ([self.dataSource numberOfCardViewsForMultiCardView:self]) ? [self.dataSource multiCardView:self cardViewForIndex:0] : nil;
}

#pragma mark Private

- (void)_panned:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint center = self.center;
    UIView *view = [gestureRecognizer view];

    CGFloat xDistance = [gestureRecognizer translationInView:self].x;
    CGFloat yDistance = [gestureRecognizer translationInView:self].y;

    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            _isRotatingUp = (yDistance < 0.f);
            break;
        }
        case UIGestureRecognizerStateChanged: {
            if (fabs(yDistance) > 0.f && !_determinedRotationDirection) {
                _determinedRotationDirection = YES;
                _isRotatingUp = yDistance < 0;
            }
            view.center = CGPointMake(center.x + xDistance, center.y + yDistance);

            [self _enumerateViewsUsingBlock:^(UIView *currentView, NSUInteger idx, BOOL *stop) {
                if (view != currentView) {
                    CGFloat percent = (CGFloat)MIN((fabs(xDistance) + fabs(yDistance)) / 200.f, 1.f);
                    [self _setPositionForView:currentView offset:idx - percent];
                }
            }];

            CGFloat rotationAngle = [self _rotationAngleForHorizontalTranslation:xDistance];

            if (fabs(rotationAngle) > 0.f) {
                // If we already started rotating, don't change.
                _determinedRotationDirection = YES;
            }

            view.layer.transform = CATransform3DMakeRotation(rotationAngle, 0.f, 0.f, 1.f);

            break;
        }
        case UIGestureRecognizerStateEnded: {
            if (fabs(xDistance) > 100.f) {
                [UIView animateWithDuration:0.2f animations:^{
                    CGFloat centerX;
                    if (xDistance > 0.f) {
                        centerX = CGRectGetWidth(self.bounds) + [self.delegate preferredSizeForPrimaryCardView].width;
                    } else {
                        centerX = -[self.delegate preferredSizeForPrimaryCardView].width;
                    }
                    CGFloat rotationAngle = [self _rotationAngleForHorizontalTranslation:centerX - center.x];
                    view.center = CGPointMake(centerX, center.y + yDistance * 5.f);
                    view.layer.transform = CATransform3DMakeRotation(rotationAngle, 0.f, 0.f, 1.f);
                } completion:^(BOOL finished) {
                    [view removeGestureRecognizer:_panGestureRecognizer];
                    [view removeGestureRecognizer:_tapGestureRecognizer];
                    [view removeFromSuperview];

                    FISSwipeDirection direction = (xDistance > 0) ? FISSwipeDirectionRight : FISSwipeDirectionLeft;
                    [self.delegate multiCardView:self didSwipeViewInDirection:direction];
                    [self.frontmostCardView addGestureRecognizer:_panGestureRecognizer];
                    [self.frontmostCardView addGestureRecognizer:_tapGestureRecognizer];
                }];
            } else {
                [self _resetViewPositions];
            }
            break;
        }
        case UIGestureRecognizerStatePossible:
            break;
        case UIGestureRecognizerStateCancelled:
            break;
        case UIGestureRecognizerStateFailed:
            break;
    }
}

- (void)_tapped:(UIPanGestureRecognizer *)gestureRecognizer
{
    [self.delegate multiCardView:self didTapCardView:gestureRecognizer.view];
}

- (void)_setPositionForView:(UIView *)view offset:(CGFloat)offset
{
    CGFloat inset = MIN(offset, 2.f) * 14.f;
    CGSize size = [self.delegate preferredSizeForPrimaryCardView];
    view.bounds = (CGRect){
        .origin = CGPointZero,
        .size.width = MIN(size.width, CGRectGetWidth(self.bounds)) - inset,
        .size.height = MIN(size.height, CGRectGetHeight(self.bounds)) - inset
    };

    view.center = CGPointMake(self.center.x, self.center.y + MIN(offset, 2.f) * 11.f);
}

- (void)_resetViewPositions
{
    _determinedRotationDirection = NO;

    [UIView animateWithDuration:0.2 animations:^{
        self.frontmostCardView.layer.transform = CATransform3DMakeRotation(0.f, 0.f, 0.f, 1.f);
        [self _enumerateViewsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
            [self _setPositionForView:view offset:idx];
        }];
    }];
}

- (void)_enumerateViewsUsingBlock:(void(^)(UIView *view, NSUInteger idx, BOOL *stop))block
{
    NSUInteger numberOfViews = [self.dataSource numberOfCardViewsForMultiCardView:self];
    for (NSUInteger idx = 0; idx < numberOfViews; idx++) {
        UIView *view = [self.dataSource multiCardView:self cardViewForIndex:idx];

        BOOL stop = NO;
        block(view, idx, &stop);

        if (stop) {
            break;
        }
    }
}

- (CGFloat)_rotationAngleForHorizontalTranslation:(CGFloat)horizontalTranslation
{
    CGFloat rotationStrength = MIN(horizontalTranslation / 320.f, 1.f);
    CGFloat rotationAngle = (CGFloat)(2.f * M_PI * rotationStrength / 16.f);
    return (_isRotatingUp) ? -rotationAngle : rotationAngle;
}

@end
