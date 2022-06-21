import 'package:flutter/material.dart';
import 'package:vncitizens_administrative_document/src/config/color_map_config.dart';
import 'package:vncitizens_administrative_document/src/controller/admin_doc_list_controller.dart';
import 'package:vncitizens_administrative_document/src/model/color_map_model.dart';
import 'package:vncitizens_common/vncitizens_common.dart';

class AdminDocList extends GetView<AdminDocListController> {
  const AdminDocList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: const MyBottomAppBar(index: -1),
      appBar: AppBar(
        title: Text("van ban nha nuoc".tr),
        actions: [IconButton(onPressed: () => controller.onTapSearch(), icon: const Icon(Icons.search))],
      ),
      body: Obx(() => controller.isInitializing.value
          ? const Center(child: CircularProgressIndicator())
          : controller.listDocs.isEmpty
              ? Center(
                  child: Text("khong tim thay van ban".tr),
                )
              : _buildListDoc()),
    );
  }

  Widget _buildListDoc() {
    return ListView.separated(
        controller: controller.scrollController,
        itemCount: controller.listDocs.length + 1,
        addAutomaticKeepAlives: true,
        itemBuilder: (ctx, index) {
          if (index < controller.listDocs.length) {
            final document = controller.listDocs[index];
            final ColorMapModel colorMapModel = ColorMapConfig.getColor(text: document.tenLoaiVanBan);
            return ListTile(
              minVerticalPadding: 0,
              onTap: () => controller.onTapDocumentItem(document),
              title: Text(
                document.trichYeu,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("so".tr + " " + document.soVanBan + " " + "ngay".tr.toLowerCase() + " " + document.ngayBanHanh),
              leading: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: colorMapModel.color,
                  borderRadius: BorderRadius.circular(100)
                ),
                child: Center(child: Text(colorMapModel.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16),)),
              )
            );
          } else {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 20),
              child: Center(
                  child: Obx(() => controller.isEndList.value ? Text("da den cuoi danh sach".tr) : const CircularProgressIndicator())),
            );
          }
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(color: Color(0xFFE5E5E5), thickness: 4));
  }
}
