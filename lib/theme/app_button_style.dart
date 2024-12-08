import 'package:flutter/material.dart';

import '../utils/ui_utils.dart';
import 'app_color.dart';


class AppButtonStyle {
  AppButtonStyle._();

  static ButtonStyle filledPrimary = ButtonStyle(
    backgroundColor: MaterialStateProperty.resolveWith(
          (states) {
        if (states.contains(MaterialState.disabled)) {
          return AppColor.neutral200;
        }
        return AppColor.primary500;
      },
    ),
    padding: MaterialStateProperty.all(
        UIUtils.paddingSymmetric(vertical: 12, horizontal: 24)),
    shape: MaterialStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: UIUtils.borderRadiusAll(),
      ),
    ),
    foregroundColor: MaterialStateProperty.resolveWith(
          (states) {
        if (states.contains(MaterialState.disabled)) {
          return AppColor.neutral500;
        }
        return Colors.white;
      },
    ),
  );
}