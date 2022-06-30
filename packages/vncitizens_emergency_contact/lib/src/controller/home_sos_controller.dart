import 'dart:developer';

import 'package:vncitizens_account/vncitizens_account.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_common_hcm/vncitizens_common_hcm.dart';
import 'package:vncitizens_emergency_contact/src/config/app_config.dart';
import 'package:vncitizens_emergency_contact/src/model/sos_item_model.dart';

class HomeSosController extends GetxController {
  RxList<SosItemModel> listSos = AppConfig.contacts.obs;
  RxBool isLoading = false.obs;
  RxString logDev = ''.obs;

  @override
  void onInit() {
    super.onInit();
    log("INIT CONTROLLER", name: AppConfig.packageName);
    // init();
  }

  senLocationCall(SosItemModel item) async {
    isLoading(true);
    try {
      final phoneNumber = AppConfig.phoneNumber;
      var position = await _determinePosition();

      if (phoneNumber != null && position != null) {
        final jwt = JWT({
          "msisdn": phoneNumber.replaceAll('+84', '0'),
          "dial_number": item.dialNumber,
          "lat": position.latitude,
          "lng": position.longitude
        });
        var data = jwt.sign(SecretKey(AppConfig.secertKey), noIssueAt: true);
        final res = await HCMSoSLocationCallService(
                AppConfig.soSConfig.urlEndPoint ?? '')
            .sendLocationCall(data);

        if (res.statusCode == 200) {
          log('Location call' + res.body.toString(),
              name: AppConfig.packageName);
          print('Location call success: ' + res.body.toString());
          logDev.value = res.body.toString();
          isLoading(false);
          launchUrl(Uri.parse("tel:${item.phoneNumber}"));
        } else {
          logDev.value = 'Không thể gửi vị trí toạ độ';
          isLoading(false);
          launchUrl(Uri.parse("tel:${item.phoneNumber}"));
        }
      } else {
        logDev.value = 'Không thể gửi vị trí toạ độ';
        isLoading(false);
        launchUrl(Uri.parse("tel:${item.phoneNumber}"));
      }
    } catch (error) {
      logDev.value = 'Không thể gửi vị trí toạ độ';
      isLoading(false);
      launchUrl(Uri.parse("tel:${item.phoneNumber}"));
    }
  }

  Future<Position?> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      return null;
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return null;
    }
    return await Geolocator.getCurrentPosition();
  }
}
