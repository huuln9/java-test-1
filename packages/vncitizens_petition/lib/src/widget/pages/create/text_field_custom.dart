import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';

class TextFieldCustom extends StatelessWidget {
  const TextFieldCustom(
      {Key? key,
      required this.controller,
      required this.hintText,
      this.minLines,
      this.suffixIcon,
      this.textError,
      this.labelText,
      this.onEditingComplete,
      this.textInputAction,
      this.maxLength,
      this.keyboardType})
      : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final int? minLines;
  final Widget? suffixIcon;
  final String? textError;
  final TextInputAction? textInputAction;
  final VoidCallback? onEditingComplete;
  final int? maxLength;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // cursorColor: Theme.of(context).primaryColor,
      controller: controller,
      maxLength: maxLength,
      minLines: minLines,
      maxLines: minLines != null ? 10 : null,
      keyboardType: keyboardType,
      style: GoogleFonts.roboto(
          color: Colors.black87, fontSize: 16, letterSpacing: 0.25),
      decoration: InputDecoration(
          isDense: true,
          labelText: labelText ?? hintText,
          fillColor: Colors.grey.shade100.withOpacity(0.1),
          hintText: hintText,
          alignLabelWithHint: true,
          errorText: textError == null || textError!.isEmpty ? null : textError,
          hintStyle: GoogleFonts.roboto(color: Colors.grey, fontSize: 16),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          suffixIcon: suffixIcon,
          counter: const Offstage(),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              borderSide: BorderSide(color: Colors.black12)),
          focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              borderSide: BorderSide(color: Colors.blue.shade800))),
      textInputAction: textInputAction,
      onEditingComplete: onEditingComplete,
    );
  }
}
