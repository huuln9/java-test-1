package vn.vnpt.digo.vncitzens.flutter.app.dev

import android.annotation.SuppressLint
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.util.Log
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import com.vnpt.vnptmedia.soft.vnptpaysdkfull.uiv3.home.SDKActivityHome
import com.vnpt.vnptmedia.soft.vnptpaysdkfull.utils.VnptPaySdkManager
import com.vnptit.si.bio_sdk.model.*
import com.vnptit.si.bio_sdk.sdk.BioSDK
import com.vnptit.si.bio_sdk.sdk.CameraViewCallback
import com.vnptit.si.bio_sdk.utils.BitmapUtils
import com.vnptit.si.bio_sdk.utils.SDKEnum
import com.vnptit2.vnpt_vcall.HandleMainAcitivity
import com.vnptit2.vnpt_vcall.VnptVcallPlugin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant


class MainActivity: FlutterActivity() {
    private val TAG = "MainActivity"
    private val QRCODE_WIFI_CHANNEL = "qrcode_wifisetting"

    val channel = "vnptit/si/biosdk"
    val channelVnptPay = "vnptit/vnptpay"
    private var mainResult: MethodChannel.Result? = null
    var mainMethodChannel: MethodChannel? = null
    var mainMethodChannelVnptPay: MethodChannel? = null

    val handleMainAcitivity = HandleMainAcitivity()
    var vnptVcallPlugin = VnptVcallPlugin()
//    var ACTION_MANAGE_OVERLAY_PERMISSION_REQUEST_CODE = 5469


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        initVNPTPay()

//        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O_MR1) {
//            setShowWhenLocked(true)
//            setTurnScreenOn(true)
//            val keyguardManager = getSystemService(KEYGUARD_SERVICE) as KeyguardManager
//            keyguardManager?.requestDismissKeyguard(this, null)
//        }
//
//        window.addFlags(
//                WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED
//                        or WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD
//                        or WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON
//                        or WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON
//                        or WindowManager.LayoutParams.FLAG_ALLOW_LOCK_WHILE_SCREEN_ON)


    }

    private fun initVNPTPay() {
        Log.d(TAG, "Init VNPTPay")
        VnptPaySdkManager.initialize(context, getString(R.string.app_name), "451", "b1dfb33bbdae6b936b16f56a1f21f1a5") //hai tham số cuối là partnerID và account do Pay cấp cho đối tác
        VnptPaySdkManager.setCurrentClass(SDKActivityHome::class.java)
        VnptPaySdkManager.setMainClass(MainActivity::class.java) // set main activity để pay có thể quay về trang chủ
        VnptPaySdkManager.getInstance().isHaveingTopNavigation = false;// true nếu app chủ có top navigation và ngược lại
        VnptPaySdkManager.getInstance().isImportAsFragment = false;// true nếu app chủ nhúng pay vào 1 fragment
        VnptPaySdkManager.getInstance().partnerName = "TIENGIANG_SDK"; // set partner name do pay cấp cho đối tác
        VnptPaySdkManager.getInstance().walletPrivatekey = "7eef90357d9647efa1afdce768d7c27a"//set wallet private key do pay cấp cho đối tác
        VnptPaySdkManager.setFileProvider(getString(R.string.file_provider_authorize))
        VnptPaySdkManager.getInstance().isImportAsFragment = false
        VnptPaySdkManager.getInstance().setLogin(false)

        val waterCompany: ArrayList<String> = ArrayList()
        waterCompany.add("TIWACO")
        VnptPaySdkManager.getInstance().setListWaterSuppliers(waterCompany)

        val provinceList: ArrayList<String> = ArrayList()
        provinceList.add("TGG")
        VnptPaySdkManager.getInstance().provinceList = provinceList
    }


    @Suppress("NULLABILITY_MISMATCH_BASED_ON_JAVA_ANNOTATIONS", "RECEIVER_NULLABILITY_MISMATCH_BASED_ON_JAVA_ANNOTATIONS")
    override fun onStart() {
        Log.d(TAG, "onStart ==")

        super.onStart()

        val methodChannel = MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, vnptVcallPlugin.CHANNEL_PLUGIN)
        val intent = getIntent()
        Log.d(TAG, "onStartHandle ==")
        handleMainAcitivity.onStartHandle(intent, methodChannel, context)

        //xin quyền overlay
