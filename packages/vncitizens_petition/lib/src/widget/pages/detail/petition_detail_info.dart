import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_petition/src/config/app_config.dart';
import 'package:vncitizens_petition/src/controller/petition_detail_controller.dart';
import 'package:vncitizens_petition/src/util/date_util.dart';
import 'package:vncitizens_petition/src/widget/pages/detail/petition_detail_file.dart';

class PetitionDetailInfo extends StatelessWidget {
  PetitionDetailInfo({Key? key}) : super(key: key);

  final PetitionDetailController _controller =
      Get.put(PetitionDetailController());
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _controller.petitionDetail.value!.title!,
            style:
                GoogleFonts.roboto(fontWeight: FontWeight.w500, fontSize: 20),
          ),
          const SizedBox(
            height: 14,
          ),
          RichText(
              text: TextSpan(
                  style: const TextStyle(color: Colors.grey),
                  children: [
                TextSpan(
                    text: 'vao luc'.tr +
                        ' ' +
                        DateTimeUtils.formatDateTimeV2(
                            _controller.petitionDetail.value!.createdDate),
                    style: GoogleFonts.roboto(color: Colors.grey)),
                TextSpan(
                    text:
                        _controller.petitionDetail.value!.isAnonymous == "false"
                            ? (' ' +
                                'boi'.tr +
                                ' ' +
                                _controller
                                    .petitionDetail.value!.reporter!.fullname!)
                            : '',
                    style: GoogleFonts.roboto(color: Colors.grey)),
                TextSpan(
                    text: ' ' +
                        'tai'.tr +
                        ' ' +
                        _controller
                            .petitionDetail.value!.takePlaceAt!.fullAddress!,
                    style: GoogleFonts.roboto(color: Colors.grey))
              ])),
          const SizedBox(
            height: 14,
          ),
          Text(
            _controller.petitionDetail.value!.description!,
            textAlign: TextAlign.justify,
            style: GoogleFonts.roboto(
                fontSize: 16, color: ColorUtils.fromString('#555555')),
          ),
          _controller.petitionDetail.value!.file != null &&
                  _controller.petitionDetail.value!.file!
                      .where((element) => element.group!.contains(1))
                      .isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: PetitionDetailFile(
                    files: _controller.petitionDetail.value!.file!
                        .where((element) => element.group!.contains(1))
                        .toList(),
                  ),
                )
              : Container(),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: Get.width * 0.6),
                child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20),
                      ),
                      border: Border.all(
                        color: AppConfig.textGreyColor,
                      ),
                    ),
                    child: Text(
                      _controller.petitionDetail.value!.tag!.name!,
                      style: GoogleFonts.roboto(color: AppConfig.textGreyColor),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  _controller.petitionDetail.value!.statusDescription!,
                  style: GoogleFonts.roboto(color: AppConfig.textGreyColor),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
