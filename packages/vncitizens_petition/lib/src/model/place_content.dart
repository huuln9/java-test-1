import 'package:latlong2/latlong.dart';

class PlaceContent {
  final LatLng? place;
  final String? conscious;
  final String? districts;
  final String? wards;
  final String? street;
  final String? country;
  PlaceContent({
    this.place,
    this.conscious,
    this.districts,
    this.wards,
    this.street,
    this.country,
  });

  String get address {
    var address = '';
    if (street != null && street!.isNotEmpty) {
      address += street!;
    }
    if (wards != null && wards!.isNotEmpty) {
      address += ', ${wards!}';
    }
    if (districts != null && districts!.isNotEmpty) {
      address += ', ${districts!}';
    }
    if (conscious != null && conscious!.isNotEmpty) {
      address += ', ${conscious!}';
    }
    if (country != null && country!.isNotEmpty) {
      address += ', ${country!}';
    }
    return address;
  }
}
