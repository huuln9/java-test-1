import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_petition/src/config/app_config.dart';
import 'package:vncitizens_petition/src/controller/create_controller.dart';
import 'package:vncitizens_petition/src/model/petition_detail_model.dart';
import 'package:vncitizens_petition/src/widget/pages/create/petition_info.dart';
import 'package:vncitizens_petition/src/widget/pages/create/reporter_info.dart';

import 'document_attachments.dart';

class PetitionCreate extends StatefulWidget {
  const PetitionCreate({Key? key, this.id, this.petition}) : super(key: key);
  final String? id;
  final PetitionDetailModel? petition;

  @override
  State<PetitionCreate> createState() => _PetitionCreateState();
}

class _PetitionCreateState extends State<PetitionCreate> {
  final InternetController _internetController = Get.put(InternetController());
  final PetitionCreateController _controller =
      Get.put(PetitionCreateController());

  bool isShowingDialog = false;

  @override
  void initState() {
    super.initState();
    _controller.onInitFormEdit(petition: widget.petition, id: widget.id);
    _controller.isLoading.stream.listen((val) {
      if (val && !isShowingDialog) {
        isShowingDialog = true;
        Get.dialog(
            AlertDialog(
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              content: SizedBox(
                height: 160,
                width: Get.width - 20,
                child: DataLoading(
                  message: _controller.isEdit.value
                      ? 'Đang cập nhật phản ánh'
                      : 'dang gui phan anh'.tr,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                ),
              ),
            ),
            barrierDismissible: false);
      } else if (isShowingDialog) {
        isShowingDialog = false;
        Get.back();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.petition != null || widget.id != null
                ? 'cap nhat phan anh'.tr
                : "gui phan anh".tr,
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
        }));
  }

  Widget _bodyWidget() {
    return Container(
      color: Colors.white,
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          SizedBox(
            height: Get.height,
            child: ListView(
              padding: const EdgeInsets.only(bottom: 50),
              children: [
                widget.petition != null || widget.id != null
                    ? Container()
                    : Column(
                        children: [
                          ReporterInfo(),
                          Container(
                            color: AppConfig.backgroundColor,
                            height: 10,
                          ),
                        ],
                      ),
                PetitionInfo(),
                const DocumentsAttactments(),
                widget.petition != null || widget.id != null
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, bottom: 16),
                        child: Column(
                          children: [
                            (AppConfig.getPetitionCreateConfig.anonymous !=
                                        null &&
                                    AppConfig.getPetitionCreateConfig.anonymous!
                                        .active!)
                                ? Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'cong khai thong tin ca nhan'
                                              .tr
                                              .toUpperCase(),
                                          style: GoogleFonts.roboto(
                                              color: Colors.grey,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Obx(() {
                                        return Switch(
                                          onChanged: (data) {
                                            _controller.isAnonymous(!data);
                                          },
                                          value: !_controller.isAnonymous.value,
                                          activeColor:
                                              AppConfig.materialMainBlueColor,
                                          activeTrackColor:
                                              ColorUtils.fromString('#BB86FC')
                                                  .withOpacity(0.20),
                                          inactiveThumbColor: Colors.white,
                                          inactiveTrackColor:
                                              Colors.black.withOpacity(0.08),
                                        );
                                      }),
                                    ],
                                  )
                                : Container(),
                            // const SizedBox(
                            //   height: 16,
                            // ),
                            (AppConfig.getPetitionCreateConfig.public != null &&
                                    AppConfig.getPetitionCreateConfig.public!
                                        .active!)
                                ? Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'cong khai ket qua phan anh'
                                              .tr
                                              .toUpperCase(),
                                          style: GoogleFonts.roboto(
                                              color: Colors.grey,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Obx(() {
                                        return Switch(
                                          onChanged: (data) {
                                            _controller.isPublicResult(data);
                                          },
                                          value:
                                              _controller.isPublicResult.value,
                                          activeColor:
                                              AppConfig.materialMainBlueColor,
                                          activeTrackColor:
                                              ColorUtils.fromString('#BB86FC')
                                                  .withOpacity(0.20),
                                          inactiveThumbColor: Colors.white,
                                          inactiveTrackColor:
                                              Colors.black.withOpacity(0.08),
                                        );
                                      }),
                                    ],
                                  )
                                : Container(),
                          ],
                        ),
                      ),
              ],
            ),
          ),
          widget.petition != null || widget.id != null
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                              left: 20, right: 10, bottom: 6, top: 6),
                          width: Get.width * 0.5,
                          child: ElevatedButton(
                            onPressed: () {
                              Get.back();
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white)),
                            child: Text(
                              'huy bo'.tr.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              left: 10, right: 20, bottom: 6, top: 6),
                          width: Get.width * 0.5,
                          child: ElevatedButton(
                            onPressed: _controller.isChangeDataEdit.value
                                ? () {
                                    _controller.onCreatePetition();
                                  }
                                : null,
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    _controller.isChangeDataEdit.value
                                        ? const Color(0xFF1565C0)
                                        : ColorUtils.fromString('#828282'))),
                            child: Text(
                              'cap nhat'.tr.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    width: Get.width,
                    child: ElevatedButton(
                      onPressed: _controller.isActiveCreateButton.value
                          ? () {
                              _controller.onCreatePetition();
                            }
                          : null,
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              _controller.isActiveCreateButton.value
                                  ? const Color(0xFF1565C0)
                                  : ColorUtils.fromString('#828282'))),
                      child: Text(
                        'gui phan anh'.tr.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
