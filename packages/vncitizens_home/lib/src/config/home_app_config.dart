import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:vncitizens_home/src/model/group_menu_model.dart';
import 'package:vncitizens_home/src/model/menu_model.dart';
import 'dart:developer' as dev;

class HomeAppConfig {
  // ------------------------------------
  // REQUIRED UPDATE
  // ------------------------------------

  /// your package name
  static const String packageName = "vncitizens_home";

  /// storage box name
  static const String storageBox = packageName;

  /// the assets root folder
  static const String assetsRoot = "packages/$packageName/assets";

  // ------------------------------------
  // PACKAGE PRIVACY
  // ------------------------------------

  static const accountPackageName = "vncitizens_account";

  /// app storage key name
  static const String appStorageKey = "app";

  /// menu storage key name
  static const String menuStorageKey = "menu";

  /// banner storage key name
  static const String bannerStorageKey = "banner";

  /// isGroupMenu storage key name
  static const String isGroupMenuStorageKey = "is_group_menu";

  /// material design blue color
  static const Color materialMainBlueColor = Color.fromRGBO(21, 101, 192, 1);

  /// default menu data for display in case they do not config from backend
  static List<GroupMenuModel> defaultMenuData = [];

  static List<GroupMenuModel> get menuData {
    var menuData = GetStorage(storageBox).read(menuStorageKey);
    bool isGroupMenu = GetStorage(storageBox).read(isGroupMenuStorageKey);
    if (menuData is List) {
      dev.log('read menu data from GetStorage', name: packageName);
      List<GroupMenuModel> listMenu = <GroupMenuModel>[];
      if (isGroupMenu) {
        for (var group in menuData) {
          listMenu.add(GroupMenuModel.fromMap(group));
        }
        return listMenu;
      } else {
        List<MenuModel> menuModels = <MenuModel>[];
        for (var group in menuData) {
          menuModels.addAll(MenuModel.fromArray(group["menu"]));
        }
        listMenu.add(GroupMenuModel(groupName: "", menu: menuModels));
        return listMenu;
      }
    }
    dev.log('menu data from GetStorage is null, return default menu data', name: packageName);
    return defaultMenuData;
  }

  // ============ Routes ===============
  static const String homeRoute = "/vncitizens_home";
}
