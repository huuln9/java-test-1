import 'package:flutter/material.dart';
import 'package:vncitizens_account/vncitizens_account.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_setting/src/config/app_config.dart';
import 'package:vncitizens_setting/src/controller/setting_controller.dart';

class SettingBody extends GetView<SettingController> {
  SettingBody({Key? key}) : super(key: key);

  final InternetController _internetController = Get.put(InternetController());

  @override
  Widget build(BuildContext context) {
    bool integratedEKYC =
        GetStorage(AppConfig.storageBox).read(AppConfig.integratedEKYC) ??
            false;
    return Obx(
      () => _internetController.hasConnected.value
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                integratedEKYC && AuthUtil.isLoggedIn
                    ? GestureDetector(
                        onTap: () => controller.toggleFaceLoginStatus(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            border: Border(
                                bottom: BorderSide(color: Colors.black12)),
                          ),
                          child: ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black12,
                              ),
                              child: const Icon(
                                Icons.face_retouching_natural,
                                color: Colors.black54,
                                size: 30,
                              ),
                            ),
                            title: Text(
                              "dang nhap bang khuon mat".tr,
                              style: const TextStyle(fontSize: 18),
                            ),
                            trailing: Obx(
                              () => Switch(
                                value: controller.enableFaceLogin.value,
                                onChanged: (boolValue) => controller
                                    .toggleFaceLoginStatus(value: boolValue),
                                activeTrackColor: Colors.black12,
                                activeColor: AppConfig.materialMainBlueColor,
                                inactiveTrackColor: Colors.black12,
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
                GestureDetector(
                  onTap: () => controller.toggleNotificationStatus(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(bottom: BorderSide(color: Colors.black12)),
                    ),
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black12,
                        ),
                        child: const Icon(
                          Icons.notifications_none,
                          color: Colors.black54,
                          size: 30,
                        ),
                      ),
                      title: Text(
                        "nhan thong bao".tr,
                        style: const TextStyle(fontSize: 18),
                      ),
                      trailing: Obx(
                        () => Switch(
                          value: controller.enableNotification.value,
                          onChanged: (boolValue) => controller
                              .toggleNotificationStatus(value: boolValue),
                          activeTrackColor: Colors.black12,
                          activeColor: AppConfig.materialMainBlueColor,
                          inactiveTrackColor: Colors.black12,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => controller.watchInstruction(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(bottom: BorderSide(color: Colors.black12)),
                    ),
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black12,
                        ),
                        child: const Icon(
                          Icons.amp_stories_outlined,
                          color: Colors.black54,
                          size: 30,
                        ),
                      ),
                      title: Text(
                        "xem huong dan".tr,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => controller.shareApp(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(bottom: BorderSide(color: Colors.black12)),
                    ),
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black12,
                        ),
                        child: const Icon(
                          Icons.share,
                          color: Colors.black54,
                          size: 30,
                        ),
                      ),
                      title: Text(
                        "chia se ung dung".tr,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: const BoxDecoration(color: Colors.white),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black12,
                      ),
                      child: const Icon(
                        Icons.mobile_friendly,
                        color: Colors.black54,
                        size: 30,
                      ),
                    ),
                    title: Text(
                      "phien ban ung dung".tr,
                      style: const TextStyle(fontSize: 18),
                    ),
                    trailing: Obx(
                      () => Text(
                        controller.version.value,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => controller.updateRequest.value
                      ? _updateRequestNotify()
                      : const SizedBox.shrink(),
                ),
              ],
            )
          : NoInternet(onPressed: () => controller.onInit()),
    );
  }

  Widget _updateRequestNotify() {
    return Expanded(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'ung dung da co phien ban moi'.tr,
              style: const TextStyle(fontSize: 18),
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 8)),
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 120),
              child: ElevatedButton(
                onPressed: () => controller.getAppUpdate(),
                child: Text("cap nhat".tr.toUpperCase()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
