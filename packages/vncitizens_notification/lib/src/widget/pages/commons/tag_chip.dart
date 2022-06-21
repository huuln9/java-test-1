import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_notification/src/model/tag_model.dart';

class TagChip extends StatelessWidget {
  final TagModel tag;

  const TagChip({Key? key, required this.tag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Chip(
        label: Text(tag.name,
            style: GoogleFonts.roboto(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade700)),
        backgroundColor: Colors.grey.shade200,
        shape: StadiumBorder(side: BorderSide(color: Colors.black12)),
      ),
    );
  }
}
