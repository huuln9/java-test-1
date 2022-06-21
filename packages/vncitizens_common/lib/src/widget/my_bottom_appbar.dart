import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:vncitizens_common/src/controller/internet_controller.dart';
import 'package:vncitizens_common/src/controller/notification_counter_controller.dart';

/// [index] là vị trí của item trong bottomAppBar dùng để đánh dấu item được active.
///
/// Nếu [index] không được truyền hoặc bằng 0 thì item đầu tiên được active
class MyBottomAppBar extends StatelessWidget {
  const MyBottomAppBar(
      {Key? key,
      this.index,
      this.settingCallback,
      this.additionalSettingFunction,
      this.notifyCallback,
      this.additionalNotifyFunction,
      this.qrCallback,
      this.additionalQrFunction,
      this.homeCallback,
      this.additionalHomeFunction,
      this.accountCallback,
      this.additionalAccountFunction})
      : super(key: key);

  final int? index;
  final Function? homeCallback;
  final Function? additionalHomeFunction;
  final Function? settingCallback;
  final Function? additionalSettingFunction;
  final Function? notifyCallback;
  final Function? additionalNotifyFunction;
  final Function? qrCallback;
  final Function? additionalQrFunction;
  final Function? accountCallback;
  final Function? additionalAccountFunction;
  static const double iconSize = 24;
  static const Color activeColor = Color.fromRGBO(21, 101, 192, 1);

  @override
  Widget build(BuildContext context) {
    NotificationCounterController controller =
        Get.put(NotificationCounterController());
    InternetController internetController = Get.put(InternetController());
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 5,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
              onPressed: () {
                if (Get.currentRoute != "/vncitizens_home") {
                  additionalHomeFunction?.call();
                  Get.offAllNamed("/vncitizens_home")?.then((value) {
                    homeCallback?.call();
                  });
                }
              },
              icon: index == null || index == 0
                  ? const Icon(Icons.home, size: iconSize, color: activeColor)
                  : const Icon(Icons.home_outlined, size: iconSize)),
          Obx(() {
            if (internetController.hasConnected.value) {
              if (controller.num.value > 0) {
                return IconButton(
                    onPressed: () {
                      additionalNotifyFunction?.call();
                      Get.toNamed("/vncitizens_notification")?.then((value) {
                        notifyCallback?.call();
                      });
                    },
                    icon: Badge(
                        shape: BadgeShape.square,
                        toAnimate: false,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        badgeColor: Colors.redAccent.shade700,
                        borderRadius: BorderRadius.circular(8),
                        badgeContent: Text(
                            controller.num < 100
                                ? controller.num.value.toString()
                                : '99+',
                            style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500)),
                        child: index != null && index == 1
                            ? const Icon(Icons.notifications_outlined,
                                size: iconSize, color: activeColor)
                            : const Icon(Icons.notifications_outlined,
                                size: iconSize)));
              } else {
                return IconButton(
                    onPressed: () {
                      additionalNotifyFunction?.call();
                      Get.toNamed("/vncitizens_notification")?.then((value) {
                        notifyCallback?.call();
                      });
                    },
                    icon: index != null && index == 1
                        ? const Icon(Icons.notifications_outlined,
                            size: iconSize, color: activeColor)
                        : const Icon(Icons.notifications_outlined,
                            size: iconSize));
              }
            } else {
              return IconButton(
                  onPressed: () {
                    additionalNotifyFunction?.call();
                    Get.toNamed("/vncitizens_notification")?.then((value) {
                      notifyCallback?.call();
                    });
                  },
                  icon: index != null && index == 1
                      ? const Icon(Icons.notifications_outlined,
                          size: iconSize, color: activeColor)
                      : const Icon(Icons.notifications_outlined,
                          size: iconSize));
            }
          }),
          // SizedBox(width: MediaQuery.of(context).size.width / 6),
          IconButton(
              onPressed: () {
                additionalSettingFunction?.call();
                Get.toNamed("/vncitizens_qrcode")?.then((value) {
                  settingCallback?.call();
                });
              },
              icon: DecoratedBox(
                  decoration: BoxDecoration(boxShadow: const [
                    BoxShadow(
                        color: Color.fromRGBO(21, 101, 192, 1),
                        spreadRadius: 10)
                  ], borderRadius: BorderRadius.circular(100)),
                  child: const Icon(
                    Icons.qr_code,
                    size: iconSize,
                    color: Colors.white,
                  ))),
          IconButton(
              onPressed: () {
                additionalSettingFunction?.call();
                Get.toNamed("/vncitizens_setting")?.then((value) {
                  settingCallback?.call();
                });
              },
              icon: index != null && index == 2
                  ? const Icon(Icons.settings_outlined,
                      size: iconSize, color: activeColor)
                  : const Icon(Icons.settings_outlined, size: iconSize)),
          IconButton(
              onPressed: () {
                final bool isLoggedIn =
                    Hive.box("vncitizens_account").get("is_logon") ??
                        false;
                if (isLoggedIn) {
                  additionalAccountFunction?.call();
                  Get.toNamed("/vncitizens_account/user_detail")
                      ?.then((value) {
                    accountCallback?.call();
                  });
                } else {
                  additionalAccountFunction?.call();
                  Get.toNamed("/vncitizens_account/login")
                      ?.then((value) {
                    accountCallback?.call();
                  });
                }
              },
              icon: index != null && index == 3
                  ? const Icon(Icons.person_outline,
                      size: iconSize, color: activeColor)
                  : const Icon(Icons.person_outline, size: iconSize)),
        ],
      ),
    );
  }
}
