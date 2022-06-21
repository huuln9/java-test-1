import 'dart:developer';

import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_queue/src/model/info_model.dart';
import 'package:vncitizens_queue/src/model/queue_model.dart';
import 'package:vncitizens_account/src/util/AuthUtil.dart';

import '../config/app_config.dart';
import '../config/route_config.dart';
import '../model/agency_model.dart';
import '../service/queue_service.dart';

class QueueController extends GetxController {
  RxList<QueueModel> getListReception = <QueueModel>[].obs;
  RxList<AgencyModel> getListAgency = <AgencyModel>[].obs;
  Rx<AgencyModel> agencySelected = AgencyModel().obs;
  String? fullName;
  String? identity;
  String? phoneNumber;
  String? address;
  var isLoading = false.obs;
  int page = 0;
  int? maxPage;
  int size = 100;
  InfoModel? info;

  // ScrollController coQuanScrollController = ScrollController();
  // RxBool isLastPlacePage = false.obs;
  // RxBool isLoadMoreCoQuan = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    await getAccessToken();

    await _getInfo();

    await _getListAgency(page, size).then((value) {
      agencySelected.value = getListAgency[0];
      changeAgency(agencySelected.value.id.toString());
    });

    // coQuanScrollController.addListener(() {
    //   if (coQuanScrollController.position.pixels ==
    //       coQuanScrollController.position.maxScrollExtent) {
    //     if (!isLastPlacePage.value) {
    //       page++;
    //       _getListAgency(page, size);
    //     } else {
    //       log("Last page place: " + page.toString(),
    //           name: AppConfig.packageName);
    //     }
    //   }
    // });
  }

  Future<List<QueueModel>> _getListReception(String agencyId) async {
    String? userId = AuthUtil.username;

    Response response = await QueueService().getListReception(
        agencyId: agencyId, userId: userId, page: 0, size: 100);
    if (response.statusCode == 200) {
      List<QueueModel> list = [];
      response.body["content"].forEach((item) {
        list.add(QueueModel.fromMap(item));
      });
      return list;
    } else {
      log(response.statusCode.toString());
      throw "ERROR";
    }
  }

  Future<List<AgencyModel>> _getListAgency(int page, int size) async {
    // isLoadMoreCoQuan(true);

    Response response =
        await QueueService().getListAgency(keyword: '', page: page, size: size);
    if (response.statusCode == 200) {
      // log(response.body.toString());
      response.body["content"].forEach((item) {
        getListAgency.add(AgencyModel.fromMap(item));
      });

      // isLastPlacePage(response.body["totalPages"]);
      // isLoadMoreCoQuan(false);

      return getListAgency;
    } else {
      // isLoadMoreCoQuan(false);
      log(response.statusCode.toString());
      throw "ERROR";
    }
  }

  changeAgency(String agencyId) {
    _getListReception(agencyId).then((value) {
      getListReception.value = value;
    });
  }

  Future<int?> orderNumber(String officials, String queueId) async {
    String? userId = AuthUtil.username;
    isLoading.value = true;
    Response response = await QueueService().postOrderNumber(
        userId: userId, officials: officials, queueId: queueId);
    if (response.statusCode == 200) {
      isLoading.value = false;
      return response.statusCode;
    } else {
      isLoading.value = false;
      log(response.statusCode.toString());
      throw "ERROR";
    }
  }

  getAccessToken() async {
    Response response = await QueueService().getAccessToken();
    if (response.statusCode == 200) {
      await GetStorage(AppConfig.storageBox)
          .write(AppConfig.tokenStorageKey, response.body["access_token"]);
    } else {
      log('ERROR' + response.body);
      throw "ERROR";
    }
  }

  Future<int?> cancelNumber(String numberId) async {
    isLoading.value = true;
    Response response =
        await QueueService().putCancelNumber(numberId: numberId);
    if (response.statusCode == 200) {
      isLoading.value = false;
      return response.statusCode;
    } else {
      isLoading.value = false;
      log(response.statusCode.toString());
      throw "ERROR";
    }
  }

  Future<void> onTapDetails(QueueModel model) async {
    Get.toNamed(RouteConfig.detailRoute, arguments: model);
  }

  Future<void> backToList() async {
    Get.toNamed(RouteConfig.listRoute);
  }

  Future<void> _getInfo() async {
    Response response = await QueueService().getInfo();
    if (response.statusCode == 200) {
      log(response.bodyString.toString());

      info = InfoModel.fromJson(response.body);
    } else {
      log(response.statusCode.toString());
      throw "ERROR";
    }
  }
}
