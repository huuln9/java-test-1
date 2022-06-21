// ignore_for_file: invalid_use_of_protected_member

import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:vncitizens_account/vncitizens_account.dart';
import 'package:vncitizens_common/vncitizens_common.dart' hide LatLng;
import 'package:latlong2/latlong.dart';
import 'package:path/path.dart' as p;
import 'package:vncitizens_petition/src/controller/petition_public_list_controller.dart';
import 'package:vncitizens_petition/src/controller/petition_filter_list_controller.dart';
import 'package:vncitizens_petition/src/model/petition_detail_model.dart';
import 'package:vncitizens_petition/src/model/place_content.dart';
import 'package:vncitizens_petition/src/model/tag_info_model.dart';
import 'package:vncitizens_petition/src/model/tag_page_model.dart';
import 'package:vncitizens_petition/src/util/file_util.dart';
import 'package:vncitizens_common/dio.dart' as dio;
import 'package:vncitizens_petition/src/widget/pages/create/otp_verify.dart';
import '../config/app_config.dart';
import '../model/tag_page_content_model.dart';
import 'address_maps_controller.dart';
import 'petition_personal_list_controller.dart';

class PetitionCreateController extends GetxController {
  // AddressMapsController addressMapController = Get.find();
  Rx<PetitionDetailModel?> petitionEdit = (null as PetitionDetailModel).obs;
  final RxBool isLoading = false.obs;
  final RxBool isEdit = false.obs;
  final RxBool isChangeDataEdit = false.obs;
  final RxBool isShowClearTakeAtPlace = false.obs;

  RxList<TagPageContentModel> categories = <TagPageContentModel>[].obs;
  RxList<TagPageContentModel> tags = <TagPageContentModel>[].obs;

  RxList<PlaceModel> reporterProvinces = <PlaceModel>[].obs;
  RxList<PlaceModel> reporterDistricts = <PlaceModel>[].obs;
  RxList<PlaceModel> reporterWards = <PlaceModel>[].obs;

  RxList<PlaceModel> takePlaceAtDistricts = <PlaceModel>[].obs;
  RxList<PlaceModel> takePlaceAtWards = <PlaceModel>[].obs;

  PlaceContent? placeSelected;

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController petitionAddressController =
      TextEditingController();
  final TextEditingController reporterAddressController =
      TextEditingController();

  final Rx<TagPageContentModel?> categorySelected =
      (null as TagPageContentModel).obs;
  final Rx<TagPageContentModel?> tagSelected =
      (null as TagPageContentModel).obs;

  final RxBool expandedReporterAddress = false.obs;
  final RxBool isAnonymous = false.obs;
  final RxBool isPublicResult = false.obs;
  final RxBool isActiveCreateButton = false.obs;

  final Rx<PlaceModel?> reporterProvinceSelected = (null as PlaceModel).obs;
  final Rx<PlaceModel?> reporterDistrictSelected = (null as PlaceModel).obs;
  final Rx<PlaceModel?> reporterWardSelected = (null as PlaceModel).obs;
  final Rx<PlaceModel?> takePlaceAtProvinceSelected = (null as PlaceModel).obs;
  final Rx<PlaceModel?> takePlaceAtDistrictSelected = (null as PlaceModel).obs;
  final Rx<PlaceModel?> takePlaceAtWardSelected = (null as PlaceModel).obs;

  final RxString emailError = ''.obs;
  final RxString phoneError = ''.obs;

  RxList<FileModel> files = <FileModel>[].obs;

  late GalleryController galleryController;

  // final videoEx = [
  //   'webm',
  //   'mkv',
  //   'flv',
  //   'vob',
  //   'ogg',
  //   'ogv',
  //   'gif',
  //   'wmv',
  //   'viv',
  //   'mp4'
  // ];

  // final imageEx = [
  //   'jpeg',
  //   'jpg',
  //   'png',
  // ];

  // final docEx = [
  //   'pdf',
  //   'docx',
  //   'xls',
  //   'xlsx',
  //   'pptx',
  //   'doc',
  // ];

