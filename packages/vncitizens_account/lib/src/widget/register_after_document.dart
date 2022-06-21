import 'package:flutter/material.dart';
import 'package:vncitizens_account/src/config/account_app_config.dart';
import 'package:vncitizens_account/src/controller/register_after_doc_controller.dart';
import 'package:vncitizens_common/vncitizens_common.dart';

class RegisterAfterDocument extends GetView<RegisterAfterDocumentController> {
  const RegisterAfterDocument({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          bottomNavigationBar: AccountAppConfig.appRequireLogin == true ? null : const MyBottomAppBar(index: 3),
          resizeToAvoidBottomInset: false,
          appBar: AppBar(title: Text("dang ky tai khoan".tr), centerTitle: true),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Obx(
                          () => Focus(
                            onFocusChange: (bool value) {
                              if (value == false) {
                                controller.onUnFocusPhoneNumber();
                              }
                            },
                            child: TextFormField(
                              controller: controller.phoneNumberController,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: 'so dien thoai *'.tr,
                                errorText: controller.phoneTextError.value == "" ? null : controller.phoneTextError.value,
                                enabledBorder: const OutlineInputBorder(),
                              ),
                              onChanged: (value) => controller.phoneNumberValidator(value),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Obx(
                          () => Focus(
                            onFocusChange: (bool value) {
                              if (value == false) {
                                controller.onUnFocusEmail();
                              }
                            },
                            child: TextFormField(
                              controller: controller.emailController,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: AccountAppConfig.requireEmail == true ? 'Email *' : "Email",
                                errorText: controller.emailTextError.value == "" ? null : controller.emailTextError.value,
                                enabledBorder: const OutlineInputBorder(),
                              ),
                              onChanged: (value) => controller.emailValidator(value),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Obx(
                          () => TextFormField(
                            controller: controller.passwordController,
                            obscureText: !controller.showPassword.value,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: 'mat khau *'.tr,
                              enabledBorder: const OutlineInputBorder(),
                              errorText: controller.passwordTextError.value == "" ? null : controller.passwordTextError.value,
                              suffixIcon: IconButton(
                                icon: Icon(controller.showPassword.value ? Icons.visibility : Icons.visibility_off),
                                onPressed: () {
                                  controller.setShowPassword(!controller.showPassword.value);
                                },
                              ),
                            ),
                            onChanged: (value) {
                              controller.passwordValidator(value);
                              controller.repeatPasswordValidator();
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        Obx(
                          () => TextFormField(
                            controller: controller.repeatPasswordController,
                            obscureText: !controller.showRepeatPassword.value,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: 'nhap lai mat khau *'.tr,
                              enabledBorder: const OutlineInputBorder(),
                              errorText: controller.repeatPasswordTextError.value == "" ? null : controller.repeatPasswordTextError.value,
                              suffixIcon: IconButton(
                                icon: Icon(controller.showRepeatPassword.value ? Icons.visibility : Icons.visibility_off),
                                onPressed: () {
                                  controller.setRepeatShowPassword(!controller.showRepeatPassword.value);
                                },
                              ),
                            ),
                            onChanged: (value) => controller.repeatPasswordValidator(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () => controller.submit(),
                              child: Text("dang ky".tr.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold))),
                        )
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
