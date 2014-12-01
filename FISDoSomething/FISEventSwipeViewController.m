//
//  FISVenueSwipeViewController.m
//

#define NUMBER_OF_EVENTS 10

#import "FISMultiCardView.h"
#import "FISEventCard.h"
#import "FISEventSwipeViewController.h"
#import "FISEventDetailView.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "FISDataStore.h"
#import "FISCampaign.h"

@interface FISEventSwipeViewController () <FISMultiCardViewDataSource, FISMultiCardViewDelegate>

@property (nonatomic) NSUInteger downloadIndex;

@end

@implementation FISEventSwipeViewController
{
    NSMutableArray *_swipeableViews;
    FISMultiCardView *_multiCardView;
    UIVisualEffectView *_blurEffectView;
}

- (instancetype)init
{
    if (self = [super initWithNibName:nil bundle:nil]) {
        _swipeableViews = [NSMutableArray array];
        _multiCardView = [[FISMultiCardView alloc] init];
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        [self fetchEvents];
    }
    return self;
}

#pragma mark UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.downloadIndex = 0;
    
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    UIImage *image = [UIImage imageNamed:@"Do_Something_Logo"];
    navItem.titleView = [[UIImageView alloc] initWithImage:image];
    navigationBar.items = @[navItem];
    [self.view addSubview:navigationBar];

    self.view.backgroundColor = [UIColor colorWithRed:(248/255.0) green:(248/255.0) blue:(248/255.0) alpha:1];
    _multiCardView.frame = self.view.bounds;
    _multiCardView.delegate = self;
    _multiCardView.dataSource = self;
    [self.view addSubview:_multiCardView];
    [_multiCardView reloadCardViews];
}

#pragma mark FISEventSwipeViewControllerDataSource

- (NSUInteger)numberOfCardViewsForMultiCardView:(FISMultiCardView *)multiCardView
{
    return [_swipeableViews count];
}

- (UIView *)multiCardView:(FISMultiCardView *)multiCardView cardViewForIndex:(NSUInteger)index
{
    return [_swipeableViews objectAtIndex:index];
}

#pragma mark FISEventSwipeViewControllerDelegate

- (CGSize)preferredSizeForPrimaryCardView
{
    CGFloat width = CGRectGetWidth(self.view.bounds) * 0.9;
    CGFloat height = 4.0 / 3.0 * width;
    return CGSizeMake(width, height - 15);
}

- (void)multiCardView:(FISMultiCardView *)multiCardView didSwipeViewInDirection:(FISSwipeDirection)direction
{
    if (![_swipeableViews count]) {
        return ;
    }
    [_swipeableViews removeObjectAtIndex:0];
    if (self.downloadIndex < [[FISDataStore sharedDataStore].campaigns count]) {
        NSLog(@"%lu", self.downloadIndex);
        [[FISDataStore sharedDataStore] getImageForCampaign:[FISDataStore sharedDataStore].campaigns[self.downloadIndex++] inLandscape:NO withCompletionHandler:^(UIImage *image) {
            FISEventCard * eventCardToLoadImage = _swipeableViews[2];
            eventCardToLoadImage.imageView.image = image;
            [_multiCardView reloadCardViews];
        }];
    }
}

- (void)multiCardView:(FISMultiCardView *)multiCardView didTapCardView:(UIView *)cardView
{
    _blurEffectView.alpha = 0.0f;
    _blurEffectView.frame = CGRectMake(cardView.bounds.origin.x, cardView.bounds.origin.y, [self preferredSizeForPrimaryCardView].width, [self preferredSizeForPrimaryCardView].height);
    [cardView addSubview:_blurEffectView];

    FISEventDetailView *detailView = [[[NSBundle mainBundle] loadNibNamed:@"FISEventDetailView" owner:self options:nil] firstObject];
     detailView.frame = _blurEffectView.frame;


    [UIView animateWithDuration:0.7f animations:^{
        _blurEffectView.alpha = 0.90f;
        [_blurEffectView addSubview: detailView];
    }];

    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapDetailView:)];
    [detailView addGestureRecognizer:singleFingerTap];
}

- (void)tapDetailView:(UITapGestureRecognizer *)recognizer
{
    [UIView animateWithDuration:0.7f animations:^{
        _blurEffectView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [_blurEffectView removeFromSuperview];
    }];
}


#pragma mark Private

- (void)fetchEvents
{
    [SVProgressHUD show];
    [[FISDataStore sharedDataStore] getAllActiveCampaignsWithCompletionHandler:^{
        for (FISCampaign *campaign in [FISDataStore sharedDataStore].campaigns) {
            
            FISEventCard *eventCard =
            [[[NSBundle mainBundle] loadNibNamed:@"FISEventCard"
                                           owner:self
                                         options:nil] firstObject];
            eventCard.campaign = campaign;
            [_swipeableViews addObject:eventCard];
            
            if (self.downloadIndex < 3) {
                self.downloadIndex++;
                [[FISDataStore sharedDataStore] getImageForCampaign:campaign inLandscape:NO withCompletionHandler:^(UIImage *image) {
                    eventCard.imageView.image = image;
                }];
            }
        }
        [SVProgressHUD dismiss];
        [_multiCardView reloadCardViews];
    }];
}

@end
