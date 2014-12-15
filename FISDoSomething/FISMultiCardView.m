//
//  FISMultiCardView.m
//

#import "FISMultiCardView.h"

@interface FISMultiCardView () <UIGestureRecognizerDelegate>

@property (nonatomic) BOOL determinedRotationDirection;
@property (nonatomic) BOOL isRotatingUp;
@property (nonatomic) BOOL isSwiping;

@property (nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic) UITapGestureRecognizer *tapGestureRecognizer;

@property (nonatomic) UIButton *yesButton;
@property (nonatomic) UIButton *noButton;

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

        _yesButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_yesButton setBackgroundImage:[UIImage imageNamed:@"yesIcon"] forState:UIControlStateNormal];
        [_yesButton addTarget:self action:@selector(didTapYesButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_yesButton];

        _noButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_noButton setBackgroundImage:[UIImage imageNamed:@"noIcon"] forState:UIControlStateNormal];
        [_noButton addTarget:self action:@selector(didTapNoButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_noButton];
    }
    return self;
}

- (void)dealloc
{
    [self.frontmostCardView removeGestureRecognizer:_tapGestureRecognizer];
    [self.frontmostCardView removeGestureRecognizer:_panGestureRecognizer];
    _tapGestureRecognizer.delegate = nil;
    _panGestureRecognizer.delegate = nil;
}

- (void)layoutSubviews
{
    const CGFloat buttonGap = CGRectGetWidth(self.bounds) / 10.0f;

    CGSize yesButtonSize = [_yesButton backgroundImageForState:UIControlStateNormal].size;
    CGSize noButtonSize = [_noButton backgroundImageForState:UIControlStateNormal].size;

    CGFloat yPosition = self.center.y + ([self.delegate preferredSizeForPrimaryCardView].height + buttonGap) / 2.0f;
    _noButton.frame = (CGRect){
        .origin.x = self.center.x - noButtonSize.width - buttonGap / 2.0f,
        .origin.y = yPosition,
        .size = noButtonSize
    };
    _yesButton.frame = (CGRect){
        .origin.x = self.center.x + buttonGap / 2.0f,
        .origin.y = yPosition,
        .size = yesButtonSize
    };
}

#pragma mark FISMultiCardView

- (void)reloadCardViews
{
    __block UIView *previousView;
    [self _enumerateViewsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        view.userInteractionEnabled = YES;

        view.layer.cornerRadius = 5;
        view.layer.masksToBounds = YES;
        view.layer.borderWidth = 1.f;
        view.layer.borderColor = [UIColor colorWithRed:0.08f green:0.25f blue:0.31f alpha:1.0f].CGColor;

        [self _setPositionForView:view offset:idx];
        [self addSubview:view];
        [self insertSubview:view belowSubview:previousView];

        previousView = view;
    }];

    [self.frontmostCardView addGestureRecognizer:_panGestureRecognizer];
    [self.frontmostCardView addGestureRecognizer:_tapGestureRecognizer];
}

- (UIView *)frontmostCardView
{
    return ([self.dataSource numberOfCardViewsForMultiCardView:self]) ? [self.dataSource multiCardView:self cardViewForIndex:0] : nil;
}

- (void)didTapYesButton:(id)sender
{
    [self _swipeViewInDirection:FISSwipeDirectionRight];
}

- (void)didTapNoButton:(id)sender
{
    [self _swipeViewInDirection:FISSwipeDirectionLeft];
}

