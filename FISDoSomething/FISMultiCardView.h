//
//  FISMultiCardView.h
//

#import <UIKit/UIKit.h>

@class FISMultiCardView;

typedef NS_ENUM(NSUInteger, FISSwipeDirection) {
  FISSwipeDirectionLeft,
  FISSwipeDirectionRight
};

@protocol FISMultiCardViewDataSource <NSObject>

- (UIView *)multiCardView:(FISMultiCardView *)multiCardView cardViewForIndex:(NSUInteger)index;
- (NSUInteger)numberOfCardViewsForMultiCardView:(FISMultiCardView *)multiCardView;

@end

@protocol FISMultiCardViewDelegate <NSObject>

- (CGSize)preferredSizeForPrimaryCardView;

@optional
- (void)multiCardView:(FISMultiCardView *)multiCardView didSwipeViewInDirection:(FISSwipeDirection)direction;
- (void)multiCardView:(FISMultiCardView *)multiCardView didTapCardView:(UIView *)cardView;

@end

@interface FISMultiCardView : UIView

@property (nonatomic, weak) id<FISMultiCardViewDataSource> dataSource;
@property (nonatomic, weak) id<FISMultiCardViewDelegate> delegate;
@property (nonatomic, readonly) UIView *frontmostCardView;

- (void)reloadCardViews;

@end
