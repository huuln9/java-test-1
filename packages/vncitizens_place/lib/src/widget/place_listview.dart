import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_common_hcm/vncitizens_common_hcm.dart';
import 'package:vncitizens_place/src/controller/place_controller.dart';
import 'package:vncitizens_place/src/widget/place_listview_item.dart';

class PlaceListView extends StatelessWidget {
  const PlaceListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PlaceController _controller = Get.put(PlaceController());
    return Column(
      children: [
        Expanded(child: Obx(() {
          if (_controller.isPlaceLoading.value && _controller.isSearch.value) {
            return const Center(
              child: AppLinearProgress(),
            );
          } else if (_controller.hcmPlaces.isNotEmpty) {
            return _controller.isSearch.value
                ? ListView.separated(
                    padding: const EdgeInsets.only(bottom: 70),
                    controller: _controller.placeScrollController,
                    itemBuilder: (context, index) {
                      if (index == _controller.hcmPlaces.length - 1 &&
                          _controller.isMoreAvailablePlace.value == true) {
                        return const Padding(
                          padding: EdgeInsets.all(20),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else {
                        return PlaceListViewItem(index: index);
                      }
                    },
                    itemCount: _controller.hcmPlaces.length,
                    separatorBuilder: (context, index) {
                      return Container(
                        height: 0.5,
                        decoration: const BoxDecoration(color: Colors.white),
                        child: const Divider(
                          thickness: 0.5,
                          color: Colors.black12,
                          height: 0.5,
                        ),
                      );
                    },
                  )
                : RefreshIndicator(
                    onRefresh: () async => await _controller.refreshPlaces(),
                    child: ListView.separated(
                      padding: const EdgeInsets.only(bottom: 70),
                      controller: _controller.placeScrollController,
                      itemBuilder: (context, index) {
                        if (index == _controller.hcmPlaces.length - 1 &&
                            _controller.isMoreAvailablePlace.value == true) {
                          return const Padding(
                            padding: EdgeInsets.all(20),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        } else {
                          return PlaceListViewItem(index: index);
                        }
                      },
                      itemCount: _controller.hcmPlaces.length,
                      separatorBuilder: (context, index) {
                        return Container(
                          height: 0.5,
                          decoration: const BoxDecoration(color: Colors.white),
                          child: const Divider(
                            thickness: 0.5,
                            color: Colors.black12,
                            height: 0.5,
                          ),
                        );
                      },
                    ),
                  );
          } else {
            if (_controller.isPlaceLoading.value) {
              return Container();
            } else if (_controller.searchController.text.isNotEmpty) {
              return NoData(message: "khong tim thay dia diem".tr);
            } else {
              return EmptyAndReloadDataWidget(
                message: 'khong tai duoc du lieu'.tr,
                onCallBack: () async {
                  await _controller.refreshPlaces();
                },
              );
            }
          }
        })),
      ],
    );
  }
}
