import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:vncitizens_account/vncitizens_account.dart';
import 'package:vncitizens_common/permission_handler.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_petition/src/config/app_config.dart';
import 'package:vncitizens_petition/src/controller/petition_personal_list_controller.dart';
import 'package:vncitizens_petition/src/controller/petition_public_list_controller.dart';
import 'package:vncitizens_petition/src/model/petition_detail_model.dart';
import 'package:path/path.dart' as p;
import 'package:vncitizens_petition/src/model/petition_evaluation.dart';
import 'package:vncitizens_petition/src/util/helpers_download.dart';

import '../util/file_util.dart';

class PetitionDetailController extends GetxController {
  Rx<PetitionDetailModel?> petitionDetail = (null as PetitionDetailModel).obs;
  RxList<FileModel> files = <FileModel>[].obs;
  PetitionEvaluation? evaluation;
  RxBool isLoading = false.obs;
  RxBool isLoadingEvaluation = false.obs;
  String petitionId = '';
  RxDouble reporterRating = 0.0.obs;
  bool isShowDialogLoading = false;
  RxList<String> fileDownloading = <String>[].obs;
  @override
  void onInit() {
    super.onInit();
    // getDetail();
    // _fileFromUrl(FileModel(
    //   group: [0],
    //   name: 'Phan anh cay co.mp4',
    //   id: '6295884a1b1ee64df7d9a1ba',
    // ));
  }

  getDetail(String id) async {
    try {
      isLoading.value = true;
      petitionId = id;
      var res = await IGatePetitionService().getDetail(id);
      var detail = PetitionDetailModel.fromJson(res.body);
      detail.id = id;
      petitionDetail.value = detail;
      isLoading.value = false;
      if (reporterRating.value != 0.0) {
        updateEvalution(reporterRating.value.round());
      }
    } catch (_) {
      isLoading.value = false;
    }
  }

  // Future<Uint8List> fileFromUrl(FileModel fileModel) async {
  //   final res =
  //       await IGateFilemanService().downloadFile(id: fileModel.id ?? '');
  //   // var dir = await getApplicationDocumentsDirectory();
  //   // File file = File("${dir.path}/" + fileModel.name!);

  //   // file.writeAsBytesSync(res.bodyBytes);

  //   return res.bodyBytes;
  // }

  Future<void> saveFile(FileModel fileModel) async {
    if (!(await Permission.storage.request().isGranted)) {
      return;
    }
    await downloadFile(fileModel);
    UIHelper.showNotificationSnackBar(message: 'Lưu về máy thành công');
  }

  Future<void> downloadFile(FileModel fileMode) async {
    await HelperDownload().downloadFile(fileMode, onError: (er) async {
      UIHelper.showNotificationSnackBar(message: er);
    });
  }

  onOpenFile(FileModel fileModel) async {
    fileDownloading.add(fileModel.id!);
    fileDownloading.refresh();
    final downloadedFile = await HelperDownload().getDownloadedFile(fileModel);
    if (downloadedFile != null) {
      fileDownloading.remove(fileModel.id!);

      OpenFile.open(downloadedFile.path);
    } else {
      HelperDownload().downloadFile(fileModel, onError: (er) async {
        fileDownloading.remove(fileModel.id!);

        UIHelper.showNotificationSnackBar(message: er);
      }).then((value) async {
        final downloadedFile =
            await HelperDownload().getDownloadedFile(fileModel);
        if (downloadedFile != null) {
          fileDownloading.remove(fileModel.id!);

          OpenFile.open(downloadedFile.path);
        }
      });
    }
    fileDownloading.refresh();
  }

  List<FileModel> imagesOrVideos(List<FileModel> files) {
    var imageOrVideoFiles = files.where((file) {
      final extension =
          p.extension(file.name ?? '').replaceAll('.', '').toLowerCase();
      if (FileUtil.videoEx.contains(extension) ||
          FileUtil.imageEx.contains(extension)) {
        return true;
      } else {
        return false;
      }
    });
    return imageOrVideoFiles.toList();
  }

  List<FileModel> filesDoc(List<FileModel> files) {
    var filesDoc = files.where((file) {
      final extension =
          p.extension(file.name ?? '').replaceAll('.', '').toLowerCase();
      if (!FileUtil.videoEx.contains(extension) &&
          !FileUtil.imageEx.contains(extension)) {
        return true;
      } else {
        return false;
      }
    });
    return filesDoc.toList();
  }

