import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:vncitizens_account/src/config/account_app_config.dart';
import 'package:vncitizens_account/src/controller/login_controller.dart';
import 'package:vncitizens_account/src/widget/fullscreen_circular_loading.dart';
import 'package:vncitizens_common/vncitizens_common.dart';

class Login extends GetView<LoginController> {
  const Login({Key? key, this.initApp}) : super(key: key);

  final bool? initApp;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: initApp == true
            ? null
            : AppBar(
                title: Text("dang nhap".tr),
              ),
        bottomNavigationBar: initApp == true
            ? null
            : MyBottomAppBar(
                index: 3,
                additionalSettingFunction: () => controller.additionalNavbarFunction(),
                settingCallback: () => controller.navbarCallback(),
                additionalNotifyFunction: () => controller.additionalNavbarFunction(),
                notifyCallback: () => controller.navbarCallback(),
                additionalQrFunction: () => controller.additionalNavbarFunction(),
                qrCallback: () => controller.navbarCallback(),
              ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: initApp == true
                    ? const EdgeInsets.only(left: 20, right: 20, top: 80, bottom: 60)
                    : const EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 60),
                child: Form(
                  key: controller.loginFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildImage(),
                      const SizedBox(height: 10),
                      _buildEmailOrUsername(context),
                      const SizedBox(height: 20),
                      _buildPasswordInput(),
                      const SizedBox(height: 20),
                      _buildNotifyLogin(),
                      _buildTextAction(),
                      _buttonLogin(),
                      const SizedBox(height: 30),

                      /// show face scan only if integrate eKYC
                      if (AccountAppConfig.isIntegratedEKYC == true)
                        GestureDetector(
                          onTap: () => controller.onTapFaceScan(),
                          child: Image.asset("${AccountAppConfig.assetsRoot}/images/face_scan.jpg", width: 48, height: 48),
                        )
                    ],
                  ),
                ),
              ),
            ),
            AccountAppConfig.remoteAppCopyright == null || initApp != true
                ? const SizedBox()
                : Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        AccountAppConfig.remoteAppCopyright!,
                        style: TextStyle(color: Colors.black.withOpacity(0.4)),
                      ),
                    ),
                  ),
            Obx(() => controller.loading.value ? const FullScreenCircularLoading() : const SizedBox())
          ],
        ),
      ),
    );
  }

  Row _buildTextAction() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () => controller.goToResetPassword(),
          child: Text("quen mat khau?".tr,
              style: const TextStyle(
                color: Color.fromRGBO(0, 66, 255, 1),
              )),
        ),
        const Padding(padding: EdgeInsets.symmetric(horizontal: 2), child: Text("|")),
        TextButton(
          onPressed: () => controller.onTapRegister(),
          child: Text("dang ky".tr,
              style: const TextStyle(
                color: Color.fromRGBO(0, 66, 255, 1),
              )),
        ),
        Obx(() => controller.loginOther.value == false && controller.localUsername.value != null
            ? const Padding(padding: EdgeInsets.symmetric(horizontal: 2), child: Text("|"))
            : const SizedBox()),
        Obx(() => controller.loginOther.value == false && controller.localUsername.value != null
            ? TextButton(
                onPressed: () => controller.onTapOtherAccount(),
                child: Text("tai khoan khac".tr,
                    style: const TextStyle(
                      color: Color.fromRGBO(0, 66, 255, 1),
                    )),
              )
            : const SizedBox()),
      ],
    );
  }

  Obx _buildEmailOrUsername(BuildContext context) {
    return Obx(
      () => controller.loginOther.value == false && controller.localUsername.value != null
          ? Text(
              controller.localUsername.value!,
              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey, fontSize: Theme.of(context).textTheme.headline6?.fontSize),
            )
          : Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Obx(() => TextFormField(
                  controller: controller.emailController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'tai khoan/so dien thoai/email *'.tr,
                    labelStyle: TextStyle(color: controller.status.value ? Colors.black54 : Colors.red),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: controller.status.value ? const Color.fromRGBO(218, 218, 218, 1) : Colors.red, width: 2)),
                  ),
                  onChanged: (value) {
                    controller.checkEnableLoginButton();
                    if (!controller.status.value && !controller.lockLoginButton.value) {
                      controller.setStatus(true);
                    }
                  })),
            ),
    );
  }

  Obx _buildPasswordInput() {
    return Obx(() => TextFormField(
        controller: controller.passwordController,
        obscureText: !controller.showPassword.value,
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
          labelText: 'mat khau *'.tr,
          labelStyle: TextStyle(color: controller.status.value ? Colors.black54 : Colors.red),
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: Icon(controller.showPassword.value ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              controller.setShowPassword(!controller.showPassword.value);
            },
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: controller.status.value ? const Color.fromRGBO(218, 218, 218, 1) : Colors.red, width: 2)),
        ),
        onChanged: (value) {
          controller.checkEnableLoginButton();
          if (!controller.status.value && !controller.lockLoginButton.value) {
            controller.setStatus(true);
          }
        }));
  }

  Widget _buttonLogin() {
    return Obx(
      () => ConstrainedBox(
          constraints: const BoxConstraints(minWidth: double.infinity, minHeight: 40),
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: (controller.enableLoginButton.value && !controller.lockLoginButton.value)
                    ? null
                    : MaterialStateProperty.all(Colors.black12)),
            child: Text('dang nhap'.tr.toUpperCase(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: (controller.enableLoginButton.value && !controller.lockLoginButton.value)
                        ? Colors.white
                        : Colors.black.withOpacity(0.7))),
            onPressed: (controller.enableLoginButton.value && !controller.lockLoginButton.value) ? () => controller.login() : null,
          )),
    );
  }

  Widget _buildNotifyLogin() {
    return Obx(() => controller.status.value == true
        ? const SizedBox()
        : controller.loginFailedCount.value >= AccountAppConfig.loginFailedCount1 && controller.loginFailedCountdown.value > 0
            ? Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "ban da nhap sai".tr + " " + controller.loginFailedCount.toString() + " " + "lan".tr,
                      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "vui long dang nhap lai sau".tr + " ",
                          style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          controller.loginFailedCountdown.toString() + "s",
                          style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  "thong tin dang nhap chua dung!".tr,
                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ));
  }

  Widget _buildImage() {
    return Obx(
      () => controller.avatarBytes.value == null
          ? controller.shortString.value == null
              ? AccountAppConfig.loginLogoUrl != null
                  ? Image.network(AccountAppConfig.loginLogoUrl!, width: 100)
                  : Image.asset("${AccountAppConfig.assetsRoot}/images/avatar_login.png", width: 100)
              : Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: const Color.fromRGBO(6, 143, 224, 1), boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.7),
                      spreadRadius: 4,
                      blurRadius: 2,
                      offset: const Offset(0, 0),
                    ),
                    const BoxShadow(
                      color: Colors.white,
                      spreadRadius: 2,
                      offset: Offset(0, 0),
                    ),
                  ]),
                  child: Center(
                    child: Text(
                      controller.shortString.value as String,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 50),
                    ),
                  ),
                )
          : Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(shape: BoxShape.circle, color: const Color.fromRGBO(6, 143, 224, 1), boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.7),
                  spreadRadius: 4,
                  blurRadius: 2,
                  offset: const Offset(0, 0),
                ),
                const BoxShadow(
                  color: Colors.white,
                  spreadRadius: 2,
                  offset: Offset(0, 0),
                ),
              ]),
              child: CircleAvatar(backgroundImage: Image.memory(controller.avatarBytes.value as Uint8List).image),
            ),
    );
  }
}
