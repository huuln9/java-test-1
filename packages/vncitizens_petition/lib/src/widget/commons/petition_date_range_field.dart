import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_petition/src/controller/petition_filter_list_controller.dart';

/// A [PetitionFilterDateRangeField] which extends a [FormField].
///
/// The use of a [Form] ancestor is not required, however it makes it easier to
/// save, reset, and validate multiple fields at the same time. In order to use
/// this without a [Form] ancestor, pass a [GlobalKey] to the constructor and use
/// [GlobalKey.currentState] the same way as you would for a form.
///
/// To style this widget, pass an [InputDecoration] to the constructor. If not,
/// the [PetitionFilterDateRangeField] will use the default from the [Theme].
///
/// This widget must have a [Material] ancestor, such as a [MaterialApp] or [Form].
class PetitionFilterDateRangeField extends FormField<DateTimeRange> {
  /// Creates a [PetitionFilterDateRangeField] which extends a [FormField].
  ///
  /// When using without a [Form] ancestor a [GlobalKey] is required.

  PetitionFilterDateRangeField(
      {Key? key,
      this.firstDate,
      this.lastDate,
      this.currentDate,
      this.initialEntryMode,
      this.helpText,
      this.cancelText,
      this.enabled = true,
      this.confirmText,
      this.saveText,
      this.errorFormatText,
      this.errorInvalidText,
      this.errorInvalidRangeText,
      this.fieldStartHintText,
      this.fieldEndHintText,
      this.fieldStartLabelText,
      this.fieldEndLabelText,
      this.width,
      this.margin,
      ValueChanged<DateTimeRange?>? onChanged,
      FormFieldSetter<DateTimeRange>? onSaved,
      FormFieldValidator<DateTimeRange>? validator,
      this.initialValue,
      bool autoValidate = false,
      this.dateFormat,
      InputDecoration decoration = const InputDecoration()})
      : super(
            key: key,
            validator: validator,
            onSaved: onSaved,
            enabled: enabled,
            initialValue: initialValue,
            builder: (FormFieldState<DateTimeRange> state) {
              final _controller = Get.put(PetitionFilterListController());
              final DateFormat format =
                  (dateFormat ?? DateFormat('dd/MM/yyyy'));
              final InputDecoration inputDecoration = decoration
                  .copyWith(enabled: enabled)
                  .applyDefaults(Theme.of(state.context).inputDecorationTheme);

              /// This is the dialog to select the date range.
              Future<void> selectDateRange() async {
                DateTimeRange? picked = await showDateRangePicker(
                        context: state.context,
                        initialDateRange: initialValue,
                        firstDate: firstDate ?? DateTime.now(),
                        lastDate: lastDate ?? DateTime(DateTime.now().year + 5),
                        helpText: helpText ?? 'chon khoang thoi gian'.tr,
                        cancelText: cancelText ?? 'huy'.tr.toUpperCase(),
                        confirmText: confirmText ?? 'dong y'.tr.toUpperCase(),
                        saveText: saveText ?? 'luu'.tr.toUpperCase(),
                        errorFormatText:
                            errorFormatText ?? 'dinh dang khong hop le'.tr,
                        errorInvalidText:
                            errorInvalidText ?? 'ngoai pham vi'.tr,
                        errorInvalidRangeText:
                            errorInvalidRangeText ?? 'pham vi khong hop le'.tr,
                        fieldStartHintText: fieldStartHintText ?? 'tu ngay'.tr,
                        fieldEndHintText: fieldEndHintText ?? 'den ngay'.tr,
                        fieldStartLabelText:
                            fieldStartLabelText ?? 'tu ngay'.tr,
                        fieldEndLabelText: fieldEndLabelText ?? 'den ngay'.tr,
                        locale: const Locale('vi')) ??
                    state.value;
                if (picked != state.value) {
                  state.didChange(picked);
                  onChanged?.call(picked);
                  _controller.restorationId.value = 'VN_CITIZENS_DEFAULT';
                } else {
                  if (_controller.restorationId.value == 'VN_CITIZENS_RESET') {
                    _controller.restorationId.value = 'VN_CITIZENS_DEFAULT';
                  }
                }
              }

              String hintText = decoration.hintText ?? '';
              return InkWell(
                /// This calls the dialog to select the date range.
                onTap: enabled ? selectDateRange : null,
                child: Container(
                  margin: margin ?? const EdgeInsets.all(15.0),
                  width: width ?? MediaQuery.of(state.context).size.width,
                  child: InputDecorator(
                    decoration:
                        inputDecoration.copyWith(errorText: state.errorText),
                    child: Obx(() {
                      if (_controller.restorationId.value ==
                          'VN_CITIZENS_RESET') {
                        return Text(
                            // This will display hintText if provided and if state.value is null
                            hintText,
                            style: (state.value == null &&
                                    hintText != '' &&
                                    decoration.hintStyle != null)
                                ? decoration.hintStyle
                                : TextStyle(
                                    color: enabled
                                        ? null
                                        : Theme.of(state.context)
                                            .disabledColor));
                      } else {
                        return Text(
                            // This will display hintText if provided and if state.value is null
                            state.value == null
                                ? hintText
                                :

                                /// This displays the selected date range when the dialog is closed.
                                '${format.format(state.value!.start)} - ${format.format(state.value!.end)}',
                            style: (state.value == null &&
                                    hintText != '' &&
                                    decoration.hintStyle != null)
                                ? decoration.hintStyle
                                : TextStyle(
                                    color: enabled
                                        ? null
                                        : Theme.of(state.context)
                                            .disabledColor));
                      }
                    }),
                  ),
                ),
              );
            });

