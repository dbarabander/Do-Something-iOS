//
//  FISEventDetailView.h
//  FISDoSomething
//
//  Created by DANIEL BARABANDER on 11/25/14.
//  Copyright (c) 2014 Flatiron iOS 003. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FISEventDetailView;

@protocol eventDetailViewDelegate <NSObject>

- (void)didTapEventDetailView:(FISEventDetailView *)detailView;

@end

@interface FISEventDetailView : UIView
@property (nonatomic) NSString *valueProposition;
@property (nonatomic) id<eventDetailViewDelegate>delegate;
@end
