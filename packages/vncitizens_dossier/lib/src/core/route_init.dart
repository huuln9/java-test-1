import 'dart:developer' as dev;

import 'package:digo_common/digo_common.dart';
import 'package:get/get.dart';
import 'package:vncitizens_dossier/src/binding/dossier_binding.dart';
import 'package:vncitizens_dossier/src/widget/dossier.dart';
import 'package:vncitizens_dossier/src/widget/dossier_detail.dart';

import '../config/app_config.dart';

/// init application routes
initAppRoute() async {
  dev.log('initialize route', name: AppConfig.packageName);
  GetPageCenter.add(
    GetPage(
      name: '/vncitizens_dossier',
      page: () => const Dossier(),
      binding: DossierBinding(),
    ),
  );
  GetPageCenter.add(
    GetPage(
      name: '/vncitizens_dossier/detail',
      page: () => const DossierDetail(),
      binding: DossierBinding(),
    ),
  );
}
