//
//  WXMessage.h
//  WXSideSlip
//
//  Created by macOS on 2017/10/10.
//  Copyright © 2017年 WX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WXMessageBodyType) {
    WXMessageBodyTypeText,
    WXMessageBodyTypeImage,
    WXMessageBodyTypeVideo,
    WXMessageBodyTypeLocation,
    WXMessageBodyTypeVoice,
};

typedef NS_ENUM(NSUInteger, WXMessageStatus) {
    WXMessageStatusPending,
    WXMessageStatusDelivering,
    WXMessageStatusSucceed,
    WXMessageStatusFailed,
};

typedef NS_ENUM(NSUInteger, WXChatType) {
    WXChatTypeChat,
    WXChatTypeGroupChat,
    WXChatTypeChatRoom,
};

typedef NS_ENUM(NSUInteger, WXMessageDirection) {
    WXMessageDirectionSend,
    WXMessageDirectionReceive,
};

@interface WXMessage : NSObject
@property (copy, nonatomic) NSString *messageId;
@property (assign, nonatomic) WXMessageBodyType bodyType;
@property (assign, nonatomic) WXMessageStatus messageStatus;
@property (assign, nonatomic) WXChatType chatType;
@property (assign, nonatomic) BOOL isMessageRead;
@property (assign, nonatomic) BOOL isSender;
@property (copy, nonatomic) NSString *userid;
@property (copy, nonatomic) NSString *nickname;
@property (copy, nonatomic) NSString *portraitUrl;
@property (strong, nonatomic) UIImage *portraitImage;

@property (copy, nonatomic) NSString *text;
@property (copy, nonatomic) NSAttributedString *attrText;

@property (copy, nonatomic) NSString *address;
@property (assign, nonatomic) double latitude;
@property (assign, nonatomic) double longitude;

@property (copy, nonatomic) NSString *failImageName;
@property (assign, nonatomic) CGSize imageSize;
@property (assign, nonatomic) CGSize thumbnailImageSize;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIImage *thumbnailImage;

@property (assign, nonatomic) BOOL isMediaPlaying;
@property (assign, nonatomic) BOOL isMediaPlayed;
@property (assign, nonatomic) CGFloat mediaDuration;

@property (copy, nonatomic) NSString *fileIconName;
@property (copy, nonatomic) NSString *fileName;
@property (copy, nonatomic) NSString *fileSizeDes;
@property (assign, nonatomic) CGFloat fileSize;
@property (assign, nonatomic) CGFloat progress;
@property (copy, nonatomic) NSString *fileLocalPath;
@property (copy, nonatomic) NSString *thumbnailFileLocalPath;
@property (copy, nonatomic) NSString *fileUrl;
@property (copy, nonatomic) NSString *thumbnailFileUrl;

@end
