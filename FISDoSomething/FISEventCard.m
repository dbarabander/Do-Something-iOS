//
//  FISPlaceCard.m
//

#import "FISEventCard.h"
#import "Campaign.h"
#import "FISAppFont.h"

@interface FISEventCard ()
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;

@end

@implementation FISEventCard

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.clipsToBounds = YES;
    }
    return self;
}

#pragma mark Properties

- (void)setCampaign:(Campaign *)campaign
{
    _campaign = campaign;
    self.nameLabel.text = campaign.title;
    self.nameLabel.font = appFont(23);
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.backgroundColor =[UIColor colorWithRed:0.867 green:0.867 blue:0.867 alpha:1.0];
}

- (void)setImageView:(UIImageView *)imageView
{
    _imageView = imageView;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
}

- (UIImage *)backgroundImage
{
    return _imageView.image;
}

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    _imageView.image = backgroundImage;
}


@end