//        if (!Settings.canDrawOverlays(this)) {
//            val intent: Intent = Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
//                    Uri.parse(context.packageName))
//            startActivityForResult(intent, ACTION_MANAGE_OVERLAY_PERMISSION_REQUEST_CODE)
//        }
    }

    override fun onResume() {
        super.onResume()
        Log.d(TAG, "onResume ----------------------------")
        handleMainAcitivity.activityResumed()
        val methodChannel = MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, vnptVcallPlugin.CHANNEL_PLUGIN)
        handleMainAcitivity.onResumeHandle(methodChannel, context)
    }

    override fun onPause() {
        super.onPause()
        Log.d(TAG, "onPause ----------------------------")
        handleMainAcitivity.activityPaused()
    }

    @SuppressLint("ServiceCast")
    @Suppress("RECEIVER_NULLABILITY_MISMATCH_BASED_ON_JAVA_ANNOTATIONS")
    @RequiresApi(Build.VERSION_CODES.N)
    override fun onNewIntent(intent: Intent) {
        Log.d(TAG, "onNewIntent ==")
        super.onNewIntent(intent)
        val methodChannel = MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, vnptVcallPlugin.CHANNEL_PLUGIN)
        handleMainAcitivity.onNewIntentHandle(intent, methodChannel, context)
    }


    @SuppressLint("LongLogTag")
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        Log.d(TAG, "configureFlutterEngine ==")
        super.configureFlutterEngine(flutterEngine)
