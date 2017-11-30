//
//  WXMacros.h
//  WXSideSlip
//
//  Created by macOS on 2017/10/9.
//  Copyright © 2017年 WX. All rights reserved.
//

#ifndef WXMacros_h
#define WXMacros_h

///MARK: Color
#define WXHEXCOLOR(c) WXHEXCOLORWITHALPHA(c, 1.0)
#define WXHEXCOLORWITHALPHA(c, a) [UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:((c)&0xFF)/255.0 alpha:a]

#define WX_TINT_COLOR WXHEXCOLOR(0x09BB07)

///MARK: Font
#define WXSYSTEMFONTOFSIZE(s) [UIFont systemFontOfSize:s]
#define WX_SYSTEM_FONT_10 WXSYSTEMFONTOFSIZE(10)
#define WX_SYSTEM_FONT_12 WXSYSTEMFONTOFSIZE(12)
#define WX_SYSTEM_FONT_14 WXSYSTEMFONTOFSIZE(14)
#define WX_SYSTEM_FONT_16 WXSYSTEMFONTOFSIZE(16)

///MARK: Frame
#define WX_MARGIN_4 (4.0)
#define WX_MARGIN_5 (5.0)
#define WX_MARGIN_8 (8.0)
#define WX_MARGIN_10 (10.0)
#define WX_MARGIN_15 (15.0)
#define WX_MARGIN_20 (20.0)

#define WX_PORTRAIT_WIDTH_30 (30.0)
#define WX_PORTRAIT_WIDTH_40 (40.0)
#define WX_PORTRAIT_WIDTH_50 (50.0)
#define WX_PORTRAIT_WIDTH_60 (60.0)
#define WX_PORTRAIT_WIDTH_70 (70.0)

#define WX_TIMELINE_BUTTON_HEIGHT (47.0)

#define WX_TABBAR_HEIGHT CGRectGetHeight(self.tabBarController.tabBar.frame)
#define WX_STATUSBAR_HEIGHT CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame])
#define WX_NAVIGATIONBAR_HEIGHT CGRectGetHeight(self.navigationController.navigationBar.frame)

///MARK: Image
#define WX_BUNDLE_IMAGE(b, n) [UIImage imageNamed:[NSString stringWithFormat:@"%@.bundle/%@", b, n]]

#endif /* WXMacros_h */