  List<FileModel> get imagesOrVideos {
    var imageOrVideoFiles = files.where((file) {
      final extension = p
          .extension(file.path ?? file.name ?? '')
          .replaceAll('.', '')
          .toLowerCase();
      if (FileUtil.videoEx.contains(extension) ||
          FileUtil.imageEx.contains(extension)) {
        return true;
      } else {
        return false;
      }
    });
    return imageOrVideoFiles.toList();
  }

  List<FileModel> get filesDoc {
    var filesDoc = files.where((file) {
      final extension = p
          .extension(file.path ?? file.name ?? '')
          .replaceAll('.', '')
          .toLowerCase();
      if (!FileUtil.videoEx.contains(extension) &&
          !FileUtil.imageEx.contains(extension)) {
        return true;
      } else {
        return false;
      }
    });
    return filesDoc.toList();
  }

//config petition edit
  onInitFormEdit({PetitionDetailModel? petition, String? id}) async {
    if (petition != null) {
      isEdit.value = true;
      isLoading.value = true;
      await _initData();

      await _configDataEdit(petition);
      isLoading.value = false;
    } else if (id != null) {
      isEdit.value = true;
      isLoading.value = true;
      await _initData();
      var petitionDetail = await _getDetail(id);
      if (petitionDetail != null) {
        petitionDetail.id = id;

        await _configDataEdit(petitionDetail);
      }
      isLoading.value = false;
    } else {
      await _initData();
    }
  }

  _configDataEdit(PetitionDetailModel petition) async {
    petitionEdit.value = petition;
    fullNameController.text = petition.reporter!.fullname ?? '';
    emailController.text = petition.reporter!.email ?? '';
    phoneController.text = petition.reporter!.phone ?? '';
    titleController.text = petition.title ?? '';
    descriptionController.text = petition.description ?? '';
    petitionAddressController.text = petition.takePlaceAt!.fullAddress ?? '';
    files.value.addAll(petition.file ?? []);
    files.refresh();

    //reporter address
    try {
      if (petition.reporter != null &&
          petition.reporter!.address != null &&
          petition.reporter!.address!.place != null &&
          petition.reporter!.address!.place!.isNotEmpty) {
        var province = petition.reporter!.address!.place!.firstWhereOrNull(
            (element) =>
                element.typeId ==
                AppConfig.getPetitionCreateConfig.provincesTypeId);
        if (province != null) {
          reporterProvinceSelected.value = reporterProvinces
              .firstWhereOrNull((element) => province.id == element.id);
          await getReporterPlaceDistricts(province.id ?? '');
        }
        var district = petition.reporter!.address!.place!.firstWhereOrNull(
            (element) =>
                element.typeId ==
                AppConfig.getPetitionCreateConfig.districtsTypeId);
        if (district != null) {
          reporterDistrictSelected.value = reporterDistricts
              .firstWhereOrNull((element) => district.id == element.id);
          await getReporterPlaceWards(district.id ?? '');
        }
        var ward = petition.reporter!.address!.place!.firstWhereOrNull(
            (element) =>
                element.typeId ==
                AppConfig.getPetitionCreateConfig.wardsTypeId);
        if (ward != null) {
          reporterWardSelected.value = reporterWards
              .firstWhereOrNull((element) => ward.id == element.id);
        }
        reporterAddressController.text =
            petition.reporter!.address!.address ?? '';
        emailController.text = petition.reporter!.email ?? '';
      }
    } catch (_) {}

    //take at place
    try {
      var district = petition.takePlaceAt!.place!.firstWhereOrNull((element) =>
          element.typeId == AppConfig.getPetitionCreateConfig.districtsTypeId);
      if (district != null) {
        takePlaceAtDistrictSelected.value = takePlaceAtDistricts.value
            .firstWhereOrNull((element) => district.id == element.id);
        await getTakeAtPlaceWards(district.id ?? '');
      }

      var ward = petition.takePlaceAt!.place!.firstWhereOrNull((element) =>
          element.typeId == AppConfig.getPetitionCreateConfig.wardsTypeId);
      if (ward != null) {
        takePlaceAtWardSelected.value = takePlaceAtWards.value
            .firstWhereOrNull((element) => ward.id == element.id);
      }
      placeSelected = PlaceContent(
          place: LatLng(petition.takePlaceAt!.latitude ?? 0.0,
              petition.takePlaceAt!.longitude ?? 0));
      petitionAddressController.text = petition.takePlaceAt!.fullAddress ?? '';
    } catch (_) {}

    try {
      var res =
          await IGateBasecatService().getTagInfo(id: petition.tag!.id ?? '');
      var tagInfo = TagInfoModel.fromJson(res.body);
      categorySelected.value = categories.value
          .firstWhereOrNull((element) => element.id == tagInfo.parent);

      await getTags(parentId: tagInfo.parent);
      tagSelected.value = tags.value
          .firstWhereOrNull((element) => element.id == petition.tag!.id);
    } catch (_) {}

    isAnonymous.value = petition.isAnonymous == "true";
    isPublicResult.value = petition.isPublic == "true";
    isChangeDataEdit.value = false;
  }

