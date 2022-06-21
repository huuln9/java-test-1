import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_petition/src/config/app_config.dart';
import 'package:vncitizens_petition/src/controller/petition_detail_controller.dart';

class PetitionDetailEvaluation extends StatelessWidget {
  PetitionDetailEvaluation({Key? key}) : super(key: key);
  final PetitionDetailController _controller =
      Get.put(PetitionDetailController());
  @override
  Widget build(BuildContext context) {
    return _controller.petitionDetail.value!.status == 3
        ? Column(
            children: [
              Container(
                color: AppConfig.backgroundColor,
                height: 10,
              ),
              Container(
                color: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'danh gia ket qua xu ly phan anh'.tr.toUpperCase(),
                          style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RatingBar(
                          initialRating: _controller.convertNumRating(
                              _controller.petitionDetail.value!.rating),
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          ignoreGestures: true,
                          itemCount: 3,
                          ratingWidget: RatingWidget(
                            full: SvgPicture.asset(
                              AppConfig.assetsRoot + "/star.svg",
                            ),
                            half: SvgPicture.asset(
                              AppConfig.assetsRoot + "/star_half.svg",
                            ),
                            empty: SvgPicture.asset(
                              AppConfig.assetsRoot + "/star_outline.svg",
                            ),
                          ),
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        ),
                        Text(
                          _controller.petitionDetail.value!.rating.toString(),
                          style: GoogleFonts.roboto(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            _controller.petitionDetail.value!.countRate
                                    .toString() +
                                ' ' +
                                'luot danh gia'.tr,
                            style: GoogleFonts.roboto(
                                fontSize: 14,
                                color: ColorUtils.fromString('#ABABAB')),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Divider(),
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              'muc do hai long cua ban ve ket qua xu ly tren'
                                  .tr,
                              style: GoogleFonts.roboto(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Obx(() {
                      return RatingBar(
                        initialRating: _controller.reporterRating.value,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 3,
                        itemSize: 50,
                        ratingWidget: RatingWidget(
                          full: SvgPicture.asset(
                            AppConfig.assetsRoot + "/star.svg",
                          ),
                          half: SvgPicture.asset(
                            AppConfig.assetsRoot + "/star_half.svg",
                          ),
                          empty: SvgPicture.asset(
                            AppConfig.assetsRoot + "/star_outline.svg",
                            color: Colors.grey,
                          ),
                        ),
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 4.0),
                        onRatingUpdate: (rating) {
                          print(rating);
                          _controller.updateEvalution(rating.round());
                        },
                      );
                    }),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ],
          )
        : Container();
  }
}
