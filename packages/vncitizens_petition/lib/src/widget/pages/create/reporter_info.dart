import 'package:flutter/material.dart';
import 'package:vncitizens_account/vncitizens_account.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_petition/src/config/app_config.dart';
import 'package:vncitizens_petition/src/controller/create_controller.dart';
import 'package:vncitizens_petition/src/widget/pages/create/reporter_address.dart';

import 'text_field_custom.dart';

class ReporterInfo extends StatelessWidget {
  ReporterInfo({Key? key}) : super(key: key);
  final PetitionCreateController _controller =
      Get.put(PetitionCreateController());
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'thong tin nguoi gui'.tr.toUpperCase(),
            style: GoogleFonts.roboto(
                color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 24,
          ),
          TextFieldCustom(
            controller: _controller.fullNameController,
            hintText: 'ho ten'.tr + ' *',
            maxLength: 64,
          ),
          const SizedBox(
            height: 24,
          ),
          Obx(() {
            return TextFieldCustom(
                controller: _controller.phoneController,
                hintText: 'so dien thoai'.tr + ' *',
                textError: _controller.phoneError.value,
                keyboardType: TextInputType.phone);
          }),
          const SizedBox(
            height: 24,
          ),
          Obx(() {
            return TextFieldCustom(
                controller: _controller.emailController,
                hintText: 'Email',
                maxLength: 128,
                textError: _controller.emailError.value,
                keyboardType: TextInputType.emailAddress);
          }),
          const SizedBox(
            height: 24,
          ),
          !AuthUtil.isLoggedIn
              ? Row(
                  children: [
                    Expanded(
                      child: Text(
                        'cung cap them dia chi'.tr.toUpperCase(),
                        style: GoogleFonts.roboto(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Obx(() {
                      return Switch(
                        onChanged: (data) {
                          _controller.expandedReporterAddress(data);
                        },
                        value: _controller.expandedReporterAddress.value,
                        activeColor: AppConfig.materialMainBlueColor,
                        activeTrackColor:
                            ColorUtils.fromString('#BB86FC').withOpacity(0.20),
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: Colors.black.withOpacity(0.08),
                      );
                    }),
                  ],
                )
              : Container(),
          !AuthUtil.isLoggedIn
              ? Obx(() {
                  return ExpandableNotifier(
                    controller: ExpandableController(
                        initialExpanded:
                            _controller.expandedReporterAddress.value),
                    child: Expandable(
                      collapsed: ExpandableButton(
                        child: Container(),
                      ),
                      expanded: ReporterAddress(),
                    ),
                  );
                  // if (_controller.expandedSenderAddress.value) {
                  //   return SenderAddress();
                  // } else {
                  //   return Container();
                  // }
                })
              : Container()
        ],
      ),
    );
  }
}
