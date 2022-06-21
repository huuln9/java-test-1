import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vncitizens_account/vncitizens_account.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_petition/src/controller/petition_filter_list_controller.dart';
import 'package:vncitizens_petition/src/controller/petition_public_list_controller.dart';
import 'package:vncitizens_petition/src/controller/petition_personal_list_controller.dart';
import 'package:vncitizens_petition/src/model/tag_page_content_model.dart';
import 'package:vncitizens_petition/src/widget/commons/vncitizens_select_dropdown.dart';
import 'package:vncitizens_petition/src/widget/commons/petition_filter_date_range_field.dart';
import 'package:vncitizens_petition/src/widget/pages/create/text_field_custom.dart';

class PetitionListAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  PetitionListAppBar({Key? key, required this.controller}) : super(key: key);

  final TabController controller;

  final _filterController = Get.put(PetitionFilterListController());
  final _petitionPublicController = Get.put(PetitionPublicListController());
  final _petitionPersonalController = Get.put(PetitionPersonalListController());

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text("phan anh".tr, style: AppBarStyle.title),
      backgroundColor: Colors.blue.shade800,
      actions: [
        IconButton(
            icon: const Icon(Icons.filter_alt_outlined),
            color: Colors.white,
            onPressed: () {
              _buildAppBarBottomSheet();
            })
      ],
      bottom: TabBar(
        indicatorColor: Colors.white,
        controller: controller,
        tabs: [
          Tab(
            text: 'tat ca'.tr.toUpperCase(),
          ),
          Tab(
            text: 'ca nhan'.tr.toUpperCase(),
          )
        ],
        onTap: (index) {
          if (AuthUtil.isLoggedIn != true && index == 1) {
            UIHelper.showRequiredLoginDialog(
                routeBack: '/vncitizens_petition/list');
            controller.index = 0;
          }
        },
      ),
      automaticallyImplyLeading: true,
    );
  }

  void _buildAppBarBottomSheet() {
    Get.bottomSheet(
      Obx(() {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(children: [
            Stack(children: [
              Container(
                  alignment: FractionalOffset.topRight,
                  child: InkWell(
                    child: const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Icon(Icons.clear),
                    ),
                    onTap: () {
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                      Get.back();
                    },
                  )),
              Container(
                  alignment: FractionalOffset.center,
                  height: 56,
                  margin: const EdgeInsets.only(top: 16),
                  child: Text(
                    'bo loc'.tr,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  )),
            ]),
            Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              TextFieldCustom(
                controller: _filterController.keywordController,
                hintText: 'nhap tu khoa tim kiem'.tr,
                labelText: 'tu khoa'.tr,
                textInputAction: TextInputAction.done,
                onEditingComplete: () {
                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                },
              ),
              const SizedBox(
                height: 24,
              ),
              VnCitizensSelectDropDown(
                label: 'trang thai'.tr,
                items: _filterController.statusList,
                initValue: _filterController.statusSelector.value,
                onChanged: (TagPageContentModel? item) {
                  _filterController.statusSelector.value = item!;
                },
              ),
              const SizedBox(
                height: 24,
              ),
              VnCitizensSelectDropDown(
                label: 'linh vuc'.tr,
                items: _filterController.categories,
                initValue: _filterController.categorySelector.value.id != ''
                    ? _filterController.categorySelector.value
                    : _filterController.defaultTag.value,
                onChanged: (TagPageContentModel? item) {
                  _filterController.categorySelector.value = item!;
                  _filterController.getTags();
                },
              ),
              const SizedBox(
                height: 24,
              ),
              Obx(() {
                return VnCitizensSelectDropDown(
                  label: 'chuyen muc'.tr,
                  items: _filterController.tags,
                  initValue: _filterController.tagSelector.value.id != ''
                      ? _filterController.tagSelector.value
                      : _filterController.defaultTag.value,
                  onChanged: (TagPageContentModel? item) {
                    _filterController.tagSelector.value = item!;
                  },
                );
              }),
              const SizedBox(
                height: 24,
              ),
              Obx(() {
                if (_filterController.checkDateTimeRange()) {
                  return VnCitizensDateRangeField(
                    restorationId: 'VN_CITIZENS_DEFAULT',
                    initialValue: DateTimeRange(
                        start: DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                            .parse(_filterController.startDate.value),
                        end: DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                            .parse(_filterController.endDate.value)),
                    onChanged: (DateTimeRange? range) {
                      final DateFormat formatter =
                          DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
                      _filterController.startDate.value = range?.start != null
                          ? formatter.format(range!.start)
                          : '';
                      _filterController.endDate.value = range?.end != null
                          ? formatter.format(DateTime(range!.end.year,
                              range.end.month, range.end.day + 1))
                          : '';
                    },
                  );
                } else {
                  return VnCitizensDateRangeField(
                    restorationId: 'VN_CITIZENS_RESET',
                    onChanged: (DateTimeRange? range) {
                      final DateFormat formatter =
                          DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
                      _filterController.startDate.value = range?.start != null
                          ? formatter.format(range!.start)
                          : '';
                      _filterController.endDate.value = range?.end != null
                          ? formatter.format(DateTime(range!.end.year,
                              range.end.month, range.end.day + 1))
                          : '';
                    },
                  );
                }
              }),
              const SizedBox(
                height: 16,
              ),
            ]),
            SizedBox(
              height: 40,
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _filterController.resetFilterValue();
                            if (controller.index == 0) {
                              _petitionPublicController.searchPetitions();
                            } else {
                              _petitionPersonalController.searchPetitions();
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            width: Get.width * 0.4 - 16,
                            child: Text(
                              'huy bo loc'.tr.toUpperCase(),
                              style: const TextStyle(color: Color(0xFF263238)),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _petitionPublicController.searchPetitions();
                            Get.back();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: Get.width * 0.4 - 16,
                            child: Text('ap dung'.tr.toUpperCase()),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 55),
          ]),
        );
      }),
      backgroundColor: Colors.white,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
      ),
      isScrollControlled: true,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height +
      const TabBar(tabs: []).preferredSize.height);
}
