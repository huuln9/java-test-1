import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:vncitizens_account/vncitizens_account.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_petition/src/controller/petition_detail_controller.dart';
import 'package:vncitizens_petition/src/controller/petition_personal_list_controller.dart';
import 'package:vncitizens_petition/src/model/petition_page_content_model.dart';
import 'package:vncitizens_petition/src/widget/pages/create/petition_create.dart';
import 'package:vncitizens_petition/src/widget/pages/detail/petition_detail.dart';

class PetitionPersonalListItem extends StatelessWidget {
  PetitionPersonalListItem({Key? key, required this.index}) : super(key: key);

  final int index;
  final _controller = Get.put(PetitionPersonalListController());

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      child: Obx(() {
        PetitionPageContentModel petition = _controller.petitions[index];
        Uint8List? thumbnailBytes = _controller.thumbnailBytesList[petition.id];
        return ListTile(
            contentPadding:
                const EdgeInsets.only(left: 16, right: 16, top: 6, bottom: 8),
            leading: thumbnailBytes != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: SizedBox(
                        height: 75,
                        width: 90,
                        child: Image.memory(
                          thumbnailBytes,
                          fit: BoxFit.cover,
                        )),
                  )
                : null,
            title: Text(petition.title,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                softWrap: false,
                style: ListTitleStyle.title,
                textAlign: TextAlign.justify),
            subtitle: Wrap(
              children: [
                SizedBox(
                  width: Get.width,
                  child: RichText(
                    text: TextSpan(
                      text: 'dia diem'.tr + ': ',
                      style: const TextStyle(
                          color: Color(0xFF434343), letterSpacing: 0.25),
                      children: <TextSpan>[
                        TextSpan(
                            text: petition.takePlaceAt.fullAddress,
                            style: const TextStyle(
                                color: Color(0xFF7D7B7B), letterSpacing: 0.25))
                      ],
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    softWrap: false,
                  ),
                ),
                SizedBox(
                  width: Get.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'trang thai'.tr + ': ',
                          style: const TextStyle(
                              color: Color(0xFF434343), letterSpacing: 0.25),
                          children: <TextSpan>[
                            TextSpan(
                                text: petition.statusDescription,
                                style: const TextStyle(
                                    color: Color(0xFF7D7B7B),
                                    letterSpacing: 0.25))
                          ],
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: false,
                      ),
                      AuthUtil.userId == petition.reporter.id &&
                              petition.status == 1
                          ? InkWell(
                              onTap: () {
                                UIHelper.showBottomSheetActions(
                                    children:
                                        _buildBottomSheetActions(petition));
                              },
                              child: const Icon(Icons.more_horiz,
                                  color: Colors.black),
                            )
                          : const SizedBox()
                    ],
                  ),
                ),
              ],
            ),
            isThreeLine: true,
            onTap: () {
              Get.to(PetitionDetail(
                id: petition.id,
              ));
            });
      }),
    );
  }

  List<Widget> _buildBottomSheetActions(PetitionPageContentModel petition) {
    return [
      SizedBox(
        height: 40,
        child: ListTile(
          leading: const Icon(Icons.edit),
          title: Text('cap nhat'.tr),
          onTap: () async {
            // controller.changeSelectedMode();
            Get.back();
            var result = await Get.to(PetitionCreate(
              id: petition.id,
            ));
            if (result is bool) {
              _controller.refreshPetitions();
              final _controllerPersonal =
                  Get.put(PetitionPersonalListController());
              _controllerPersonal.refreshPetitions();
            }
          },
        ),
      ),
      SizedBox(
        height: 40,
        child: ListTile(
          leading: const Icon(Icons.delete_outlined),
          title: Text('xoa'.tr),
          onTap: () {
            // Get.back();
            // Get.back();
            UIHelper.showNotificationDialog(
                title: Text('xac nhan'.tr),
                content: Text('xoa phan anh da gui'.tr),
                onPressed: () {
                  Get.back();
                  final _controller = Get.put(PetitionDetailController());
                  _controller.onDeletePetition(petition.id);
                });
          },
        ),
      ),
    ];
  }
}
