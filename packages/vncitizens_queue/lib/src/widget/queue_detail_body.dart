
import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_queue/src/controller/queue_controller.dart';
import 'package:vncitizens_queue/src/model/queue_model.dart';
import 'package:vncitizens_queue/src/widget/success_dialog.dart';

import 'error_dialog.dart';

class QueueDetailBody extends GetView<QueueController> {
  const QueueDetailBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final list =
        ModalRoute.of(context)?.settings.arguments as QueueModel;

    var now = DateTime.now();
    var formatter = DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(now);

    return Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
              Color.fromRGBO(250, 250, 110, 50),
              Color.fromRGBO(8, 159, 143, 80),
            ])),
        child: SingleChildScrollView(
            child: Obx(() => Column(children: [
                  Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(list.name,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold))),
                  Padding(
                      padding: const EdgeInsets.only(top: 5.4),
                      child: Text(list.coQuan,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 12))),
                  const Padding(
                      padding: EdgeInsets.only(top: 21.41),
                      child: Text('Dịch vụ cung cấp',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold))),
                  Padding(
                      padding: const EdgeInsets.only(top: 6.3),
                      child: SizedBox(
                        width: Get.width - 150,
                        child: Text(
                          list.description,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      )),
                  Padding(
                      padding: const EdgeInsets.only(top: 6.3),
                      child: Text('Ngày $formattedDate',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ))),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromRGBO(255, 255, 255, 1),
                    ),
                    constraints: BoxConstraints.expand(
                      height: MediaQuery.of(context).size.height / 4,
                      width: MediaQuery.of(context).size.width / 1.5,
                    ),
                    margin: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Padding(
                            padding: EdgeInsets.only(top: 6.3),
                            child: Text('Số thứ tự của bạn',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                ))),
                        Padding(
                            padding: const EdgeInsets.only(bottom: 24),
                            child: Text(list.userNumber.toString(),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold))),
                        Container(
                          height: 2,
                          width: Get.width,
                          color: const Color.fromRGBO(189, 189, 189, 0.5),
                        ),
                        const Padding(
                            padding: EdgeInsets.only(top: 6),
                            child: Text('Số thứ tự hiện tại',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                ))),
                        Text(list.processingNumber.toString(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 28,
                            )),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(5),
                    child: Text('Thông tin cá nhân',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(controller.info?.fullName ?? '',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                        'CMND: ${controller.info?.identity.toString()}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                        'Điện thoại: ${controller.info?.phoneNumber.toString()}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: SizedBox(
                      width: Get.width - 100,
                      child: Text(
                        'Địa chỉ: ${controller.info?.address.toString()}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      controller.isLoading.value
                          ? null
                          : _showDialogCancelNumber(context, list);
                    },
                    child: Text(
                      controller.isLoading.value ? 'Đang hủy số...' : 'Hủy số',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: controller.isLoading.value
                              ? Colors.grey
                              : Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: controller.isLoading.value
                            ? const Color.fromRGBO(212, 212, 212, 1)
                            : const Color.fromRGBO(213, 29, 29, 1)),
                  )
                ]))));
  }

  _showDialogCancelNumber(BuildContext context, QueueModel list) {
    // Create button
    Widget okButton = TextButton(
      child:
          Text("dong y".tr.toUpperCase(), style: const TextStyle(fontSize: 14)),
      onPressed: () {
        controller.cancelNumber(list.numberId.toString()).then((value) => {
              if (value == 200)
                {
                  controller.changeAgency(
                      controller.agencySelected.value.id.toString()),
                  controller.backToList(),
                  Get.dialog(SuccessDialog(
                    message: "huy so thu tu thanh cong".tr,
                  )),
                }
              else
                {
                  Get.dialog(ErrorDialog(
                    message: "huy so thu tu that bai".tr,
                  )),
                }
            });
      },
    );

    Widget cancelButton = TextButton(
      child:
          Text("dong".tr.toUpperCase(), style: const TextStyle(fontSize: 14)),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("huy so".tr),
      content: Text(
          "Bạn có muốn hủy số thứ tự ${list.userNumber} tại ${list.name}, ${list.coQuan}?"),
      actions: [cancelButton, okButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
