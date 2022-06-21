import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_notification/src/controller/notification_controller.dart';
import 'package:vncitizens_notification/src/model/notification_selector_model.dart';

import '../detail/notification_detail.dart';
import 'notification_selector_circle.dart';

class NotificationListBodyItem extends StatelessWidget {
  NotificationListBodyItem({Key? key, required this.index}) : super(key: key);

  final int index;
  final _ctrl = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      child: Obx(() {
        NotificationSelectorModel notification = _ctrl.notifications[index];
        Uint8List? iconBytes = _ctrl.iconBytesList[notification.data.id];
        return ListTile(
          contentPadding:
              const EdgeInsets.only(left: 4, right: 6, top: 6, bottom: 6),
          horizontalTitleGap: 2,
          leading: _buildAvatar(notification, iconBytes, _ctrl),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: Get.width - 185,
                child: Text(notification.data.title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: false,
                    style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.05,
                        color: notification.data.fcmViewer.read == 0
                            ? Colors.black
                            : Colors.grey.shade500),
                    textAlign: TextAlign.justify),
              ),
              SizedBox(
                child: Text(_getDate(notification.data.sentDate),
                    style: GoogleFonts.roboto(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.05,
                        color: notification.data.fcmViewer.read == 0
                            ? Colors.black
                            : Colors.grey.shade500)),
              )
            ],
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: Get.width - 150,
                child: Text(notification.data.content,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    softWrap: false,
                    style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.25,
                        color: notification.data.fcmViewer.read == 0
                            ? Colors.black.withOpacity(0.7)
                            : Colors.grey.shade500),
                    textAlign: TextAlign.justify),
              ),
              InkWell(
                onTap: () {
                  _buildBottomSheet(notification, _ctrl);
                },
                child: const Icon(Icons.more_vert, color: Colors.black),
              )
            ],
          ),
          onTap: () {
            if (_ctrl.isSelectedMode.value) {
              _ctrl.toggle(index);
            } else {
              _ctrl.index.value = index;
              _ctrl.id.value = notification.data.id;
              Get.to(NotificationDetail(id: notification.data.id));
            }
          },
        );
      }),
    );
  }

  Widget _buildAvatar(NotificationSelectorModel notification,
      Uint8List? iconBytes, NotificationController _ctrl) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: CircleAvatar(
            radius: 22,
            backgroundColor: CharColorHelper
                .characterColor[notification.data.title[0].toLowerCase()],
            child: iconBytes != null
                ? ClipRRect(
                    child: Image.memory(iconBytes),
                    borderRadius: BorderRadius.circular(36),
                  )
                : Text(
                    notification.data.title[0].toUpperCase(),
                    style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w500),
                  ),
          ),
        ),
        Obx(() {
          if (_ctrl.isSelectedMode.value) {
            return NotificationSelectorCircle(data: notification);
          } else {
            return const SizedBox();
          }
        })
      ],
    );
  }

  void _buildBottomSheet(
      NotificationSelectorModel notification, NotificationController _ctrl) {
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
        notification.data.fcmViewer.read != 1
            ? SizedBox(
                height: 40,
                child: Center(
                  child: ListTile(
                      leading: const Icon(Icons.class__outlined),
                      title: Text('danh dau da doc'.tr),
                      onTap: () {
                        _ctrl.id.value = notification.data.id;
                        _ctrl.index.value = index;
                        _ctrl.markFcmAsReadById(notification.data.id);
                        Get.back();
                      }),
                ),
              )
            : const SizedBox(),
        SizedBox(
          height: 40,
          child: Center(
            child: ListTile(
                leading: const Icon(Icons.delete_outlined),
                title: Text('xoa'.tr),
                onTap: () {
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                child: Text(
                                  'xoa thong bao'.tr,
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
                                    _ctrl.id.value = notification.data.id;
                                    _ctrl.index.value = index;
                                    _ctrl.markFcmAsDeleteById();
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

  String _getDate(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(dateTime);
  }
}
