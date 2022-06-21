
import 'package:vncitizens_common/vncitizens_common.dart';

class MapNatureService extends GetConnect {
  Future<Response> getDetailStationNature(int suId) async {
    return await get("http://quantrac.vnisa.vn/api/v2/home_client/loadTGS_GetDataByStation?su_id=" + suId.toString());
  }
}