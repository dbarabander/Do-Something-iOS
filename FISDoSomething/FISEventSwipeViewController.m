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
    NSString *relationKey = (direction == FISSwipeDirectionRight) ? @"likes" : @"dislikes";
    if ([relationKey isEqualToString:@"likes"]) {
        FISCampaign *currentCampaign = [[_swipeableViews firstObject] campaign];
        NSLog(@"calling from here");
        [self.delegate didLikeCampaign:currentCampaign];
    }
    
    [_swipeableViews removeObjectAtIndex:0];
    static NSUInteger imageBatchCount = 0;
    static NSUInteger swipedCount = 0;
    swipedCount++;
    NSLog(@"Swiped Count: %lu",(unsigned long)swipedCount);
    if (![_swipeableViews count] || !(swipedCount % 7 == 0)) {
        return ;
    }
    _multiCardView.isLoading = YES;
    [SVProgressHUD show];
    if (self.downloadIndex < [[FISDataStore sharedDataStore].campaigns count]) {
        NSLog(@"Download Index: %lu", self.downloadIndex);
        for (NSUInteger i = 0; i < 7; i++) {
            
            [[FISDataStore sharedDataStore] getImageForCampaign:[FISDataStore sharedDataStore].campaigns[self.downloadIndex] inLandscape:NO withCompletionHandler:^(UIImage *image) {
                NSLog(@"Image batch count: %lu", imageBatchCount);
                
                imageBatchCount++;
                
                if (imageBatchCount == 7) {
                    __block int j = 0;
                    for (NSUInteger i = self.downloadIndex - 7; i < self.downloadIndex; i++) {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            FISEventCard * eventCardToLoadImage = _swipeableViews[j];
                            eventCardToLoadImage.imageView.image = [[FISDataStore sharedDataStore].campaigns[i] squareImage];
                            [_multiCardView reloadCardViews];
                            j++;
                        }];
                    }
                    [SVProgressHUD dismiss];
                    _multiCardView.isLoading = NO;
                    imageBatchCount = 0;
                }
            }];
            self.downloadIndex++;
        }
    }
}

- (void)multiCardView:(FISMultiCardView *)multiCardView didTapCardView:(UIView *)cardView
{
    _blurEffectView.alpha = 0.0f;
    _blurEffectView.frame = CGRectMake(cardView.bounds.origin.x, cardView.bounds.origin.y, [self preferredSizeForPrimaryCardView].width, [self preferredSizeForPrimaryCardView].height);
    [cardView addSubview:_blurEffectView];

    static BOOL didLoad = NO;
    FISEventDetailView *detailView;
    if (!didLoad) {
        detailView = [[[NSBundle mainBundle] loadNibNamed:@"FISEventDetailView" owner:self options:nil] firstObject];
        didLoad = YES;
    }
    detailView.valueProposition = [[[_swipeableViews firstObject] campaign]valueProposition];
    NSLog(@"%@",detailView.valueProposition);
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
    _multiCardView.isLoading = YES;
    [SVProgressHUD show];
    [[FISDataStore sharedDataStore] getAllActiveCampaignsWithCompletionHandler:^{
        for (FISCampaign *campaign in [FISDataStore sharedDataStore].campaigns) {
            
            FISEventCard *eventCard =
            [[[NSBundle mainBundle] loadNibNamed:@"FISEventCard"
                                           owner:self
                                         options:nil] firstObject];
            eventCard.campaign = campaign;
            [_swipeableViews addObject:eventCard];
        }
        for (NSUInteger i = 0; i < 7; i++) {
            [[FISDataStore sharedDataStore] getImageForCampaign:[[FISDataStore sharedDataStore] campaigns][i] inLandscape:NO withCompletionHandler:^(UIImage *image) {
                FISEventCard *firstCard = _swipeableViews[i];
                firstCard.imageView.image = image;
                [_multiCardView reloadCardViews];
                self.downloadIndex++;
                if (self.downloadIndex == 6) {
                    [SVProgressHUD dismiss];
                    _multiCardView.isLoading = NO;
                }
            }];
        }
    }];
}

@end
