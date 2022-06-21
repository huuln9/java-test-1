import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_place/src/controller/place_controller.dart';
import 'package:vncitizens_place/src/widget/pages/index/place_listview_item.dart';

class PlaceListView extends StatelessWidget {
  const PlaceListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PlaceController _controller = Get.put(PlaceController());
    return Column(
      children: [
        Expanded(child: Obx(() {
          if (_controller.places.isNotEmpty) {
            return RefreshIndicator(
              onRefresh: () => _controller.refreshPlaces(),
              child: ListView.separated(
                // TODO: create new controller
                controller: _controller.placeScrollController,
                itemBuilder: (context, index) {
                  if (index == _controller.places.length - 1 &&
                      _controller.isMoreAvailablePlace.value == true) {
                    return const Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else {
                    return PlaceListViewItem(index: index);
                  }
                },
                itemCount: _controller.places.length,
                separatorBuilder: (context, index) {
                  return Container(
                    height: 1,
                    decoration: const BoxDecoration(color: Colors.white),
                    child: const Divider(
                      thickness: 1,
                      color: Colors.black12,
                      height: 20,
                    ),
                  );
                },
              ),
            );
          } else {
            return DataNotFound(message: "khong tim thay dia diem".tr);
          }
        })),
      ],
    );
  }
}
