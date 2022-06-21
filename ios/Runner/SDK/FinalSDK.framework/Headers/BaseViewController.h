//
//  BaseViewController.h
//  ManmoSearch
//
//  Created by Jessy on 7/6/20.
//  Copyright © 2020 Manmo Company. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define LocalizedString(key) [[ICLocalizeHelper sharedLocalSystem] localizedStringForKey:(key)]
// #define LocalizationSetLanguage(language, bundle) [[ICLocalizeHelper sharedLocalSystem] setLanguage:(language) bundle:(bundle)]

#define LocalizationSetLanguage(language, bundle) \
        [[ICLocalizeHelper sharedLocalSystem] setLanguage:(language) bundle:(bundle)]



#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface BaseViewController: UIViewController

@property UIActivityIndicatorView *indicatorBase;

- (void) showPopupWithTitle:(NSString *) title message:(NSString *) message;
- (UIImage *) imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
- (NSString *) convertObjectToString:(id) object;
- (NSString *) convertHtmlPlainText:(NSString *) stringHTML;
- (CGFloat) convertNumber:(CGFloat )input;
- (void) setGradientView:(UIView *)view withFrame:(CGRect)frameButton;
- (void) setMaskLayerView:(UIView *)view withFrame:(CGRect)frameView;
- (CGFloat) widthText:(NSString *)text withFont:(UIFont *)fontText;
- (CGFloat)sizeScale:(CGFloat)size;
- (CGFloat)heightScale:(CGFloat)height;
- (CGFloat)fontSizeScale:(NSInteger)size;
- (void) addActionView:(UIView *)view target:(id)target action:(SEL)action;
- (NSMutableAttributedString *) attributedString:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font underlineStyle:(NSUnderlineStyle)underlineStyle;
- (void) setupButton:(UIButton *)button title:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font backgroundColor:(UIColor *)backgroundColor target:(id)target action:(SEL)action;
- (void) setShadowView:(UIView *)view shadowRadius:(CGFloat)shadowRadius shadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset shadowOpacity:(float)shadowOpacity masksToBounds:(BOOL)masksToBounds;
- (void) setupLabel:(UILabel *)label text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment;
- (NSString *) formatFloatNumber:(CGFloat)floatNumber maximumFractionDigits:(NSInteger)maximumFractionDigits;
- (NSString *) formatIntegerNumber:(NSInteger)integerNumber;
- (NSMutableAttributedString *) attributedString:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font betweenlineStyle:(NSUnderlineStyle)underlineStyle;
- (UIImage *)imageFromLayer:(CALayer *)layer;
- (NSArray *)getListJSONFromFile:(NSString *)filename;
- (BOOL) validatePhoneNumber:(NSString *)phoneNumber;
- (BOOL) isEmailWithString:(NSString *)emailCheck;
- (NSAttributedString *) getAttributedHTMLString:(NSString*)htmlString;
- (UIColor *)UIColorFromRGB:(int)rgbValue alpha:(CGFloat)alpha;

- (double) getDistanceInKilometerFromLatOne:(double)lat1 lngOne:(double)lng1 latTwo:(double)lat2 lngTwo:(double)lng2;
- (double) deg2rad: (double) deg;

@end
