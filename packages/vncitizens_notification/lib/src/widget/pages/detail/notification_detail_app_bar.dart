import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_notification/src/controller/notification_detail_controller.dart';

class NotificationDetailAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  NotificationDetailAppBar({
    Key? key,
  }) : super(key: key);

  final _controller = Get.put(NotificationDetailController());

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text("chi tiet thong bao".tr),
      backgroundColor: Colors.blue.shade800,
      actions: [
        IconButton(
            icon: const Icon(Icons.more_vert),
            color: Colors.white,
            onPressed: () {
              _buildBottomSheet();
            })
      ],
    );
  }

  void _buildBottomSheet() {
    Get.bottomSheet(
      Wrap(children: [
        Container(
            alignment: FractionalOffset.topRight,
            child: InkWell(
              child: const Padding(
                padding: EdgeInsets.only(top: 8, right: 16),
                child: Icon(Icons.clear),
              ),
              onTap: () {
                Get.back();
              },
            )),
        SizedBox(
          height: 40,
          child: ListTile(
            leading: const Icon(Icons.delete_outlined),
            title: Text('xoa'.tr),
            onTap: () {
              Get.back();
              _buildDialog();
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

  void _buildDialog() {
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
                      _controller.markFcmAsDeleteById();
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

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}