  /// This is the earliest date a user can select.
  ///
  /// If null, this will default to DateTime.now().
  final DateTime? firstDate;

  /// This is the latest date a user can select.
  ///
  /// If null, this will default to 5 years from now.
  final DateTime? lastDate;

  /// currentDate represents the the current day (today).
  ///
  /// If null, this default to DateTime.now().
  final DateTime? currentDate;

  /// This argument determines which mode the showDateRangePicker will initially display in.
  ///
  /// It defaults to a scrollable calendar month grid ([DatePickerEntryMode.calendar]).
  /// It can also be set to display two text input fields ([DatePickerEntryMode.input]).
  final DatePickerEntryMode? initialEntryMode;

  /// This is the label displayed at the top of the [showDateRangePicker] dialog.
  ///
  /// If null, this defaults to 'Select Date Range'.
  final String? helpText;

  /// This is the label on the cancel button for the text input mode.
  ///
  /// If null, this defaults to 'CANCEL'.
  final String? cancelText;

  /// Whether input should be enabled.
  ///
  /// If null, this defaults to true.
  final bool enabled;

  /// This is the label on the ok button for the text input mode.
  ///
  /// If null, this defaults to 'OK'.
  final String? confirmText;

  /// This is the label on the save button for the calendar view.
  ///
  /// If null, this defaults to 'SAVE'.
  final String? saveText;

  /// This is the error message displayed when the input text is not a proper date format.
  ///
  /// For example, if the date format was 'MM-dd-yyyy', and the user enters 'Monday' this message will be displayed.
  /// If null, this defaults to 'Invalid format.'.
  final String? errorFormatText;

  /// This is the error message displayed when an input is not a selectable date.
  ///
  /// For example, if firstDate was set to 09-01-2020, and the user enters '09-01-2019' this message will be displayed.
  /// If null, this defaults to 'Out of range.'.
  final String? errorInvalidText;

  /// This is the error message displayed when an input is not a valid date range.
  ///
  /// For example, if the user selects a startDate after the endDate this message will be displayed.
  /// If null, this defaults to 'Invalid range.'.
  final String? errorInvalidRangeText;

  /// This is the text used to prompt the user when no text has been entered in the start field.
  ///
  /// If null, this defaults to 'Start Date'.
  final String? fieldStartHintText;

  /// This is the text used to prompt the user when no text has been entered in the end field.
  ///
  /// If null, this defaults to 'End Date'.
  final String? fieldEndHintText;

  /// This is the label for the start date input text field.
  ///
  /// If null, this defaults to 'Start Date'.
  final String? fieldStartLabelText;

  /// This is the label for the end date input text field.
  ///
  /// If null, this default to 'End Date'.
  final String? fieldEndLabelText;

  /// This is the width of the widget.
  ///
  /// If null, this defaults to the width of the screen.
  final double? width;

  /// This is the margins of the widget.
  ///
  /// If null, this defaults to EdgeInsets.all(15.0).
  final EdgeInsets? margin;

  /// This required field is the initial DateTimeRange value of the widget.
  ///
  /// This value will be displayed upon first opening the dialog, and if the user does not choose another value it will be saved when the onSaved method is called.
  final DateTimeRange? initialValue;

  /// This is the format the widget will use for dates.
  ///
  /// Any valid format from the intl package is usable.
  /// If null, this will default to 'MM/dd/yyyy'.
  final DateFormat? dateFormat;

  @override
  _MyDateRangeFieldState createState() => _MyDateRangeFieldState();
}

class _MyDateRangeFieldState extends FormFieldState<DateTimeRange> {
  @override
  FormField<DateTimeRange> get widget => super.widget;

  @override
  void dispose() {
    super.dispose();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }
}
