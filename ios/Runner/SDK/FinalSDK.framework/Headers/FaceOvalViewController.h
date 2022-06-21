//
//  FaceOvalViewController.h
//  FinalSDK
//
//  Created by IC iOS Team's Macbook Pro on 3/20/21.
//  Copyright © 2021 Minh Nguyễn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FaceOvalDelegate <NSObject>

- (void) pressDismissFaceOval;
//- (void) completeTakeFarPhotoFace:(UIImage *)farImage;
//- (void) completeTakeNearPhotoFace:(UIImage *)nearImage;
//- (void) completeLogData:(NSData *)logData;
- (void) completeProcess:(NSData *)logData farImg:(UIImage *)farImage nearImg:(UIImage *)nearImage;

@end



//@protocol HelpOvalDelegate <NSObject>
//
//- (void) startDetectFace;
//
//@end

@interface FaceOvalViewController : BaseViewController

@property (weak, nonatomic) id<FaceOvalDelegate> faceOvalDelegate;

@property (nonatomic) NSString *languageApplication;
@property (nonatomic) BOOL isShowTrademark;
@property (nonatomic) BOOL isBtnBack;

@property (nonatomic) UIImage *imageTrademark;
@property (nonatomic) BOOL isShowHelp;
@property (nonatomic) BOOL isSkipVoiceVideo;
@property (nonatomic) UIColor *buttonTitleColor;
@property (nonatomic) UIColor *screenTitleTextColor;

@property (nonatomic) UIColor *ovalCircleColor;

@property (nonatomic) UIColor *backgroundColor;

@property (nonatomic) UIColor *titleFeedbackColor;

@property (strong,nonatomic) NSBundle *bundleOvalAnimation;
@property (strong,nonatomic) NSBundle *bundleFeedbackAnimation;


@property (nonatomic) UIColor *buttonBackgroundColor;
//@property (strong,nonatomic) UIView *viewHelp;
@property (strong,nonatomic) UIViewController *viewControllerHelp;

@property (nonatomic) UIImage *imgBottom;

- (void) deallocSessionFaceOval;

- (void) stopVideoWhenExpiredToken;
- (void) startRuningVideo;

@end

NS_ASSUME_NONNULL_END
