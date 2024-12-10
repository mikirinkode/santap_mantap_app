import 'package:flutter/material.dart';

class UIUtils {
  UIUtils._();

  static const double borderRadius = 16;

  // space
  static heightSpace(double height) => SizedBox(height: height);

  static widthSpace(double width) => SizedBox(width: width);

  // padding
  static paddingAll(double padding) => EdgeInsets.all(padding);

  static paddingSymmetric(
          {required double vertical, required double horizontal}) =>
      EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal);

  static paddingTop(double padding) => EdgeInsets.only(top: padding);

  static paddingBottom(double padding) => EdgeInsets.only(bottom: padding);

  static paddingLeft(double padding) => EdgeInsets.only(left: padding);

  static paddingRight(double padding) => EdgeInsets.only(right: padding);

  static paddingHorizontal(double padding) =>
      EdgeInsets.symmetric(horizontal: padding);

  static paddingVertical(double padding) =>
      EdgeInsets.symmetric(vertical: padding);

  static paddingFromLTRB(
          {required double left,
          required double top,
          required double right,
          required double bottom}) =>
      EdgeInsets.fromLTRB(left, top, right, bottom);

  // border radius
  static borderRadiusAll({double radius = UIUtils.borderRadius}) =>
      BorderRadius.circular(radius);

  static borderRadiusSmall() => BorderRadius.circular(8);
  static borderRadiusMedium() => BorderRadius.circular(borderRadius);

  static borderRadiusTop({double radius = UIUtils.borderRadius}) =>
      BorderRadius.vertical(top: Radius.circular(radius));

  static borderRadiusBottom({double radius = UIUtils.borderRadius}) =>
      BorderRadius.vertical(bottom: Radius.circular(radius));
}
