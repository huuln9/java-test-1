import 'dart:async';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:flutter/material.dart';
import 'package:vncitizens_administrative_document/src/config/file_type_map_config.dart';
import 'package:vncitizens_administrative_document/src/model/doc_item_detail_model.dart';
import 'package:vncitizens_administrative_document/src/widget/pdf_screen.dart';
import 'package:vncitizens_common/dio.dart' as dio;
import 'package:vncitizens_common/permission_handler.dart';
import 'package:vncitizens_common/vncitizens_common.dart';

class AdminDocDetailController extends GetxController {
  late String docId;
  Rxn<DocItemDetailModel> docDetail = Rxn();
  RxBool isInitializing = true.obs;
  RxnString fileTypeImageSource = RxnString();
  RxnString fileUrl = RxnString();
  RxnString fileName = RxnString();
  RxInt percent = 0.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments[0] != null && Get.arguments[0] is String) {
      docId = Get.arguments[0];
    } else {
      throw "Cannot find docId";
    }
    getDocDetail(docId).then((value) {
      docDetail.value = value;
      fileTypeImageSource.value = FileTypeMapConfig.getFileTypeImageSource(filetype: extension(value.fileVanBan).replaceAll(".", ""));
      dev.log(fileTypeImageSource.value ?? "NULL", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));

      /// file url
      if (Uri.parse(value.fileVanBan).isAbsolute) {
        fileUrl.value = value.fileVanBan;
      } else {
        fileUrl.value = getCleanUrl(value.fileVanBan);
      }
      dev.log(fileUrl.value ?? "NULL", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));

      /// file name
      List<String> splitUrl = basenameWithoutExtension(fileUrl.value!).split("/");
      splitUrl.removeWhere((element) => element.isEmpty);
      fileName.value = splitUrl.isEmpty ? fileUrl.value! : splitUrl.last + extension(fileUrl.value!);
      dev.log(fileName.value ?? "NULL", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));

      isInitializing.value = false;
    });
  }


  // =========== EVENTS ==========

  Future<void> onTapFile(String url, String filename) async {
    if (extension(url).replaceAll(".", "").toLowerCase() == "pdf") {
      Get.to(() => PDFScreen(url: url, filename: filename));
    } else {
      percent.value = 0;
      download(fileUrl: url, nameSaved: filename);
      Get.showSnackbar(GetSnackBar(
          message: "dang tai".tr + "...",
          messageText: Obx(
            () => percent.value < 100
                ? RichText(
                    text: TextSpan(children: [
                    TextSpan(text: "dang tai".tr + "... ", style: const TextStyle(color: Colors.white)),
                    TextSpan(text: percent.value.toString() + "%", style: const TextStyle(color: Colors.white))
                  ]))
                : Text("tai xuong thanh cong".tr + ".", style: const TextStyle(color: Colors.white)),
          ),
          mainButton: TextButton(onPressed: () => Get.closeAllSnackbars(), child: Text("dong".tr)),
          isDismissible: true,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 70),
          animationDuration: const Duration(milliseconds: 200)));
    }
  }

  // ========== MANUAL FUNC ==========
  Future<DocItemDetailModel> getDocDetail(String id) async {
    Response response = await AdministrativeDocumentService().getDocumentById(id: id);
    dev.log(response.statusCode.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    dev.log(response.body.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    if (response.statusCode == 200) {
      return DocItemDetailModel.fromMap(response.body);
    }  else {
      throw "Cannot get document";
    }
    // await Future.delayed(const Duration(seconds: 1));
    // return DocItemDetailModel.fromMap(ExampleData.docItemDetailMap);
  }

  String getCleanUrl(String url) {
    String cleanUrl = url.replaceAll(RegExp(r"\\"), "/");
    if (url.startsWith("http[s]?://") == false) {
      cleanUrl = "https://" + cleanUrl;
    }
    return cleanUrl;
  }

  Future<void> download({required String fileUrl, required String nameSaved}) async {
    Map<Permission, PermissionStatus> statuses = await [Permission.storage].request();
    print(statuses);
    if (statuses[Permission.storage]!.isGranted) {
      Directory? downloadDir = await DownloadsPathProvider.downloadsDirectory;
      Directory? externalStorage = await pathProvider.getExternalStorageDirectory();
      Directory appDir = await pathProvider.getApplicationDocumentsDirectory();
      String savePath = "";
      if (downloadDir != null) {
        /// check permission on download directory
        try {
            Directory appDownloadDir = Directory(downloadDir.path + "/vnCitizens");
            if (!appDownloadDir.existsSync()) {
              dev.log("Create directory", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
              appDownloadDir.createSync(recursive: true);
              savePath = appDownloadDir.path + "/$nameSaved";
            }
        } catch (error) {
          savePath = externalStorage!.path + "/" + nameSaved;
        }
      } else {
        dev.log("downloadDir is NULL", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
        savePath = externalStorage!.path + "/" + nameSaved;
      }
      try {
        if (Platform.isIOS) {
          dio.Response response = await dio.Dio().get(fileUrl,
            onReceiveProgress: (received, total) {
              if (total != -1) {
                percent.value = (received / total * 100).toInt();
                dev.log((received / total * 100).toStringAsFixed(0) + "%", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
              }
            },
            options: dio.Options(
              responseType: dio.ResponseType.bytes
            )
          );
          final directory = Directory(appDir.path);
          if (!directory.existsSync()) {
            dev.log("Create directory", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
            directory.createSync(recursive: true);
          }
          dev.log("Set path save: " + appDir.path + "/" + nameSaved, name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
          File file = File(appDir.path + "/" + nameSaved);
          await file.writeAsBytes(response.data);
        } else {
          await dio.Dio().download(fileUrl, savePath, onReceiveProgress: (received, total) {
            if (total != -1) {
              percent.value = (received / total * 100).toInt();
              dev.log((received / total * 100).toStringAsFixed(0) + "%", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
            }
          });
          dev.log("Set path save: $savePath", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
        }
        dev.log("File is saved to download folder.", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      } on dio.DioError catch (e) {
        dev.log(e.message, name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      }
    } else {
      dev.log("No permission to read and write.", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    }
  }
}
