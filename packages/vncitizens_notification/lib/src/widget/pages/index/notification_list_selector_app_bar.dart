import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_notification/src/controller/notification_controller.dart';

class NotificationListSelectorAppBar extends StatelessWidget {
  NotificationListSelectorAppBar({
    Key? key,
  }) : super(key: key);

  final controller = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Row(
        children: [
          IconButton(
              icon: const Icon(Icons.close),
              color: Colors.white,
              onPressed: () {
                controller.changeSelectedMode();
              }),
          Obx(
            () {
              int selectedNum = controller.getSelectedNum();
              if (selectedNum > 0) {
                return Text('$selectedNum',
                    style: const TextStyle(fontSize: 20));
              } else {
                return const Text('');
              }
            },
          )
        ],
      ),
      leadingWidth: 75,
      backgroundColor: Colors.blue.shade800,
      actions: [
        Obx(() {
          if (controller.isSelectedAll.value) {
            return InkWell(
                child: Row(
                  children: [
                    const Icon(Icons.radio_button_checked, color: Colors.white),
                    const SizedBox(
                      width: 8,
                    ),
                    Text("chon tat ca".tr)
                  ],
                ),
                onTap: () {
                  controller.unselectAll();
                });
          } else {
            return InkWell(
                child: Row(
                  children: [
                    const Icon(Icons.radio_button_unchecked,
                        color: Colors.white),
                    const SizedBox(
                      width: 8,
                    ),
                    Text("chon tat ca".tr)
                  ],
                ),
                onTap: () {
                  controller.selectAll();
                });
          }
        }),
        Obx(() {
          if (controller.fcmId.value.isNotEmpty) {
            return IconButton(
                icon: const Icon(Icons.mark_email_read),
                color: Colors.white,
                tooltip: "danh dau da doc".tr,
                onPressed: () {
                  _buildMarkAsReadDialog(controller);
                });
          } else {
            return const SizedBox();
          }
        }),
        Obx(() {
          if (controller.fcmId.value.isNotEmpty) {
            return IconButton(
                icon: const Icon(Icons.delete_forever_outlined),
                color: Colors.white,
                tooltip: "xoa".tr,
                onPressed: () {
                  _buildDeleteDialog(controller);
                });
          } else {
            return const SizedBox(
              width: 16,
            );
          }
        })
      ],
    );
  }

  void _buildMarkAsReadDialog(NotificationController controller) {
    Get.defaultDialog(
      title: '',
      titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      content: SizedBox(
        height: 115,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'xac nhan'.tr,
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'danh dau da doc tat ca thong bao'.tr,
                    textAlign: TextAlign.left,
                    style: const TextStyle(fontSize: 14),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      "dong".tr.toUpperCase(),
                      style: const TextStyle(color: Color(0xff0D47A1)),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      controller.markFcmAsRead();
                      controller.changeSelectedMode();
                      Get.back();
                    },
                    child: Text(
                      "dong y".tr.toUpperCase(),
                      style: const TextStyle(color: Color(0xff0D47A1)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      radius: 4,
      barrierDismissible: false,
    );
  }

  void _buildDeleteDialog(NotificationController controller) {
    Get.defaultDialog(
      title: '',
      titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      content: SizedBox(
        height: 115,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'xac nhan'.tr,
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'xoa tat ca thong bao'.tr,
                    textAlign: TextAlign.left,
                    style: const TextStyle(fontSize: 14),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      "dong".tr.toUpperCase(),
                      style: const TextStyle(color: Color(0xff0D47A1)),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      controller.markFcmAsDelete();
                      controller.changeSelectedMode();
                      Get.back();
                    },
                    child: Text(
                      "dong y".tr.toUpperCase(),
                      style: const TextStyle(color: Color(0xff0D47A1)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      radius: 4,
      barrierDismissible: false,
    );
  }
}
