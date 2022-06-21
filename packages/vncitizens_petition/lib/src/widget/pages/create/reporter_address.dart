// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_petition/src/controller/create_controller.dart';
import 'package:vncitizens_petition/src/model/petition_detail_model.dart';
import 'package:vncitizens_petition/src/widget/pages/create/text_field_custom.dart';

import 'dropdown_button_custom.dart';

class ReporterAddress extends StatelessWidget {
  ReporterAddress({Key? key}) : super(key: key);
  final PetitionCreateController _controller =
      Get.put(PetitionCreateController());

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            return Padding(
              padding: const EdgeInsets.only(top: 16),
              child: DropdownButtonCustom<PlaceModel>(
                lable: 'tinh'.tr + ' *',
                value: _controller.reporterProvinceSelected.value,
                data: _controller.reporterProvinces.value,
                onChanged: (data) {
                  _controller.reporterProvinceSelected.value = data;
                  _controller.getReporterPlaceDistricts(data.id ?? '');
                },
              ),
            );
          }),
          Obx(() {
            return Padding(
              padding: const EdgeInsets.only(top: 24),
              child: DropdownButtonCustom<PlaceModel>(
                lable: 'quan/huyen'.tr + ' *',
                value: _controller.reporterDistrictSelected.value,
                data: _controller.reporterDistricts.value,
                onChanged: (data) {
                  _controller.reporterDistrictSelected.value = data;
                  _controller.getReporterPlaceWards(data.id ?? '');
                },
              ),
            );
          }),
          Obx(() {
            return Padding(
              padding: const EdgeInsets.only(top: 24),
              child: DropdownButtonCustom<PlaceModel>(
                  lable: 'phuong/xa'.tr + ' *',
                  value: _controller.reporterWardSelected.value,
                  data: _controller.reporterWards.value,
                  onChanged: (data) {
                    _controller.reporterWardSelected.value = data;
                  }),
            );
          }),
          const SizedBox(
            height: 24,
          ),
          TextFieldCustom(
              controller: _controller.reporterAddressController,
              hintText: 'dia chi'.tr)
        ],
      ),
    );
  }

  // Widget _dropdownButtonCustom(
  //     {required String lable, String? value, required List<String> data}) {
  //   return DropdownButtonFormField<String>(
  //     value: value,
  //     isExpanded: true,
  //     style: GoogleFonts.roboto(
  //         color: Colors.black87, fontSize: 16, letterSpacing: 0.25),
  //     decoration: InputDecoration(
  //         labelText: lable,
  //         contentPadding:
  //             const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  //         border: const OutlineInputBorder(
  //             borderRadius: BorderRadius.all(Radius.circular(5)),
  //             borderSide: BorderSide(color: Colors.black12)),
  //         focusedBorder: OutlineInputBorder(
  //             borderRadius: const BorderRadius.all(Radius.circular(5)),
  //             borderSide: BorderSide(color: Colors.blue.shade800))),
  //     onChanged: (String? newValue) {},
  //     items: data.map<DropdownMenuItem<String>>((String value) {
  //       return DropdownMenuItem<String>(
  //         value: value,
  //         child: Text(value),
  //       );
  //     }).toList(),
  //   );
  // }
}
