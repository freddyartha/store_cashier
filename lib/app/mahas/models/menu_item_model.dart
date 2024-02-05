import 'package:flutter/material.dart';

class MenuItemModel {
  final String? title;
  final IconData? icon;
  final String? assetImage;
  final GestureTapCallback? onTab;

  MenuItemModel({
    @required this.title,
    this.icon,
    this.assetImage,
    this.onTab,
  });
}
