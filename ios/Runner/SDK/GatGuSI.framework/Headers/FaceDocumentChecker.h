//
//  FaceDocumentChecker.h
//  FinalSDK
//
//  Created by user on 24/04/2021.
//  Copyright © 2021 Minh Nguyễn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FaceDocumentChecker : NSObject

- (instancetype)init;

- (BOOL)read:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
