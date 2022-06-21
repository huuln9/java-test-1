import 'package:flutter/material.dart';
import 'package:vncitizens_account/src/config/account_app_config.dart';
import 'package:vncitizens_account/src/controller/register_controller.dart';
import 'package:vncitizens_common/vncitizens_common.dart';

import 'fullscreen_circular_loading.dart';

class Register extends GetView<RegisterController> {
  const Register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text("dang ky tai khoan".tr),
          ),
          bottomNavigationBar: AccountAppConfig.appRequireLogin == true ? null : const MyBottomAppBar(index: 3),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 40),
                  child: Form(
                    key: controller.registerFormKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Obx(
                          () => TextFormField(
                              controller: controller.fullNameController,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: 'ho ten *'.tr,
                                errorText: controller.fullnameTextError.value == "" ? null : controller.fullnameTextError.value,
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                  width: 2,
                                  color: Color.fromRGBO(218, 218, 218, 1),
                                )),
                              ),
                              onChanged: (value) {
                                controller.fullNameValidator(value);
                                controller.checkEnableRegisterButton();
                                if (!controller.status.value) {
                                  controller.setStatus(true);
                                }
                              }),
                        ),
                        const SizedBox(height: 20),
                        Obx(
                          () => Focus(
                            onFocusChange: (bool value) {
                              if (value == false) {
                                controller.onUnFocusPhoneNumber();
                              }
                            },
                            child: TextFormField(
                                controller: controller.phoneNumberController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: 'so dien thoai *'.tr,
                                  errorText: controller.phoneTextError.value == "" ? null : controller.phoneTextError.value,
                                  enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                    width: 2,
                                    color: Color.fromRGBO(218, 218, 218, 1),
                                  )),
                                ),
                                onChanged: (value) {
                                  controller.phoneNumberValidator(value);
                                  controller.checkEnableRegisterButton();
                                  if (!controller.status.value) {
                                    controller.setStatus(true);
                                  }
                                }),
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
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: AccountAppConfig.requireEmail == true ? 'Email *' : "Email",
                                  errorText: controller.emailTextError.value == "" ? null : controller.emailTextError.value,
                                  enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                    width: 2,
                                    color: Color.fromRGBO(218, 218, 218, 1),
                                  )),
                                ),
                                onChanged: (value) {
                                  controller.emailValidator(value);
                                  controller.checkEnableRegisterButton();
                                  if (!controller.status.value) {
                                    controller.setStatus(true);
                                  }
                                }),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Obx(() => TextFormField(
                            controller: controller.passwordController,
                            obscureText: !controller.showPassword.value,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              labelText: 'mat khau *'.tr,
                              border: const OutlineInputBorder(),
                              errorText: controller.passwordTextError.value == "" ? null : controller.passwordTextError.value,
                              suffixIcon: IconButton(
                                icon: Icon(controller.showPassword.value ? Icons.visibility : Icons.visibility_off),
                                onPressed: () {
                                  controller.setShowPassword(!controller.showPassword.value);
                                },
                              ),
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                width: 2,
                                color: Color.fromRGBO(218, 218, 218, 1),
                              )),
                            ),
                            onChanged: (value) {
                              controller.passwordValidator(value);
                              controller.repeatPasswordValidator();
                              controller.checkEnableRegisterButton();
                              if (!controller.status.value) {
                                controller.setStatus(true);
                              }
                            })),
                        const SizedBox(height: 20),
                        Obx(() => TextFormField(
                            controller: controller.repeatPasswordController,
                            obscureText: !controller.showRepeatPassword.value,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              labelText: 'xac nhan mat khau *'.tr,
                              border: const OutlineInputBorder(),
                              errorText: controller.repeatPasswordTextError.value == "" ? null : controller.repeatPasswordTextError.value,
                              suffixIcon: IconButton(
                                icon: Icon(controller.showRepeatPassword.value ? Icons.visibility : Icons.visibility_off),
                                onPressed: () {
                                  controller.setRepeatShowPassword(!controller.showRepeatPassword.value);
                                },
                              ),
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                width: 2,
                                color: Color.fromRGBO(218, 218, 218, 1),
                              )),
                            ),
                            onChanged: (value) {
                              controller.repeatPasswordValidator();
                              controller.checkEnableRegisterButton();
                              if (!controller.status.value) {
                                controller.setStatus(true);
                              }
                            })),
                        const SizedBox(height: 20),
                        _buttonRegister(),
                        const SizedBox(height: 40),

                        /// show only if integrate eKYC
                        if (AccountAppConfig.isIntegratedEKYC == true)
                          Row(children: [
                            const Expanded(child: Divider(color: Colors.black54)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              child: Text("hoac".tr),
                            ),
                            const Expanded(child: Divider(color: Colors.black54)),
                          ]),

                        /// show only if integrate eKYC
                        if (AccountAppConfig.isIntegratedEKYC == true) const SizedBox(height: 20),

                        /// show only if integrate eKYC
                        if (AccountAppConfig.isIntegratedEKYC == true)
                          TextButton(
                            onPressed: () => showBottomSheet(context),
                            child: Text(
                              'chup chan dung va quet giay to ca nhan cua ban de dang ky'.tr,
                              style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.blue),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        if (AccountAppConfig.appRequireLogin == true && AccountAppConfig.remoteAppCopyright != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 60),
                            child: Text(
                              AccountAppConfig.remoteAppCopyright!,
                              style: TextStyle(color: Colors.black.withOpacity(0.4)),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              ),
              Obx(() => controller.loading.value ? const FullScreenCircularLoading() : const SizedBox())
            ],
          )),
    );
  }

  Widget _buttonRegister() {
    return Obx(
      () => ConstrainedBox(
          constraints: const BoxConstraints(minWidth: double.infinity, minHeight: 40),
          child: ElevatedButton(
            style: ButtonStyle(backgroundColor: controller.enableRegisterButton.value ? null : MaterialStateProperty.all(Colors.black12)),
            child: Text('dang ky'.tr.toUpperCase(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: controller.enableRegisterButton.value ? Colors.white : Colors.black.withOpacity(0.7))),
            onPressed: controller.enableRegisterButton.value ? () => controller.register() : null,
          )),
    );
  }

  showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Expanded(child: Text("")),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text("ban vui long lua chon loai giay to tuy than phu hop de dang ky tai khoan".tr),

              /// radio buttons
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Obx(
                      () => RadioListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Transform.translate(offset: const Offset(-20, 0), child: const Text('CCCD')),
                        value: 1,
                        groupValue: controller.radioGroupValue.value,
                        onChanged: (value) => controller.onChangeRadioButton(value as int),
                      ),
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Obx(
                      () => RadioListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Transform.translate(offset: const Offset(-20, 0), child: const Text('CMND')),
                        value: 2,
                        groupValue: controller.radioGroupValue.value,
                        onChanged: (value) => controller.onChangeRadioButton(value as int),
                      ),
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Obx(
                      () => RadioListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Transform.translate(offset: const Offset(-20, 0), child: Text('ho chieu'.tr)),
                        value: 3,
                        groupValue: controller.radioGroupValue.value,
                        onChanged: (value) => controller.onChangeRadioButton(value as int),
                      ),
                    ),
                    flex: 1,
                  ),
                ],
              ),

              /// example image
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(() => Image.asset(controller.exampleImageSrc.value, width: 300)),
                  const SizedBox(height: 4),
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 300,
                    ),
                    child: Obx(() => Text(
                          "chup 2 mat truoc va sau de hoan thanh xac thuc".trArgs([controller.documentType.value]),
                          textAlign: TextAlign.center,
                        )),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              /// button next
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => controller.onClickNextButton(),
                    child: Text("tiep tuc".tr.toUpperCase()),
                  ))
            ],
          ),
        );
      },
    );
  }
}
