import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_account/src/controller/change_phone_controller.dart';

class ChangePhone extends GetView<ChangePhoneController> {
  const ChangePhone({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("so dien thoai".tr.toUpperCase()),
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
                    () => TextFormField(
                      controller: controller.phoneNumberController,
                      keyboardType: TextInputType.number,
                      onChanged: (value) => controller.phoneNumberValidator(value),
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: "so dien thoai".tr,
                        errorText: controller.textError.value.isEmpty ? null : controller.textError.value,
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                  ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 120),
                    child: Obx(
                      () => ElevatedButton(
                        onPressed: () => controller.disableButton.value ? null : controller.submit(),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(controller.disableButton.value ? const Color(0xFFD4D4D4) : null),
                        ),
                        child: Text(
                          "luu lai".tr.toUpperCase(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: controller.disableButton.value ? const Color.fromRGBO(125, 123, 123, 1) : Colors.white),
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
