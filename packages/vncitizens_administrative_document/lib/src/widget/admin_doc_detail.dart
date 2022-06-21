import 'package:flutter/material.dart';
import 'package:vncitizens_administrative_document/src/controller/admin_doc_detail_controller.dart';
import 'package:vncitizens_common/vncitizens_common.dart';

class AdminDocDetail extends GetView<AdminDocDetailController> {
  const AdminDocDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const MyBottomAppBar(index: -1),
      appBar: AppBar(
        title: Text("chi tiet van ban".tr),
      ),
      body: Obx(
        () => controller.isInitializing.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// trich yeu
                      _Field(title: "trich yeu".tr, content: controller.docDetail.value!.trichYeu),
                      const Divider(),

                      /// so ky hieu
                      _Field(title: "so ky hieu".tr, content: controller.docDetail.value!.soVanBan),
                      const Divider(),

                      /// co quan ban hanh
                      _Field(title: "co quan ban hanh".tr, content: controller.docDetail.value!.tenCoQuan),
                      const Divider(),

                      /// ngay ban hanh
                      _Field(title: "ngay ban hanh".tr, content: controller.docDetail.value!.ngayBanHanh),
                      const Divider(),

                      /// linh vuc
                      _Field(title: "linh vuc".tr, content: controller.docDetail.value!.tenLinhVuc),
                      const Divider(),

                      /// loai van ban
                      _Field(title: "loai van ban".tr, content: controller.docDetail.value!.tenLoaiVanBan),
                      const Divider(),

                      /// nguoi ky
                      _Field(title: "nguoi ky".tr, content: controller.docDetail.value!.nguoiKy),
                      const Divider(),

                      /// file van ban
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text("file van ban".tr),
                            const SizedBox(height: 4),
                            OutlinedButton(
                              onPressed: () => controller.onTapFile(controller.fileUrl.value ?? "", controller.fileName.value ?? '',),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(1000),
                                ),
                                side: const BorderSide(color: Color(0xFFBEBEBE)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  controller.fileTypeImageSource.value != null
                                      ? Container(
                                          padding: const EdgeInsets.only(right: 6),
                                          margin: const EdgeInsets.only(right: 6),
                                          decoration: const BoxDecoration(border: Border(right: BorderSide(color: Color(0xFFBEBEBE)))),
                                          child: Image.asset(controller.fileTypeImageSource.value!, width: 24),
                                        )
                                      : const SizedBox(),
                                  Expanded(
                                    child: Text(
                                      controller.fileUrl.value ?? "",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({Key? key, required this.title, required this.content}) : super(key: key);

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title),
          const SizedBox(height: 4),
          Text(content, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
