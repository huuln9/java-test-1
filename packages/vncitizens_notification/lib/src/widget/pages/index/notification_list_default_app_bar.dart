import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_notification/src/controller/notification_controller.dart';

class NotificationListDefaultAppBar extends StatelessWidget {
  NotificationListDefaultAppBar({
    Key? key,
  }) : super(key: key);

  final controller = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        "thong bao".tr,
        style: AppBarStyle.title,
      ),
      backgroundColor: Colors.blue.shade800,
      actions: [
        IconButton(
            icon: const Icon(Icons.more_vert),
            color: Colors.white,
            onPressed: () {
              _buildBottomSheet(controller);
            })
      ],
    );
  }

  void _buildBottomSheet(NotificationController controller) {
    Get.bottomSheet(
      Wrap(children: [
        Container(
            alignment: FractionalOffset.topRight,
            child: InkWell(
              child: const Padding(
                padding: EdgeInsets.only(top: 8, right: 8),
                child: Icon(Icons.clear),
              ),
              onTap: () {
                Get.back();
              },
            )),
        SizedBox(
          height: 40,
          child: ListTile(
            leading: const Icon(Icons.task_alt),
            title: Text('chon nhieu'.tr),
            onTap: () {
              controller.changeSelectedMode();
              Get.back();
            },
          ),
        ),
        Obx(() {
          if (controller.showMarkFcmAsReadBtn()) {
            return SizedBox(
              height: 40,
              child: ListTile(
                  leading: const Icon(Icons.class__outlined),
                  title: Text('danh dau da doc'.tr),
                  onTap: () {
                    Get.back();
                    Get.defaultDialog(
                      title: '',
                      titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
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
                                      style: const TextStyle(
                                          color: Color(0xff0D47A1)),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      controller.markFcmAsReadAll();
                                      Get.back();
                                    },
                                    child: Text(
                                      "dong y".tr.toUpperCase(),
                                      style: const TextStyle(
                                          color: Color(0xff0D47A1)),
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
                  }),
            );
          } else {
            return const SizedBox();
          }
        }),
        SizedBox(
          height: 40,
          child: ListTile(
            leading: const Icon(Icons.delete_outlined),
            title: Text('xoa tat ca'.tr),
            onTap: () {
              _buildDeleteAllDialog(controller);
            },
          ),
        ),
        const SizedBox(height: 55),
      ]),
      backgroundColor: Colors.white,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
      ),
      isScrollControlled: true,
    );
  }

  void _buildDeleteAllDialog(NotificationController controller) {
    Get.back();
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
                      controller.markFcmAsDeleteAll();
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
