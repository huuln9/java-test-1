// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_petition/src/config/app_config.dart';
import 'package:vncitizens_petition/src/controller/create_controller.dart';
import 'package:vncitizens_petition/src/controller/petition_filter_list_controller.dart';
import 'package:vncitizens_petition/src/widget/pages/create/petition_address.dart';

import '../../../model/tag_page_content_model.dart';
import 'dropdown_button_custom.dart';
import 'text_field_custom.dart';

class PetitionInfo extends StatelessWidget {
  PetitionInfo({Key? key}) : super(key: key);
  final PetitionCreateController _controller =
      Get.put(PetitionCreateController());

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'thong tin phan anh'.tr.toUpperCase(),
            style: GoogleFonts.roboto(
                color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500),
          ),
          // const SizedBox(
          //   height: 24,
          // ),
          (AppConfig.getPetitionCreateConfig.titleActive ?? true)
              ? Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: TextFieldCustom(
                    controller: _controller.titleController,
                    hintText: 'tieu de phan anh'.tr + ' *',
                    maxLength: 128,
                  ),
                )
              : Container(),
          (AppConfig.getPetitionCreateConfig.categoryActive ?? true)
              ? Obx(() {
                  return Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: DropdownButtonCustom<TagPageContentModel>(
                      lable: 'linh vuc phan anh'.tr + ' *',
                      value: _controller.categorySelected.value,
                      data: _controller.categories.value,
                      onChanged: (data) {
                        _controller.categorySelected(data);
                        _controller.getTags(parentId: data.id);
                      },
                    ),
                  );
                })
              : Container(),
          Obx(() {
            if (_controller.tags.value.isEmpty) {
              return Container();
            } else {
              return Padding(
                padding: const EdgeInsets.only(top: 24),
                child: DropdownButtonCustom<TagPageContentModel>(
                  lable: 'chuyen muc phan anh'.tr + ' *',
                  value: _controller.tagSelected.value,
                  data: _controller.tags.value,
                  onChanged: (data) {
                    _controller.tagSelected.value = data;
                  },
                ),
              );
            }
          }),
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: TextFieldCustom(
              controller: _controller.descriptionController,
              hintText: 'noi dung phan anh'.tr + ' *',
              minLines: 5,
              maxLength: AppConfig.getPetitionCreateConfig.descriptionMaxLength,
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          PetitionAddress()
        ],
      ),
    );
  }
}
