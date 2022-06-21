
import 'package:vncitizens_common/src/config/app_config.dart';
import 'package:vncitizens_common/vncitizens_common.dart';

class VnccService extends GetConnect {

  Future<Response> getAllContactActivated(
      {String? keyword, String? tagId, String? spec, String? sort, int? size, int? page}) async {
    Map<String, String> headers = {'Authorization': 'Bearer ${AppConfig.accessToken}'};
    String keywordQuery = keyword != null ? "&keyword=" + keyword : "";
    String tagIdQuery = tagId != null ? "&tag-id=" + tagId : "";
    String specQuery = spec != null ? "&spec=" + spec : "";
    String pageQuery = page != null ? "&page=" + page.toString() : "";
    String sizeQuery = size != null ? "&size=" + size.toString() : "";
    String sortQuery = sort != null ? "&sort=" + sort : "";
    print("${AppConfig.vnccApiEndpoint}/vncc/contact?status=1" + keywordQuery + tagIdQuery + specQuery + sizeQuery + sortQuery + pageQuery);
    return await get(
        "${AppConfig.vnccApiEndpoint}/vncc/contact?status=1" + keywordQuery + tagIdQuery + specQuery + sizeQuery + sortQuery + pageQuery,
        headers: headers);
  }

  Future<Response> getAllContactActivatedWithTag(String tagId, {String? spec, String? sort, int? size, String? keyword, int? page}) async {
    String specQuery = spec != null ? "&spec=" + spec : "";
    String sizeQuery = size != null ? "&size=" + size.toString() : "";
    String sortQuery = sort != null ? "&sort=" + sort : "";
    String pageQuery = page != null ? "&page=" + page.toString() : "";
    String keywordQuery = keyword != null ? "&keyword=" + keyword : "";
    Map<String, String> headers = {'Authorization': 'Bearer ${AppConfig.accessToken}'};
    return await get("${AppConfig.vnccApiEndpoint}/vncc/contact?status=1&tag-id=$tagId" + specQuery + sizeQuery + sortQuery + keywordQuery + pageQuery, headers: headers);
  }

  Future<Response> getFullGarbageSchedule({required String provinceId, required String nationId, String? keyword}) async {
    Map<String, String> headers = {'Authorization': 'Bearer ${AppConfig.accessToken}'};
    String keyQuery = keyword != null ? '&keyword=' + keyword : '';
    return await get("${AppConfig.vnccApiEndpoint}/vncc/garbage-schedule/--full?province-id=$provinceId&nation-id=$nationId&status=1" + keyQuery, headers: headers);
  }

  Future<Response> getWeather({required double latitude, required double longitude}) async {
    Map<String, String> headers = {'Authorization': 'Bearer ${AppConfig.accessToken}'};
    return await get("${AppConfig.vnccApiEndpoint}/vncc/weather?latitude=$latitude&longitude=$longitude", headers: headers);
  }
}