  Future<PetitionDetailModel?> _getDetail(String id) async {
    try {
      var res = await IGatePetitionService().getDetail(id);
      return PetitionDetailModel.fromJson(res.body);
    } catch (_) {
      return null;
    }
  }

  @override
  void onInit() async {
    super.onInit();
    log("INIT PETITION CREATE CONTROLLER", name: AppConfig.packageName);

    _onListentTextField();
    initGalleryController();
  }

  void initGalleryController() {
    galleryController = GalleryController(
      gallerySetting: const GallerySetting(
        enableCamera: false,
        requestType: RequestType.image,
        crossAxisCount: 3,
      ),
    );
  }

  _initData() async {
    _initRemoteConfig();
    final _filterController = Get.put(PetitionFilterListController());
    categories.value =
        _filterController.categories.where((p0) => p0.id.isNotEmpty).toList();
    if (categories.isEmpty) {
      await _initCategories();
    }
    _getReporterPlaceProvinces();
    if (AppConfig.getPetitionCreateConfig.takePlaceAt != null &&
        AppConfig.getPetitionCreateConfig.takePlaceAt!.districtActive!) {
      takePlaceAtProvinceSelected.value = PlaceModel(
          id: AppConfig.getPetitionCreateConfig.takePlaceAt!.provincesIdDefault,
          name: AppConfig
              .getPetitionCreateConfig.takePlaceAt!.provincesNameDefault,
          typeId: AppConfig.getPetitionCreateConfig.provincesTypeId);
      takePlaceAtDistricts.value = await _getPlaceDistricts(
          AppConfig.getPetitionCreateConfig.takePlaceAt!.provincesIdDefault ??
              '5def47c5f47614018c000079');
    }

    //hide categories
    if (!AppConfig.getPetitionCreateConfig.categoryActive!) {
      getTags();
    }
  }

  _initRemoteConfig() {
    isAnonymous.value = AppConfig.getPetitionCreateConfig.anonymous!.value!;
    isPublicResult.value = AppConfig.getPetitionCreateConfig.public!.value!;
  }

  Future<void> _initCategories() async {
    try {
      IGateBasecatService()
          .getCategories(0, 50, categoryId: AppConfig.tagCategoryId)
          .then((res) {
        categories.value = [];
        tags.value = [];
        try {
          TagPageModel page = TagPageModel.fromJson(res.body);
          for (var i = 0; i < page.numberOfElements; ++i) {
            TagPageContentModel element = page.content[i];
            categories.add(element);
          }
        } catch (er) {}
        categories.refresh();
      }, onError: (_) {});
    } catch (_) {}
  }

  Future<void> getTags({String? parentId}) async {
    try {
      var res = await IGateBasecatService().getTags(0, 50,
          categoryId: AppConfig.tagCategoryId, parentId: parentId);

      if (res.statusCode == 200) {
        var listTag = <TagPageContentModel>[];

        try {
          TagPageModel page = TagPageModel.fromJson(res.body);
          for (final element in page.content) {
            listTag.add(element);
          }
        } catch (_) {}
        tagSelected.value = null;
        tags.value = listTag;
      } else {
        tagSelected.value = null;
        tags.value = [];
      }
    } catch (_) {
      tagSelected.value = null;
      tags.value = [];
    }
  }

  _getReporterPlaceProvinces() async {
    reporterProvinces.value = [];
    try {
      var res = await IGatePlaceDataService().getProvinces();
      if (res.statusCode == 200) {
        for (var item in res.body) {
          try {
            item['typeId'] = AppConfig.getPetitionCreateConfig.provincesTypeId;
            var province = PlaceModel.fromJson(item);
            reporterProvinces.add(province);
          } catch (_) {}
        }
        reporterProvinces.refresh();
      }
    } catch (_) {}
  }

