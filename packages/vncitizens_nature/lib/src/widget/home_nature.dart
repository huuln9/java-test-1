import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_nature/src/config/app_config.dart';
import 'package:vncitizens_nature/src/controller/home_nature_controller.dart';

class HomeNature extends GetView<HomeNatureController> {
  const HomeNature({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: const MyBottomAppBar(),
        appBar: AppBar(
          title: Text("nature".tr),
          actions: [
            IconButton(
              onPressed: () => controller.onTapOutlinedAction(),
              icon: const Icon(Icons.map_outlined),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    controller: controller.searchController,
                    onChanged: (value) => controller.onChangeSearch(value),
                    onEditingComplete: () => controller.onSearchComplete(),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(
                          left: 10, top: 15, bottom: 0, right: 10),
                      border: InputBorder.none,
                      hintText: "enterlocation".tr,
                      suffixIcon: Obx(
                        () => Visibility(
                          visible: controller.isShowSearchDeleteIcon.value,
                          child: IconButton(
                            onPressed: () => controller.onClickSearchDeleteIcon(),
                            icon: const Icon(Icons.close, size: 24),
                          ),
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                Obx(
                  () => !controller.isInitialized.value
                      ? _buildLoadingData(context)
                      : controller.natureStationList.isEmpty
                          ? _buildWithEmptyData(context)
                          : _buildWithData(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWithEmptyData(BuildContext context) {
    return ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * 0.6,
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(
                      "${AppConfig.assetsRoot}/images/error_loading_nature_station.png",
                      width: 86),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("notfound".tr),
                ),
              ],
            ),
            ),
    );
  }

  Widget _buildWithData(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: controller.searchEmptyData.value
          ? [_buildSearchEmptyData()]
          : List.generate(controller.natureStationList.length, (index) {
              final item = controller.natureStationList[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      color: Colors.white, borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    onTap: () => controller.onClickNatureStationItem(item),
                    leading: Image.asset(
                        "${AppConfig.assetsRoot}/images/nature_station.png",
                        width: 36),
                    title: Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(item.su_name,
                          style: const TextStyle(fontWeight: FontWeight.w500)),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    subtitle: Text(item.su_address,
                        style: const TextStyle(color: Colors.black87)),
                    visualDensity: VisualDensity.compact,
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
                  ),
                ),
              );
      }),
    );
  }

  Widget _buildLoadingData(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.6,
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Text("loadingdata".tr, style: const TextStyle(fontSize: 18)),
              margin: const EdgeInsets.all(20),
            ),
            Container(
              margin: const EdgeInsets.all(20),
              child: const LinearProgressIndicator(
                backgroundColor: Color.fromRGBO(21, 101, 192, 0.2),
                color: Color.fromRGBO(21, 101, 192, 1),
                minHeight: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchEmptyData() {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(Get.context!).size.height * 0.6,
        maxHeight: MediaQuery.of(Get.context!).size.height * 0.6,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Text("emptydata".tr, style: const TextStyle(fontSize: 16)),
              margin: const EdgeInsets.all(20),
            ),
          ],
        ),
      ),
    );
  }
}
