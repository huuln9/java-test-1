import 'dart:developer' as dev;
import 'dart:developer';


import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_weather/src/config/app_config.dart';
import 'package:vncitizens_weather/src/model/current_children.dart';
import 'package:vncitizens_weather/src/model/features.dart';

class WeatherController extends GetxController {
  RxBool loading = false.obs;
  RxString celsiusStr = "".obs;
  RxString locationName = "".obs;
  RxString iconWeather = "".obs;
  RxString weatherTime = "".obs;
  RxString descriptionWeather = "".obs;
  RxString humidity = "".obs;
  RxString windSpeed = "".obs;
  RxList<CurrentChildrenModel> getListChildren = <CurrentChildrenModel>[].obs;
  RxList<FeaturesModel> getListFeature = <FeaturesModel>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    await getWeatherCurrent().then((map) {
      locationName.value = map["city"]["name"].toString();
      celsiusStr.value = map["forecast"]["current"]["main"]["temperature"]["value"].toString();
      windSpeed.value = map["forecast"]["current"]["wind"]["speed"]["value"].toString();
      humidity.value = map["forecast"]["current"]["main"]["humidity"]["value"].toString();
      weatherTime.value = map["forecast"]["current"]["date"].toString();
      descriptionWeather.value = map["forecast"]["current"]["weathers"][0]["description"].toString();
      iconWeather.value = map["forecast"]["current"]["weathers"][0]["icon"].toString();
    });
  }
  Future<Map<String, dynamic>> getWeatherCurrent() async {
    loading(true);
    final GetStorage _storage = GetStorage(AppConfig.packageName);
    Position position = await getCurrentLocation();
    await _storage.write('position', position);
    Response response = await VnccService().getWeather(latitude: position.latitude, longitude: position.longitude);
    dev.log(response.statusCode.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    if (response.statusCode == 200) {
      loading(false);
      await getWeatherFeatures(response).then((value){});
      await getWeatherCurrentChildren(response).then((value) {});
      return response.body;
    } else {
      loading(false);
      throw "Get weather error";
    }
  }
  Future<Object> getWeatherCurrentChildren(response) async {
    response.body["forecast"]["current"]["children"].forEach((item){
      if(getParseHour(item['date']) > getCurrentHourStr()) {
        getListChildren.add(CurrentChildrenModel.fromMap(item));
      }
    });
    return getListChildren;
  }
  Future<Object> getWeatherFeatures(response) async {
    loading(false);
    response.body["forecast"]["features"].forEach((item){
      getListFeature.add(FeaturesModel.fromMap(item));
    });
    return getListFeature;
  }
  Future<Position> getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw "Location permissions are denied";
        }
      }
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      return position;
    } catch (error) {
      throw "Get current position error !!!";
    }
  }

  getParseHour(dateStr){
    DateTime dateTime = DateTime.parse(dateStr).toLocal();
    String formattedDate = DateFormat.Hm().format(dateTime);
    var result = formattedDate.substring(0,2);
    var hhWeather = int.tryParse(result);
    return hhWeather;
  }
  getCurrentHourStr() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat.Hm().format(now);
    var result = formattedDate.substring(0,2);
    var hhNow = int.tryParse(result);
    return hhNow;
  }
}
