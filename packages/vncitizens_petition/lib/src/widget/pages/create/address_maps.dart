import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_petition/src/controller/address_maps_controller.dart';
import 'package:vncitizens_petition/src/model/place_maker.dart';

class AddressMaps extends StatefulWidget {
  const AddressMaps({Key? key}) : super(key: key);

  @override
  State<AddressMaps> createState() => _AddressMapsState();
}

class _AddressMapsState extends State<AddressMaps> {
  final InternetController _internetController = Get.put(InternetController());

  final AddressMapsController _controller = Get.put(AddressMapsController());

  final PopupController _popupLayerController = PopupController();

  @override
  void initState() {
    super.initState();
    _controller.getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "gui phan anh".tr,
          style: AppBarStyle.title,
        ),
        backgroundColor: Colors.blue.shade800,
      ),
      body: Obx(() {
        if (_internetController.hasConnected.value) {
          return _bodyWidget();
        } else {
          return NoInternet(
            onPressed: () => {},
          );
        }
      }),
    );
  }

  Widget _bodyWidget() {
    return Column(
      children: [
        Expanded(child: Obx(() {
          if (_controller.isLoading.value) {
            return const Padding(
              padding: EdgeInsets.only(bottom: 85),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            return Stack(
              children: [
                FlutterMap(
                  options: MapOptions(
                    center: _controller.centerLocation.value,
                    minZoom: 5,
                    maxZoom: 21,
                    zoom: 14,
                    onTap: (tapPosition, point) => {
                      print(point.toString()),
                      _controller.changeLocation(point)
                    },
                  ),
                  children: [
                    TileLayerWidget(
                      options: TileLayerOptions(
                        urlTemplate:
                            'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                        subdomains: ['a', 'b', 'c'],
                      ),
                    ),
                    PopupMarkerLayerWidget(
                      options: PopupMarkerLayerOptions(
                          popupController: _popupLayerController,
                          markers: _controller.markers,
                          markerRotateAlignment:
                              PopupMarkerLayerOptions.rotationAlignmentFor(
                            AnchorAlign.top,
                          ),
                          popupBuilder: (BuildContext context, Marker marker) {
                            if (marker is PlaceMarker) {
                              return Container();
                            } else {
                              return Container();
                            }
                          }),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _addressBottomSheet(),
                )
              ],
            );
          }
        }))
      ],
    );
  }

  Widget _addressBottomSheet() {
    return _controller.markers.isNotEmpty
        ? Obx(() {
            var maker = _controller.markers[0];
            return maker is PlaceMarker
                ? Container(
                    width: Get.width,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'vi tri'.tr,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  Get.back();
                                },
                              )
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Divider(),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Icon(
                                  Icons.location_on_outlined,
                                  size: 28,
                                  color: Colors.grey,
                                ),
                              ),
                              Flexible(child: Text(maker.place.address))
                            ],
                          ),
                        ),
                        const Divider(),
                        Container(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 10),
                          width: Get.width,
                          child: ElevatedButton(
                            onPressed: () {
                              _controller.submit();
                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    const Color(0xFF1565C0))),
                            child: Text(
                              'xac nhan'.tr,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                : Container();
          })
        : Container();
  }
}
