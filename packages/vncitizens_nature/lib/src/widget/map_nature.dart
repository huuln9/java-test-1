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
            title: Text("nature".tr),
          ),
          body: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height,
              maxWidth: MediaQuery.of(context).size.width,
            ),
            child: Stack(
              children: [
                _buildMapNature(context),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: TextFormField(
                      style: const TextStyle(color: Color.fromRGBO(67, 67, 67, 1), fontSize: 16),
                      controller: controller.searchController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        fillColor: Colors.white,
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color.fromRGBO(206, 206, 206, 1), width: 1.0),
                          borderRadius: BorderRadius.circular(3.5),
                        ),
                        hintText: "enterlocation".tr,
                        isDense: true,
                        contentPadding: const EdgeInsets.all(14),
                        suffixIcon: Obx(() => Visibility(
                            visible: controller.isShowSearchDeleteIcon.value,
                            child: IconButton(
                              onPressed: () => controller.onClickSearchDeleteIcon(),
                              icon: const Icon(Icons.close, size: 24),
                            ),
                          ),
                        )),
                        onChanged: (value) => controller.onChangeSearch(value),
                        onEditingComplete: () => controller.onSearchComplete(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMapNature(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Obx(
            () => FlutterMap(
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
            ),
          ),
        ),
      ],
    );
  }

  List<Marker> _getListNatureMarket() {
    const double iconSize = 30;
    List<Marker> list = [];
    for (var element in controller.natureStationItemModel) {
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