//        GeneratedPluginRegistrant.registerWith(flutterEngine)
        handleMainAcitivity.handleMethodCall(flutterEngine, context)

        // 
        val methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, QRCODE_WIFI_CHANNEL)
        methodChannel.setMethodCallHandler {call, result ->
            if (call.method == "redirectToWifiSettingAndroid") {
                startActivityForResult(Intent(android.provider.Settings.ACTION_WIFI_SETTINGS), 1)
                result.success("Redirect to wifi setting successfully")
            }
        }
        // BioID
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        mainMethodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel)
        mainMethodChannel!!.setMethodCallHandler { call, result ->
            run {
                mainResult = result
                when {
                    call.method!!.contentEquals("openOneSide") -> {
                        openOneSide(call.arguments)
                    }
                    call.method!!.contentEquals("openTwoSide") -> {
                        openTwoSide()
                    }
                    call.method!!.contentEquals("openFaceBasic") -> {
                        faceBasic()
                    }
                    call.method!!.contentEquals("openFaceAdvance") -> {
                        faceAdvance()
                    }
                    call.method!!.contentEquals("openFaceAdvanceOval") -> {
                        faceAdvanceOval()
                    }
                }
            }
        }

        // VNPT PAY
        mainMethodChannelVnptPay = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelVnptPay)
        mainMethodChannelVnptPay!!.setMethodCallHandler { call, result ->
            run {
                mainResult = result
                when {
                    call.method!!.contentEquals("openPay") -> {
                        Log.d(channelVnptPay, "openPay")
//                        VnptPaySdkManager.getInstance().openPayByButton(context)
                        val intent = Intent(context, VnptPayFragmentActivity::class.java)
                        startActivity(intent)
                    }
                    call.method!!.contentEquals("thanhToanTienDien") -> {
                        Log.d(channelVnptPay, "thanhToanTienDien")
                        VnptPaySdkManager.getInstance().thanhToanTienDien("")
                    }
                    call.method!!.contentEquals("thanhToanVnpData") -> {
                        Log.d(channelVnptPay, "thanhToanVnpData")
                        VnptPaySdkManager.getInstance().thanhToanVnpData("")
                    }
                    call.method!!.contentEquals("thanhToanHTVC") -> {
                        Log.d(channelVnptPay, "thanhToanHTVC")
                        VnptPaySdkManager.getInstance().thanhToanHTVC("")
                    }
                    call.method!!.contentEquals("thanhtoanKPlus") -> {
                        Log.d(channelVnptPay, "thanhtoanKPlus")
                        VnptPaySdkManager.getInstance().thanhtoanKPlus("")
                    }
                    call.method!!.contentEquals("thanhToanVTVCab") -> {
                        Log.d(channelVnptPay, "thanhToanVTVCab")
                        VnptPaySdkManager.getInstance().thanhToanVTVCab("")
                    }
                    call.method!!.contentEquals("thanhToanMyTvNet") -> {
                        Log.d(channelVnptPay, "thanhToanMyTvNet")
                        VnptPaySdkManager.getInstance().thanhToanMyTvNet("")
                    }
                    call.method!!.contentEquals("thanhToanHoaDonVienThongV2") -> {
                        Log.d(channelVnptPay, "thanhToanHoaDonVienThongV2")
                        VnptPaySdkManager.getInstance().thanhToanHoaDonVienThongV2("", "")
                    }
                    call.method!!.contentEquals("thanhToanInterNet") -> {
                        Log.d(channelVnptPay, "thanhToanInterNet")
                        VnptPaySdkManager.getInstance().thanhToanInterNet("", "")
                    }
                    call.method!!.contentEquals("thanhToanDienThoaiCoDinh") -> {
                        Log.d(channelVnptPay, "thanhToanDienThoaiCoDinh")
                        VnptPaySdkManager.getInstance().thanhToanDienThoaiCoDinh("", "")
                    }
                    call.method!!.contentEquals("thanhToanDonHangVnptVienThong") -> {
                        Log.d(channelVnptPay, "thanhToanDonHangVnptVienThong")
                        VnptPaySdkManager.getInstance().thanhToanDonHangVnptVienThong("")
                    }
                    call.method!!.contentEquals("thanhToanGreenHouse") -> {
                        Log.d(channelVnptPay, "thanhToanGreenHouse")
                        VnptPaySdkManager.getInstance().thanhToanGreenHouse("")
                    }
                    call.method!!.contentEquals("thanhToanVinaIDVoucher") -> {
                        Log.d(channelVnptPay, "thanhToanVinaIDVoucher")
                        VnptPaySdkManager.getInstance().thanhToanVinaIDVoucher("")
                    }
                    call.method!!.contentEquals("thanhToanVinaID") -> {
                        Log.d(channelVnptPay, "thanhToanVinaID")
                        VnptPaySdkManager.getInstance().thanhToanVinaID("")
                    }
                    call.method!!.contentEquals("thanhToanNuoc") -> {
                        Log.d(channelVnptPay, "thanhToanNuoc")
                        VnptPaySdkManager.getInstance().thanhToanNuoc("", "")
                    }
                    call.method!!.contentEquals("thanhToanHocPhiVnedu") -> {
                        Log.d(channelVnptPay, "thanhToanHocPhiVnedu")
                        VnptPaySdkManager.getInstance().thanhToanHocPhiVnedu("")
                    }
                    call.method!!.contentEquals("napTien") -> {
                        Log.d(channelVnptPay, "napTien")
                        VnptPaySdkManager.getInstance().cashInToWallet(MainActivity::class.java)
                    }
                    call.method!!.contentEquals("chuyenTien") -> {
                        Log.d(channelVnptPay, "chuyenTien")
                        VnptPaySdkManager.getInstance().transferToWallet(MainActivity::class.java)
                    }
                    call.method!!.contentEquals("quetQRThanhToan") -> {
                        Log.d(channelVnptPay, "quetQRThanhToan")
                        VnptPaySdkManager.getInstance().checkoutViaQR(MainActivity::class.java)
                    }
                    call.method!!.contentEquals("chiTietTaiKhoan") -> {
                        Log.d(channelVnptPay, "chiTietTaiKhoan")
                        VnptPaySdkManager.getInstance().checkAccountDetail(MainActivity::class.java)
                    }
                    call.method!!.contentEquals("quetQRChuyenTien") -> {
                        Log.d(channelVnptPay, "quetQRChuyenTien")
                        VnptPaySdkManager.getInstance().transferViaQr(MainActivity::class.java)
                    }
                    call.method!!.contentEquals("QRCuaToi") -> {
                        Log.d(channelVnptPay, "QRCuaToi")
                        VnptPaySdkManager.getInstance().getMyQr(MainActivity::class.java)
                    }
                    call.method!!.contentEquals("thanhToanCuoc") -> {
                        Log.d(channelVnptPay, "thanhToanCuoc")
                        VnptPaySdkManager.getInstance().openThanhToanCuoc(context, null, null, MainActivity::class.java)
                    }
                    call.method!!.contentEquals("thanhToanHocPhi") -> {
                        Log.d(channelVnptPay, "thanhToanHocPhi")
                        VnptPaySdkManager.getInstance().thanhToanHocPhi(context, MainActivity::class.java)
                    }
                }
            }
        }
    }

    @SuppressLint("LongLogTag")
    private fun openOneSide(arguments: Any) {
        Log.d(channel, "oneSide")
        val bioSDK = BioSDK(this)
        val intentParams = IntentParams()
        intentParams.setSdkType(SDKEnum.Type.ONE_SIDE)
        val oneSideOption = OneSideOption()
        intentParams.setOneSideOption(oneSideOption)
        bioSDK.openCameraView(intentParams, object : CameraViewCallback() {
            override fun onSuccess(resultData: ResultData) {
                Log.d(channel, "onSuccess")
                // lấy ảnh thông qua result data
                mainMethodChannel?.invokeMethod("captureDone", null)
                Thread {
                    try {
                        val map = hashMapOf<String, Any?>()
                        map["FRONT_IMAGE"] = BitmapUtils.convertBitmapToBytes(resultData.bitmapOneSide)
                        map["CROP_PARAMS"] = resultData.cropParam
                        map["TOP_CROP_PARAM"] = resultData.topCropParam
                        map["BOTTOM_CROP_PARAM"] = resultData.bottomCropParam
                        map["FAR_PATH"] = resultData.getFarPath()
                        map["NEAR_PATH"] = resultData.getNearPath()
                        map["SCAN_3D_PATH"] = resultData.getScan3dPath()
                        map["CROP_FRONT_IMAGE"] = BitmapUtils.convertBitmapToBytes(resultData.getCropBitmap(resultData.bitmapOneSide))
                        runOnUiThread {
                            mainMethodChannel!!.invokeMethod("processImageDone", map)
                        }
                    } catch (e: Exception) {
                        Log.d(channel, "Call processImageException")
                        Log.d(channel, "Error: $e")
                        runOnUiThread {
                            mainMethodChannel?.invokeMethod(
                                "processImageException",
                                null
                            )
                        }
                    }
                }.start()
            }

            override fun onError(error: String) {
                Log.d(channel, "onError: " + error.toString())
                //lỗi trả về
                mainMethodChannel?.invokeMethod("captureError", null);
            }

            override fun onClose() {
                Log.d(channel, "onClose")
                //close sdk
                mainMethodChannel?.invokeMethod("captureClose", null);
            }
        })
    }

    @SuppressLint("LongLogTag")
    private fun openTwoSide() {
        Log.d(channel, "twoSide")
        val bioSDK = BioSDK(this)
        val intentParams = IntentParams()
        intentParams.setSdkType(SDKEnum.Type.TWO_SIDE)
        val twoSideOption = TwoSideOption()
        intentParams.setTwoSideOption(twoSideOption)
        bioSDK.openCameraView(intentParams, object : CameraViewCallback() {
            override fun onSuccess(resultData: ResultData) {
                // lấy ảnh thông qua result data
                mainMethodChannel?.invokeMethod("captureDone", null)
                Thread {
                    try {
                        val map = hashMapOf<String, Any?>()
                        map["BIT_MAP_FRONT"] = BitmapUtils.convertBitmapToBytes(resultData.bitmapFront)
                        map["BIT_MAP_BACK"] = BitmapUtils.convertBitmapToBytes(resultData.bitmapBack)
                        map["FRONT_CROP_BITMAP"] = BitmapUtils.convertBitmapToBytes(resultData.getCropBitmap(resultData.bitmapFront))
                        map["BACK_CROP_BITMAP"] = BitmapUtils.convertBitmapToBytes(resultData.getCropBitmap(resultData.bitmapBack))
                        map["CROP_PARAMS"] = resultData.cropParam
                        runOnUiThread {
                            mainMethodChannel!!.invokeMethod("processImageDone", map)
                        }
                    } catch (e: Exception) {
                        Log.d(channel, "Call processImageException")
                        Log.d(channel, "Error: $e")
                        runOnUiThread {
                            mainMethodChannel?.invokeMethod(
                                "processImageException",
                                null
                            )
                        }
                    }
                }.start()
            }

            override fun onError(error: String) {
                Log.d(channel, "onError: " + error.toString())
                //lỗi trả về
                mainMethodChannel?.invokeMethod("captureError", null);
            }

            override fun onClose() {
                Log.d(channel, "onClose")
                //close sdk
                mainMethodChannel?.invokeMethod("captureClose", null);
            }
        })
    }

    @SuppressLint("LongLogTag")
    private fun faceBasic() {
        Log.d(channel, "faceBasic")
        val bioSDK = BioSDK(this)
        val intentParams = IntentParams()
        intentParams.setSdkType(SDKEnum.Type.FACE_BASIC)
        val faceBasicOption = FaceBasicOption()
        intentParams.setFaceBasicOption(faceBasicOption)
        bioSDK.openCameraView(intentParams, object : CameraViewCallback() {
            override fun onSuccess(resultData: ResultData) {
                // lấy ảnh thông qua result data
            }

            override fun onError(error: String) {
                //lỗi trả về
                mainMethodChannel?.invokeMethod("captureError", null);
            }

            override fun onClose() {
                //close sdk
                mainMethodChannel?.invokeMethod("captureClose", null);
            }
        })
    }

    @SuppressLint("LongLogTag")
    private fun faceAdvance() {
        Log.d(channel, "faceAdvance")
        val bioSDK = BioSDK(this)
        val intentParams = IntentParams()
        intentParams.setSdkType(SDKEnum.Type.FACE_ADVANCE)
        val faceAdvanceOption = FaceAdvanceOption()
        intentParams.setFaceAdvanceOption(faceAdvanceOption)
        bioSDK.openCameraView(intentParams, object : CameraViewCallback() {
            override fun onSuccess(resultData: ResultData?) {
                // lấy ảnh thông qua result data
            }

            override fun onError(error: String) {
                //lỗi trả về
            }

            override fun onClose() {
                //close sdk
            }
        })
    }

    @SuppressLint("LongLogTag")
    private fun faceAdvanceOval() {
        Log.d(channel, "faceAdvanceOval")
        val bioSDK = BioSDK(this)
        val params = IntentParams()
        params.setSdkType(SDKEnum.Type.FACE_OVAL)
        val ovalOption = OvalOption()
        params.setOvalOption(ovalOption)
        bioSDK.openCameraView(params, object : CameraViewCallback() {
            override fun onSuccess(resultData: ResultData) {
                // lấy ảnh thông qua result data
                mainMethodChannel?.invokeMethod("captureDone", null)
                Thread {
                    try {
                        val map = hashMapOf<String, Any?>()
                        map["FAR_PATH"] = resultData.getFarPath()
                        map["NEAR_PATH"] = resultData.getNearPath()
                        runOnUiThread {
                            mainMethodChannel!!.invokeMethod("processOvalFaceDone", map)
                        }
                    } catch (e: Exception) {
                        Log.d(channel, "Call processImageException")
                        Log.d(channel, "Error: $e")
                        runOnUiThread {
                            mainMethodChannel?.invokeMethod(
                                "processImageException",
                                null
                            )
                        }
                    }
                }.start()
            }

            override fun onError(error: String) {
                //lỗi trả về
                mainMethodChannel?.invokeMethod("captureError", null);
            }

            override fun onClose() {
                //close sdk
                mainMethodChannel?.invokeMethod("captureClose", null);
            }
        })
    }
}
