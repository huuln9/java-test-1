import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_place/src/controller/place_controller.dart';
import 'package:vncitizens_place/src/model/hcm_tag_resource.dart';

class TagCheckBoxListTile extends StatelessWidget {
  const TagCheckBoxListTile({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    final PlaceController _controller = Get.put(PlaceController());
    return Column(
      children: <Widget>[
        Obx(() {
          HCMTagResource selector = _controller.hcmTags[index];
          return CheckboxListTile(
            activeColor: Colors.blue.shade800,
            dense: true,
            title: Text(
              selector.name,
              style: GoogleFonts.roboto(fontSize: 16, color: Colors.black87),
            ),
            value: selector.isSelected,
            onChanged: (bool? value) async {
              await _controller.toggleHCMTag(index);
            },
          );
        })
      ],
    );
  }
}
