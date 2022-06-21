import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_petition/src/model/petition_detail_model.dart';
import 'package:vncitizens_petition/src/model/tag_page_content_model.dart';

class DropdownButtonCustom<T> extends StatelessWidget {
  final String lable;
  final T? value;
  final List<T> data;
  final Function(T) onChanged;

  const DropdownButtonCustom(
      {Key? key,
      required this.lable,
      this.value,
      required this.data,
      required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      isExpanded: true,
      style: GoogleFonts.roboto(
          color: Colors.black87, fontSize: 16, letterSpacing: 0.25),
      decoration: InputDecoration(
          labelText: lable,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              borderSide: BorderSide(color: Colors.black12)),
          focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              borderSide: BorderSide(color: Colors.blue.shade800))),
      onChanged: (newValue) {
        if (newValue != null) {
          onChanged(newValue);
        }
      },
      items: data.map<DropdownMenuItem<T>>((value) {
        if (value is PlaceModel) {
          return DropdownMenuItem<T>(
            value: value,
            child: Text(value.name!),
          );
        }
        if (value is TagPageContentModel) {
          return DropdownMenuItem<T>(
            value: value,
            child: Text(value.name),
          );
        }
        return DropdownMenuItem<T>(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
    );
  }
}
