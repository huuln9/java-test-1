import 'package:digo_common/digo_common.dart';
import 'package:get/get.dart';
import 'package:vncitizens_petition/src/widget/pages/create/petition_create.dart';
import 'package:vncitizens_petition/src/widget/pages/detail/petition_detail.dart';
import 'package:vncitizens_petition/src/widget/pages/index/petition_list.dart';
import 'dart:developer' as dev;

import 'package:vncitizens_petition/src/config/app_config.dart';

import '../binding/all_binding.dart';
import '../widget/pages/create/address_maps.dart';
import '../widget/pages/create/otp_verify.dart';

initAppRoute() async {
  dev.log('initialize route', name: AppConfig.packageName);

  GetPageCenter.add(GetPage(
      name: '/vncitizens_petition/list',
      page: () => const PetitionList(),
      binding: AllBinding()));
  // GetPageCenter.add(GetPage(
  //     name: '/vncitizens_petition/list/:id_detail/:rating',
  //     page: () => const PetitionList(),
  //     binding: AllBinding()));
  GetPageCenter.add(GetPage(
      name: '/vncitizens_petition/detail',
      page: () => const PetitionDetail(),
      binding: AllBinding()));

  GetPageCenter.add(GetPage(
      name: '/vncitizens_petition/create',
      page: () => const PetitionCreate(),
      binding: AllBinding()));

  GetPageCenter.add(GetPage(
      name: '/vncitizens_petition/petition_address_map',
      page: () => const AddressMaps(),
      binding: AllBinding()));

  GetPageCenter.add(GetPage(
      name: '/vncitizens_petition/petition_otp_verify',
      page: () => OtpVerify(),
      binding: AllBinding()));
  // GetPageCenter.add(GetPage(
  //   name: '/second',
  //   page: () => Second(),
  //   binding: BindingsBuilder(() => {Get.lazyPut<ExampleXController>(() => ExampleXController())}),
  // ));
  //
  // GetPageCenter.add(GetPage(
  //   name: '/third',
  //   transition: Transition.cupertino,
  //   page: () => Third(),
  // ));
}
