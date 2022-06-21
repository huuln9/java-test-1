import 'package:digo_common/digo_common.dart';
import 'package:get/get.dart';
import 'package:vncitizens_administrative_document/src/binding/all_binding.dart';
import 'package:vncitizens_administrative_document/src/config/route_config.dart';
import 'package:vncitizens_administrative_document/src/widget/admin_doc_detail.dart';
import 'package:vncitizens_administrative_document/src/widget/admin_doc_list.dart';
import 'package:vncitizens_administrative_document/src/widget/admin_doc_search.dart';

/// init application routes
initAppRoute() async {
  GetPageCenter.add(GetPage(name: RouteConfig.listRoute, page: () => const AdminDocList(), binding: AllBinding()));
  GetPageCenter.add(GetPage(name: RouteConfig.searchRoute, page: () => const AdminDocSearch(), binding: AllBinding()));
  GetPageCenter.add(GetPage(name: RouteConfig.detailRoute, page: () => const AdminDocDetail(), binding: AllBinding()));
}
