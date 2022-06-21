import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_account/src/controller/change_password_controller.dart';

class ChangePassword extends GetView<ChangePasswordController> {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("doi mat khau".tr),
        ),
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: const MyBottomAppBar(index: 3),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: controller.formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(
                    () => Focus(
                      onFocusChange: (bool value) {
                        if (value == false) {
                          controller.confirmPassword();
                        }
                      },
                      child: TextFormField(
                        controller: controller.oldPasswordController,
                        keyboardType: TextInputType.visiblePassword,
                        onChanged: (value) {
                          controller.oldPassValidator(value);
                          controller.checkDisableButton();
                        },
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            label: Text("mat khau hien tai".tr + " *"),
                            errorText: controller.oldPassTextErr.value.isEmpty ? null : controller.oldPassTextErr.value),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
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
                        onPressed: () => controller.disableButton.value ? null : controller.submit(),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              controller.disableButton.value ? const Color(0xFFD4D4D4) : null),
                        ),
                        child: Text(
                          "doi mat khau".tr.toUpperCase(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: controller.disableButton.value
                                  ? const Color.fromRGBO(125, 123, 123, 1)
                                  : Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
