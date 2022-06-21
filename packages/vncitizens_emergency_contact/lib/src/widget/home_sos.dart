import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_emergency_contact/src/config/emer_contact_app_config.dart';
import 'package:vncitizens_emergency_contact/src/config/emer_contact_route_config.dart';
import 'package:vncitizens_emergency_contact/src/controller/home_sos_controller.dart';
import 'package:vncitizens_emergency_contact/src/model/sos_group_by_tag_model.dart';
import 'package:vncitizens_emergency_contact/src/model/sos_item_model.dart';
import 'package:vncitizens_emergency_contact/src/util/string_util.dart';
import 'package:vncitizens_emergency_contact/src/widget/component/api_error_widget.dart';
import 'package:vncitizens_emergency_contact/src/widget/component/linear_loading_widget.dart';

class HomeSos extends GetView<HomeSosController> {
  const HomeSos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: const MyBottomAppBar(index: -1),
      appBar: AppBar(
        title: Obx(() => controller.isShowSearchInput.value ? _buildSearchInput(context) : Text(controller.title.value ?? "danh ba".tr)),
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
            : controller.listSosByTag.isEmpty && controller.listSosNoTag.isEmpty
              ? _buildNotFoundSos()
              : _buildBodyWithSos()),
    );
  }

  Widget _buildSearchInput(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(splashColor: Colors.transparent),
      child: TextFormField(
        controller: controller.searchController,
        onEditingComplete: () => controller.search(controller.searchController.text),
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

  Widget _buildNotFoundSos() {
    return Center(child: Text("khong tim thay danh ba".tr));
  }

  Widget _buildBodyWithSos() {
    return Obx(
      () => ListView.builder(
        itemCount: controller.listSosByTag.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Obx(() => Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 4.0, color: Color.fromRGBO(229, 229, 229, 1)),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: getListSosNoTagWidget(controller.listSosNoTag),
                  ),
                ));
          }
          return Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(width: 4.0, color: Color.fromRGBO(229, 229, 229, 1)),
                bottom: BorderSide(width: 4.0, color: Color.fromRGBO(229, 229, 229, 1)),
              ),
            ),
            child: GetX<HomeSosController>(builder: (_) {
              return ExpansionTile(
                initiallyExpanded: controller.listSosByTag[index - 1].description == EmerContactAppConfig.titleExpandedString,
                onExpansionChanged: (bool value) {
                  if (value == true) {
                    controller.onTapSosGroupTitle(controller.listSosByTag[index - 1].id);
                  }
                },
                iconColor: Colors.black,
                title: Text(controller.listSosByTag[index - 1].name ?? "",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
                        color: Colors.black)),
                children: getListSosWidget(controller.listSosByTag[index - 1]),
              );
            }),
          );
        },
      ),
    );
  }

  List<Widget> getListSosNoTagWidget(List<SosItemModel> items) {
    List<Widget> listWidget = [];
    for (var element in items) {
      listWidget.add(ListTile(
        onTap: () {
          launch("tel:${element.phoneNumber}");
        },
        leading: _buildSosImage(element),
        minLeadingWidth: 10,
        title: Text(
          element.name,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(element.phoneNumber),
        trailing: const Icon(
          Icons.wifi_calling_3,
          color: Colors.black,
        ),
      ));
    }
    return listWidget;
  }

  List<Widget> getListSosWidget(SosGroupByTagModel sosGroupByTagModel) {
    List<Widget> listWidget = [];
    final contacts = sosGroupByTagModel.contacts;
    if (contacts != null && contacts.isNotEmpty) {
      for (var element in contacts) {
        listWidget.add(Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(width: 2, color: Color.fromRGBO(229, 229, 229, 1)),
            ),
          ),
          child: ListTile(
            onTap: () {
              launch("tel:${element.phoneNumber}");
            },
            leading: _buildSosImage(element),
            minLeadingWidth: 10,
            title: Text(element.name, style: const TextStyle(fontWeight: FontWeight.w500)),
            subtitle: Text(element.phoneNumber),
            trailing: const Icon(
              Icons.wifi_calling_3,
              color: Colors.black,
            ),
          ),
        ));
      }
    }
    return listWidget;
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
