import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_notification/src/controller/notification_detail_controller.dart';
import 'package:vncitizens_notification/src/model/fcm_info_model.dart';
import 'package:vncitizens_notification/src/widget/commons/notification_image_view.dart';
import 'package:vncitizens_notification/src/widget/pages/commons/tag_chip.dart';

import 'notification_detail_app_bar.dart';

class NotificationDetail extends StatefulWidget {
  const NotificationDetail({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  State<NotificationDetail> createState() => _NotificationDetailState();
}

class _NotificationDetailState extends State<NotificationDetail> {
  final _controller = Get.put(NotificationDetailController());
  final _internetController = Get.put(InternetController());

  @override
  void initState() {
    super.initState();
    _controller.init(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NotificationDetailAppBar(),
      body: _buildBody(),
      // bottomNavigationBar: const MyBottomAppBar(index: 1),
    );
  }

  Widget _buildBody() {
    return Obx(() {
      FcmInfoModel fcm = _controller.notification.value;
      if (_internetController.hasConnected.value) {
        if (_controller.isLoading.value) {
          return DataLoading(message: "dang tai chi tiet thong bao".tr);
        } else {
          if (_controller.isFailedLoading.value) {
            return DataFailedLoading(
              onPressed: () {
                _controller.onInit();
              },
            );
          } else {
            return Wrap(children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(fcm.title == null ? '' : fcm.title!,
                    style: GoogleFonts.roboto(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        height: 1.25,
                        letterSpacing: 0.05),
                    textAlign: TextAlign.justify),
              ),
              ListTile(
                leading: CircleAvatar(
                  radius: 36,
                  backgroundColor: CharColorHelper.characterColor[
                      fcm.fromAgency == null
                          ? ''
                          : fcm.fromAgency!.name[0].toLowerCase()],
                  child: _buildAvatar(fcm, _controller),
                ),
                title: Text(fcm.fromAgency == null ? '' : fcm.fromAgency!.name),
                subtitle: Text(_getDate(
                    fcm.sentDate == null ? DateTime.now() : fcm.sentDate!)),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Wrap(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text("noi dung".tr.toUpperCase(),
                          style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              height: 0.85,
                              color: Colors.grey),
                          textAlign: TextAlign.justify),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(fcm.content == null ? '' : fcm.content!,
                          style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              height: 1.5,
                              color: Colors.grey.shade800),
                          textAlign: TextAlign.justify),
                    ),
                  ],
                ),
              ),
              Obx(() {
                if (_controller.thumbnailBytesList.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Wrap(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text("hinh anh".tr.toUpperCase(),
                              style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  height: 0.85,
                                  color: Colors.grey),
                              textAlign: TextAlign.justify),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: SizedBox(
                              height: 200,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount:
                                    _controller.thumbnailBytesList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                    onTap: () {
                                      Get.to(NotificationImageView(
                                          items: _controller.thumbnailBytesList,
                                          index: index));
                                    },
                                    child: Card(
                                      // child: Image.network(
                                      //   galleryItems[index],
                                      // )
                                      child: Image.memory(_controller
                                          .thumbnailBytesList[index]),
                                    ),
                                  );
                                },
                              ),
                            )),
                      ],
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              }),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Wrap(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text("loai thong bao".tr.toUpperCase(),
                          style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              height: 0.85,
                              color: Colors.grey),
                          textAlign: TextAlign.justify),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Wrap(
                            children: List<Widget>.generate(fcm.tag!.length,
                                (int index) {
                          return TagChip(tag: fcm.tag![index]);
                        }).toList())),
                  ],
                ),
              ),
            ]);
          }
        }
      } else {
        return NoInternet(
          onPressed: () {
            _controller.onInit();
          },
        );
      }
    });
  }

  Widget _buildAvatar(FcmInfoModel fcm, NotificationDetailController _ctrl) {
    if (fcm.fromAgency != null && fcm.fromSystem != null) {
      if (fcm.fromAgency!.logoId.isNotEmpty &&
          _ctrl.agencyIconBytes.value != null) {
        return ClipRRect(
          child: Image.memory(_ctrl.agencyIconBytes.value as Uint8List),
          borderRadius: BorderRadius.circular(36),
        );
      } else {
        return Text(
          CharColorHelper.get2Wildcards(fcm.fromAgency!.name),
          style: GoogleFonts.roboto(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500),
        );
      }
    } else {
      if (fcm.fromSystem != null) {
        if (fcm.fromSystem!.logoURL.isNotEmpty &&
            _hasValidUrl(fcm.fromSystem!.logoURL)) {
          return ClipRRect(
            child: Image.network(fcm.fromSystem!.logoURL),
            borderRadius: BorderRadius.circular(36),
          );
        } else {
          return Text(
            CharColorHelper.get2Wildcards(fcm.fromSystem!.name),
            style: GoogleFonts.roboto(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500),
          );
        }
      } else {
        return const Text('');
      }
    }
  }

  bool _hasValidUrl(String url) {
    String pattern =
        r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?';
    RegExp regExp = RegExp(pattern);
    if (url.isEmpty) {
      return false;
    } else if (!regExp.hasMatch(url)) {
      return false;
    }
    return true;
  }

  String _getDate(DateTime dateTime) {
    DateTime newDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    DateTime currentDate = DateTime.now();
    if (newDate.isAtSameMomentAs(
        DateTime(currentDate.year, currentDate.month, currentDate.day))) {
      final DateFormat formatter = DateFormat('HH:mm');
      return formatter.format(dateTime);
    } else {
      if (newDate.isAtSameMomentAs(
          DateTime(currentDate.year, currentDate.month, currentDate.day - 1))) {
        final DateFormat formatter = DateFormat('HH:mm');
        return "hom qua".tr + " " + formatter.format(dateTime);
      } else {
        final DateFormat formatter = DateFormat('HH:mm dd/MM/yyyy');
        return formatter.format(dateTime);
      }
    }
  }
}
