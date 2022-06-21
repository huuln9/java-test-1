import 'dart:async';
import 'dart:developer' as dev;
import 'dart:io';
import 'dart:typed_data';
import 'package:vncitizens_common/src/config/app_config.dart';
import 'package:vncitizens_common/vncitizens_common.dart';

class MinioService {
  static final Map<String, dynamic> _minioConfig = AppConfig.minioMap;
  static final Map<String, dynamic> _minioConnect = _minioConfig["connect"];
  static final String _bucketName = _minioConfig["bucketNamePrefix"] + _minioConfig["bucket"];
  static final String _pathPrefix = _minioConfig["pathPrefix"];

  final minio = Minio(
    endPoint: _minioConnect["endPoint"],
    accessKey: _minioConnect["accessKey"],
    secretKey: _minioConnect["secretKey"],
  );

  Future<void> _createBucketIfNotExists() async {
    if (!await minio.bucketExists(_bucketName)) {
      await minio.makeBucket(_bucketName);
      dev.log('bucket $_bucketName created', name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    } else {
      dev.log('bucket $_bucketName already exists', name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    }
  }

  /// return file path in minio
  Future<String?> uploadWithPath({required String filePath}) async {
    try {
      await _createBucketIfNotExists();
      final oid = ObjectId();
      await minio.fPutObject(_bucketName, _pathPrefix + "/" + oid.hexString, filePath).timeout(const Duration(seconds: 30));
      return _pathPrefix + "/" + oid.hexString;
    } catch (error) {
      dev.log("Upload Minio failed", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      return null;
    }
  }

  /// return file path in minio
  Future<String?> uploadWithStream({required Uint8List bytes}) async {
    try {
      await _createBucketIfNotExists();
      final oid = ObjectId();
      await minio.putObject(_bucketName, _pathPrefix + "/" + oid.hexString, Stream<Uint8List>.value(bytes)).timeout(const Duration(seconds: 30));
      return _pathPrefix + "/" + oid.hexString;
    } catch (error) {
      dev.log("Upload Minio failed", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      return null;
    }
  }

  Future<File> getFile({required String minioPath}) async {
    dev.log("Getting minio file with path: $minioPath", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    MinioByteStream byteStream = await minio.getObject(_bucketName, minioPath);
    List<List<int>> values = await byteStream.toList();
    List<int> content = [];
    for (var element in values) {
      content.addAll(element);
    }
    final oid = ObjectId();
    final tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/${oid.hexString}.jpg').create();
    file.writeAsBytesSync(content);
    return file;
  }
}