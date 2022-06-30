import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_place/src/config/app_config.dart';
import 'package:vncitizens_place/src/controller/place_detail_controller.dart';
import 'package:vncitizens_place/src/widget/place_detail_mapview.dart';

class PlaceDetailView extends StatelessWidget {
  const PlaceDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PlaceDetailController _controller = Get.put(PlaceDetailController());
    InternetController _internetController = Get.put(InternetController());
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text("dia diem".tr, style: AppBarStyle.title),
        ),
        body: Obx(() {
          if (_internetController.hasConnected.value) {
            if (_controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              List<Widget> listTableRow = [];
              if (_controller.place.value.address != null &&
                  _controller.place.value.address!.isNotEmpty) {
                listTableRow.add(_itemDetailBuild(
                    icon: 'point.png',
                    content: _controller.place.value.address ?? '',
                    isFirst: true));
              }
              if (_controller.place.value.status != null &&
                  _controller.place.value.status!.isNotEmpty) {
                listTableRow.add(_itemDetailBuild(
                    icon: 'schedule.png',
                    content: _controller.place.value.status ?? '',
                    textColor: ColorUtils.fromString('#17A434')));
              }
              if (_controller.place.value.lienCap != null &&
                  _controller.place.value.lienCap!.isNotEmpty) {
                listTableRow.add(_itemDetailBuild(
                    icon: 'cast_for_education.png',
                    title: 'lien cap'.tr + ": ",
                    content: _controller.place.value.lienCap ?? ''));
              }
              if (_controller.place.value.tenMien != null) {
                listTableRow.add(_itemDetailBuild(
                    icon: 'language.png',
                    title: 'ten mien'.tr + ": ",
                    content: _controller.place.value.tenMien ?? '',
                    onClick: () {
                      FlutterWebBrowser.openWebPage(
                          url: _controller.place.value.tenMien!);
                      // launch(_controller.place.value.tenMien!);
                    }));
              }
              if (_controller.place.value.subName != null) {
                listTableRow.add(_itemDetailBuild(
                    icon: 'category.png',
                    title: 'hinh thuc'.tr + ": ",
                    content: _controller.place.value.subName ?? ''));
              }
              if (_controller.place.value.license != null) {
                listTableRow.add(_itemDetailBuild(
                    icon: 'policy.png',
                    title: 'so giay phep'.tr + ": ",
                    content: _controller.place.value.license ?? ''));
              }
              if (_controller.place.value.approvedDate != null) {
                final f = DateFormat('dd/MM/yyyy');
                listTableRow.add(_itemDetailBuild(
                    icon: 'date_range.png',
                    title: 'ngay cap'.tr + ": ",
                    content: _controller.place.value.approvedDate!.isNotEmpty
                        ? f.format(DateTime.parse(
                            _controller.place.value.approvedDate!))
                        : ''));
              }
              if (_controller.place.value.soCCHNNDD != null) {
                listTableRow.add(_itemDetailBuild(
                    icon: 'cchn.png',
                    title: 'so chung chi hanh nghe nguoi dung dau'.tr + ": ",
                    content: _controller.place.value.soCCHNNDD ?? ''));
              }
              return Wrap(
                children: [
                  // Obx(() {
                  //   if (_controller.place.value.thumbnail.isNotEmpty) {
                  //     return Container(
                  //         alignment: Alignment.center,
                  //         height: 200,
                  //         child: Obx(() {
                  //           if (_controller.thumbnailBytes.value != null) {
                  //             return FittedBox(
                  //               child: Image.memory(_controller
                  //                   .thumbnailBytes.value as Uint8List),
                  //               fit: BoxFit.fill,
                  //             );
                  //           } else {
                  //             return const SizedBox();
                  //           }
                  //         }));
                  //   } else {
                  //     return const SizedBox();
                  //   }
                  // }),
                  Container(
                      padding: const EdgeInsets.all(8),
                      child: Wrap(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(top: 4, bottom: 8),
                            child: Text(
                              _controller.place.value.name != null
                                  ? _controller.place.value.name!
                                  : '',
                              style: GoogleFonts.roboto(
                                  color: Colors.black87,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: listTableRow,
                          ),
                        ],
                      )),
                  // Obx(() {
                  //   if (_controller.place.value.thumbnail.isNotEmpty) {
                  //     return Container(
                  //         alignment: Alignment.centerRight,
                  //         height: Get.height - 375,
                  //         child: PlaceDetailMapView());
                  //   } else {
                  //     return Container(
                  //         alignment: Alignment.centerRight,
                  //         height: Get.height - 175,
                  //         child: PlaceDetailMapView());
                  //   }
                  // })
                  _controller.placeDetailViewMap
                      ? Container(
                          alignment: Alignment.centerRight,
                          height: Get.height - 175,
                          child: PlaceDetailMapView())
                      : Container()
                ],
              );
            }
          } else {
            return NoInternet(
              onPressed: () {},
            );
          }
        }));
  }

  Widget _itemDetailBuild(
      {String? icon,
      String? title,
      String? content,
      Color? textColor,
      bool? isFirst,
      Function? onClick}) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(children: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Image(
            image: AssetImage('${AppConfig.assetsRoot}/$icon'),
            width: 28,
            height: 28,
          ),
        ),
        Flexible(
          child: Container(
            alignment: Alignment.centerLeft,
            height: 50,
            decoration: BoxDecoration(
              border: isFirst == null
                  ? const Border(
                      top: BorderSide(
                          width: 0.5, color: Color.fromRGBO(229, 229, 229, 1)),
                    )
                  : null,
            ),
            child: RichText(
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style:
                    TextStyle(color: textColor ?? Colors.black, fontSize: 16),
                children: [
                  TextSpan(
                    text: title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          if (onClick != null) {
                            onClick();
                          }
                        },
                      text: content,
                      style: TextStyle(
                          color: onClick != null
                              ? AppConfig.materialMainBlueColor
                              : null))
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }
}
