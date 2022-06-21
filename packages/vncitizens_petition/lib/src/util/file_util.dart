class FileUtil {
  static final videoEx = ['mp4'];

  static final imageEx = [
    'jpeg',
    'jpg',
    'png',
  ];

  // static final docEx = [
  //   'pdf',
  //   'docx',
  //   'xls',
  //   'xlsx',
  //   'pptx',
  //   'doc',
  //   'ppt',
  //   'pptx',
  //   'cad',
  //   'html',
  //   'iso',
  //   'mp3',
  //   'php',
  //   'js',
  // ];

  static String checkFileType(String fileType) {
    var assetImage = 'other.png';

    switch (fileType.toUpperCase()) {
      case 'DOC':
        assetImage = 'doc.png';
        break;
      case 'DOCX':
        assetImage = 'doc.png';
        break;
      case 'PPT':
        assetImage = 'ppt.png';
        break;
      case 'PPTX':
        assetImage = 'ppt.png';
        break;
      case 'XLS':
        assetImage = 'xls.png';
        break;
      case 'XLSX':
        assetImage = 'xls.png';
        break;
      case 'PDF':
        assetImage = 'pdf.png';
        break;
      case 'MP4':
        assetImage = 'video.png';
        break;
      case 'JPG':
        assetImage = 'jpg.png';
        break;
      case 'JEPG':
        assetImage = 'jpg.png';
        break;
      case 'PNG':
        assetImage = 'png.png';
        break;
      case 'TXT':
        assetImage = 'txt.png';
        break;
      case 'XML':
        assetImage = 'xml.png';
        break;
      case 'ZIP':
        assetImage = 'zip.png';
        break;
      case 'MP3':
        assetImage = 'mp3.png';
        break;
      case 'ISO':
        assetImage = 'ios.png';
        break;
      case 'CAD':
        assetImage = 'cad.png';
        break;
      case 'AVI':
        assetImage = 'avi.png';
        break;
      case 'BMP':
        assetImage = 'bmp.png';
        break;
      case 'CDR':
        assetImage = 'cdr.png';
        break;
      case 'GIF':
        assetImage = 'gif.png';
        break;
      case 'JS':
        assetImage = 'js.png';
        break;
      case 'TIF':
        assetImage = 'tif.png';
        break;
      case 'PHP':
        assetImage = 'php.png';
        break;
      default:
        assetImage = 'other.png';
    }
    return assetImage;
  }
}
