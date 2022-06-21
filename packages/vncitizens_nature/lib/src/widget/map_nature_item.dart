import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:vncitizens_common/vncitizens_common.dart' hide LatLng;
import 'package:latlong2/latlong.dart';
import 'package:vncitizens_nature/src/config/app_config.dart';
import 'package:vncitizens_nature/src/controller/map_nature_item_controller.dart';
import 'package:vncitizens_nature/src/model/information_popup_nature_model.dart';
import 'package:vncitizens_nature/src/widget/custom_marker_widget_nature.dart';

class MapNatureItem extends GetView<MapNatureItemController> {

  MapNatureItem({Key? key}) : super(key: key);

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
          floatingActionButton: IconButton(
            iconSize: 50,
            icon: Image.asset("${AppConfig.assetsRoot}/images/directions_nature_station.png",
                width: 50),
            onPressed: () => controller.navigateTo(controller.natureStationItemModel[0].su_location_lat, controller.natureStationItemModel[0].su_location_lng),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          resizeToAvoidBottomInset: false,
          bottomNavigationBar: const MyBottomAppBar(),
          appBar: AppBar(
            title: Text("nature".tr, style: const TextStyle(fontSize: 24)),
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
