//
//  SaveData.h
//  FinalSDK
//
//  Created by Minh Nguyễn on 9/1/20.
//  Copyright © 2020 Minh Nguyễn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface SaveData : NSObject {
        
}

+ (SaveData *)shared;
 
@property (nonatomic) NSString *languageApplication;

@property (nonatomic) NSString *tokenWaterMark;
@property (nonatomic) NSString *SDAuthorization;
@property (nonatomic) NSString *SDTokenId;
@property (nonatomic) NSString *SDTokenKey;
@property (nonatomic) NSString *SDMacAddress;
@property (nonatomic) NSString *SDClientSession;

@property (nonatomic) NSInteger ExpriseTime;

@property (nonatomic) NSString *UrlUploadImage;
@property (nonatomic) NSString *BaseUrl;
@property (nonatomic) NSString *scanQRCode;

@property (nonatomic) NSString *jsonInfo;
@property (nonatomic) NSString *jsonAPIGetInfo;
@property (nonatomic) NSString *jsonBodyGetInfo;

@property (nonatomic) NSString *jsonCompareFace;
@property (nonatomic) NSString *jsonAPICompareFace;
@property (nonatomic) NSString *jsonBodyCompareFace;

@property (nonatomic) NSString *jsonLivenessFace;
@property (nonatomic) NSString *jsonAPILivenessFace;
@property (nonatomic) NSString *jsonBodyLivenessFace;

@property (nonatomic) NSString *jsonVerifyFace;
@property (nonatomic) NSString *jsonAPIVerifyFace;
@property (nonatomic) NSString *jsonBodyVerifyFace;

@property (nonatomic) NSString *jsonCheckMask;
@property (nonatomic) NSString *jsonAPICheckMask;
@property (nonatomic) NSString *jsonBodyCheckMask;

@property (nonatomic) NSString *jsonCheckLivenessFrontCard;
@property (nonatomic) NSString *jsonAPICheckLivenessFrontCard;
@property (nonatomic) NSString *jsonBodyCheckLivenessFrontCard;

@property (nonatomic) NSString *jsonCheckLivenessBackCard;
@property (nonatomic) NSString *jsonAPICheckLivenessBackCard;
@property (nonatomic) NSString *jsonBodyCheckLivenessBackCard;

@property (nonatomic) NSString *jsonAddFace;
@property (nonatomic) NSString *jsonAPIAddFace;
@property (nonatomic) NSString *jsonBodyAddFace;

@property (nonatomic) NSString *jsonSearchFace;
@property (nonatomic) NSString *jsonAPISearchFace;
@property (nonatomic) NSString *jsonBodySearchFace;

@property (nonatomic) NSString *networkProblem;

@property (nonatomic) NSString *jsonAPIGetPostCode;
@property (nonatomic) NSString *jsonBodyGetPostCode;
@property (nonatomic) NSString *jsonIssuePlace;
@property (nonatomic) NSString *jsonOriginLocation;
@property (nonatomic) NSString *jsonRecentLocation;
@property (nonatomic) NSString *jsonBirthPlace;

@property (nonatomic) UIImage *imageFront;
@property (nonatomic) UIImage *imageBack;
@property (nonatomic) UIImage *imageFace;
@property (nonatomic) UIImage *imageFaceLeft;
@property (nonatomic) UIImage *imageFaceRight;
@property (nonatomic) UIImage *imageFaceNear;
@property (nonatomic) UIImage *imageFaceFar;


@property (nonatomic) NSString *linkUploadImage;
@property (nonatomic) NSString *hashImageFront;
@property (nonatomic) NSString *hashImageBack;
@property (nonatomic) NSString *hashImageFace;
@property (nonatomic) NSString *hashImageFaceLeft;
@property (nonatomic) NSString *hashImageFaceRight;
@property (nonatomic) NSString *hashImageNear;
@property (nonatomic) NSString *hashImageFar;
@property (nonatomic) NSString *hashLog;
@property (nonatomic) NSString *json3DLiveness;


@end

NS_ASSUME_NONNULL_END
