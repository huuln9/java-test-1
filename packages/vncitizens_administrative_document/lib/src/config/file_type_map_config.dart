import 'package:vncitizens_administrative_document/src/config/app_config.dart';

class FileTypeMapConfig {
  static const Map<String, String> _fileTypeMap = {
    "jpg": "${AppConfig.assetsRoot}/images/jpg.png",
    "ppt": "${AppConfig.assetsRoot}/images/ppt.png",
    "raw": "${AppConfig.assetsRoot}/images/raw.png",
    "iso": "${AppConfig.assetsRoot}/images/iso.png",
    "cdr": "${AppConfig.assetsRoot}/images/cdr.png",
    "tif": "${AppConfig.assetsRoot}/images/tif.png",
    "mov": "${AppConfig.assetsRoot}/images/mov.png",
    "avi": "${AppConfig.assetsRoot}/images/avi.png",
    "cad": "${AppConfig.assetsRoot}/images/cad.png",
    "bmp": "${AppConfig.assetsRoot}/images/bmp.png",
    "gif": "${AppConfig.assetsRoot}/images/gif.png",
    "sql": "${AppConfig.assetsRoot}/images/sql.png",
    "txt": "${AppConfig.assetsRoot}/images/txt.png",
    "xml": "${AppConfig.assetsRoot}/images/xml.png",
    "xls": "${AppConfig.assetsRoot}/images/xls.png",
    "doc": "${AppConfig.assetsRoot}/images/doc.png",
    "js": "${AppConfig.assetsRoot}/images/js.png",
    "mp3": "${AppConfig.assetsRoot}/images/mp3.png",
    "html": "${AppConfig.assetsRoot}/images/html.png",
    "php": "${AppConfig.assetsRoot}/images/php.png",
    "png": "${AppConfig.assetsRoot}/images/png.png",
    "zip": "${AppConfig.assetsRoot}/images/zip.png",
    "pdf": "${AppConfig.assetsRoot}/images/pdf.png",
    "?": "${AppConfig.assetsRoot}/images/unknown.png",
  };

  static String getFileTypeImageSource({required String filetype}) {
    final String cleanText = filetype.toLowerCase().trim();
    if (_fileTypeMap[cleanText] != null) {
      return _fileTypeMap[cleanText]!;
    }
    return _fileTypeMap["?"] ?? "${AppConfig.assetsRoot}/images/unknown.png";
  }
}