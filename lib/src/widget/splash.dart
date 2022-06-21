import 'package:flutter/material.dart';

class SplashConfig {

  /// the second splash screen config
  static const String splashLightLogo = "packages/flutter_app_template/assets/logo/vnpt-blue.png";
  static const Color splashLightBackgroundColor = Color(0xfff1f1f1);
  static const String splashDarkLogo = "packages/flutter_app_template/assets/logo/vnpt-white.png";
  static const Color splashDarkBackgroundColor = Color(0xff054f80);

}

class DigoSplash extends StatelessWidget {
  const DigoSplash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool lightMode =
        MediaQuery.of(context).platformBrightness == Brightness.light;
    return Scaffold(
      backgroundColor: lightMode
          ? SplashConfig.splashLightBackgroundColor
          : SplashConfig.splashDarkBackgroundColor,
      body: Center(
          child: lightMode
              ? Image.asset(SplashConfig.splashLightLogo)
              : Image.asset(SplashConfig.splashDarkLogo)),
    );
  }
}

