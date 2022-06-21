
class NatureStationItemModel {
    int id;
    String su_code;
    String su_name;
    String su_address;
    int su_orderby;
    double su_location_lat;
    double su_location_lng;

    NatureStationItemModel({
        required this.id,
        required this.su_code,
        required this.su_name,
        required this.su_address,
        required this.su_orderby,
        required this.su_location_lat,
        required this.su_location_lng
    });

    factory NatureStationItemModel.fromMap(Map<String, dynamic> map) {
        return NatureStationItemModel(
            id: map['id'] as int,
            su_code: map['su_code'] as String,
            su_name: map['su_name'] as String,
            su_address: map['su_address'] as String,
            su_orderby: map['su_orderby'] as int,
            su_location_lat: map['su_location_lat'] as double,
            su_location_lng: map['su_location_lng'] as double
        );
    }
}