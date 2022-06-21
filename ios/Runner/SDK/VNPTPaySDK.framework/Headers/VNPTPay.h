//
//  VNPTPay.h
//  VNPTPaySDK
//
//  Created by QuangPV1 on 4/3/20.
//  Copyright © 2020 QuangPV1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol VNPTPayDelegate <NSObject>
@optional
- (bool)shouldUseVNPTPaySDK;
@end

@interface VNPTPay : NSObject
@property (nonatomic, weak) id <VNPTPayDelegate> delegate;
+ (instancetype)sharedInstance;
+ (void)setVNPTPayDelegate:(id <VNPTPayDelegate>) delegate;
+ (void)paymentGateVNPTPay:(UIViewController*) viewController totalPrice:(NSInteger)totalPrice finish:(void (^)(NSMutableDictionary *resultObject))completion;
+ (BOOL)isLinkSDKWithPhone:(NSString *)phoneNumber;
// initSDK
+ (void)initializeSDK: (NSString *)partnerAccountId partnerAccountCode:(NSString *) partnerAccountCode secretKey1: (NSString *)secretKey1 secretKey2: (NSString *)secretKey2;

// get UINavigationController goto VNPT Money
+ (UINavigationController*) getTabNavigationControllerVNPTPay: (BOOL) isFullScreenForHome;
+ (UINavigationController*) getTabNavigationControllerVNPTPay: (BOOL) isFullScreenForHome scrollviewBlock:(void (^)(UIScrollView* scrollView))scrollviewBlock;;
+ (UINavigationController*) getNavigationControllerVNPT;
+ (UINavigationController *)loginVNPTPay: (NSString *)phoneNumber isChangePhoneNumber: (BOOL) isChangePhoneNumber completion:(void(^)(BOOL))commpletionBlock;
+ (UINavigationController * _Nullable)linkVNPTPaySDK:(NSString *)phoneNumber isChangePhoneNumber: (BOOL) isChangePhoneNumber completionBlock:(void(^)(bool))completionBlock;
+ (void)unlinkVNPTPaySDK:(void(^)(bool))completionBlock;


// function use VNPT Money
+ (void)setPhoneNumber: (NSString *)phoneNumber isChangePhoneNumber: (BOOL) isChangePhoneNumber;
+ (void)setColorForApp: (UIColor *)colorDefault colorSuccess: (UIColor *)colorSuccess colorError: (UIColor *)colorError;
+ (void)applicationDidEnterBackground:(UIApplication *)application;
+ (void)applicationDidBecomeActive:(UIApplication *)application;
+ (BOOL)checkLogin;
+ (void)logout;
+ (void)getAvailableBalanceWallet:(void (^)(NSInteger availableBalanceWallet))availableBalanceWalletBlock;
+ (NSInteger)getAvailableBalance;
+ (NSInteger)getAvailableMobileMoneyBalance;
+ (void)loginVNPTPayFromTab;

// Value default setting for VNPT Money
@property (strong, nonatomic) UINavigationController * _Nullable currentnavigationController;
@property (strong, nonatomic) UIColor * _Nullable colorDefault;
@property (strong, nonatomic) UIColor * _Nullable colorSuccess;
@property (strong, nonatomic) UIColor * _Nullable colorError;
@property (strong, nonatomic) NSString * _Nullable partnerAccountId;
@property (strong, nonatomic) NSString * _Nullable partnerAccountCode;
@property (strong, nonatomic) NSString * _Nullable secretKeyCoreApp;
@property (strong, nonatomic) NSString * _Nullable secretKeyCoreWallet;

// function set default service for VNPT Money
+ (void)setSupplierBillpayment: (NSMutableArray *)supplierBillpayment supplierDefault: (NSString*) supplierDefault;
+ (void)setSupplierWater: (NSMutableArray *)supplierWater supplierDefault: (NSString*) supplierDefault;
+ (void)setPaymentAdditionInfo: (NSString *)additionInfo;
- (BOOL)shouldUseFunction;
// function charges with for VNPT Money
+ (void)rechargeMoney;
+ (void)cashOutMoney;
+ (void)transferMoney;
+ (void)scanQRCodeByPayment;
+ (void)scanQRCodeByTransferMoney;
+ (void)myQRCode;
+ (void)detailAccount;
+ (void)chargesTopup;
+ (void)chargesByCard;
+ (void)chargesVNTT: (NSString * _Nullable)code;
+ (void)chargesVinaphone: (NSString * _Nullable)phone;
+ (void)chargesHTVC: (NSString * _Nullable)code;
+ (void)chargesMyTVNet: (NSString * _Nullable)code;
+ (void)chargesKPlus: (NSString * _Nullable)code;
+ (void)chargesVTVCab: (NSString * _Nullable)code;
+ (void)chargesBillpayment: (NSString * _Nullable)supplierBillpaymentCode codeBillpayment: (NSString * _Nullable)codeBillpayment;
+ (void)chargesPostpaid:(NSString * _Nullable)phoneNumber;
+ (void)chargesEVN: (NSString * _Nullable)codeEVN;
+ (void)chargesGREENHOUSE: (NSString * _Nullable)code;
+ (void)chargesVINAIDVOUCHER: (NSString * _Nullable)code;
+ (void)chargesVINAIDCODE: (NSString * _Nullable)code;
+ (void)chargesWater: (NSString * _Nullable)supplierWater codeWater: (NSString * _Nullable)codeWater;
+ (void)chargesVNEDU: (NSString * _Nullable)code;
+ (void)paymentVNPTSelfCareQRCodeVNPTPay:(NSString*) qrCodeDetail;
+ (NSString *)getPhoneNumberDidLoginInSDK;
+ (BOOL)isShowBannerLinkSDK;
+ (UINavigationController *_Nullable)paymentXHH:(NSString *)phoneNumber moneyAmount:(NSString *)moneyAmount transactionDetail:(NSString *)transactionDetail completion:(void(^)(BOOL))completionBlock;
@end



NS_ASSUME_NONNULL_END
