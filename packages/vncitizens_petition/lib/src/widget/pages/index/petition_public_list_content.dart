import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_petition/src/controller/petition_public_list_controller.dart';
import 'package:vncitizens_petition/src/widget/pages/index/petition_public_list_item.dart';

class PetitionPublicListContent extends StatelessWidget {
  PetitionPublicListContent({Key? key}) : super(key: key);

  final _controller = Get.put(PetitionPublicListController());
  final _internetController = Get.put(InternetController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: Obx(() {
          if (_internetController.hasConnected.value) {
            if (_controller.isLoading.value) {
              return DataLoading(message: "dang tai danh sach phan anh".tr);
            } else {
              if (_controller.isFailedLoading.value) {
                return DataFailedLoading(
                  onPressed: () {
                    _controller.onInit();
                  },
                );
              } else {
                if (_controller.petitions.isNotEmpty) {
                  return RefreshIndicator(
                      onRefresh: () => _controller.refreshPetitions(),
                      child: ListView.separated(
                        controller: _controller.scrollController,
                        itemBuilder: (context, index) {
                          if (index == _controller.petitions.length - 1 &&
                              _controller.isMoreAvailablePlace.value == true) {
                            return const Padding(
                              padding: EdgeInsets.all(20),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          } else {
                            return PetitionPublicListItem(index: index);
                          }
                        },
                        itemCount: _controller.petitions.length,
                        separatorBuilder: (context, index) {
                          return Container(
                            height: 1,
                            decoration:
                                const BoxDecoration(color: Colors.white),
                            child: const Divider(
                              thickness: 1,
                              indent: 10,
                              endIndent: 10,
                              color: Colors.black12,
                              height: 20,
                            ),
                          );
                        },
                      ));
                } else {
                  return const EmptyData();
                }
              }
            }
          } else {
            return NoInternet(
              onPressed: () {
                _controller.onInit();
              },
            );
          }
        })),
      ],
    );
  }
}
