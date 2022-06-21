import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_place/src/controller/place_controller.dart';
import 'package:vncitizens_place/src/model/map_maker.dart';
import 'package:vncitizens_place/src/widget/pages/detail/place_detail_view.dart';

class PlaceListViewItem extends StatelessWidget {
  PlaceListViewItem({Key? key, required this.index}) : super(key: key);

  final int index;
  final _ctrl = Get.put(PlaceController());

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      child: Obx(() {
        PlaceSelector selector = _ctrl.places[index];
        Uint8List? iconBytes = _ctrl.iconBytesList[selector.data.id];
        return ListTile(
            leading: _buildAvatar(selector, iconBytes),
            title: Text(selector.data.name,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: false,
                style: ListTitleStyle.title,
                textAlign: TextAlign.justify),
            subtitle: Text(selector.data.name,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                softWrap: false,
                style: ListTitleStyle.subtitle,
                textAlign: TextAlign.justify),
            trailing: selector.data.data != null &&
                    selector.data.data['phone'] != null
                ? IconButton(
                    icon: const Icon(Icons.phone_in_talk),
                    color: Colors.black,
                    onPressed: () {
                      _ctrl.makeCall(selector.data.data['phone']);
                    })
                : null,
            onTap: () {
              _ctrl.id.value = selector.data.id;
              Get.to(const PlaceDetailView());
            });
      }),
    );
  }

  CircleAvatar _buildAvatar(PlaceSelector selector, Uint8List? iconBytes) {
    return CircleAvatar(
      radius: 24,
      backgroundColor:
          CharColorHelper.characterColor[selector.data.name[0].toLowerCase()],
      child: iconBytes != null
          ? ClipRRect(
              child: Image.memory(
                iconBytes,
                height: 55,
                width: 55,
                fit: BoxFit.fill,
              ),
              borderRadius: BorderRadius.circular(36),
            )
          : Text(
              CharColorHelper.get2Wildcards(selector.data.name),
              style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
    );
  }
}
