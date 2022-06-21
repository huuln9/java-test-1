import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_notification/src/controller/notification_controller.dart';

import 'notification_list_body_item.dart';

class NotificationListBody extends StatelessWidget {
  const NotificationListBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _controller = Get.put(NotificationController());
    final internetController = Get.put(InternetController());

    return Column(
      children: [
        Expanded(child: Obx(() {
          if (internetController.hasConnected.value) {
            if (_controller.isLoading.value) {
              return DataLoading(message: "dang tai danh sach thong bao".tr);
            } else {
              if (_controller.isFailedLoading.value) {
                return DataFailedLoading(
                  onPressed: () {
                    _controller.onInit();
                  },
                );
              } else {
                if (_controller.notifications.isNotEmpty) {
                  return RefreshIndicator(
                    onRefresh: () => _controller.refreshFcmList(),
                    child: ListView.separated(
                      controller: _controller.scrollController,
                      itemBuilder: (context, index) {
                        if (index == _controller.notifications.length - 1 &&
                            _controller.isMoreDataAvailable.value == true) {
                          return const Padding(
                            padding: EdgeInsets.all(20),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        } else {
                          return NotificationListBodyItem(index: index);
                        }
                      },
                      itemCount: _controller.notifications.length,
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 5,
                        );
                      },
                    ),
                  );
                } else {
                  return DataNotFound(message: 'khong tim thay thong bao'.tr);
                }
              }
            }
          } else {
            return NoInternet(
              onPressed: () => {},
            );
          }
        })),
      ],
    );
  }
}
