import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_petition/src/config/app_config.dart';
import 'package:path/path.dart' as p;
import 'package:vncitizens_petition/src/controller/petition_detail_controller.dart';
import 'package:vncitizens_petition/src/model/petition_detail_model.dart';
import 'package:vncitizens_petition/src/util/helpers_download.dart';

import '../../util/file_util.dart';

class DocumentAttachmentItem extends StatelessWidget {
  final FileModel? file;
  final bool? paddingEnd;

  DocumentAttachmentItem({Key? key, this.file, this.paddingEnd = false})
      : super(key: key);
  final PetitionDetailController _controllerDetail =
      Get.put(PetitionDetailController());
  @override
  Widget build(BuildContext context) {
    var name = '';
    if (file != null) {
      name = file!.name ?? '';
    }
    final extension = p.extension(name).replaceAll('.', '').toLowerCase();
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(6),
          ),
          border: Border.all(color: ColorUtils.fromString('#E8EDF2')),
          color: ColorUtils.fromString('#F7F8F9')),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.only(right: 8),
            child: Image(
              image: AssetImage(
                  '${AppConfig.assetsRoot}/filetype/${FileUtil.checkFileType(extension)}'),
              width: 28,
              height: 28,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    left: BorderSide(
                        width: 1, color: Color.fromRGBO(229, 229, 229, 1)),
                  ),
                ),
                padding: const EdgeInsets.only(left: 16),
                child: Text(name)),
          ),
          file != null
              ? Obx(() {
                  if (_controllerDetail.fileDownloading.contains(file!.id)) {
                    return Center(
                        child: StreamBuilder<double>(
                            stream: HelperDownload().getProgressStream(file!),
                            builder: (context, snapshot) {
                              return SizedBox(
                                  height: 20.0,
                                  width: 20.0,
                                  child: CircularProgressIndicator(
                                    value: snapshot.data,
                                    strokeWidth: 2,
                                  ));
                            }));
                  }
                  return Container();
                })
              : Container(
                  width: paddingEnd! ? 30 : 0,
                )
        ],
      ),
    );
  }
}
