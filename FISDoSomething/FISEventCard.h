//
//  FISPlaceCard.h
//

#import <UIKit/UIKit.h>

@class FISCampaign;

@interface FISEventCard : UIView

// Need to expose for custom view controller animation. Is there a better way to do this?
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) NSString *name;
@property (nonatomic) UIImage *backgroundImage;
@property (strong, nonatomic) FISCampaign *campaign;

@end
