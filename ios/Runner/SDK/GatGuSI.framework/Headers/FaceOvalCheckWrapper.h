//
//  FaceOvalCheckWrapper.h
//  FinalSDK
//
//  Created by Trần Quang Tuấn on 12/28/20.
//  Copyright © 2020 Aeris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>
#import "FacePoseChecker.h"
#import "ModelDataHandler.h"
#import "FaceLandMarkModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FaceOvalCheckWrapper : NSObject

typedef enum FACE_POSITIONS {
    POS_INVALID,
    POS_NEAR,
    POS_FAR,
    POS_FIT
} FACE_POSITIONS;

typedef struct FACE_INFO {
    float faceScore;
    FACE_POSITIONS facePosition;
    FACE_STATES faceState;
    float landmarks[468][3];
} FACE_INFO;

- (instancetype)initWithModel:(ModelDataHandler *)model poseChecker:(FacePoseChecker *)poseChecker landmarkModel:(FaceLandMarkModel *)landmarkModel;

- (FACE_INFO)checkFacePosition:(UIImage *)captureImage ovalRect:(CGRect) ovalRect;

- (void)resetLog;

- (void)updateLog;

- (NSString *)exportLog;

- (void)modifyNearThreshold:(float)threshold;

- (void)modifyFarThreshold:(float)threshold;

- (void)modifyIntersectionThreshold: (float)threshold;

@end

NS_ASSUME_NONNULL_END
