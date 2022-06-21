import 'package:flutter/services.dart';
import 'package:vncitizens_payment/src/constant/payment_constant.dart';

class PaymentCallbackUtil {
  static const _platform = MethodChannel("vnptit/vnptpay");
  static Future<void> callPaymentServiceByRoute(String route) async {
    if (PaymentRouteConstant.paymentMethodMap[route] != null) {
      _platform.invokeMethod(PaymentRouteConstant.paymentMethodMap[route]!);
    } else {
      throw "Không tìm thấy method tương ứng với route: $route";
    }
  }
}