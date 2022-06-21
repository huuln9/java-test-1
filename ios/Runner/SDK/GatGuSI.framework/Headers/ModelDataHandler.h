//
//  ModelDataHandler.h
//  ICFaceDetect
//
//  Created by Nguyen Duy Hung on 7/29/20.
//  Copyright © 2020 Nguyen Duy Hung. All rights reserved.
//

#ifndef ModelDataHandler_h
#define ModelDataHandler_h

#import <Foundation/Foundation.h>
#import<CoreImage/CoreImage.h>
#import <UIKit/UIkit.h>
//#import <TensorFlowLite/TensorFlowLiteSwift-umbrella.h>
@interface ModelDataHandler : NSObject {
    
    //NSMutableArray<NSArray<Float32>> *anchors_array_warp;
    NSString *aaaa;
    
}


//Interpreter *interpreter;
//public var anchors_array_warp:[[Float32]]?


struct Inference {
    float confidence;
    NSString *label;
    
};

@property struct Inference infer;
struct Result {
    double *inferenceTime;
    NSArray<NSObject *> *inferences;
};

typedef struct FileInfo {
    NSString *name;
    NSString *extension;
} FileInfo;


@property (nonatomic, retain) NSArray<NSString *> *labels;
@property (nonatomic, retain) NSData * inputData;
@property (strong, nonatomic) NSMutableArray * anchors_array_warp;

//@property (nonatomic, strong) Interpreter *interpreter;


//typedef enum  {
//    NSObject *modelInfo;
//    NSObject *labelsInfo;
//    //static FileInfo modelInfo = { .name = @"face_detection_front", .extension = @"tflite"};
//   // const FileInfo labelsInfo =  { .name = @"labels", .extension = @"txt"};
// } MobileNet;
//


- (id)init;

- (id)initWithAES128:(NSString *)name type:(NSString *)type;

- (void)setMinScoreThread: (float)score;

- (float)getLastScore;

- (void)setInputWithImage:(UIImage *)image;

- (void)setInputWithPixelBuffer:(CVPixelBufferRef) pixelBuffer;

- (void)setInputWithRawdata:(NSData *)data;

//- (NSMutableDictionary*)runModel:(CVPixelBufferRef *)pixelBuffer;
// tuantq - truyền vào đối tượng thay vì truyền vào tham chiếu
- (NSMutableDictionary*)runModel:(CVPixelBufferRef)pixelBuffer;
- (CVPixelBufferRef)getImageToRunModel:(UIImage *)image;
- (NSMutableArray *) generateAnchorBoxes;



@end

#endif /* ModelDataHandler_h */
