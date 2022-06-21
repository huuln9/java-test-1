import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_emergency_contact/src/controller/contact_by_group_controller.dart';
import 'package:vncitizens_emergency_contact/src/model/sos_item_model.dart';
import 'package:vncitizens_emergency_contact/src/util/string_util.dart';

import 'component/api_error_widget.dart';
import 'component/linear_loading_widget.dart';

class ContactByGroup extends GetView<ContactByGroupController> {
  const ContactByGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: const MyBottomAppBar(index: -1),
      appBar: AppBar(
          title: Obx(() => controller.isShowSearchInput.value ? _buildSearchInput(context) : Text(controller.title.value ?? "")),
        actions: [
          Obx(
                () => controller.isShowSearchInput.value
                ? IconButton(onPressed: () => controller.onClickSearchDeleteIcon(), icon: const Icon(Icons.close))
                : IconButton(onPressed: () => controller.onTapIconSearch(), icon: const Icon(Icons.search)),
          )
        ],
      ),
      body: Obx(() => controller.isInitialized.value != true
          ? const LinearLoadingWidget()
          : controller.isInitError.value == true
              ? ApiErrorWidget(retry: () => controller.init())
              : controller.listContact.isEmpty
                  ? Center(child: Text("khong tim thay danh ba".tr))
                  : SingleChildScrollView(
                    controller: controller.scrollController,
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(controller.listContact.length + 1, (index) {
                          if (index < controller.listContact.length) {
                            final element = controller.listContact[index];
                            return DecoratedBox(
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(color: Colors.black12)
                                  )
                              ),
                              child: ListTile(
                                onTap: () => launchUrl(Uri.parse("tel:${element.phoneNumber}")),
                                leading: _buildSosImage(element),
                                minLeadingWidth: 10,
                                subtitle: Text(element.phoneNumber),
                                title: Text(
                                  element.name,
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                                trailing: const Icon(
                                  Icons.wifi_calling_3,
                                  color: Colors.black,
                                ),
                              ),
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0, bottom: 20),
                              child: Center(
                                  child: Obx(() => controller.isEndList.value ? Text("da den cuoi danh sach".tr) : const CircularProgressIndicator())),
                            );
                          }
                        }),
                      ),
                  )),
    );
  }

  Widget _buildSearchInput(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(splashColor: Colors.transparent),
      child: TextFormField(
        controller: controller.searchController,
        autofocus: true,
        onEditingComplete: () => controller.search(),
        cursorColor: Colors.white,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
            filled: true,
            hintStyle: const TextStyle(color: Colors.white70),
            fillColor: Theme.of(context).appBarTheme.backgroundColor,
            hintText: 'tu khoa'.tr,
            border: InputBorder.none),
      ),
    );
  }

  Widget _buildSosImage(SosItemModel element) {
    final image = element.image;
    if (image != null) {
      if (image.isNotEmpty) {
        if (element.imageFile != null) {
          return CircleAvatar(
            backgroundImage: Image.file(element.imageFile!).image,
            radius: 20,
          );
        } else {
          return Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Color.fromRGBO(6, 143, 224, 1)),
            child: Center(
              child: Text(
                StringUtil.getShortStringFromName(element.name),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          );
        }
      }
    }
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(shape: BoxShape.circle, color: Color.fromRGBO(6, 143, 224, 1)),
      child: Center(
        child: Text(
          StringUtil.getShortStringFromName(element.name),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

}