import 'package:vncitizens_home/src/model/menu_model.dart';

class GroupMenuModel {
  String groupName;
  List<MenuModel> menu;

  GroupMenuModel({
    required this.groupName,
    required this.menu,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': groupName,
      'menu': menu,
    };
  }

  factory GroupMenuModel.fromMap(Map<String, dynamic> map) {
    return GroupMenuModel(
      groupName: map['groupName'] as String,
      menu: MenuModel.fromArray(map['menu']),
    );
  }

  @override
  String toString() {
    return 'GroupMenuModel{groupName: $groupName, menu: $menu}';
  }
}