- (void)_swipeViewInDirection:(FISSwipeDirection)swipeDirection
{
    if (_isSwiping) {
        return;
    }
    _isSwiping = YES;

    UIView *frontmostCardView = self.frontmostCardView;

    [frontmostCardView removeGestureRecognizer:_panGestureRecognizer];
    [frontmostCardView removeGestureRecognizer:_tapGestureRecognizer];

    [UIView animateWithDuration:.2 delay:0 options: UIViewAnimationOptionCurveEaseIn animations:^{
        CGFloat newX;
        switch (swipeDirection) {
            case FISSwipeDirectionLeft:
                newX = -[self.delegate preferredSizeForPrimaryCardView].width * 1.5f;
                break;
            case FISSwipeDirectionRight:
                newX = CGRectGetWidth(self.bounds) + [self.delegate preferredSizeForPrimaryCardView].width * 1.5f;
                break;
        }

        frontmostCardView.frame = CGRectMake(newX, -100, frontmostCardView.frame.size.width, frontmostCardView.frame.size.height);
        CGFloat rotationAngle =  [self _rotationAngleForHorizontalTranslation:newX];
        frontmostCardView.layer.transform = CATransform3DMakeRotation(rotationAngle, 0.f, 0.f, 1.f);

        [self _enumerateViewsUsingBlock:^(UIView *currentView, NSUInteger idx, BOOL *stop) {
            if (frontmostCardView != currentView) {
                [self _setPositionForView:currentView offset:idx - 1.0f];
            }
        }];
    } completion:^(BOOL finished) {
        [self _didSwipeFrontmostCardView:frontmostCardView inDirection:swipeDirection];
        _isSwiping = NO;
    }];
}

#pragma mark Private

- (void)_setFrontmostCardViewCenter:(CGPoint)newCenter
{
    CGFloat xDistance = newCenter.x - self.center.x;
    CGFloat yDistance = newCenter.y - self.center.y;

    self.frontmostCardView.center = newCenter;

    [self _enumerateViewsUsingBlock:^(UIView *currentView, NSUInteger idx, BOOL *stop) {
        if (self.frontmostCardView != currentView) {
            CGFloat percent = (CGFloat)MIN((fabs(xDistance) + fabs(yDistance)) / 200.f, 1.f);
            [self _setPositionForView:currentView offset:idx - percent];
        }
    }];

    CGFloat rotationAngle = [self _rotationAngleForHorizontalTranslation:xDistance];

    if (fabs(rotationAngle) > 0.f) {
        // If we already started rotating, don't change.
        _determinedRotationDirection = YES;
    }

    self.frontmostCardView.layer.transform = CATransform3DMakeRotation(rotationAngle, 0.f, 0.f, 1.f);
}

- (void)_didSwipeFrontmostCardView:(UIView *)frontmostCardView inDirection:(FISSwipeDirection)swipeDirection
{
    [frontmostCardView removeGestureRecognizer:_panGestureRecognizer];
    [frontmostCardView removeGestureRecognizer:_tapGestureRecognizer];
    [frontmostCardView removeFromSuperview];

    [self.delegate multiCardView:self didSwipeViewInDirection:swipeDirection];

    [self.frontmostCardView addGestureRecognizer:_panGestureRecognizer];
    [self.frontmostCardView addGestureRecognizer:_tapGestureRecognizer];
}

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
            if (yDistance != 0.f && !_determinedRotationDirection) {
                _determinedRotationDirection = YES;
                _isRotatingUp = yDistance < 0;
            }
            [self _setFrontmostCardViewCenter:CGPointMake(center.x + xDistance, center.y + yDistance)];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            if (fabs(xDistance) > 100.f) {
                CGFloat centerX;
                if (xDistance > 0.f) {
                    centerX = CGRectGetWidth(self.bounds) + [self.delegate preferredSizeForPrimaryCardView].width;
                } else {
                    centerX = -[self.delegate preferredSizeForPrimaryCardView].width;
                }
                CGFloat rotationAngle = [self _rotationAngleForHorizontalTranslation:centerX - center.x];
                [UIView animateWithDuration:0.2f animations:^{
                    view.center = CGPointMake(centerX, center.y + yDistance * 5.f);
                    view.layer.transform = CATransform3DMakeRotation(rotationAngle, 0.f, 0.f, 1.f);
                } completion:^(BOOL finished) {
                    FISSwipeDirection direction = (xDistance > 0) ? FISSwipeDirectionRight : FISSwipeDirectionLeft;
                    [self _didSwipeFrontmostCardView:view inDirection:direction];
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