import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_place/src/config/app_config.dart';
import 'package:vncitizens_place/src/controller/place_detail_controller.dart';
import 'package:vncitizens_place/src/widget/pages/detail/place_detail_mapview.dart';

class PlaceDetailView extends StatelessWidget {
  const PlaceDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PlaceDetailController _controller = Get.put(PlaceDetailController());
    InternetController _internetController = Get.put(InternetController());
    return Scaffold(
        appBar: AppBar(
          title: Text("thong tin dia diem".tr, style: AppBarStyle.title),
        ),
        body: Obx(() {
          if (_internetController.hasConnected.value) {
            if (_controller.isLoading.value) {
              return const DataLoading(message: "Đang tải thông tin địa điểm");
            } else {
              return Wrap(
                children: [
                  Obx(() {
                    if (_controller.place.value.thumbnail.isNotEmpty) {
                      return Container(
                          alignment: Alignment.center,
                          height: 200,
                          child: Obx(() {
                            if (_controller.thumbnailBytes.value != null) {
                              return FittedBox(
                                child: Image.memory(_controller
                                    .thumbnailBytes.value as Uint8List),
                                fit: BoxFit.fill,
                              );
                            } else {
                              return const SizedBox();
                            }
                          }));
                    } else {
                      return const SizedBox();
                    }
                  }),
                  Container(
                      padding: const EdgeInsets.all(10),
                      child: Wrap(
                        alignment: WrapAlignment.spaceEvenly,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(top: 4, bottom: 8),
                            child: Text(
                              _controller.place.value.name,
                              style: GoogleFonts.roboto(
                                  color: Colors.black87,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            width: Get.width,
                            child: RichText(
                              text: TextSpan(
                                text: 'dia chi'.tr + ': ',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.5),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: _controller.place.value.address,
                                      style: const TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: 0.25))
                                ],
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              softWrap: false,
                            ),
                          ),
                          SizedBox(
                            width: Get.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: 'dien thoai'.tr + ': ',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.5),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: _controller.place.value.data !=
                                                      null &&
                                                  _controller.place.value
                                                          .data['phone'] !=
                                                      null
                                              ? _controller
                                                  .place.value.data['phone']
                                              : '',
                                          style: GoogleFonts.roboto(
                                              color: Colors.black87,
                                              letterSpacing: 0.5))
                                    ],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  softWrap: false,
                                ),
                                Obx(() {
                                  if (_controller.place.value.data != null &&
                                      _controller.place.value.data['phone'] !=
                                          null) {
                                    return SizedBox(
                                      height: 28,
                                      child: OutlinedButton.icon(
                                        onPressed: () {
                                          _controller.makeCall(_controller
                                              .place.value.data['phone']);
                                        },
                                        icon: const Icon(Icons.phone_in_talk,
                                            color: Colors.black87, size: 16),
                                        label: Text("goi".tr,
                                            style: GoogleFonts.roboto(
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 0.5)),
                                      ),
                                    );
                                  } else {
                                    return const SizedBox();
                                  }
                                })
                              ],
                            ),
                          ),
                        ],
                      )),
                  Obx(() {
                    if (_controller.place.value.thumbnail.isNotEmpty) {
                      return Container(
                          alignment: Alignment.centerRight,
                          height: Get.height - 375,
                          child: AppConfig.configViewMap == 1
                              ? PlaceDetailMapView()
                              : null);
                    } else {
                      return Container(
                          alignment: Alignment.centerRight,
                          height: Get.height - 175,
                          child: AppConfig.configViewMap == 1
                              ? PlaceDetailMapView()
                              : null);
                    }
                  })
                ],
              );
            }
          } else {
            return NoInternet(onPressed: () => {});
          }
        }));
  }
}
