//
//  FISCustomEventTableViewCell.m
//  FISDoSomething
//
//  Created by Karim Mourra on 11/25/14.
//  Copyright (c) 2014 Flatiron iOS 003. All rights reserved.
//

#import "FISCustomEventTableViewCell.h"
#import "Campaign.h"

@interface FISCustomEventTableViewCell()

@property (strong, nonatomic) UIImageView *campaignImageView;
@property (strong, nonatomic) UIView *textView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *valuePropositionLabel;
@property (strong, nonatomic) UIView *gradientView;
@property (strong, nonatomic) UILabel *staffPickLabel;
@property (strong, nonatomic) CAGradientLayer *gradient;
@property (strong, nonatomic) NSMutableDictionary *campaignImages;

@end

@implementation FISCustomEventTableViewCell



- (void)awakeFromNib {
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"CampaignName";
    _campaignImageView = [[UIImageView alloc] init];
    _campaignImageView.image = [UIImage imageNamed:@"image1"];
    _textView = [[UIView alloc] init];
    _valuePropositionLabel = [[UILabel alloc] init];
    _valuePropositionLabel.text = @"Value Proposition";
    _gradientView = [[UIView alloc] init];
    _staffPickLabel = [[UILabel alloc] init];
    _gradient = [CAGradientLayer layer];
    _gradient.colors = @[(id)[UIColor clearColor].CGColor, (id)[UIColor colorWithWhite:0.0 alpha:0.5].CGColor];
    _campaignImages = [NSMutableDictionary new];
}

- (void)setCampaign:(Campaign *)campaign
{
    _campaign = campaign;
    _titleLabel.text = campaign.title;
    UIImage *image = [self.campaignImages objectForKey:campaign.nid];
    if (image) {
        _campaignImageView.image = image;
    }
    else {
        [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
            UIImage *imageToDisplay = [UIImage imageWithData:campaign.landscapeImage];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.campaignImages setObject:imageToDisplay forKey:campaign.nid];
                _campaignImageView.image = imageToDisplay;
            }];
        }];
    }
    _valuePropositionLabel.text = campaign.callToAction;
    _gradientView = [[UIView alloc] init];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self layoutSubviewsOnCell];
    }
    return self;
}

- (void)layoutSubviewsOnCell
{
    // Cell height
    CGFloat cellHeight = self.contentView.frame.size.height;
    
    // Campaign Image View
    self.campaignImageView.frame =
    CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, cellHeight);
    self.campaignImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.campaignImageView.clipsToBounds = YES;
    [self.contentView addSubview:self.campaignImageView];
    
    //Gradient View
    self.gradientView.frame = self.campaignImageView.frame;
    self.gradient.frame = self.gradientView.frame;
    [self.gradientView.layer insertSublayer:self.gradient atIndex:0];
    [self.campaignImageView addSubview:self.gradientView];
    
    // Text View
    self.textView.frame = CGRectMake(8, self.campaignImageView.frame.size.height * 0.75, self.campaignImageView.frame.size.width - 16, self.campaignImageView.frame.size.height * 0.25);
    [self.gradientView addSubview:self.textView];
    
    // Title Label
    self.titleLabel.frame = CGRectMake(0, 0, self.textView.frame.size.width, self.textView.frame.size.height*0.5);
    self.titleLabel.font = [UIFont fontWithName:@"ProximaNovaA-Bold" size:23.0];
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    [self.textView addSubview:self.titleLabel];
    
    // Value Proposition Label
    self.valuePropositionLabel.frame = CGRectMake(0, self.textView.frame.size.height*0.5, self.textView.frame.size.width, self.textView.frame.size.height * 0.5);
    self.valuePropositionLabel.font = [UIFont fontWithName:@"ProximaNovaA-Bold" size:23.0];
    self.valuePropositionLabel.adjustsFontSizeToFitWidth = YES;
    self.valuePropositionLabel.textColor = [UIColor whiteColor];
    self.valuePropositionLabel.backgroundColor = [UIColor clearColor];
    self.valuePropositionLabel.numberOfLines = 0;
    [self.textView addSubview:self.valuePropositionLabel];
    
    // Staff Pick
    if (self.campaign.isStaffPick) {
        self.staffPickLabel.frame = CGRectMake(0, 0, 50, 20);
        self.staffPickLabel.backgroundColor = [UIColor colorWithRed:252.0/255.0 green:209.0/255.0 blue:23.0/255.0 alpha:1.0];
        self.staffPickLabel.text = @"STAFF PICK";
        self.staffPickLabel.font = [UIFont fontWithName:@"ProximaNovaA-Bold" size:23.0];
        self.staffPickLabel.adjustsFontSizeToFitWidth = YES;
        [self.gradientView addSubview:self.staffPickLabel];
    }
    else {
        [self.staffPickLabel removeFromSuperview];
    }
}

- (void)layoutSubviews
{
    [self layoutSubviewsOnCell];
}

- (void)prepareForReuse
{
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




@end
