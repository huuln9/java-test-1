//
//  FacePoseChecker.h
//  DemoObject
//
//  Created by Nguyen Duy Hung on 9/24/20.
//  Copyright © 2020 Nguyen Duy Hung. All rights reserved.
//

#ifndef FacePoseChecker_h
#define FacePoseChecker_h
@interface FacePoseChecker : NSObject {
}

typedef NS_ENUM(NSInteger, FACE_STATES) {
        STRAIGHT,
    TURN_LEFT,
    TURN_RIGHT,
    TURN_UP,
    TURN_DOWN,
    INVALID,
};

-(FACE_STATES) getFaceState:(CGRect)box landmarks: (NSArray *)landmarks ;

@end

#endif /* FacePoseChecker_h */

