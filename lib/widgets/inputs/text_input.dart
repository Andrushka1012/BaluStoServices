import 'package:balu_sto/helpers/styles/colors.dart';
import 'package:balu_sto/helpers/styles/dimens.dart';
import 'package:balu_sto/helpers/styles/text_styles.dart';
import 'package:flutter/material.dart';

import 'input_decoration.dart';

class TextInput extends StatelessWidget {
  TextInput({
    this.controller,
    this.label,
    this.hint,
    this.keyboardType,
    this.onChanged,
    this.textInputAction,
    this.obscureText = false,
  });

  final String? label;
  final TextEditingController? controller;
  final String? hint;
  final TextInputType? keyboardType;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null)
            Text(
              label!,
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: Dimens.spanTiny,
              horizontal: Dimens.spanMicro,
            ),
            child: TextField(
              controller: controller,
              textInputAction: textInputAction,
              keyboardType: keyboardType,
              obscureText: obscureText,
              decoration: getDecoration().copyWith(
                hintText: hint,
              ),
              enableSuggestions: false,
              autocorrect: false,
              onChanged: onChanged,
            ),
          ),
        ],
      );
}
