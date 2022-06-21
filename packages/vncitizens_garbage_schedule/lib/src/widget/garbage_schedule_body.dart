import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_garbage_schedule/src/config/app_config.dart';
import 'package:vncitizens_garbage_schedule/src/controller/garbage_schedule_controller.dart';
import 'package:vncitizens_garbage_schedule/src/model/garbage_schedule_model.dart';

class GarbageScheduleBody extends GetView<GarbageScheduleController> {
  GarbageScheduleBody({Key? key}) : super(key: key);

  final InternetController _internetController = Get.put(InternetController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _internetController.hasConnected.value
          ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: controller.textController,
                    focusNode: controller.textFocus,
                    onEditingComplete: () {
                      controller.getAndHandleData(
                          keyword: controller.textController.text);
                      FocusScope.of(context).unfocus();
                    },
                    decoration: InputDecoration(
                      fillColor: Colors.grey.shade300,
                      filled: true,
                      hintText: 'nhap tu khoa tim kiem ...'.tr,
                      contentPadding: const EdgeInsets.only(left: 15),
                      border:
                          const OutlineInputBorder(borderSide: BorderSide.none),
                      suffixIcon: Obx(
                        () => controller.isFocus.value
                            ? IconButton(
                                onPressed: () {
                                  controller.textController.clear();
                                  controller.getAndHandleData(
                                      keyword: controller.textController.text);
                                  FocusScope.of(context).unfocus();
                                },
                                icon: const Icon(Icons.cancel,
                                    color: Colors.black45),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Obx(
                    () => !controller.isLoading.value
                        ? controller.data.isNotEmpty
                            ? _buildFoundData()
                            : _buildNotFoundData()
                        : const Center(child: CircularProgressIndicator()),
                  ),
                ),
              ],
            )
          : NoInternet(onPressed: () => controller.onInit()),
    );
  }

  Widget _buildFoundData() {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 50),
      itemCount: controller.data.length,
      itemBuilder: (context, i) {
        return Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: i == 0,
            title: Text(
              controller.data[i].name,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            children: <Widget>[
              Column(
                  children: _buildExpandableContent(controller.data[i].group)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNotFoundData() {
    return Center(
      child: Text(
        "khong tim thay ket qua".tr,
        style: const TextStyle(fontStyle: FontStyle.italic),
      ),
    );
  }

  List<Widget> _buildExpandableContent(List<GarbageScheduleModel> group) {
    List<Widget> columnContent = [];
    for (final e in group) {
      columnContent.add(
        ListTile(
          leading:
              Image.asset('${AppConfig.assetsRoot}/garbage-schedule-icon.png'),
          title: Text(e.street, style: const TextStyle(fontSize: 18.0)),
          subtitle: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: e.description! + '\n',
                  style: const TextStyle(color: Colors.black, fontSize: 12),
                ),
                TextSpan(
                  text: e.period,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          minVerticalPadding: 10,
          // isThreeLine: true,
        ),
      );
    }
    return columnContent;
  }
}
