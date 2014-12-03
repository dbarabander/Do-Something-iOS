//
//  FISEventDetailView.m
//  FISDoSomething
//
//  Created by DANIEL BARABANDER on 11/25/14.
//  Copyright (c) 2014 Flatiron iOS 003. All rights reserved.
//

#import "FISEventDetailView.h"

@interface FISEventDetailView()
@property (weak, nonatomic) IBOutlet UILabel *valuePropositionLabel;
@property (strong, nonatomic) UITapGestureRecognizer *detailViewTapped;
@end

@implementation FISEventDetailView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.clipsToBounds = YES;
        _detailViewTapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetailView:)];
        [self addGestureRecognizer:_detailViewTapped];

    }
    return self;
}

- (void)setValueProposition:(NSString *)valueProposition
{
    _valueProposition = valueProposition;
    self.valuePropositionLabel.text = valueProposition;
}


- (void)tapDetailView:(UIGestureRecognizer *)gestureRecognizer
{
    [self.delegate didTapEventDetailView:self];
}

@end
