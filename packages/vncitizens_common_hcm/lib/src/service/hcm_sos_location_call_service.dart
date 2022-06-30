import 'dart:developer' as dev;

import 'package:vncitizens_common/vncitizens_common.dart';

class HCMSoSLocationCallService extends GetConnect {
  HCMSoSLocationCallService(String url) {
    httpClient.defaultContentType = 'application/x-www-form-urlencoded';
    httpClient.baseUrl = url;
  }

  Future<Response> sendLocationCall(String data) async {
    return await post("", {"data": data},
        contentType: 'application/x-www-form-urlencoded');
  }
}
