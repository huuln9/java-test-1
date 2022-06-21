//
//  ICLocalizeHelper.h
//  FinalSDK
//
//  Created by Minh Minh iOS on 07/05/2021.
//  Copyright © 2021 Minh Nguyễn. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ICLocalizeHelper : NSObject

+ (ICLocalizeHelper*) sharedLocalSystem;

// this gets the string localized:
- (NSString*) localizedStringForKey:(NSString*)key;

// set a new language:
- (void) setLanguage:(NSString*)language bundle:(NSBundle*) bundle;

@end

NS_ASSUME_NONNULL_END
