import 'package:flutter/material.dart';
import 'package:vncitizens_account/src/config/account_app_config.dart';
import 'package:vncitizens_account/src/controller/reset_pass_new_pass_controller.dart';
import 'package:vncitizens_common/vncitizens_common.dart';

class ResetPassNewPass extends GetView<ResetPassNewPassController> {
  const ResetPassNewPass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          bottomNavigationBar: AccountAppConfig.appRequireLogin == true ? null : const MyBottomAppBar(index: 3),
          appBar: AppBar(
            title: Text("doi mat khau".tr),
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  child: Form(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Obx(
                          () => TextFormField(
                            controller: controller.newPasswordController,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: !controller.showNewPassword.value,
                            onChanged: (value) {
                              controller.newPassValidator(value);
                              controller.repeatPassValidator();
                              controller.checkDisableButton();
                            },
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: "mat khau moi".tr + " *",
                              errorText: controller.newPassTextErr.value.isEmpty ? null : controller.newPassTextErr.value,
                              suffixIcon: IconButton(
                                icon: Icon(controller.showNewPassword.value ? Icons.visibility : Icons.visibility_off),
                                onPressed: () {
                                  controller.setShowNewPassword(!controller.showNewPassword.value);
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        Obx(
                          () => TextFormField(
                            controller: controller.repeatPasswordController,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: !controller.showRepeatPassword.value,
                            onChanged: (value) {
                              controller.repeatPassValidator();
                              controller.checkDisableButton();
                            },
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: "nhap lai mat khau moi".tr + " *",
                              errorText: controller.repeatPassTextErr.value.isEmpty ? null : controller.repeatPassTextErr.value,
                              suffixIcon: IconButton(
                                icon: Icon(controller.showRepeatPassword.value ? Icons.visibility : Icons.visibility_off),
                                onPressed: () {
                                  controller.setShowRepeatPassword(!controller.showRepeatPassword.value);
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        ConstrainedBox(
                          constraints: const BoxConstraints(minWidth: 120),
                          child: Obx(
                            () => ElevatedButton(
                              onPressed: () => controller.submit(),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(controller.disableButton.value ? const Color(0xFFD4D4D4) : null),
                              ),
                              child: Text(
                                "doi mat khau".tr.toUpperCase(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: controller.disableButton.value ? const Color.fromRGBO(125, 123, 123, 1) : Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (AccountAppConfig.appRequireLogin == true && AccountAppConfig.remoteAppCopyright != null)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      AccountAppConfig.remoteAppCopyright!,
                      style: TextStyle(color: Colors.black.withOpacity(0.4)),
                    ),
                  ),
                ),
            ],
          )),
    );
  }
}
