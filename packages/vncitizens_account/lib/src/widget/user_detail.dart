import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:vncitizens_account/src/config/account_app_config.dart';
import 'package:vncitizens_account/src/config/account_route_config.dart';
import 'package:vncitizens_account/src/controller/user_detail_controller.dart';
import 'package:vncitizens_common/vncitizens_common.dart';

import 'fullscreen_circular_loading.dart';

class UserDetail extends GetView<UserDetailController> with WidgetsBindingObserver {
  const UserDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back(result: true);
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: const MyBottomAppBar(index: 3),
        appBar: AppBar(
          title: Text("quan ly tai khoan".tr),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),

                  /// Avatar
                  _buildAvatar(context),

                  /// Name
                  _buildName(context),

                  /// Phone number
                  Obx(() => _buildInfoItem(
                        titleLeft: "so dien thoai",
                        titleRight: controller.phoneNumber.value,
                        context: context,
                        route: AccountRouteConfig.changePhoneNumberRoute,
                      )),

                  /// Email
                  Obx(() => _buildInfoItem(
                        titleLeft: "Email",
                        titleRight: controller.email.value,
                        context: context,
                        route: AccountRouteConfig.changeEmailRoute,
                      )),

                  /// Current address
                  Obx(() => _buildInfoItem(
                    titleLeft: "dia chi hien tai",
                    titleRight: controller.currentAddress.value,
                    context: context,
                    route: AccountRouteConfig.updateCurrentAddress,
                    arguments: [controller.userFullyModel],
                    routeCallback: () {
                      controller.getUserInfo();
                    })),

                  const Divider(thickness: 10, color: Color.fromRGBO(229, 229, 229, 1)),

                  /// Documents
                  _buildDocuments(context),

                  const SizedBox(height: 30),

                  /// Buttons
                  _buildButtons(context)
                ],
              ),
            ),
            Obx(() => controller.loading.value ? const FullScreenCircularLoading() : const SizedBox())
          ],
        ),
      ),
    );
  }

  Widget _buildDocuments(BuildContext context) {
    return Obx(() {
      if (controller.hasDocument.value) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              trailing: (controller.identity != null && controller.citizenIdentity != null && controller.passport != null)
                  ? null
                  : const Icon(
                      Icons.add,
                      color: Colors.black54,
                      size: 30,
                    ),
              onTap: (controller.identity != null && controller.citizenIdentity != null && controller.passport != null)
                  ? null
                  : () => showBottomSheet(context),
              title: Text(
                "giay to ca nhan".tr.toUpperCase(),
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black54, fontSize: Theme.of(context).textTheme.headline6?.fontSize),
              ),
            ),
            const SizedBox(height: 4),
            if (controller.identity != null)
              ListTile(
                  onTap: () => controller.onTapDocument(2),
                  title: Text(
                    "chung minh nhan dan".tr,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: const Icon(Icons.keyboard_arrow_right, size: 20)),
            if (controller.citizenIdentity != null)
              ListTile(
                  onTap: () => controller.onTapDocument(1),
                  title: Text(
                    "can cuoc cong dan".tr,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: const Icon(Icons.keyboard_arrow_right, size: 20)),
            if (controller.passport != null)
              ListTile(
                  onTap: () => controller.onTapDocument(3),
                  title: Text(
                    "ho chieu".tr,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: const Icon(Icons.keyboard_arrow_right, size: 20))
          ],
        );
      } else {
        return Column(
          children: [
            TextButton(
              onPressed: () => showBottomSheet(context),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [const Icon(Icons.add), Text("them giay to ca nhan".tr)],
              ),
            ),
            const Divider(thickness: 10, color: Color.fromRGBO(229, 229, 229, 1)),
          ],
        );
      }
    });
  }

  Widget _buildButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 140,
            ),
            child: OutlinedButton(
                onPressed: () => controller.logout(),
                style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red, width: 2)),
                child: Text(
                  "dang xuat".tr.toUpperCase(),
                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                )),
          ),
          const SizedBox(width: 15),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 140),
            child: OutlinedButton(
                onPressed: () => Get.toNamed(AccountRouteConfig.changePasswordRoute),
                style: OutlinedButton.styleFrom(side: BorderSide(width: 2, color: Theme.of(context).colorScheme.primary)),
                child: Text(
                  "doi mat khau".tr.toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )),
          ),
        ],
      ),
    );
  }

  Padding _buildName(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28, top: 12),
      child: Center(
        child: Obx(() => Text(controller.fullName.value, style: Theme.of(context).textTheme.headline6)),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return Obx(
      () => controller.avatarBytes.value != null
          ? SizedBox(
              width: 96,
              height: 96,
              child: Stack(
                clipBehavior: Clip.none,
                fit: StackFit.expand,
                children: [
                  GestureDetector(
                    onTap: () => controller.onTapAvatar(context),
                    child: CircleAvatar(
                      backgroundImage: Image.memory(controller.avatarBytes.value as Uint8List).image,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: -25,
                    child: ElevatedButton(
                      onPressed: () => controller.onTapAvatar(context, changeAvatar: true),
                      child: const Icon(Icons.camera_alt_outlined, color: Colors.blue),
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(8), shape: const CircleBorder(), primary: Colors.white),
                    ),
                  )
                ],
              ),
            )
          : GestureDetector(
              onTap: () => controller.onTapAvatar(context),
              child: Container(
                width: 96,
                height: 96,
                decoration: const BoxDecoration(shape: BoxShape.circle, color: Color.fromRGBO(6, 143, 224, 1)),
                child: Center(
                  child: Obx(
                    () => Text(
                      controller.shortName.value,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 27),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildInfoItem({required String titleLeft, String? titleRight, required String route, required BuildContext context, List<dynamic>? arguments, Function? routeCallback}) {
    return ListTile(
      onTap: () => Get.toNamed(route, arguments: arguments)?.then((value) {
        if (value == true) {
          routeCallback?.call();
        }
      }),
      horizontalTitleGap: 10,
      title: Text(
        titleLeft.tr,
        style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black54),
      ),
      trailing: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: max(MediaQuery.of(context).size.width * 0.5, 250)
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                titleRight == null || titleRight.isEmpty ? "chua cap nhat".tr : titleRight,
                style: TextStyle(fontWeight: titleRight == null || titleRight.isEmpty ? FontWeight.w300 : FontWeight.bold),
                textAlign: TextAlign.right,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_right, size: 20)
          ],
        ),
      ),
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
              Text(
                "vui long chon giay to ca nhan cap nhat".tr,
                textAlign: TextAlign.left,
              ),

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
                    child: AccountAppConfig.isIntegratedEKYC == true
                        ? Obx(() => Text(
                              "chup 2 mat truoc va sau de hoan thanh xac thuc".trArgs([controller.documentType.value]),
                              textAlign: TextAlign.center,
                            ))
                        : Text(
                            "nhap day du thong tin tren giay to".tr,
                            textAlign: TextAlign.center,
                          ),
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
