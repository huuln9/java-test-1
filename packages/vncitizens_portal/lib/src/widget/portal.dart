import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_portal/src/config/app_config.dart';
import 'package:vncitizens_portal/src/controller/portal_controller.dart';
import 'package:vncitizens_portal/src/widget/news_detail.dart';
import 'package:vncitizens_portal/src/widget/news_list.dart';

class Portal extends GetView<PortalController> {
  const Portal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final route = ModalRoute.of(context)!.settings.name!.split('?')[0];
    return Scaffold(
      appBar: AppBar(
        title: Text("tin tuc".tr),
        actions: [
          route == AppConfig.router['list']
              ? IconButton(
                  onPressed: () {
                    if (!controller.searchMode.value) {
                      controller.changeAll(false);
                    }
                    _openSearchModal();
                  },
                  icon: const Icon(Icons.search),
                )
              : const SizedBox.shrink()
        ],
      ),
      body: route == AppConfig.router['list'] ? NewsList() : NewsDetail(),
      // floatingActionButton: const MyFloatingActionButton(),
      // floatingActionButtonLocation:
      //     FloatingActionButtonLocation.miniCenterDocked,
      bottomNavigationBar: const MyBottomAppBar(index: -1),
    );
  }

  void _openSearchModal() {
    showModalBottomSheet(
      context: Get.context!,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, state) {
          return ListView(
            children: <Widget>[
              Container(
                decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.black12))),
                child: Stack(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Text(
                          'tim kiem'.tr,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(Icons.close),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: Get.width,
                decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.black12))),
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'nguon tin'.tr,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                    Wrap(
                      spacing: 5.0,
                      children: [
                        for (var e in controller.resources)
                          ActionChip(
                            label: Text(
                              e.name,
                              style: e.active
                                  ? const TextStyle(
                                      color: Color.fromARGB(255, 21, 101, 192))
                                  : const TextStyle(color: Colors.black26),
                            ),
                            backgroundColor:
                                Colors.grey.shade100.withOpacity(0.1),
                            shape: StadiumBorder(
                                side: e.active
                                    ? BorderSide(
                                        width: 1, color: Colors.blue.shade800)
                                    : const BorderSide(
                                        width: 1, color: Colors.black12)),
                            onPressed: () =>
                                state(() => controller.resourceChange(e)),
                          ),
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'chuyen muc'.tr,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                    Wrap(
                      spacing: 5.0,
                      children: [
                        for (var e in controller.categories)
                          ActionChip(
                            label: Text(
                              e.name ?? '',
                              style: e.active
                                  ? const TextStyle(
                                      color: Color.fromARGB(255, 21, 101, 192))
                                  : const TextStyle(color: Colors.black26),
                            ),
                            backgroundColor: Colors.grey.shade100,
                            shape: StadiumBorder(
                              side: e.active
                                  ? BorderSide(
                                      width: 1, color: Colors.blue.shade800)
                                  : const BorderSide(
                                      width: 1, color: Colors.black12),
                            ),
                            onPressed: () =>
                                state(() => controller.categoryChange(e)),
                          )
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      child: Text(
                        'bo chon tat ca'.tr.toUpperCase(),
                        style: const TextStyle(color: Colors.black),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(),
                      ),
                      onPressed: () => state(() => controller.changeAll(false)),
                    ),
                    const Padding(padding: EdgeInsets.all(8.0)),
                    ElevatedButton(
                      child: Text('xem ket qua'.tr.toUpperCase()),
                      onPressed: () {
                        Get.back();
                        if (controller.checkAllResourceIsDeactive() ||
                            controller.checkAllCategoryIsDeactive()) {
                          controller.changeAll(true);
                          controller.search(false);
                        } else {
                          controller.search(true);
                        }
                      },
                    )
                  ],
                ),
              )
            ],
          );
        });
      },
    );
  }
}
