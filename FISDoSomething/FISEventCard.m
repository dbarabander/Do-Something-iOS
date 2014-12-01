//
//  FISPlaceCard.m
//

#import "FISEventCard.h"
#import "FISCampaign.h"

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

- (void)setCampaign:(FISCampaign *)campaign
{
    _campaign = campaign;
    self.nameLabel.text = campaign.title;
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
