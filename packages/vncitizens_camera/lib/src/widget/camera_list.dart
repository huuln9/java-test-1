import 'package:flutter/material.dart';
import 'package:vncitizens_camera/src/config/camera_app_config.dart';
import 'package:vncitizens_camera/src/controller/camera_list_controller.dart';
import 'package:vncitizens_camera/src/model/place_group_model.dart';
import 'package:vncitizens_camera/src/widget/component/api_error_widget.dart';
import 'package:vncitizens_camera/src/widget/component/linear_loading_widget.dart';
import 'package:vncitizens_common/vncitizens_common.dart';

class CameraList extends GetView<CameraListController> {
  const CameraList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: const MyBottomAppBar(index: -1),
        backgroundColor: const Color(0xFFF0F0F0),
        appBar: AppBar(
          title: Obx(() => !controller.isShowSearchInput.value
              ? const Text("Camera")
              : _SearchInput(controller: controller)),
          actions: [
            Obx(() => controller.isShowSearchInput.value
                ? IconButton(onPressed: () => controller.onClickSearchDeleteIcon(), icon: const Icon(Icons.close))
                : IconButton(onPressed: () => controller.onTapIconSearch(), icon: const Icon(Icons.search))),

            /// show only if enable map
            if (CameraAppConfig.enableMap)
              IconButton(onPressed: () => controller.onTapAppBarAction(), icon: const Icon(Icons.map_outlined)),
          ],
        ),
        body: Obx(
          () => controller.hasConnected.value != true
              ? Container(color: Colors.white, child: NoInternet(onPressed: () {}))
              : controller.isInitialized.value != true
                ? const LinearLoadingWidget()
                : controller.isInitError.value
                    ? ApiErrorWidget(retry: () => controller.init())
                    : SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 40),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Obx(
                                () => controller.groupCameras.isEmpty
                                    ? ConstrainedBox(
                                        constraints: BoxConstraints(
                                          minHeight: MediaQuery.of(context).size.height * 0.73,
                                          maxHeight: MediaQuery.of(context).size.height * 0.73,
                                        ),
                                        child: Center(child: Text("khong tim thay camera".tr)))
                                    : _buildListGroupCamera(context),
                              ),
                            ],
                          ),
                        ),
                      ),
        ),
      ),
    );
  }

  Widget _buildListGroupCamera(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children:
          List.generate(controller.groupCameras.length, (index) => Obx(() => _buildGroupCamera(context, controller.groupCameras[index], index))),
    );
  }

  Widget _buildGroupCamera(BuildContext context, PlaceGroupModel groupCamera, int groupIndex) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(
          groupCamera.name,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        initiallyExpanded: groupIndex == 0,
        onExpansionChanged: (bool value) => controller.onExpansionChanged(value, groupCamera.id),
        iconColor: Colors.black,
        tilePadding: const EdgeInsets.symmetric(horizontal: 6),
        children: groupCamera.places.isEmpty
            ? [
                Obx(() => controller.isLoadingCamera.value == true
                    ? const Padding(padding: EdgeInsets.symmetric(vertical: 14), child: CircularProgressIndicator())
                    : Text("khong tim thay camera".tr))
              ]
            : List.generate(groupCamera.places.length, (index) {
                final item = groupCamera.places[index];
                List<String?> addressStr = [item.address, item.fullPlace]..removeWhere((element) => element == null || element.isEmpty);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      onTap: () => controller.onTapCameraItem(item),
                      leading: Image.asset("${CameraAppConfig.assetsRoot}/images/camera.png", width: 36),
                      title: Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(item.name, style: const TextStyle(fontWeight: FontWeight.w500)),
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      subtitle: Text(addressStr.join(" - "), style: const TextStyle(color: Colors.black87)),
                      visualDensity: VisualDensity.compact,
                      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
                    ),
                  ),
                );
              }),
      ),
    );
  }
}

class _SearchInput extends StatelessWidget {
  const _SearchInput({Key? key, required this.controller}) : super(key: key);

  final CameraListController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: true,
      controller: controller.searchController,
      onChanged: (value) => controller.onChangeSearch(value),
      onEditingComplete: () => controller.onSearchComplete(),
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: const EdgeInsets.only(left: 10, right: 10),
        hintText: "nhap dia diem".tr,
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.transparent,
      ),
    );
  }
}