  getReporterPlaceDistricts(String provinceId) async {
    reporterDistrictSelected.value = null;
    reporterWardSelected.value = null;
    reporterWards.value = [];
    reporterDistricts.value = await _getPlaceDistricts(provinceId);
  }

  getReporterPlaceWards(String districtId) async {
    reporterWardSelected.value = null;
    reporterWards.value = await _getPlaceWards(districtId);
  }

  getTakeAtPlaceWards(String districtId) async {
    takePlaceAtWardSelected.value = null;
    takePlaceAtWards.value = await _getPlaceWards(districtId);
  }

  Future<List<PlaceModel>> _getPlaceDistricts(String provinceId) async {
    try {
      if (provinceId.isNotEmpty) {
        var list = <PlaceModel>[];
        var res =
            await IGatePlaceDataService().getDistricts(provinceId: provinceId);
        for (var item in res.body) {
          try {
            item['typeId'] = AppConfig.getPetitionCreateConfig.districtsTypeId;
            var district = PlaceModel.fromJson(item);
            list.add(district);
          } catch (_) {}
        }
        return list;
      } else {
        return [];
      }
    } catch (_) {
      return [];
    }
  }

  Future<List<PlaceModel>> _getPlaceWards(String districtId) async {
    try {
      if (districtId.isNotEmpty) {
        var list = <PlaceModel>[];
        var res =
            await IGatePlaceDataService().getWards(districtId: districtId);
        for (var item in res.body) {
          try {
            item['typeId'] = AppConfig.getPetitionCreateConfig.wardsTypeId;
            var ward = PlaceModel.fromJson(item);
            list.add(ward);
          } catch (_) {}
        }
        return list;
      } else {
        return [];
      }
    } catch (_) {
      return [];
    }
  }

  @override
  void onClose() {
    super.onClose();
    _onRemoveListentTextField();
  }

  _onListentTextField() {
    fullNameController.addListener(() {
      _onDataChange();
    });
    phoneController.addListener(() {
      _onDataChange();
    });
    emailController.addListener(() {
      emailValidator(emailController.text);
      _onDataChange();
    });
    titleController.addListener(() {
      _onDataChange();
    });
    categorySelected.listen((p0) {
      _onDataChange();
    });
    tagSelected.listen((p0) {
      _onDataChange();
    });
    descriptionController.addListener(() {
      _onDataChange();
    });
    petitionAddressController.addListener(() {
      if (petitionAddressController.text.isNotEmpty) {
        if (placeSelected != null &&
            placeSelected!.address != petitionAddressController.text) {
          placeSelected = null;
        }
        isShowClearTakeAtPlace.value = true;
      } else {
        isShowClearTakeAtPlace.value = false;
      }
      _onDataChange();
    });
    reporterProvinceSelected.listen((p0) {
      _onDataChange();
    });
    reporterDistrictSelected.listen((p0) {
      _onDataChange();
    });
    reporterWardSelected.listen((p0) {
      _onDataChange();
    });
    takePlaceAtDistrictSelected.listen((p0) {
      _onDataChange();
    });
    takePlaceAtWardSelected.listen((p0) {
      _onDataChange();
    });
    expandedReporterAddress.listen((p0) {
      _onDataChange();
    });
    files.listen((p0) {
      _onDataChange();
    });
    isAnonymous.listen((p0) {
      _onDataChange();
    });
    isPublicResult.listen((p0) {
      _onDataChange();
    });
  }

  @override
  void dispose() {
    super.dispose();
    // _onRemoveListentTextField();
  }

  _onRemoveListentTextField() {
    // files.clear();
    fullNameController.removeListener(() {
      _onDataChange();
    });
    phoneController.removeListener(() {
      _onDataChange();
    });
    emailController.removeListener(() {
      _onDataChange();
    });
    titleController.removeListener(() {
      _onDataChange();
    });
    descriptionController.removeListener(() {
      _onDataChange();
    });
    petitionAddressController.removeListener(() {
      _onDataChange();
    });
    fullNameController.dispose();
    phoneController.dispose();
    titleController.dispose();
    emailController.dispose();
    descriptionController.dispose();
    petitionAddressController.dispose();
  }

