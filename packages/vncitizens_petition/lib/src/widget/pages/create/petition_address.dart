// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_petition/src/config/app_config.dart';
import 'package:vncitizens_petition/src/controller/create_controller.dart';
import 'package:vncitizens_petition/src/model/petition_detail_model.dart';
import 'package:vncitizens_petition/src/widget/pages/create/text_field_custom.dart';

import 'dropdown_button_custom.dart';

class PetitionAddress extends StatelessWidget {
  PetitionAddress({Key? key}) : super(key: key);
  final PetitionCreateController _controller =
      Get.put(PetitionCreateController());

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'dia diem phan anh'.tr.toUpperCase(),
            style: GoogleFonts.roboto(
                color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500),
          ),
          (AppConfig.getPetitionCreateConfig.takePlaceAt != null &&
                  (AppConfig.getPetitionCreateConfig.takePlaceAt!
                          .districtActive ??
                      true))
              ? Obx(() {
                  return Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: DropdownButtonCustom<PlaceModel>(
                      lable: 'quan/huyen'.tr + ' *',
                      value: _controller.takePlaceAtDistrictSelected.value,
                      data: _controller.takePlaceAtDistricts.value,
                      onChanged: (data) {
                        _controller.petitionAddressController.clear();
                        _controller.takePlaceAtDistrictSelected.value = data;
                        _controller.getTakeAtPlaceWards(data.id ?? '');
                      },
                    ),
                  );
                })
              : Container(),
          (AppConfig.getPetitionCreateConfig.takePlaceAt != null &&
                  (AppConfig.getPetitionCreateConfig.takePlaceAt!.wardsActive ??
                      true))
              ? Obx(() {
                  return Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: DropdownButtonCustom<PlaceModel>(
                      lable: 'phuong/xa'.tr,
                      value: _controller.takePlaceAtWardSelected.value,
                      data: _controller.takePlaceAtWards.value,
                      onChanged: (data) {
                        _controller.petitionAddressController.clear();
                        _controller.takePlaceAtWardSelected.value = data;
                      },
                    ),
                  );
                })
              : Container(),
          const SizedBox(
            height: 24,
          ),
          Obx(() {
            return TextFieldCustom(
              controller: _controller.petitionAddressController,
              hintText: 'chi tiet dia diem phan anh'.tr + ' *',
              textInputAction: TextInputAction.done,
              onEditingComplete: () {
                _controller.convertAddressDecomposition();
                SystemChannels.textInput.invokeMethod('TextInput.hide');
              },
              suffixIcon: !_controller.isShowClearTakeAtPlace.value
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () {
                            _controller.getAddress();
                          },
                          child: const Image(
                            image: AssetImage(
                                '${AppConfig.assetsRoot}/gps-location.png'),
                            width: 24,
                            height: 24,
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        InkWell(
                          onTap: () {
                            _controller.routeAddressMap();
                          },
                          child: const Image(
                            image: AssetImage(
                                '${AppConfig.assetsRoot}/map-marker.png'),
                            width: 24,
                            height: 24,
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                      ],
                    )
                  : IconButton(
                      onPressed: () {
                        _controller.petitionAddressController.clear();
                      },
                      icon: Icon(Icons.close)),
            );
          })
        ],
      ),
    );
  }
}
