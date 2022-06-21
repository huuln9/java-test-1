import 'dart:developer' as dev;

import 'package:vncitizens_home/src/config/home_app_config.dart';

class MenuModel {
  String name;
  String? icon;
  String? networkIcon;
  bool? requiredLogin;
  String? route;
  String? webUrl;
  String? deeplink;
  String? inAppBrowserUrl;
  String? sms;
  String? email;
  String? call;
  List<MenuModel>? child;

  MenuModel(
    this.name, {
    this.icon,
    this.networkIcon,
    this.requiredLogin,
    this.route,
    this.webUrl,
    this.deeplink,
    this.inAppBrowserUrl,
    this.child,
    this.sms,
    this.email,
    this.call,
  });

  static List<MenuModel> fromArray(List<dynamic> jsonArr) {
    List<MenuModel> lstMenu = [];
    for (var json in jsonArr) {
      if (json == null ||
          json?['name'] == null ||
          (json?['icon'] == null && json?['networkIcon'] == null) ||
          (json?['route'] == null &&
              json?['webUrl'] == null &&
              json?['deeplink'] == null &&
              json?['inAppBrowserUrl'] == null &&
              json?['sms'] == null &&
              json?['email'] == null &&
              json?['call'] == null &&
              json?['child'] == null)) {
        dev.log('ignore menu: $json', name: HomeAppConfig.packageName);
        continue;
      }
      lstMenu.add(MenuModel(json['name'],
          icon: json?['icon'],
          networkIcon: json?['networkIcon'],
          requiredLogin: json?['requiredLogin'],
          route: json?['route'],
          webUrl: json?['webUrl'],
          deeplink: json?['deeplink'],
          inAppBrowserUrl: json?['inAppBrowserUrl'],
          sms: json?['sms'],
          email: json?['email'],
          call: json?['call'],
          child: json?['child'] != null ? MenuModel.fromArray(json?['child']) : null));
    }
    return lstMenu;
  }

  @override
  String toString() {
    return 'MenuModel{name: $name, icon: $icon, networkIcon: $networkIcon, route: $route, webUrl: $webUrl, deeplink: $deeplink, inAppBrowserUrl: $inAppBrowserUrl, child: $child}';
  }
}
