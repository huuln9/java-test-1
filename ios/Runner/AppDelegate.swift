import UIKit
import Flutter
import flutter_voip_push_notification
import flutter_call_kit
import VNPTPaySDK
#if !targetEnvironment(simulator)
import BioSDK
#endif
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, PKPushRegistryDelegate {
	#if !targetEnvironment(simulator)
    var channelFlutter: FlutterMethodChannel?
    var typeDocument: DocumentType = .twoside
    var jsonAgruments: [String: Any] = [:]
    var rootVC = UIViewController()
    var topParamCrop: Float = 0
    var bottomParamCrop: Float = 0
    var call: FlutterMethodCall?
	#endif
    
    override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure();

    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }

    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let methodChannel = FlutterMethodChannel(name: "qrcode_wifisetting", binaryMessenger: controller.binaryMessenger)

    methodChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      if (call.method == "redirectToSettingIos") {
        if let url = URL(string: "App-Prefs:root=WIFI") {
          if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
          }
        }
      }
    })
      
    #if !targetEnvironment(simulator)
    if let rootView = window?.rootViewController as? FlutterViewController {
        let channel = FlutterMethodChannel(name: "vnptit/si/biosdk", binaryMessenger: rootView.binaryMessenger)
        channel.setMethodCallHandler({ (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            self.rootVC = rootView
            self.channelFlutter = channel
            self.call = call
            if call.method == "openTwoSide" {
                self.openTwoSide()
            }
            if call.method == "openFaceAdvanceOval" {
                self.openFaceAdvanceOval()
            }
        })
    }
    #endif
      
    // VNPT PAY
    VNPTPay.initializeSDK("451", partnerAccountCode: "TIENGIANG_SDK", secretKey1: "b1dfb33bbdae6b936b16f56a1f21f1a5", secretKey2: "7eef90357d9647efa1afdce768d7c27a")
    let arrSupplierBillpayment: NSMutableArray = ["TGG"]
    VNPTPay.setSupplierBillpayment(arrSupplierBillpayment, supplierDefault: "TGG")

    let arrSupplierWater: NSMutableArray = ["TIWACO"]
    VNPTPay.setSupplierWater(arrSupplierWater, supplierDefault: "TIWACO")
      
    if let rootView1 = window?.rootViewController as? FlutterViewController {
      let channel1 = FlutterMethodChannel(name: "vnptit/vnptpay", binaryMessenger: rootView1.binaryMessenger)
      channel1.setMethodCallHandler({ (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
          if call.method == "openPay" {
              print("openPay")
              let vc = VNPTPay.getTabNavigationControllerVNPTPay(true)
              vc.modalPresentationStyle = .formSheet
              vc.preferredContentSize = CGSize(width: rootView1.view.frame.size.width, height: rootView1.view.frame.size.height)
              rootView1.present(vc, animated: true, completion: nil)
          }
          if call.method == "thanhToanTienDien" {
              print("thanhToanTienDien")
              VNPTPay.chargesEVN("")
          }
          if call.method == "thanhToanNuoc" {
              print("thanhToanNuoc")
              VNPTPay.chargesWater("", codeWater: "")
          }
          if call.method == "thanhToanCuoc" {
              print("thanhToanCuoc")
              VNPTPay.chargesBillpayment("", codeBillpayment: "")
          }
          if call.method == "thanhToanHocPhi" {
              print("thanhToanHocPhi")
              VNPTPay.chargesVNEDU("")
          }
      })
    }
      
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    #if !targetEnvironment(simulator)
    func openTwoSide() {
        self.typeDocument = .twoside
        let vc = Camera()
        vc.delegate =  self
        vc.documentType = .twoside
        vc.show(rootVC)
    }
    #endif
    
    #if !targetEnvironment(simulator)
    func openFaceAdvanceOval() {
        self.typeDocument = .oval
        let vc = Camera()
        vc.delegate =  self
        vc.documentType = .oval
        let option = OvalOption()
        option.language = .vn
        option.isShowTutorial = false
        //        vc.language = .vn //deprecated
        vc.show(rootVC)
    }
    #endif
    
    #if !targetEnvironment(simulator)
    func cropToBounds(image: UIImage) -> UIImage {
        guard let cgimage = image.cgImage else { return image }
        let contextImage = UIImage(cgImage: cgimage)
        let contextSize = contextImage.size
        
        let posX: CGFloat = 0.0
        let posY = contextSize.height * CGFloat(topParamCrop)
        let cgwidth = contextSize.width
        let cgheight = contextSize.height * CGFloat(1 - topParamCrop - bottomParamCrop)
        
        let rect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
        
        // Create bitmap image from context using the rect
        guard let imageRef = cgimage.cropping(to: rect) else { return image }
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        return UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
    }
    #endif
    
  func pushRegistry(_ registry: PKPushRegistry,
                           didReceiveIncomingPushWith payload: PKPushPayload,
                           for type: PKPushType,
                           completion: @escaping () -> Void){

             // Register VoIP push token (a property of PKPushCredentials) with server
          FlutterVoipPushNotificationPlugin.didReceiveIncomingPush(with: payload, forType: type.rawValue)
          print("Check call UUID native \(UUID().uuidString.lowercased())")
          let dict = payload.dictionaryPayload
          let apsDict = dict["aps"] as! Dictionary<String, Any>
          let handle = apsDict["callerID"]!
          FlutterCallKitPlugin.reportNewIncomingCall(
              UUID().uuidString.lowercased(),
              handle: handle as! String,
              handleType: "generic",
              hasVideo: true,
              localizedCallerName: payload.dictionaryPayload,
              fromPushKit: true)

         }
    
    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
               // Process the received push
               FlutterVoipPushNotificationPlugin.didUpdate(pushCredentials, forType: type.rawValue);
           }
    
    // VNPT PAY
    override func applicationDidEnterBackground(_ application: UIApplication) {
        VNPTPay.applicationDidEnterBackground(application)
    }

    override func applicationDidBecomeActive(_ application: UIApplication) {
        VNPTPay.applicationDidBecomeActive(application)
    }

    override func applicationWillTerminate(_ application: UIApplication) {
        VNPTPay.logout()
    }
    
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }
}

