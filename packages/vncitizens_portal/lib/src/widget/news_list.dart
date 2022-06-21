import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_portal/src/controller/portal_controller.dart';

class NewsList extends GetView<PortalController> {
  NewsList({Key? key}) : super(key: key);

  final InternetController _internetController = Get.put(InternetController());

  Widget _filteredTag() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        spacing: 5.0,
        children: [
          for (var resource in controller.resources.where((r) => r.active))
            ActionChip(
                label: Text(
                  resource.name,
                  style:
                      const TextStyle(color: Color.fromARGB(255, 21, 101, 192)),
                ),
                backgroundColor: Colors.grey.shade100,
                shape: StadiumBorder(
                  side: BorderSide(width: 1, color: Colors.blue.shade800),
                ),
                onPressed: () {
                  controller.resourceChange(resource);
                  if (controller.checkAllResourceIsDeactive()) {
                    controller.changeAll(true);
                    controller.search(false);
                  } else {
                    controller.search(true);
                  }
                }),
          for (var category in controller.categories.where((c) => c.active))
            ActionChip(
              label: Text(
                category.name ?? '',
                style:
                    const TextStyle(color: Color.fromARGB(255, 21, 101, 192)),
              ),
              backgroundColor: Colors.grey.shade100,
              shape: StadiumBorder(
                side: BorderSide(width: 1, color: Colors.blue.shade800),
              ),
              onPressed: () {
                controller.categoryChange(category);
                if (controller.checkAllCategoryIsDeactive()) {
                  controller.changeAll(true);
                  controller.search(false);
                } else {
                  controller.search(true);
                }
              },
            ),
          ActionChip(
            label: Text(
              "xoa bo loc".tr,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
            onPressed: () => controller.unsearch(),
          ),
        ],
      ),
    );
  }

  Widget _listAllNews() {
    return ListView.builder(
      controller: controller.scrollController,
      itemCount: controller.listNews.length,
      itemBuilder: (BuildContext context, int index) {
        return index >= controller.listNews.length
            ? const Center(child: CircularProgressIndicator())
            : index == 0
                ? Obx(() => controller.searchMode.value
                    ? _filteredTag()
                    : GestureDetector(
                        onTap: () async => await controller.toDetailPage(index),
                        child: Column(
                          children: [
                            controller.listNews[index].thumbnail != ""
                                ? Image(
                                    image: NetworkImage(
                                        controller.listNews[index].thumbnail!),
                                    errorBuilder: (
                                      BuildContext context,
                                      Object exception,
                                      StackTrace? stackTrace,
                                    ) =>
                                        const SizedBox.shrink())
                                : const SizedBox.shrink(),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8, right: 8, left: 8),
                              child: Text(
                                controller.listNews[index].title,
                                textAlign: TextAlign.justify,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 8, bottom: 8, left: 8),
                              child: Text(
                                controller.listNews[index].description,
                                textAlign: TextAlign.justify,
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black45),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                      ))
                : GestureDetector(
                    onTap: () async => await controller.toDetailPage(index),
                    child: Container(
                      padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
                      child: Row(
                        children: [
                          controller.listNews[index].thumbnail != ""
                              ? Image(
                                  image: NetworkImage(
                                      controller.listNews[index].thumbnail!),
                                  width: 100,
                                  height: 80,
                                  errorBuilder: (
                                    BuildContext context,
                                    Object exception,
                                    StackTrace? stackTrace,
                                  ) =>
                                      const SizedBox.shrink())
                              : const SizedBox.shrink(),
                          Expanded(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    controller.listNews[index].title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    controller.listNews[index].description,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 15.0, color: Colors.black45),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.black12))),
                    ),
                  );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _internetController.hasConnected.value
          ? !controller.isInitLoading.value
              ? _listAllNews()
              : const Center(child: CircularProgressIndicator())
          : NoInternet(onPressed: () => controller.onInit()),
    );
  }
}
