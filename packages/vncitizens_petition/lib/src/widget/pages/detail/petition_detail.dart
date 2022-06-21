import 'package:flutter/material.dart';
import 'package:vncitizens_account/vncitizens_account.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_petition/src/controller/petition_detail_controller.dart';
import 'package:vncitizens_petition/src/controller/petition_personal_list_controller.dart';
import 'package:vncitizens_petition/src/controller/petition_public_list_controller.dart';
import 'package:vncitizens_petition/src/widget/pages/create/petition_create.dart';
import 'package:vncitizens_petition/src/widget/pages/detail/petition_detail_info.dart';
import 'package:vncitizens_petition/src/widget/pages/detail/petition_detail_evaluation.dart';
import 'package:vncitizens_petition/src/widget/pages/detail/petition_detail_result.dart';

class PetitionDetail extends StatefulWidget {
  const PetitionDetail({Key? key, this.id, this.reporterRating})
      : super(key: key);
  final String? id;
  final int? reporterRating;
  @override
  State<PetitionDetail> createState() => _PetitionDetailState();
}

class _PetitionDetailState extends State<PetitionDetail> {
  final InternetController _internetController = Get.put(InternetController());

  final PetitionDetailController _controller =
      Get.put(PetitionDetailController());

  @override
  void initState() {
    super.initState();
    if (widget.reporterRating != null) {
      _controller.reporterRating.value = widget.reporterRating! * 1.0;
    }
    _controller.getDetail(widget.id ?? '62a83686107bfd162c7b7dd6');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('chi tiet phan anh'.tr),
        actions: [
          Obx(
            () {
              return _controller.petitionDetail.value != null &&
                      AuthUtil.userId ==
                          _controller.petitionDetail.value!.reporter!.id &&
                      _controller.petitionDetail.value!.status! == 1
                  ? InkWell(
                      onTap: () {
                        UIHelper.showBottomSheetActions(
                            children: _buildBottomSheetActions());
                      },
                      child: const Icon(Icons.more_vert, color: Colors.white),
                    )
                  : Container();
            },
          )
        ],
      ),
      body: Obx(() {
        if (_internetController.hasConnected.value) {
          return _bodyWidget();
        } else {
          return NoInternet(
            onPressed: () => {},
          );
        }
      }),
    );
  }

  Widget _bodyWidget() {
    return Obx(() {
      if (_controller.isLoading.value) {
        return const DataLoading();
      } else if (_controller.petitionDetail.value != null) {
        return Container(
          color: Colors.white,
          child: ListView(children: [
            PetitionDetailInfo(),
            PetitionDetailResult(),
            PetitionDetailEvaluation(),
          ]),
        );
      } else {
        return DataFailedLoading(
          onPressed: () {
            _controller.getDetail(widget.id ?? '62a83686107bfd162c7b7dd6');
          },
        );
      }
    });
  }

  List<Widget> _buildBottomSheetActions() {
    return [
      SizedBox(
        height: 40,
        child: ListTile(
          leading: const Icon(Icons.edit),
          title: Text('cap nhat'.tr),
          onTap: () async {
            Get.back();
            var result = await Get.to(PetitionCreate(
              petition: _controller.petitionDetail.value,
            ));
            if (result is bool) {
              _controller.getDetail(widget.id!);
              final _controllerDefault =
                  Get.put(PetitionPublicListController());
              final _controllerPersonal =
                  Get.put(PetitionPersonalListController());
              _controllerDefault.refreshPetitions();
              _controllerPersonal.refreshPetitions();
            }
            // controller.changeSelectedMode();
            // Get.back();
          },
        ),
      ),
      SizedBox(
        height: 40,
        child: ListTile(
          leading: const Icon(Icons.delete_outlined),
          title: Text('xoa'.tr),
          onTap: () {
            Get.back();
            UIHelper.showNotificationDialog(
                title: Text('xac nhan'.tr),
                content: Text('xoa phan anh da gui'.tr),
                onPressed: () {
                  Get.back();
                  _controller.onDeletePetition(widget.id ?? '');
                });
          },
        ),
      ),
    ];
  }
}