#if !targetEnvironment(simulator)
extension AppDelegate: CameraDelegate {
    func onResult(_ data: DataModel) {
        guard let channel = channelFlutter else { return }
        jsonAgruments = [:]
        
        // two side document
        if typeDocument == .twoside, data.frontImage != nil, data.backImage != nil {
            jsonAgruments["BIT_MAP_FRONT"] = data.frontImage?.jpeg(.high)
            jsonAgruments["BIT_MAP_BACK"] = data.backImage?.jpeg(.high)
            jsonAgruments["FRONT_CROP_BITMAP"] = self.cropToBounds(image: data.frontImage!).jpeg(.high)
            jsonAgruments["BACK_CROP_BITMAP"] = self.cropToBounds(image: data.backImage!).jpeg(.high)
            jsonAgruments["CROP_PARAMS"] = data.getCropParam()
            
            channel.invokeMethod("processImageDone", arguments: jsonAgruments)
        }
        
        if typeDocument == .oval {
            print("oval")
        }
        
        if data.farImage != nil {
            print("far image")
        }
        
        if data.nearImage != nil {
            print("near image")
        }
        
        // face oval
        if typeDocument == .oval, data.farImage != nil, data.nearImage != nil {
            jsonAgruments["FAR_PATH"] = data.farImage?.jpeg(.high)
            jsonAgruments["NEAR_PATH"] = data.nearImage?.jpeg(.high)
            print("process oval face");
            channel.invokeMethod("processOvalFaceDone", arguments: jsonAgruments)
        }
    }
    
    func onClose() {
        print("CLOSE BIO SDK")
        channelFlutter?.invokeMethod("captureCancel", arguments: nil)
    }
    
    func onError(_ message: String) {
        channelFlutter?.invokeMethod("captureError", arguments: nil)
        
    }
}
#endif
