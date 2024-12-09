import 'package:flutter/material.dart';

import '../utils/ui_utils.dart';
import 'app_color.dart';


class AppButtonStyle {
  AppButtonStyle._();

  static ButtonStyle filledPrimary = ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith(
          (states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColor.neutral200;
        }
        return AppColor.primary500;
      },
    ),
    padding: WidgetStateProperty.all(
        UIUtils.paddingSymmetric(vertical: 12, horizontal: 24)),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: UIUtils.borderRadiusAll(),
      ),
    ),
    foregroundColor: WidgetStateProperty.resolveWith(
          (states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColor.neutral500;
        }
        return Colors.white;
      },
    ),
  );
}