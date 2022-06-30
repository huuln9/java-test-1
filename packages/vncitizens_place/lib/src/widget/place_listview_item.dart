import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_place/src/controller/place_controller.dart';
import 'package:vncitizens_place/src/widget/place_detail_view.dart';

import '../model/hcm_place.dart';

class PlaceListViewItem extends StatelessWidget {
  const PlaceListViewItem({Key? key, required this.index}) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    final _ctrl = Get.put(PlaceController());
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Obx(() {
            HCMPlaceResource selector = _ctrl.hcmPlaces[index];
            // Uint8List? iconBytes = _ctrl.iconBytesList[selector.data.id];
            return InkWell(
              child: Container(
                alignment: Alignment.center,
                height: 80,
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: CircleAvatar(
                      radius: 36,
                      backgroundColor: CharColorHelper.characterColor[
                          selector.name != null
                              ? selector.name![selector.name!.length - 1]
                                  .toLowerCase()
                              : 'a'],
                      child:
                          //  iconBytes != null
                          //     ? ClipRRect(
                          //         child: Image.memory(
                          //           iconBytes,
                          //           height: 55,
                          //           width: 55,
                          //           fit: BoxFit.fill,
                          //         ),
                          //         borderRadius: BorderRadius.circular(36),
                          //       )
                          //     :
                          Text(
                        CharColorHelper.get2Wildcards(selector.name ?? 'a'),
                        style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(selector.name ?? '',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: ListTitleStyle.title,
                              textAlign: TextAlign.justify),
                          const SizedBox(
                            height: 2,
                          ),
                          Text(selector.address ?? '',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: ListTitleStyle.subtitle,
                              textAlign: TextAlign.justify),
                        ],
                      ),
                    ),
                  ),
                ])
                //  ListTile(
                //     leading: CircleAvatar(
                //       radius: 36,
                //       backgroundColor: CharColorHelper.characterColor[
                //           selector.name != null
                //               ? selector.name![selector.name!.length - 1]
                //                   .toLowerCase()
                //               : 'a'],
                //       child:
                //           //  iconBytes != null
                //           //     ? ClipRRect(
                //           //         child: Image.memory(
                //           //           iconBytes,
                //           //           height: 55,
                //           //           width: 55,
                //           //           fit: BoxFit.fill,
                //           //         ),
                //           //         borderRadius: BorderRadius.circular(36),
                //           //       )
                //           //     :
                //           Text(
                //         CharColorHelper.get2Wildcards(selector.name ?? 'a'),
                //         style: GoogleFonts.roboto(
                //             color: Colors.white,
                //             fontSize: 24,
                //             fontWeight: FontWeight.w500),
                //       ),
                //     ),
                //     title: Text(selector.name ?? '',
                //         overflow: TextOverflow.ellipsis,
                //         maxLines: 2,
                //         softWrap: false,
                //         style: ListTitleStyle.title,
                //         textAlign: TextAlign.justify),
                //     subtitle: Text(selector.address ?? '',
                //         overflow: TextOverflow.ellipsis,
                //         maxLines: 2,
                //         softWrap: false,
                //         style: ListTitleStyle.subtitle,
                //         textAlign: TextAlign.justify),
                //     // trailing: selector.data.data != null &&
                //     //         selector.data.data['phone'] != null
                //     //     ? IconButton(
                //     //         icon: const Icon(Icons.phone_in_talk),
                //     //         color: Colors.black,
                //     //         onPressed: () {
                //     //           // _ctrl.makeCall(selector.data.data['phone']);
                //     //         })
                //     //     : null,
                //     isThreeLine: true)
                ,
              ),
              onTap: () {
                _ctrl.hcmPlaceSelected = selector;
                Get.to(const PlaceDetailView());
              },
            );
          }),
        ),
      ],
    );
  }
}
