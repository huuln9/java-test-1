//
//  FaceLandMarkModel.h
//  FinalSDK
//
//  Created by Trần Quang Tuấn on 1/25/21.
//  Copyright © 2021 Aeris. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FaceLandMarkModel : NSObject

- (id)init;

- (float)runModel:(NSData *)inputData output:(float[1404])output;

@end

NS_ASSUME_NONNULL_END
