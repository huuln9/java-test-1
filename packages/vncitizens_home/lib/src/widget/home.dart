import 'dart:developer';
import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vncitizens_common/vncitizens_common.dart' show MyBottomAppBar, MyFloatingActionButton;
import 'package:vncitizens_home/src/config/home_app_config.dart';
import 'package:vncitizens_home/src/controller/home_controller.dart';
import 'package:vncitizens_home/src/model/menu_model.dart';

class Home extends GetView<HomeController> {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log("HOME BUILD");
    controller.showUpdateDialog.listen((value) {
      if (value && !controller.updateDialogShowed) {
        WidgetsBinding.instance?.addPostFrameCallback((_) => showAppUpdateDialog());
        controller.setUpdateDialogShowed(true);
      }
    });
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(children: [Expanded(child: banner(context))]),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [buildCurrentTime(context), buildWeather(context), _buildUserAvatar()],
                ),
              ),

              /// render menu
              for (int i = 0; i < controller.menuData.length; i++) gridMenu(context, i)
            ],
          ),
        ),
        // floatingActionButton: const MyFloatingActionButton(),
        // floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
        bottomNavigationBar: const MyBottomAppBar());
  }

  Widget _buildUserAvatar() {
    if (!controller.checkUserLoggedIn()) {
      return GestureDetector(
        onTap: () => Get.toNamed("/vncitizens_account/login"),
        child: GetBuilder<HomeController>(
          builder: (_) => controller.avatarBytes == null
              ? const Icon(Icons.account_circle, size: 34)
              : SizedBox(
                  width: 34,
                  height: 34,
                  child: CircleAvatar(
                    backgroundImage: Image.memory(controller.avatarBytes as Uint8List).image,
                  ),
              ),
        )
      );
    } else {
      return GestureDetector(
        onTap: () => controller.onTapAvatar(),
        child: GetBuilder<HomeController>(
          builder: (_) => controller.avatarBytes == null
              ? Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: Color.fromRGBO(6, 143, 224, 1)),
                  child: Center(
                    child: Text(
                      controller.getShortStringFromName(),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              : SizedBox(
                  child: CircleAvatar(
                    backgroundImage: Image.memory(controller.avatarBytes as Uint8List).image,
                  ),
                ),
        ),
      );
    }
  }

  buildCurrentTime(BuildContext context) {
    return Flexible(
      flex: 1,
      child: Row(
        children: [
          const Icon(Icons.date_range, size: 26, color: Color.fromRGBO(152, 156, 159, 1)),
          const SizedBox(width: 8),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(controller.getCurrentDateStr(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Obx(() => Text(controller.currentALStr.value, style: const TextStyle(fontSize: 12))),
            ],
          )
        ],
      ),
    );
  }

  buildWeather(BuildContext context) {
    return Flexible(
      flex: 1,
      child: InkWell(
       onTap: () => Get.toNamed("/vncitizens_weather/weather"),
        child: Row(
          children: [
            const Image(image: AssetImage("${HomeAppConfig.assetsRoot}/images/others/cloudy.png"), width: 26),
            const SizedBox(width: 8),
            Obx(() => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(controller.celsiusStr.value + "\u2103",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(controller.locationName.value, style: const TextStyle(fontSize: 12)),
              ],
            )),
          ],
        ),
      ),

    );
  }

  banner(BuildContext context) {
    return Obx(
      () => CarouselSlider(
        options: CarouselOptions(aspectRatio: 16 / 9, viewportFraction: 1, autoPlay: true),
        items: List.generate(controller.bannerImages.length, (index) {
          return Image.network(
            controller.bannerImages[index],
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
          );
        }),
      ),
    );
  }

  gridMenu(BuildContext context, int indexGroup) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(width: 4.0, color: Color.fromRGBO(229, 229, 229, 1)),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (controller.menuData[indexGroup].groupName.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                controller.menuData[indexGroup].groupName.tr,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, mainAxisExtent: 100, crossAxisSpacing: 15, mainAxisSpacing: 20),
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.menuData[indexGroup].menu.length,
            itemBuilder: (context, indexMenu) {
              final menu = controller.menuData[indexGroup].menu[indexMenu];
              return GestureDetector(
                  onTap: () => controller.onTapMenu(
                        menu,
                        callbackSubmenu: () => showBottomSheet(context, menu),
                        callbackLogin: showRequiredLoginDialog,
                      ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      menu.networkIcon != null
                          ? Image.network(menu.networkIcon!, width: 34, height: 34)
                          : Image(image: AssetImage(menu.icon!), width: 34, height: 34),
                      const SizedBox(height: 6),
                      Expanded(child: Text(menu.name.tr, textAlign: TextAlign.center)),
                    ],
                  ));
            },
          )
        ],
      ),
    );
  }

  showBottomSheet(BuildContext context, MenuModel menuModel) {
    showModalBottomSheet(
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 12, left: 12, right: 12, bottom: 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                        child: Center(
                            child: Text(menuModel.name.tr,
                                style: TextStyle(
                                  fontSize: Theme.of(context).textTheme.headline6!.fontSize,
                                  fontWeight: FontWeight.bold,
                                )))),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, mainAxisExtent: 100, crossAxisSpacing: 15, mainAxisSpacing: 20),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: menuModel.child!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => controller.onTapMenu(menuModel.child![index]),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          menuModel.child![index].networkIcon != null
                              ? Image.network(menuModel.child![index].networkIcon!, width: 34, height: 34)
                              : Image(image: AssetImage(menuModel.child![index].icon!), width: 34, height: 34),
                          const SizedBox(height: 6),
                          Expanded(child: Text(menuModel.child![index].name.tr, textAlign: TextAlign.center)),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  showAppUpdateDialog() {
    Get.defaultDialog(
      barrierDismissible: false,
      title: "",
      titleStyle: const TextStyle(fontSize: 0),
      contentPadding: const EdgeInsets.all(16),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FractionallySizedBox(
              widthFactor: 0.6,
              child: Image.asset(
                "${HomeAppConfig.assetsRoot}/images/others/update_image.png",
              )),
          const SizedBox(height: 26),
          controller.updateRequired.value
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("ung dung da co phien ban moi".tr + "."),
                    const SizedBox(height: 4),
                    Text("vui long cap nhat de tiep tuc su dung".tr),
                  ],
                )
              : Text("ung dung da co phien ban moi".tr),
          const SizedBox(height: 26),
          controller.updateRequired.value
              ? ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 120),
                  child: ElevatedButton(onPressed: () => controller.onTapUpdate(), child: Text("cap nhat".tr.toUpperCase())),
                )
              : Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 120),
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        child: Text("bo qua".tr.toUpperCase()),
                      ),
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 120),
                      child: ElevatedButton(
                        onPressed: () => controller.onTapUpdate(),
                        child: Text("cap nhat".tr.toUpperCase()),
                      ),
                    ),
                  ],
                )
        ],
      ),
    );
  }

  showRequiredLoginDialog() {
    Get.dialog(
        AlertDialog(
          title: Text("dang nhap".tr),
          content: Text("chuc nang can dang nhap truoc".tr),
          titlePadding: const EdgeInsets.all(20),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          actionsPadding: EdgeInsets.zero,
          actions: [
            TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  "dong".tr.toUpperCase(),
                  style: const TextStyle(color: HomeAppConfig.materialMainBlueColor, fontWeight: FontWeight.bold),
                )),
            TextButton(
                onPressed: () {
                  Get.back();
                  Get.toNamed("/vncitizens_account/login");
                },
                child: Text(
                  "dang nhap".tr.toUpperCase(),
                  style: const TextStyle(color: HomeAppConfig.materialMainBlueColor, fontWeight: FontWeight.bold),
                )),
          ],
        ),
        barrierDismissible: false);
  }
}
