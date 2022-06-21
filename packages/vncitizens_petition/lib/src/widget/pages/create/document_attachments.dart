import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_petition/src/config/app_config.dart';
import 'package:vncitizens_petition/src/controller/create_controller.dart';
import 'package:path/path.dart' as p;
import 'package:vncitizens_petition/src/controller/petition_detail_controller.dart';
import 'package:vncitizens_petition/src/model/petition_detail_model.dart';
import 'package:vncitizens_petition/src/widget/commons/doc_attachment_item.dart';

import '../../../util/file_util.dart';
import '../../commons/video_attachment_item.dart';

class DocumentsAttactments extends StatefulWidget {
  const DocumentsAttactments({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DocumentsAttactmentsState();
  }
}

class DocumentsAttactmentsState extends State<DocumentsAttactments> {
  final PetitionCreateController _controller =
      Get.put(PetitionCreateController());
  final PetitionDetailController _controllerDetail = PetitionDetailController();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: GoogleFonts.roboto(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
              children: [
                TextSpan(
                  text: 'tai lieu dinh kem'.tr,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: 'hinh anh video tai lieu'.tr,
                  style: GoogleFonts.roboto(color: Colors.grey, fontSize: 16),
                ),
                TextSpan(
                  text: AppConfig.getPetitionCreateConfig.file!.required!
                      ? ' *'
                      : '',
                  style: GoogleFonts.roboto(color: Colors.grey, fontSize: 16),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Obx(() {
            if (AppConfig.getPetitionCreateConfig.file != null &&
                _controller.files.length <=
                    (AppConfig.getPetitionCreateConfig.file!.maxLength ?? 6)) {
              return DashedRect(
                color: AppConfig.materialMainBlueColor,
                strokeWidth: 1,
                gap: 3,
                child: InkWell(
                  onTap: () {
                    showBottomSheet(context);
                  },
                  child: SizedBox(
                    width: Get.width - 40,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add,
                              color: AppConfig.materialMainBlueColor),
                          Text(
                            'them'.tr,
                            style: const TextStyle(
                                color: AppConfig.materialMainBlueColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return Container();
            }
          }),
          const SizedBox(
            height: 10,
          ),
          Obx(() {
            if (_controller.files.isNotEmpty) {
              var listImageOrVideo = _controller.imagesOrVideos;
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
                    crossAxisCellCount:
                        listImageOrVideo.length % 2 == 0 ? 2 : 4,
                    mainAxisCellCount:
                        listImageOrVideo.length % 2 == 0 ? 1.5 : 2.5,
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
                  _controller.filesDoc.isNotEmpty
                      ? ListView.builder(
                          padding: const EdgeInsets.only(top: 4),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return _fileWidget(_controller.filesDoc[index]);
                          },
                          itemCount: _controller.filesDoc.length,
                        )
                      : Container()
                ],
              );
            } else {
              return Container();
            }
          }),
        ],
      ),
    );
  }

  Widget _imageOrClipWidget(FileModel file) {
    final extension = p
        .extension(file.path ?? file.name ?? '')
        .replaceAll('.', '')
        .toLowerCase();
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              child: FileUtil.videoEx.contains(extension)
                  ? VideoAttachmentItem(
                      file: file,
                    )
                  : file.path != null
                      ? Image.file(
                          File(file.path!),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        )
                      : file.id != null
                          ? FutureBuilder<dynamic>(
                              future: IGateFilemanService()
                                  .getOptionFile(id: file.id ?? ''),
                              builder: (context, snapshot) {
                                if (snapshot.hasData && snapshot.data != null) {
                                  return InkWell(
                                    onTap: () {},
                                    child: Image.network(
                                      snapshot.data!['url'],
                                      headers: snapshot.data!['headers'],
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                  );
                                } else {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                              })
                          : Container()),
          Positioned(
              top: 8,
              right: 8,
              child: _closeIcon(() {
                _controller.files.remove(file);
              }))
        ],
      ),
    );
  }

  Widget _fileWidget(FileModel file) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Stack(
        children: [
          DocumentAttachmentItem(
            file: file,
            paddingEnd: true,
          ),
          Positioned(
              top: 0,
              bottom: 0,
              right: 10,
              child: _closeIcon(() {
                _controller.files.remove(file);
              }))
        ],
      ),
    );
  }

  Widget _closeIcon(Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withOpacity(0.25),
        ),
        child: const Icon(
          Icons.close,
          color: Colors.white,
        ),
      ),
    );
  }

  showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 40),
                  Text(
                    'tai len tu'.tr,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Get.back();
                    },
                  )
                ],
              ),
              ListTile(
                onTap: () {
                  Get.back();
                  _controller.getImagesCamera();
                },
                leading: const Icon(Icons.camera_alt),
                title: const Text(
                  'Camera',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              ListTile(
                onTap: () {
                  Get.back();
                  _controller.getImagesGallery(context);
                },
                leading: const Icon(Icons.collections),
                title: Text(
                  'thu vien hinh anh'.tr,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              ListTile(
                onTap: () {
                  Get.back();
                  _controller.getFilesDevice();
                },
                leading: const Icon(Icons.storage),
                title: Text(
                  'thiet bi'.tr,
                  style: const TextStyle(fontSize: 16),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
