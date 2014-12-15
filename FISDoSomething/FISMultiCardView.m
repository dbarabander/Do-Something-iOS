//
//  FISMultiCardView.m
//

#import "FISMultiCardView.h"
#import "FISAppFont.h"

#define yesColor [UIColor colorWithRed:0.6f green:0.75f blue:0.32f alpha:1.0f]
#define noColor [UIColor colorWithRed:0.93f green:0.18f blue:0.23f alpha:1.0f]

@interface FISMultiCardView () <UIGestureRecognizerDelegate>

@property (nonatomic) BOOL determinedRotationDirection;
@property (nonatomic) BOOL isRotatingUp;
@property (nonatomic) BOOL isSwiping;

@property (nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic) UITapGestureRecognizer *tapGestureRecognizer;

@property (strong, nonatomic) UIButton *yesButton;
@property (strong, nonatomic) UIButton *noButton;

@end


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
        
        _yesButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_yesButton addTarget:self
                       action:@selector(didTapYesButton:)
             forControlEvents:UIControlEventTouchUpInside];
        
        [_yesButton setTitle:@"✓SURE" forState:UIControlStateNormal];
        [self addSubview:_yesButton];
        
        _noButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_noButton addTarget:self
                      action:@selector(didTapNoButton:)
            forControlEvents:UIControlEventTouchUpInside];
        
        [_noButton setTitle:@"✕ NAH!" forState:UIControlStateNormal];
        [self addSubview:_noButton];
        
        // Button styling
        _yesButton.backgroundColor = [UIColor whiteColor];
        _noButton.backgroundColor = [UIColor whiteColor];
        [_yesButton setTitleColor:yesColor forState:UIControlStateNormal];
        [_noButton setTitleColor:noColor forState:UIControlStateNormal];
        _yesButton.titleLabel.font = appFont(23);
        _noButton.titleLabel.font = appFont(23);
        _yesButton.layer.cornerRadius = 29.0;
        _noButton.layer.cornerRadius = 29.0;
        _yesButton.layer.borderWidth = 3.0;
        _noButton.layer.borderWidth = 3.0;
        _yesButton.layer.borderColor = yesColor.CGColor;
        _noButton.layer.borderColor = noColor.CGColor;
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
    const CGFloat heightGap = CGRectGetHeight(self.bounds) / 20.0f;
    
    CGSize noButtonSize = CGSizeMake(115.0, 55.0);
    CGSize yesButtonSize = CGSizeMake(115.0, 55.0);
    

    CGFloat yPosition = self.center.y + ([self.delegate preferredSizeForPrimaryCardView].height + heightGap) / 2.0f;
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
                [self animateNoButton];
                newX = -[self.delegate preferredSizeForPrimaryCardView].width * 1.5f;
                break;
            case FISSwipeDirectionRight:
                [self animateYesButton];
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

- (void)animateNoButton
{
    [UIView animateWithDuration:0.05 animations:^{
        self.noButton.backgroundColor = noColor;
        [self.noButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.05 animations:^{
            self.noButton.backgroundColor = [UIColor whiteColor];
            [self.noButton setTitleColor:noColor forState:UIControlStateNormal];
        } completion:nil];
    }];
}

- (void)animateYesButton
{
    [UIView animateWithDuration:0.05 animations:^{
        self.yesButton.backgroundColor = yesColor;
        [self.yesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.05 animations:^{
            self.yesButton.backgroundColor = [UIColor whiteColor];
            [self.yesButton setTitleColor:yesColor forState:UIControlStateNormal];
        } completion:nil];
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
    NSLog(@"%f", xDistance);
    
    CGFloat normalizedX = fabsf(xDistance)/(self.frame.size.width/2);
    
    // Button color change on motion
    FISSwipeDirection direction = (xDistance > 0) ? FISSwipeDirectionRight : FISSwipeDirectionLeft;
    if (direction == FISSwipeDirectionRight) {
        self.noButton.backgroundColor = [UIColor whiteColor];
        self.yesButton.backgroundColor = [self colorFromColor:[UIColor whiteColor] toColor:yesColor percent:normalizedX];
        UIColor *titleColor = [self colorFromColor:yesColor toColor:[UIColor whiteColor] percent:normalizedX];
        [self.yesButton setTitleColor:titleColor forState:UIControlStateNormal];
    }
    else {
        self.yesButton.backgroundColor = [UIColor whiteColor];
        self.noButton.backgroundColor = [self colorFromColor:[UIColor whiteColor] toColor:noColor percent:normalizedX];
        UIColor *titleColor = [self colorFromColor:noColor toColor:[UIColor whiteColor] percent:normalizedX];
        [self.noButton setTitleColor:titleColor forState:UIControlStateNormal];
    }

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
            self.yesButton.backgroundColor = [UIColor whiteColor];
            self.noButton.backgroundColor = [UIColor whiteColor];
            [self.yesButton setTitleColor:yesColor forState:UIControlStateNormal];
            [self.noButton setTitleColor:noColor forState:UIControlStateNormal];
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

- (UIColor *)colorFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor percent:(float)percent
{
    float dec = percent;
    CGFloat fRed, fBlue, fGreen, fAlpha;
    CGFloat tRed, tBlue, tGreen, tAlpha;
    CGFloat red, green, blue, alpha;
    
    if(CGColorGetNumberOfComponents(fromColor.CGColor) == 2) {
        [fromColor getWhite:&fRed alpha:&fAlpha];
        fGreen = fRed;
        fBlue = fRed;
    }
    else {
        [fromColor getRed:&fRed green:&fGreen blue:&fBlue alpha:&fAlpha];
    }
    if(CGColorGetNumberOfComponents(toColor.CGColor) == 2) {
        [toColor getWhite:&tRed alpha:&tAlpha];
        tGreen = tRed;
        tBlue = tRed;
    }
    else {
        [toColor getRed:&tRed green:&tGreen blue:&tBlue alpha:&tAlpha];
    }
    
    red = (dec * (tRed - fRed)) + fRed;
    blue = (dec * (tBlue - fBlue)) + fBlue;
    green = (dec * (tGreen - fGreen)) + fGreen;
    alpha = (dec * (tAlpha - fAlpha)) + fAlpha;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
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