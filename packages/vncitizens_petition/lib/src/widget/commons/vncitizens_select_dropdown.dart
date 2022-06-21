import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_petition/src/model/tag_page_content_model.dart';

class VnCitizensSelectDropDown extends StatelessWidget {
  const VnCitizensSelectDropDown(
      {Key? key,
      required this.label,
      this.items,
      this.initValue,
      this.placeHolder,
      this.onChanged})
      : super(key: key);

  final String label;
  final List<TagPageContentModel>? items;
  final TagPageContentModel? initValue;
  final String? placeHolder;
  final ValueChanged<TagPageContentModel?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<TagPageContentModel>(
      mode: Mode.BOTTOM_SHEET,
      items: items,
      compareFn: (i, s) => i?.isEqual(s) ?? false,
      dropdownSearchDecoration: InputDecoration(
        labelText: label,
        contentPadding: const EdgeInsets.fromLTRB(12, 12, 0, 0),
        border: const OutlineInputBorder(),
      ),
      onChanged: onChanged,
      selectedItem: initValue,
      showSelectedItems: true,
      popupTitle: Container(
        height: 60,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Stack(children: [
          Container(
              alignment: FractionalOffset.centerLeft,
              child: InkWell(
                child: const Padding(
                  padding: EdgeInsets.only(top: 16, left: 18),
                  child: Icon(
                    Icons.chevron_left,
                    size: 28,
                  ),
                ),
                onTap: () {
                  Get.back();
                },
              )),
          Container(
              alignment: FractionalOffset.center,
              height: 40,
              margin: const EdgeInsets.only(top: 16),
              child: Text(
                label,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              )),
        ]),
      ),
      popupShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      dropdownBuilder: _buildDropDownValue,
      popupItemBuilder: _buildRadioSelectorItems,
      emptyBuilder: (BuildContext build, String? err) {
        return Center(
          child: Text(
            'du lieu khong tim thay'.tr,
            style: const TextStyle(fontSize: 16),
          ),
        );
      },
    );
  }

  Widget _buildDropDownValue(BuildContext context, TagPageContentModel? item) {
    if (item == null) {
      if (placeHolder == null) {
        return Container();
      } else {
        return Text(
          placeHolder!,
          style: const TextStyle(color: Colors.black38),
        );
      }
    }
    return Text(item.name);
  }

  Widget _buildRadioSelectorItems(
      BuildContext context, TagPageContentModel? item, bool isSelected) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: <Widget>[
          Transform.scale(
            scale: 1.3,
            child: Radio<bool>(
                groupValue: true,
                value: isSelected,
                activeColor: Colors.blue.shade800,
                splashRadius: 100,
                onChanged: (bool? newValue) {}),
          ),
          RichText(
            text: TextSpan(
              text: item?.name,
              style: const TextStyle(color: Colors.black87, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
