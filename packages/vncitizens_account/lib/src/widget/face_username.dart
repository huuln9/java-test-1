import 'package:flutter/material.dart';
import 'package:vncitizens_account/src/config/account_app_config.dart';
import 'package:vncitizens_account/src/controller/face_username_controller.dart';
import 'package:vncitizens_common/vncitizens_common.dart';

import 'fullscreen_circular_loading.dart';

class FaceUsername extends GetView<FaceUsernameController> {
  const FaceUsername({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          appBar: controller.initApp
              ? null
              : AppBar(
                  title: Text("dang nhap".tr),
                ),
          bottomNavigationBar: controller.initApp ? null : const MyBottomAppBar(index: 3),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: controller.initApp == true
                      ? const EdgeInsets.only(left: 20, right: 20, top: 80, bottom: 60)
                      : const EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 60),
                  child: Form(
                    key: controller.loginFormKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AccountAppConfig.loginLogoUrl != null
                            ? Image.network(AccountAppConfig.loginLogoUrl!, width: 100)
                            : Image.asset("${AccountAppConfig.assetsRoot}/images/avatar_login.png", width: 100),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 30),
                          child: Obx(() => TextFormField(
                              controller: controller.emailController,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: 'tai khoan/so dien thoai/email *'.tr,
                                labelStyle: TextStyle(color: controller.status.value ? Colors.black54 : Colors.red),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: controller.status.value ? const Color.fromRGBO(218, 218, 218, 1) : Colors.red, width: 2)),
                              ),
                              onChanged: (value) {
                                controller.checkEnableLoginButton();
                                if (!controller.status.value) {
                                  controller.setStatus(true);
                                }
                              })),
                        ),
                        _buildNotifyLogin(),
                        _buttonLogin(),
                      ],
                    ),
                  ),
                ),
              ),
              AccountAppConfig.remoteAppCopyright == null || controller.initApp != true
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
          )),
    );
  }

  Widget _buttonLogin() {
    return Obx(
      () => ConstrainedBox(
          constraints: const BoxConstraints(minWidth: double.infinity, minHeight: 40),
          child: ElevatedButton(
            style: ButtonStyle(backgroundColor: controller.enableLoginButton.value ? null : MaterialStateProperty.all(Colors.black12)),
            child: Text('tiep tuc'.tr.toUpperCase(),
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: controller.enableLoginButton.value ? Colors.white : Colors.black.withOpacity(0.7))),
            onPressed: controller.enableLoginButton.value ? () => controller.submit() : null,
          )),
    );
  }

  Widget _buildNotifyLogin() {
    return Obx(() => controller.status.value == false && controller.notifyMessage.value != null
        ? Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(
              controller.notifyMessage.value as String,
              style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          )
        : const SizedBox());
  }
}
