import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_petition/src/widget/commons/petition_date_range_field.dart';

class VnCitizensDateRangeField extends StatelessWidget {
  const VnCitizensDateRangeField({
    Key? key,
    this.labelText,
    this.hintText,
    this.onChanged,
    this.initialValue,
    this.restorationId,
  }) : super(key: key);

  final String? labelText;
  final String? hintText;
  final DateTimeRange? initialValue;
  final String? restorationId;
  final FormFieldSetter<DateTimeRange>? onChanged;

  @override
  Widget build(BuildContext context) {
    return PetitionFilterDateRangeField(
        enabled: true,
        margin: const EdgeInsets.all(0),
        decoration: InputDecoration(
          labelText: labelText ?? 'thoi gian'.tr,
          suffixIcon: const Icon(Icons.date_range),
          hintText: hintText ?? 'dd/mm/yyyy - dd/mm/yyyy',
          contentPadding: const EdgeInsets.fromLTRB(12, 12, 0, 0),
          border: const OutlineInputBorder(),
        ),
        initialValue: initialValue,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime.now(),
        dateFormat: DateFormat("dd/MM/yyyy"),
        onChanged: onChanged);
  }
}
