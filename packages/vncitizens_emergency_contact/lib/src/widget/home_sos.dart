import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_common_hcm/vncitizens_common_hcm.dart';
import 'package:vncitizens_emergency_contact/src/controller/home_sos_controller.dart';
import 'package:vncitizens_emergency_contact/src/model/sos_item_model.dart';

class HomeSos extends StatefulWidget {
  const HomeSos({Key? key}) : super(key: key);

  @override
  State<HomeSos> createState() => _HomeSosState();
}

class _HomeSosState extends State<HomeSos> {
  final HomeSosController controller = Get.put(HomeSosController());
  bool isShowDialog = false;
  @override
  void initState() {
    super.initState();
    controller.isLoading.stream.listen((val) {
      if (val && !isShowDialog) {
        isShowDialog = true;
        Get.dialog(
            AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              content: SingleChildScrollView(
                child: AppLinearProgress(
                  text: 'dang thuc hien'.tr,
                ),
              ),
            ),
            barrierDismissible: false);
      } else if (isShowDialog) {
        isShowDialog = false;
        Get.back();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: const MyBottomAppBar(index: -1),
      appBar: AppBar(
        title: Text("tong dai 113-114-115".tr),
      ),
      body: Obx(() => controller.listSos.isEmpty
          ? _buildNotFoundSos()
          : _buildBodyWithSos()),
    );
  }

  Widget _buildNotFoundSos() {
    return Center(child: Text("khong tim thay danh ba".tr));
  }

  Widget _buildBodyWithSos() {
    return Obx(
      () => ListView.builder(
        itemCount: controller.listSos.length,
        itemBuilder: (context, index) {
          return Obx(() => Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        width: 0.5, color: Color.fromRGBO(229, 229, 229, 1)),
                  ),
                ),
                child: getListSosNoTagWidget(controller.listSos[index]),
              ));
        },
      ),
    );
  }

  Widget getListSosNoTagWidget(SosItemModel item) {
    return ListTile(
      onTap: () async {
        // launch("tel:${item.phoneNumber}");
        await controller.senLocationCall(item);
      },
      leading: _buildSosImage(item),
      minLeadingWidth: 10,
      title: Text(
        item.name!,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(item.phoneNumber!),
      trailing: const Icon(
        Icons.wifi_calling_3,
        color: Colors.black,
        size: 32,
      ),
    );
  }

  Widget _buildSosImage(SosItemModel element) {
    final image = element.image;

    return Image(
      image: AssetImage(image!),
      width: 60,
      height: 60,
    );
  }
}