  updateEvalution(int value) async {
    var evaluatorValue = 0;
    if (value == 3) {
      evaluatorValue = 1;
    }
    if (value == 2) {
      evaluatorValue = 3;
    }
    if (AuthUtil.isLoggedIn != true) {
      await UIHelper.showRequiredLoginDialog(
          routeBack:
              '/vncitizens_petition/list?id_detail=$petitionId&rating=$value');
    } else {
      evaluation = PetitionEvaluation(
          evaluator: AuthUtil.userId,
          evaluatorType: 0,
          evaluatorValue: evaluatorValue);
      showEvalutionDialog(evaluation!, value);
    }
  }

  onDeletePetition(String id) async {
    try {
      var res = await IGatePetitionService().deletePetition(id);
      print(res.body);
      if (res.statusCode == 200) {
        final _controllerDefault = Get.put(PetitionPublicListController());
        final _controllerPersonal = Get.put(PetitionPersonalListController());
        _controllerDefault.refreshPetitions();
        _controllerPersonal.refreshPetitions();
        Future.delayed(const Duration(milliseconds: 300)).then((value) {
          Get.back();
          Future.delayed(const Duration(milliseconds: 200)).then((value) {
            UIHelper.showNotificationSnackBar(
                message: 'xoa phan anh thanh cong'.tr);
          });
        });
      } else {
        Get.back();
        UIHelper.showNotificationSnackBar(message: 'xoa phan anh that bai'.tr);
      }
    } catch (_) {}
  }

  Future showEvalutionDialog(PetitionEvaluation ev, int value) async {
    await Get.dialog(
        AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16))),
          title: Text('danh gia cua ban'.tr),
          content: SizedBox(
            width: Get.width - 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RatingBar(
                  initialRating: value * 1.0,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  ignoreGestures: true,
                  itemCount: value,
                  ratingWidget: RatingWidget(
                    full: SvgPicture.asset(
                      AppConfig.assetsRoot + "/star.svg",
                    ),
                    half: SvgPicture.asset(
                      AppConfig.assetsRoot + "/star_half.svg",
                    ),
                    empty: SvgPicture.asset(
                      AppConfig.assetsRoot + "/star_outline.svg",
                      color: Colors.grey,
                    ),
                  ),
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  onRatingUpdate: (rating) {},
                ),
              ],
            ),
          ),
          titlePadding: const EdgeInsets.all(20),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          actionsPadding: EdgeInsets.zero,
          actions: [
            Obx(() {
              if (isLoadingEvaluation.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    child: ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ButtonStyle(
                          side: MaterialStateProperty.all(
                              const BorderSide(color: Color(0xFF1565C0))),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white)),
                      child: Text(
                        "huy".tr,
                        style: const TextStyle(
                          color: Color(0xFF1565C0),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  SizedBox(
                    width: 120,
                    child: ElevatedButton(
                      onPressed: () {
                        isLoadingEvaluation.value = true;
                        try {
                          IGatePetitionService()
                              .updateEvaluation(petitionId, ev.toJson())
                              .then((value) {
                            isLoadingEvaluation.value = false;
                            Get.back();
                            reporterRating.value = 0.0;
                            getDetail(petitionId);
                            UIHelper.showNotificationSnackBar(
                                message: 'cam on danh gia cua ban'.tr);
                          }, onError: (_) {
                            isLoadingEvaluation.value = false;
                            Get.back();
                            UIHelper.showNotificationSnackBar(
                                message: 'gui danh gia that bai'.tr);
                          });
                        } catch (_) {
                          isLoadingEvaluation.value = false;
                          Get.back();
                          UIHelper.showNotificationSnackBar(
                              message: 'gui danh gia that bai'.tr);
                        }
                      },
                      child: Text(
                        "xac nhan".tr,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              );
            })
          ],
        ),
        barrierDismissible: false);
  }

  convertNumRating(double rate) {
    var value = rate % rate.truncate();
    var rateConvert = rate;

    if (value < 0.5 && value != 0) {
      rateConvert = rate.truncate() * 1.0;
    }
    if (value == 0.5) {
      rateConvert = rate;
    }
    if (value >= 0.5) {
      rateConvert = rate.truncate() + 0.5;
    }
    return rateConvert;
  }
}
