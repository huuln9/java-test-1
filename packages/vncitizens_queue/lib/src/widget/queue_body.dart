import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_queue/src/controller/queue_controller.dart';
import 'package:vncitizens_queue/src/model/agency_model.dart';
import 'package:vncitizens_queue/src/model/queue_model.dart';
import 'package:vncitizens_queue/src/widget/success_dialog.dart';

import 'error_dialog.dart';

class QueueBody extends GetView<QueueController> {
  const QueueBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: double.infinity,
        color: const Color.fromRGBO(240, 240, 240, 1),
        child: Column(children: [
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                  color: const Color.fromRGBO(250, 250, 250, 1),
                  child: Column(
                    children: <Widget>[
                      Obx(() {
                        return InputDecorator(
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 10),
                            labelText: "noi nop ho so".tr,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0)),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<AgencyModel>(
                              icon: const Icon(Icons.arrow_drop_down),
                              iconSize: 24,
                              elevation: 16,
                              isExpanded: true,
                              onChanged: (newValue) {
                                controller.agencySelected.value = newValue!;
                                controller.changeAgency(newValue.id.toString());
                              },
                              value: controller.agencySelected.value,
                              items: controller.getListAgency.map((value) {
                                return DropdownMenuItem<AgencyModel>(
                                  value: value,
                                  child: Text(value.name!),
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      }),
                    ],
                  ))),
          Expanded(
              child: Container(
                  color: const Color.fromRGBO(250, 250, 250, 1),
                  child: Obx(() => controller.getListReception.isEmpty
                      ? _listNotFound()
                      : _listQueue(context))))
        ]));
  }

  Widget _listNotFound() {
    return Center(child: Text("khong tim thay dich vu".tr));
  }

  Widget _listQueue(context) {
    return ListView.separated(
      itemCount: controller.getListReception.length + 1,
      addAutomaticKeepAlives: true,
      itemBuilder: (ctx, index) {
        if (index < controller.getListReception.length) {
          final list = controller.getListReception[index];
          return ListTile(
              minVerticalPadding: 9,
              trailing: Obx(() => OutlinedButton(
                  onPressed: () {
                    list.userNumber == null
                        ? _showDialogOrderNumber(context, list)
                        : _showDialogCancelNumber(context, list);
                  },
                  child: controller.isLoading.value
                      ? Container(
                          width: 35,
                          height: 35,
                          padding: const EdgeInsets.all(2.0),
                          child: const CircularProgressIndicator(
                            color: Color.fromRGBO(21, 101, 192, 1),
                            strokeWidth: 1,
                          ),
                        )
                      : list.userNumber == null
                          ? const Text(
                              'Lấy số',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(0, 91, 175, 1)),
                            )
                          : const Text(
                              'Hủy số',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(149, 0, 0, 1)),
                            ),
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    primary: Colors.white,
                    side: BorderSide(
                        width: 1.0,
                        color: controller.isLoading.value
                            ? Colors.white
                            : list.userNumber == null
                                ? const Color.fromRGBO(0, 91, 175, 1)
                                : const Color.fromRGBO(149, 0, 0, 1)),
                  ))),
              title: Text(
                list.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(list.description),
              leading: GestureDetector(
                  onTap: () {
                    list.userNumber != null
                        ? controller.onTapDetails(list)
                        : null;
                  },
                  child: CircleAvatar(
                      radius: 30,
                      backgroundColor: list.userNumber != null
                          ? const Color.fromRGBO(235, 87, 176, 1)
                          : const Color.fromRGBO(232, 195, 0, 1),
                      child: Container(
                          padding: const EdgeInsets.only(top: 2, bottom: 2),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Visibility(
                                  visible: true,
                                  child: Text(list.processingNumber.toString(),
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.white))),
                              list.userNumber != null
                                  ? Container(
                                      height: 1,
                                      width: 32,
                                      color: Colors.white,
                                    )
                                  : Container(),
                              Visibility(
                                  visible:
                                      list.userNumber == null ? false : true,
                                  child: Text(list.userNumber.toString(),
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.white)))
                            ],
                          )))));
        } else {
          return const Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8), child: Center());
        }
      },
      separatorBuilder: (BuildContext context, int index) =>
          const Divider(color: Color.fromRGBO(240, 240, 240, 1), thickness: 4),
    );
  }

  _showDialogOrderNumber(BuildContext context, QueueModel list) {
    // Create button
    Widget okButton = TextButton(
      child:
          Text("dong y".tr.toUpperCase(), style: const TextStyle(fontSize: 14)),
      onPressed: () {
        controller.orderNumber(list.officials, list.id).then((value) => {
              if (value == 200)
                {
                  controller.changeAgency(
                      controller.agencySelected.value.id.toString()),
                  Navigator.of(context).pop(),
                  Get.dialog(SuccessDialog(
                    message: "lay so thu tu thanh cong".tr,
                  )),
                }
              else
                {
                  Get.dialog(ErrorDialog(message: "lay so thu tu that bai".tr),
                      barrierDismissible: false)
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
      title: Text("lay so".tr),
      content: Text("Bạn muốn lấy số tại ${list.name}, ${list.coQuan}?"),
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
                  Navigator.of(context).pop(),
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
