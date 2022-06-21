import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_petition/src/controller/petition_detail_controller.dart';
import 'package:vncitizens_petition/src/model/petition_detail_model.dart';
import 'package:vncitizens_petition/src/widget/commons/doc_attachment_item.dart';
import 'package:vncitizens_petition/src/widget/commons/image_view.dart';
import 'package:vncitizens_petition/src/widget/commons/video_attachment_item.dart';
import 'package:path/path.dart' as p;

import '../../../util/file_util.dart';

class PetitionDetailFile extends StatelessWidget {
  PetitionDetailFile({Key? key, this.files}) : super(key: key);
  final PetitionDetailController _controller =
      Get.put(PetitionDetailController());
  final List<FileModel>? files;

  @override
  Widget build(BuildContext context) {
    if (files!.isNotEmpty) {
      var listImageOrVideo = _controller.imagesOrVideos(files!);
      var listFilesDoc = _controller.filesDoc(files!);
      var listItem = <Widget>[];
      for (var index = 0; index < listImageOrVideo.length; index++) {
        if (index != listImageOrVideo.length - 1) {
          listItem.add(StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: 1.5,
            child: _imageOrClipWidget(listImageOrVideo[index]),
          ));
        } else {
          listItem.add(StaggeredGridTile.count(
            crossAxisCellCount: listImageOrVideo.length % 2 == 0 ? 2 : 4,
            mainAxisCellCount: listImageOrVideo.length % 2 == 0 ? 1.5 : 2.5,
            child: _imageOrClipWidget(listImageOrVideo[index]),
          ));
        }
      }
      return Column(
        children: [
          listImageOrVideo.isNotEmpty
              ? StaggeredGrid.count(
                  crossAxisCount: 4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: listItem)
              : Container(),
          listFilesDoc.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return _fileWidget(listFilesDoc[index]);
                  },
                  itemCount: listFilesDoc.length,
                )
              : Container()
        ],
      );
    } else {
      return Container();
    }
  }

  Widget _imageOrClipWidget(FileModel file) {
    final extension =
        p.extension(file.name ?? '').replaceAll('.', '').toLowerCase();
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(5)),
      child: SizedBox(
          width: Get.width * 0.5,
          child: FileUtil.videoEx.contains(extension)
              ? VideoAttachmentItem(
                  onTap: () {
                    _controller.onOpenFile(file);
                  },
                  file: file,
                )
              : FutureBuilder<dynamic>(
                  future:
                      IGateFilemanService().getOptionFile(id: file.id ?? ''),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      return InkWell(
                        onTap: () {
                          Get.to(ImageView(
                            snapshot.data,
                            saveCall: () {
                              _controller.saveFile(file);
                            },
                          ));
                        },
                        child: Image.network(
                          snapshot.data!['url'],
                          headers: snapshot.data!['headers'],
                          fit: BoxFit.cover,
                        ),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  })),
    );
  }

  Widget _fileWidget(FileModel file) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: InkWell(
          onTap: () {
            _controller.onOpenFile(file);
          },
          child: DocumentAttachmentItem(file: file)),
    );
  }
}
