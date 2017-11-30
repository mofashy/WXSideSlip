//
//  WXTimelineLayout.h
//  WXSideSlip
//
//  Created by macOS on 2017/10/9.
//  Copyright © 2017年 WX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WXTimelineLayout : NSObject
@property (assign, nonatomic) CGRect frame;

///MARK: Infos
@property (assign, nonatomic) CGRect portraitFrame;
@property (assign, nonatomic) CGRect nameFrame;
@property (assign, nonatomic) CGRect timeFrame;

///MARK: Contents
@property (assign, nonatomic) CGRect textFrame;
@property (strong, nonatomic) NSArray *imageFrames;

///MARK: Actions
@property (assign, nonatomic) CGRect likeFrame;
@property (assign, nonatomic) CGRect replyFrame;
@property (assign, nonatomic) CGRect shareFrame;
@end
