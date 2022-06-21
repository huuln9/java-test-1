import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:vncitizens_account/src/controller/account_update_address_controller.dart';
import 'package:vncitizens_account/src/model/place_model.dart';
import 'package:vncitizens_common/vncitizens_common.dart';

class UpdateCurrentAddress extends GetView<AccountUpdateAddressController> {
  const UpdateCurrentAddress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(title: Text("dia chi hien tai".tr)),
        bottomNavigationBar: const MyBottomAppBar(index: 3),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: controller.formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// level 1
                  Obx(() =>
                      controller.placeTypeLevels.isNotEmpty ? _MyDropdownFormField(level: 1, controller: controller) : const SizedBox()),

                  /// level 2
                  Obx(() =>
                      controller.placeTypeLevels.length > 1 ? _MyDropdownFormField(level: 2, controller: controller) : const SizedBox()),

                  /// level 3
                  Obx(() =>
                      controller.placeTypeLevels.length > 2 ? _MyDropdownFormField(level: 3, controller: controller) : const SizedBox()),

                  /// level 4
                  Obx(() =>
                      controller.placeTypeLevels.length > 3 ? _MyDropdownFormField(level: 4, controller: controller) : const SizedBox()),

                  /// detail
                  _MyInputFormField(
                      inputController: controller.detailController,
                      labelText: "chi tiet dia chi".tr + " *",
                      onChange: () => controller.onChangeAddressDetail(),
                  ),

                  /// button submit
                  ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 150),
                    child: Obx(
                      () => ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: controller.enableSubmit.value ? null : MaterialStateProperty.all(const Color(0xFFD4D4D4))
                        ),
                        onPressed: controller.enableSubmit.value ? () => controller.submit() : null,
                        child: Text(
                          "luu lai".tr.toUpperCase(),
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: controller.enableSubmit.value ? Colors.white : const Color(0xFF7D7B7B)),
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

class _MyDropdownFormField extends StatelessWidget {
  _MyDropdownFormField({Key? key, required this.level, required this.controller}) : super(key: key);

  final AccountUpdateAddressController controller;
  final int level;

  final ValueNotifier<int> _fTimes = ValueNotifier<int>(0);
  final ValueNotifier<String> _errorText = ValueNotifier<String>("");

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Focus(
        onFocusChange: (bool? value) {
          if (value == false) {
            _fTimes.value++;
            if (_fTimes.value == 2 && getValueByLevel() == null) {
              _errorText.value = "vui long chon du lieu".tr;
            }
          }
        },
        child: ValueListenableBuilder(
          valueListenable: _errorText,
          builder: (_, String text, Widget? child) {
            return Obx(
              () => DropdownButtonFormField(
                  isExpanded: true,
                  value: getValueByLevel(),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
                    border: const OutlineInputBorder(),
                    errorText: text.isEmpty ? null : text,
                    labelText: (getLabelTextByLevel() ?? "") + " *",
                  ),
                  items: getItemsByLevel().map((value) {
                    return DropdownMenuItem(
                      value: value.id,
                      child: Text(value.name),
                    );
                  }).toList(),
                  onTap: () => _fTimes.value = 0,
                  onChanged: (String? newValue) {
                    switch (level) {
                      case 1:
                        controller.onChangeAddressLevel1(newValue);
                        break;
                      case 2:
                        controller.onChangeAddressLevel2(newValue);
                        break;
                      case 3:
                        controller.onChangeAddressLevel3(newValue);
                        break;
                      case 4:
                        controller.onChangeAddressLevel4(newValue);
                        break;
                      default:
                        break;
                    }
                  }),
            );
          },
        ),
      ),
    );
  }

  String? getValueByLevel() {
    switch (level) {
      case 1:
        return controller.addressLevels1Selected?.id;
      case 2:
        return controller.addressLevels2Selected?.id;
      case 3:
        return controller.addressLevels3Selected?.id;
      case 4:
        return controller.addressLevels4Selected?.id;
      default:
        return null;
    }
  }

  RxList<PlaceModel> getItemsByLevel() {
    switch (level) {
      case 1:
        return controller.addressLevels1;
      case 2:
        return controller.addressLevels2;
      case 3:
        return controller.addressLevels3;
      case 4:
        return controller.addressLevels4;
      default:
        throw "Cannot find address by level: $level";
    }
  }

  String? getLabelTextByLevel() {
    try {
      switch (level) {
        case 1:
          return controller.placeTypeLevels[0].name;
        case 2:
          return controller.placeTypeLevels[1].name;
        case 3:
          return controller.placeTypeLevels[2].name;
        case 4:
          return controller.placeTypeLevels[3].name;
        default:
          return null;
      }
    } catch (error) {
      dev.log(error.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      return null;
    }
  }
}

class _MyInputFormField extends StatelessWidget {
  _MyInputFormField({Key? key, required this.inputController, required this.labelText, this.onChange}) : super(key: key);

  final TextEditingController inputController;
  final String labelText;
  final Function? onChange;

  final ValueNotifier<String> _errorText = ValueNotifier<String>("");

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 38),
      child: Focus(
        onFocusChange: (bool value) {
          if (value == false && (inputController.text.isEmpty || inputController.text.isBlank == true)) {
            _errorText.value = "vui long nhap du lieu".tr;
          }
        },
        child: ValueListenableBuilder(
          valueListenable: _errorText,
          builder: (_, String text, Widget? child) {
            return TextFormField(
              controller: inputController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  errorText: text.isEmpty ? null : text,
                  labelText: labelText,
              ),
              onChanged: (String? value) {
                if (value == null || value.isEmpty || value.isBlank == true) {
                  _errorText.value = "vui long nhap du lieu".tr;
                } else {
                  _errorText.value = "";
                }
                onChange?.call();
              },
            );
          },
        ),
      ),
    );
  }
}
