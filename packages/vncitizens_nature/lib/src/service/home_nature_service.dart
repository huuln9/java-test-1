

import 'package:vncitizens_common/vncitizens_common.dart';

class HomeNatureService extends GetConnect {

    Future<Response> getAllStationNature() async {
        return await get("http://quantrac.vnisa.vn/api/v2/home_client/loadTGS_ListStationOnDay");
    }

    Future<Response> getDetailStationNature(int suId) async {
        return await get("http://quantrac.vnisa.vn/api/v2/home_client/loadTGS_GetDataByStation?su_id=" + suId.toString());
    }
}