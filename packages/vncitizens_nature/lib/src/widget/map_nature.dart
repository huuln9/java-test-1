import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:vncitizens_common/vncitizens_common.dart' hide LatLng;
import 'package:latlong2/latlong.dart';
import 'package:vncitizens_nature/src/controller/map_nature_controller.dart';
import 'package:vncitizens_nature/src/model/information_popup_nature_model.dart';
import 'package:vncitizens_nature/src/widget/custom_marker_widget_nature.dart';

class MapNature extends GetView<MapNatureController> {

  MapNature({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Get.isSnackbarOpen) {
          Get.closeCurrentSnackbar();
        }
        return true;
      },
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          bottomNavigationBar: const MyBottomAppBar(),
          appBar: AppBar(
            title: Obx(() => !controller.isShowSearchInput.value
                ? Text("nature".tr, style: const TextStyle(fontSize: 24))
                : _SearchInput(controller: controller)),
            actions: [
              Obx(() => controller.isShowSearchInput.value
                  ? IconButton(onPressed: () => controller.onClickSearchDeleteIcon(), icon: const Icon(Icons.close))
                  : IconButton(onPressed: () => controller.onTapIconSearch(), icon: const Icon(Icons.search))),
              IconButton(
                onPressed: () => controller.onTapListNature(context),
                icon: const Icon(Icons.list),
              )
            ],
          ),
          body: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height,
              maxWidth: MediaQuery.of(context).size.width,
            ),
            child: _buildMapNature(context),
          ),
        ),
      ),
    );
  }

  Widget _buildMapNature(BuildContext context) {
    return Obx(() => FlutterMap(
      mapController: controller.mapController,
      options: MapOptions(
        zoom: controller.defaultZoom,
        minZoom: 1,
        maxZoom: 17,
      ),
      layers: [
        TileLayerOptions(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: ['a', 'b', 'c'],
        ),
        MarkerLayerOptions(
          markers: _getListNatureMarket(),
        ),
      ],
    ));
  }

  List<Marker> _getListNatureMarket() {
    const double iconSize = 30;
    List<Marker> list = [];
    for (var element in controller.natureStationList) {
      list.add(InformationPopupNatureModel(
        point: LatLng(element.su_location_lat, element.su_location_lng),
        width: 40,
        height: 40,
        natureStationItemModel: element,
        builder: (_) => CustomMarkerWidgetNature(
          onPress: () => controller.showDetailStationNature(element),
        ),
      ));
    }

    return list;
  }
}

class _SearchInput extends StatelessWidget {
  const _SearchInput({Key? key, required this.controller}) : super(key: key);

  final MapNatureController controller;

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
        hintText: "enterlocation".tr,
        hintStyle: const TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5), fontSize: 24),
        filled: true,
        fillColor: Colors.transparent,
      ),
    );
  }
}
