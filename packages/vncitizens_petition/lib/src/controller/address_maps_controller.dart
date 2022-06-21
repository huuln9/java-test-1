import 'package:latlong2/latlong.dart';
import 'package:vncitizens_common/vncitizens_common.dart' hide LatLng;
import 'package:vncitizens_petition/src/model/place_content.dart';
import 'package:vncitizens_petition/src/model/place_maker.dart';

import '../config/app_config.dart';

class AddressMapsController extends GetxController {
  Rx<LatLng> centerLocation = AppConfig.centerLocation.obs;
  RxList<Marker> markers = <Marker>[].obs;
  RxBool isLoading = false.obs;
  PlaceContent? placeSelected;

  @override
  void onInit() {
    super.onInit();
    // _getLocation();
  }

  getLocation() async {
    isLoading.value = true;
    try {
      var position = await _determinePosition();
      markers.value = [];
      if (position != null) {
        centerLocation.value = LatLng(position.latitude, position.longitude);

        var placeContent = await getAddressFromLatLong(centerLocation.value);
        var marker = PlaceMarker(place: placeContent);
        markers.add(marker);
      }
    } catch (_) {}

    isLoading.value = false;
  }

  submit() {
    var place = markers[0];
    if (place is PlaceMarker) {
      placeSelected = place.place;
    }
    Get.back(result: placeSelected);
  }

  changeLocation(LatLng point) async {
    try {
      centerLocation.value = point;
      markers.value = [];

      var placeContent = await getAddressFromLatLong(centerLocation.value);
      var marker = PlaceMarker(place: placeContent);
      markers.add(marker);
    } catch (_) {}
  }

  Future<PlaceContent> getAddressFromLatLong(LatLng point) async {
    print(point);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(point.latitude, point.longitude);
    print(placemarks);
    Placemark place = placemarks[0];

    return PlaceContent(
        place: point,
        street: place.street,
        districts: place.subAdministrativeArea,
        conscious: place.administrativeArea,
        country: place.country);
  }

  Future<Position?> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      return null;
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return null;
    }
    return await Geolocator.getCurrentPosition();
  }
}
