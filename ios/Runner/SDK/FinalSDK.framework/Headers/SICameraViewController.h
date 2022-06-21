//
//  SICameraViewController.h
//  FinalSDK
//
//  Created by Nguyen Duy Hung on 4/20/21.
//  Copyright © 2021 Minh Nguyễn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaceOvalViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SICameraViewController : UIViewController

@property (nonatomic) UIColor *buttonTitleColor;
@property (nonatomic) UIColor *buttonReTakeColor;
@property (nonatomic) UIColor *buttonBackgroundColor;
@property (nonatomic) UIColor *ovalCircleColor;
@property (nonatomic) UIColor *titleFeedbackColor;


@property (nonatomic) UIColor *screenTitleTextColor;
@property (nonatomic) UIColor *backgroundColor;

@property (nonatomic) UIImage *logoTrademarkImage;
@property (nonatomic) BOOL isShowHelp;
@property (nonatomic) BOOL isShowTrademark;

@property (nonatomic) BOOL isSkipVoiceVideo;
@property (nonatomic) NSString *languageApplication; // "vi"
@property (nonatomic) NSBundle *bundle; // "vi"

@property (nonatomic) BOOL isBtnBack;
@property (strong,nonatomic) NSBundle *bundleOvalAnimation;
@property (strong,nonatomic) NSBundle *bundleFeedBackAnimation;


//@property (strong,nonatomic) UIView *viewHelp;
@property (strong,nonatomic) UIViewController *viewControllerHelp;
@property (nonatomic) UIImage *imgBottom;

@property (strong,nonatomic) FaceOvalViewController *faceOval;

@property (weak, nonatomic) id<FaceOvalDelegate> ovalDelegate;

@end

NS_ASSUME_NONNULL_END
