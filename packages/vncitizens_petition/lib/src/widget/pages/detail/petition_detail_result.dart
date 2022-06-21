import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_petition/src/config/app_config.dart';
import 'package:vncitizens_petition/src/controller/petition_detail_controller.dart';
import 'package:vncitizens_petition/src/util/date_util.dart';
import 'package:vncitizens_petition/src/widget/pages/detail/petition_detail_file.dart';

import '../../../model/petition_detail_model.dart';

class PetitionDetailResult extends StatelessWidget {
  PetitionDetailResult({
    Key? key,
  }) : super(key: key);

  final PetitionDetailController _controller =
      Get.put(PetitionDetailController());
  @override
  Widget build(BuildContext context) {
    return _controller.petitionDetail.value!.resultArray != null
        ? Column(
            children: [
              Container(
                color: AppConfig.backgroundColor,
                height: 10,
              ),
              Container(
                color: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'ket qua xu ly phan anh'.tr.toUpperCase(),
                      style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Container(
                color: AppConfig.backgroundColor,
                height: 2,
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                  decoration: BoxDecoration(
                      color: ColorUtils.fromString('#F7F8F9'),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  child: Column(
                    children: [
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _controller
                            .petitionDetail.value!.resultArray!.length,
                        itemBuilder: ((context, index) {
                          return _itemWidget(
                            _controller
                                .petitionDetail.value!.resultArray![index],
                          );
                        }),
                        separatorBuilder: (BuildContext context, int index) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 90),
                            child: Divider(
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                      _controller.petitionDetail.value!.file != null &&
                              _controller.petitionDetail.value!.file!
                                  .where(
                                      (element) => !element.group!.contains(1))
                                  .isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, bottom: 16),
                              child: PetitionDetailFile(
                                files: _controller.petitionDetail.value!.file!
                                    .where((element) =>
                                        !element.group!.contains(1))
                                    .toList(),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ],
          )
        : Container();
  }

  Widget _itemWidget(ResultModel result) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            result.agency != null ? result.agency!.name! : '',
            style:
                GoogleFonts.roboto(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'ngay'.tr + ' ' + DateTimeUtils.formatDate(result.date),
            style: GoogleFonts.roboto(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            result.content ?? '',
            style: GoogleFonts.roboto(
                fontSize: 16, color: ColorUtils.fromString('#555555')),
          ),
        ],
      ),
    );
  }
}