  _onDataChange() {
    //Check title
    var checkTitle = true;
    if (AppConfig.getPetitionCreateConfig.titleActive! &&
        titleController.value.text.isNotEmpty) {
      checkTitle = true;
    } else if (AppConfig.getPetitionCreateConfig.titleActive! &&
        titleController.value.text.isEmpty) {
      checkTitle = false;
    } else if (!AppConfig.getPetitionCreateConfig.titleActive! &&
        AppConfig.getPetitionCreateConfig.categoryActive! &&
        categorySelected.value != null) {
      checkTitle = true;
      titleController.text = categorySelected.value!.name;
    } else {
      checkTitle = false;
    }

    //check category
    var checkCategory = true;
    if (AppConfig.getPetitionCreateConfig.categoryActive! &&
        categorySelected.value != null) {
      checkCategory = true;
    } else {
      checkCategory = false;
    }

    //Check tag
    var checkTag = true;
    if (tagSelected.value != null) {
      checkTag = true;
    } else {
      checkTag = false;
    }

    //Check takePlaceAt District
    var checkTakeAtProvince = true;
    if (AppConfig.getPetitionCreateConfig.takePlaceAt!.districtActive! &&
        takePlaceAtDistrictSelected.value != null) {
      checkTakeAtProvince = true;
    } else {
      checkTakeAtProvince = false;
    }

    //Check takePlaceAt Ward
    var checkTakeAtWard = true;
    if (AppConfig.getPetitionCreateConfig.takePlaceAt!.wardsActive! &&
        takePlaceAtWardSelected.value != null) {
      checkTakeAtWard = true;
    } else {
      checkTakeAtWard = false;
    }

    //check reporter address
    var checkReporterAddress = true;
    if (AuthUtil.isLoggedIn) {
      checkReporterAddress = true;
    } else if (!expandedReporterAddress.value) {
      checkReporterAddress = true;
    } else {
      if (reporterProvinceSelected.value != null &&
          reporterDistrictSelected.value != null &&
          reporterWardSelected.value != null) {
        checkReporterAddress = true;
      } else {
        checkReporterAddress = false;
      }
    }

    //check reporter email
    var checkEmail = true;
    if (emailController.text.isNotEmpty && emailController.text.isEmail) {
      checkEmail = true;
    } else if (emailController.text.isNotEmpty &&
        !emailController.text.isEmail) {
      checkEmail = false;
    } else {
      checkEmail = true;
    }

    var checkFiles = true;
    if (AppConfig.getPetitionCreateConfig.file!.required! && files.isEmpty) {
      checkFiles = false;
    } else {
      checkFiles = true;
    }

    if (fullNameController.value.text.isNotEmpty &&
        checkReporterAddress &&
        checkIfPhoneNumber(phoneController.text) &&
        checkEmail &&
        checkTitle &&
        petitionAddressController.text.isNotEmpty &&
        checkCategory &&
        checkTag &&
        checkFiles &&
        descriptionController.text.isNotEmpty &&
        checkTakeAtProvince) {
      isActiveCreateButton.value = true;
      isChangeDataEdit.value = true;
    } else {
      isActiveCreateButton.value = false;
      isChangeDataEdit.value = false;
    }
  }

  bool checkIfPhoneNumber(String value) {
    String pattern = r'(^0[0-9]{9}$)';
    RegExp regExp = RegExp(pattern);
    var check = regExp.hasMatch(value);
    if (value.isEmpty) {
      emailError.value = "";
    } else if (!check) {
      phoneError.value = 'so dien thoai khong hop le'.tr;
    } else {
      phoneError.value = '';
    }
    return check;
  }

  emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      emailError.value = "";
    } else {
      if (value.length > 128) {
        emailError.value = 'do dai toi da 128 ki tu'.tr;
      }
      emailError.value = value.isEmail ? "" : "email khong hop le".tr;
    }
  }

  onCreatePetition() async {
    try {
      isLoading.value = true;
      if (AuthUtil.isLoggedIn) {
        await _onConvertData();
      } else {
        var result = await Get.to(OtpVerify());
        if (result != null && result is bool && result) {
          await _onConvertData();
        }
      }
      isLoading.value = false;
    } catch (er) {
      log("Petition report failed ${er.toString()}",
          name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      isLoading.value = false;
      UIHelper.showNotificationSnackBar(message: 'gui phan anh that bai'.tr);
    }
  }

  onUpdatePetition() async {
    try {
      isLoading.value = true;
      if (AuthUtil.isLoggedIn) {
        await _onConvertData();
      } else {
        var result = await Get.to(OtpVerify());
        if (result != null && result is bool && result) {
          await _onConvertData();
        }
      }
      isLoading.value = false;
    } catch (er) {
      log("Petition report failed ${er.toString()}",
          name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      isLoading.value = false;
      UIHelper.showNotificationSnackBar(message: 'gui phan anh that bai'.tr);
    }
  }

  _onConvertData() async {
    FileModel? imageThumb;

    var fileUpload = <FileModel>[];
    try {
      if (files.value.isNotEmpty) {
        fileUpload = await _onUploadFile();
        fileUpload.addAll(files.value.where((element) => element.id != null));

        imageThumb = fileUpload.firstWhereOrNull((element) {
          final extension =
              p.extension(element.name ?? '').replaceAll('.', '').toLowerCase();
          if (FileUtil.imageEx.contains(extension)) {
            return true;
          }

          return false;
        });
      }
    } catch (_) {}

    var takePlace = <PlaceModel>[];
    if (takePlaceAtProvinceSelected.value != null) {
      takePlace.add(takePlaceAtProvinceSelected.value!);
    }
    if (AppConfig.getPetitionCreateConfig.takePlaceAt!.districtActive! &&
        takePlaceAtDistrictSelected.value != null) {
      takePlace.add(takePlaceAtDistrictSelected.value!);
    }

    if (AppConfig.getPetitionCreateConfig.takePlaceAt!.wardsActive! &&
        takePlaceAtWardSelected.value != null) {
      takePlace.add(takePlaceAtWardSelected.value!);
    }

    var reporterPlace = <PlaceModel>[];

    if (reporterProvinceSelected.value != null) {
      reporterPlace.add(reporterProvinceSelected.value!);
    }

    if (reporterProvinceSelected.value != null) {
      reporterPlace.add(reporterProvinceSelected.value!);
    }

    if (reporterWardSelected.value != null) {
      reporterPlace.add(reporterWardSelected.value!);
    }

    TakePlaceAtModel? takePlaceAt;
    if (placeSelected != null && placeSelected!.place != null) {
      takePlaceAt = TakePlaceAtModel(
          latitude: placeSelected!.place!.latitude,
          longitude: placeSelected!.place!.longitude,
          fullAddress: petitionAddressController.text,
          place: takePlace);
    } else {
      takePlaceAt = TakePlaceAtModel(
          fullAddress: petitionAddressController.text, place: takePlace);
    }
    var title = titleController.text;
    if(title.isEmpty){
      title = tagSelected.value!.name;
    }
    var petition = {
      'title': title,
      'description': descriptionController.text,
      'tag': TagModel(id: tagSelected.value!.id, name: tagSelected.value!.name)
          .toJson(),
      'takePlaceOn': DateTime.now().toIso8601String(),
      'takePlaceAt': takePlaceAt.toJson(),
      // 'reporterLocation': {'fullAddress': reporterFullAddress},
      'reporter': ReporterModel(
        id: AuthUtil.userId,
        fullname: fullNameController.text,
        username: AuthUtil.username,
        phone: phoneController.text,
        email: emailController.text,
        type: 1,
        address: ReporterAddressModel(
            address: reporterAddressController.text, place: reporterPlace),
      ).toJson(),
      'isPublic': isPublicResult.value,
      'isAnonymous': isAnonymous.value,
      "file": isEdit.value
          ? fileUpload.map((e) => e.toJsonUpdate()).toList()
          : fileUpload.map((e) => e.toJson()).toList(),
      "thumbnailId": imageThumb != null
          ? imageThumb.id
          : AppConfig.getPetitionCreateConfig.thumbnailIdDefault
    };
    if (!isEdit.value) {
      await _createPetitionRequestApi(petition);
    } else {
      await _updatePetitionRequestApi(petition);
    }
  }

  _createPetitionRequestApi(dynamic petition) async {
    var res = await IGatePetitionService().create(petition);
    if (res.statusCode == 200) {
      final _controllerDefault = Get.put(PetitionPublicListController());
      final _controllerPersonal = Get.put(PetitionPersonalListController());
      _controllerDefault.refreshPetitions();
      _controllerPersonal.refreshPetitions();
      Future.delayed(const Duration(milliseconds: 300)).then((value) {
        Get.back();
        Future.delayed(const Duration(milliseconds: 200)).then((value) {
          UIHelper.showNotificationSnackBar(
              message: 'gui phan anh thanh cong'.tr);
        });
      });
      log("Petition report successfully ${petition.toString()}",
          name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    } else {
      log("Petition report failed ${petition.toString()}",
          name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      isLoading.value = false;
      UIHelper.showNotificationSnackBar(message: 'gui phan anh that bai'.tr);
    }
  }

  _updatePetitionRequestApi(dynamic petition) async {
    var res = await IGatePetitionService()
        .updatePetition(petitionEdit.value!.id ?? '', petition);
    if (res.statusCode == 200) {
      Future.delayed(const Duration(milliseconds: 300)).then((value) {
        Get.back(result: true);
        Future.delayed(const Duration(milliseconds: 200)).then((value) {
          UIHelper.showNotificationSnackBar(
              message: 'cap nhat phan anh thanh cong'.tr);
        });
      });
      log("Petition update successfully ${petition.toString()}");
    } else {
      log("Petition update failed ${petition.toString()}",
          name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      isLoading.value = false;
      UIHelper.showNotificationSnackBar(
          message: 'cap nhat phan anh that bai'.tr);
    }
  }

  Future<List<FileModel>> _onUploadFile() async {
    try {
      var listMultipartFile = <dio.MultipartFile>[];

      for (final file
          in files.value.where((element) => element.path != null).toList()) {
        var mDecodeUriPath = file.path ?? '';
        try {
          mDecodeUriPath = Uri.decodeFull(file.path ?? '');
        } catch (_) {}
        listMultipartFile.add(await dio.MultipartFile.fromFile(mDecodeUriPath,
            filename: file.name));
      }
      final res = await IGateFilemanService()
          .uploadFile(files: listMultipartFile, accountId: AuthUtil.userId);
      var listFile = <FileModel>[];
      if (res.statusCode == 200) {
        for (final file in res.data) {
          listFile.add(FileModel(id: file['id'], name: file['filename']));
        }
      } else {}

      return listFile;
    } catch (er) {
      return [];
    }
  }

  getImagesCamera() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      files.add(FileModel(name: photo.name, path: photo.path));
      files.refresh();
    }
  }

  getImagesGallery(BuildContext context) async {
    // final ImagePicker _picker = ImagePicker();
    final List<XFile>? photos = await _imagesGallery(context);
    if (photos != null) {
      if (AppConfig.getPetitionCreateConfig.file != null &&
          (AppConfig.getPetitionCreateConfig.file!.maxLength ?? 6) <
              (files.length + photos.length)) {
        UIHelper.showNotificationSnackBar(
            message: 'chi cho phep upload toi da'.tr +
                ' ${AppConfig.getPetitionCreateConfig.file!.maxLength} files!');
      } else if (!_checkUploadFileSize(photos)) {
        UIHelper.showNotificationSnackBar(
            message: 'chi cho phep upload file toi da'.tr +
                ' ${AppConfig.getPetitionCreateConfig.file!.maxSize} MB');
      } else {
        files.addAll(
            photos.map((e) => FileModel(name: e.name, path: e.path)).toList());
        files.refresh();
      }
    }
  }

  Future<List<XFile>> _imagesGallery(BuildContext context) async {
    var list = <XFile>[];
    List<DrishyaEntity> entities = await galleryController
        .pick(context)
        .whenComplete(() => initGalleryController());
    if (entities.isNotEmpty) {
      // File? tmpFile = await entities[0].entity.file;
      for (final item in entities) {
        File? tmpFile = await item.entity.file;
        list.add(XFile(tmpFile!.path));
      }
    }
    return list;
  }

  getFilesDevice() async {
    var extensions = AppConfig.getPetitionCreateConfig.file!.extensions!;
    extensions.addAll(FileUtil.imageEx);
    extensions.addAll(FileUtil.videoEx);
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: extensions,
      allowMultiple: true,
    );
    if (result != null) {
      List<XFile> xFiles = result.paths.map((path) => XFile(path!)).toList();

      if (AppConfig.getPetitionCreateConfig.file != null &&
          (AppConfig.getPetitionCreateConfig.file!.maxLength ?? 6) <
              (files.length + xFiles.length)) {
        UIHelper.showNotificationSnackBar(
            message: 'chi cho phep upload toi da'.tr +
                ' ${AppConfig.getPetitionCreateConfig.file!.maxLength} files!');
      } else if (!_checkUploadFileSize(xFiles)) {
        UIHelper.showNotificationSnackBar(
            message: 'chi cho phep upload file toi da'.tr +
                ' ${AppConfig.getPetitionCreateConfig.file!.maxSize} MB');
      } else {
        files.addAll(
            xFiles.map((e) => FileModel(name: e.name, path: e.path)).toList());
        files.refresh();
      }
    } else {
      // User canceled the picker
    }
  }

  bool _checkUploadFileSize(List<XFile> files) {
    if (AppConfig.getPetitionCreateConfig.file != null &&
        AppConfig.getPetitionCreateConfig.file!.maxSize != null) {
      for (var item in files) {
        var file = File(item.path);
        int sizeInBytes = file.lengthSync();
        double sizeInMb = sizeInBytes / (1024 * 1024);
        if (sizeInMb > AppConfig.getPetitionCreateConfig.file!.maxSize!) {
          return false;
        }
      }
    }

    return true;
  }

  routeAddressMap() async {
    var result = await Get.toNamed("/vncitizens_petition/petition_address_map");
    if (result != null && result is PlaceContent) {
      placeSelected = result;
      if (placeSelected != null) {
        petitionAddressController.text = placeSelected!.address;
        await convertAddressDecomposition();
      }
    }
  }

  routeOtpVerify() async {
    await Get.toNamed("/vncitizens_petition/petition_otp_verify");
  }

  Future<bool> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return false;
    }
    return true;
  }

  getAddress() async {
    try {
      var position = await _getPosition();
      if (position != null) {
        var lat = LatLng(position.latitude, position.longitude);

        placeSelected = await _getAddressFromLatLong(lat);
        petitionAddressController.text = placeSelected!.address;
        await convertAddressDecomposition();
        // print(res.body);
      }
    } catch (er) {
      print(er);
    }
  }

  convertAddressDecomposition() async {
    try {
      var res = await LocationService()
          .addressDecomposition(fullAddress: petitionAddressController.text);
      if (res.body is List && res.body.isNotEmpty) {
        // PlaceModel? province;
        // PlaceModel? district;
        // PlaceModel? ward;
        // if (data[0]['province'] != null) {
        //   province = PlaceModel(
        //       id: data[0]['province']['placeId'],
        //       name: data[0]['province']['name']);
        // }

        if (res.body[0]['district'] != null) {
          takePlaceAtDistrictSelected.value =
              takePlaceAtDistricts.firstWhereOrNull((element) =>
                  element.id == res.body[0]['district']['placeId']);
          if (takePlaceAtDistrictSelected.value != null) {
            getTakeAtPlaceWards(takePlaceAtDistrictSelected.value!.id ?? '');
          }
        }
        if (res.body[0]['ward'] != null) {
          takePlaceAtWardSelected.value = takePlaceAtWards.firstWhereOrNull(
              (element) => element.id == res.body[0]['ward']['placeId']);
        }
      }
    } catch (_) {}
  }

  Future<PlaceContent> _getAddressFromLatLong(LatLng point) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(point.latitude, point.longitude);
    Placemark place = placemarks[0];

    return PlaceContent(
        place: point,
        street: place.street,
        districts: place.subAdministrativeArea,
        conscious: place.administrativeArea,
        country: place.country);
  }

  Future<Position?> _getPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      UIHelper.showNotificationSnackBar(
          message: 'nguoi dung khong mo dinh vi tao do'.tr);
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        UIHelper.showNotificationSnackBar(
            message: 'khong co quyen su dung dinh vi'.tr);
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return null;
    }
    return await Geolocator.getCurrentPosition();
  }
}
