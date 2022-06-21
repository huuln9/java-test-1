import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_petition/src/model/petition_detail_model.dart';

class HelperDownload {
  factory HelperDownload() => _singleton;

  HelperDownload._();

  static final HelperDownload _singleton = HelperDownload._();

  Map<String, double> downloaded = {};

  Future<void> downloadFile(FileModel fileModel,
      {Function(String)? onError}) async {
    final streamController = getProgressStreamController(fileModel);

    try {
      if (isDownloading(fileModel.id!)) {
        // Downloading
        onError?.call('Đang tải');
        return;
      }
      final downloadedFile = await getDownloadedFile(fileModel);
      if (downloadedFile != null) {
        return;
      }

      final filePathLocal = await getLocalPath(fileModel);

      await IGateFilemanService().saveFile(
          id: fileModel.id ?? '',
          filePathLocal: filePathLocal,
          onReceiveProgress: (rec, total) {
            downloaded[fileModel.id!] = rec.toDouble();
            streamController.add(rec / total);
          });
      // File file = File(filePathLocal);

      // file.writeAsBytesSync(res.bodyBytes);
    } catch (_) {
      onError?.call(
          'File không tồn tại, hoặc xảy ra lỗi trong quá trình mở file...');
      streamController.add(-2);

      downloaded[fileModel.id!] = -2;
    }
  }

  bool isDownloadFailed(String fileId) {
    return downloaded[fileId] != null && downloaded[fileId]! < -1;
  }

  bool isDownloading(String fileId) {
    return downloaded[fileId] != null && downloaded[fileId]! >= 0;
  }

  String getDownloadProgressText(double downloaded, double total) {
    var unit = 'B';
    var formated = total;
    var formated2 = downloaded;
    if (formated2 < 0) {
      formated2 = 0;
    }
    final showProgress = formated2 < formated;

    if (formated > 102.4) {
      formated = formated / 1024;
      formated2 = formated2 / 1024;
      unit = 'KB';
    }
    if (formated > 102.4) {
      formated = formated / 1024;
      formated2 = formated2 / 1024;
      unit = 'MB';
    }
    if (formated > 102.4) {
      formated = formated / 1024;
      formated2 = formated2 / 1024;
      unit = 'GB';
    }

    if (showProgress) {
      return '${formated2.toStringAsFixed(2)}/${formated.toStringAsFixed(2)} $unit';
    }
    return '${formated.toStringAsFixed(2)} $unit';
  }

  Map<String, BehaviorSubject<double>> progressStreams = {};

  StreamController<double> getProgressStreamController(FileModel fileModel) {
    final fileId = fileModel.id;
    var streamController = progressStreams[fileId];
    if (streamController == null) {
      streamController = BehaviorSubject<double>.seeded(0);
      progressStreams[fileId!] = streamController;
      getDownloadedFile(fileModel).then((file) {
        if (file != null) {
          streamController!.add(file.statSync().size.toDouble());
        }
      });
    }
    return streamController;
  }

  Stream<double> getProgressStream(FileModel fileModel) {
    return getProgressStreamController(fileModel).stream;
  }

  Future<String> getLocalPath(FileModel fileModel) async {
    return '${await _findLocalPath()}/Download/${fileModel.id! + '-' + fileModel.name!}';
  }

  Future<File?> getDownloadedFile(FileModel fileModel) async {
    final filePathLocal = await getLocalPath(fileModel);
    final file = File(filePathLocal);
    if (file.existsSync()) {
      return file;
    }
    return null;
  }

  Future<String> _findLocalPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return Platform.isAndroid ? '/storage/emulated/0' : directory.path;
  }
}
