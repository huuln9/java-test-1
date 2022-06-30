import 'dart:async';
import 'package:flutter_vnpt_map/geojs/flutter_vnptmap_geojs.dart';
import 'package:flutter_vnpt_map/util/raw/raw.dart';
import 'package:flutter_vnpt_map/m_config.dart';
import 'package:flutter_vnpt_map/flutter_vnpt_map.dart';
import 'package:flutter_vnpt_map/model/latlng_by_address_input.dart';
import 'package:flutter_vnpt_map/net/map_error_code.dart';
import 'package:flutter_vnpt_map/net/map_repository.dart';
import 'package:pedantic/pedantic.dart';

class MapService {
  final MapRepository _repository = MapRepository();
  final GeoJson _geoJson = GeoJson();
  late String _accessToken;

  setMapConfig(MapConfig mapConfig) {
    this._accessToken = mapConfig.key;
    MConfig().setupEnv(
      env: mapConfig.env,
    );
    MConfig.showLog = mapConfig.printLog;
  }

  final StreamController<SingleRouteOutput?> _getSingleRouteController;
  final StreamController<MultiRouteOutput?> _getMultiRouteController;
  final StreamController<AddressInfo?> _getAddressByLatlngController;
  final StreamController<List<PlaceResult>?> _getLatlngByAddressController;
  final StreamController<NearbyOutput?> _getNearbyRoadController;
  final StreamController<List<NearBySearch>> _getNearbySearchController;
  final StreamController<List<Geoboundaries>> _getProvincesPolygonController;
  final StreamController<List<List<LatLng>>>
      _getProvincePolygonVietNamController;
  final StreamController<IsochronesOutput?> _getIsochroneController;
  final StreamController<LabelIsochroneOutput?>
      _getLabelBetweenIsochroneController;
  final StreamController<List<FacilityClosestOutput>?>
      _getFacilityClosestController;

  MapService()
      : _getSingleRouteController = StreamController<SingleRouteOutput>(),
        _getMultiRouteController = StreamController<MultiRouteOutput>(),
        _getNearbyRoadController = StreamController<NearbyOutput>(),
        _getNearbySearchController = StreamController<List<NearBySearch>>(),
        _getAddressByLatlngController = StreamController<AddressInfo>(),
        _getLatlngByAddressController = StreamController<List<PlaceResult>>(),
        _getProvincesPolygonController =
            StreamController<List<Geoboundaries>>(),
        _getProvincePolygonVietNamController =
            StreamController<List<List<LatLng>>>(),
        _getIsochroneController = StreamController<IsochronesOutput>(),
        _getLabelBetweenIsochroneController =
            StreamController<LabelIsochroneOutput>(),
        _getFacilityClosestController =
            StreamController<List<FacilityClosestOutput>>();

  Stream<SingleRouteOutput?> get processedGetSingleRoute =>
      _getSingleRouteController.stream;

  Stream<MultiRouteOutput?> get processedGetMultiRoute =>
      _getMultiRouteController.stream;

  Stream<AddressInfo?> get processedGetAddressByLatlng =>
      _getAddressByLatlngController.stream;

  Stream<NearbyOutput?> get processedGetNearbyRoad =>
      _getNearbyRoadController.stream;

  Stream<List<NearBySearch>> get processedGetNearbySearch =>
      _getNearbySearchController.stream;

  Stream<List<PlaceResult>?> get processedGetLatlngByAddress =>
      _getLatlngByAddressController.stream;

  Stream<List<Geoboundaries>> get processedGetProvincesPolygon =>
      _getProvincesPolygonController.stream;

  Stream<List<List<LatLng>>> get processedGetProvincePolygonVietnam =>
      _getProvincePolygonVietNamController.stream;

  Stream<IsochronesOutput?> get processedGetIsochrone =>
      _getIsochroneController.stream;

  Stream<LabelIsochroneOutput?> get processedGetLabelBetweenIsochrone =>
      _getLabelBetweenIsochroneController.stream;

  Stream<List<FacilityClosestOutput>?> get processedGetFacilityClosest =>
      _getFacilityClosestController.stream;

  /// Hàm tìm đường đi ngắn nhất giữa 2 điểm bất kỳ
  getSingleRoute(PathInput pathInput) {
    _onRequiredAccessToken();
    assert(pathInput.algorithmType == AlgorithmType.astar_route);
    try {
      final data = pathInput.toJson();
      _repository.getRoute(this._accessToken, data: data).then(
        (BaseResp baseResp) {
          int errorCode = baseResp.error;
          if (errorCode == ErrorCode.SUCCESS ||
              errorCode == ErrorCode.SUCCESS_200) {
            SingleRouteOutput? singleRouteOutput;
            PathOutput pOut = PathOutput.fromJson(baseResp.result);
            try {
              RPath rPath = pOut.paths![0];
              if (pOut.paths!.isNotEmpty) {
                singleRouteOutput = VnptMapUtils.convertPath2Route(
                  pathInput.originPoint,
                  pathInput.destPoint,
                  rPath,
                );
              }
            } catch (e) {}
            _getSingleRouteController.sink.add(singleRouteOutput);
          } else {
            _getSingleRouteController.sink.add(null);
          }
        },
      );
    } catch (err) {
      _getSingleRouteController.sink.add(null);
    }
  }

  /// Hàm tìm các đường đi giữa 2 điểm bất kỳ
  getMultiRoute(PathInput pathInput) {
    _onRequiredAccessToken();
    assert(pathInput.algorithmType == AlgorithmType.alternative_route);
    List<SingleRouteOutput> multiRoutes = [];
    try {
      final data = pathInput.toJson();
      _repository.getRoute(this._accessToken, data: data).then(
        (BaseResp baseResp) {
          int errorCode = baseResp.error;
          if (errorCode == ErrorCode.SUCCESS ||
              errorCode == ErrorCode.SUCCESS_200) {
            PathOutput pOut = PathOutput.fromJson(baseResp.result);
            try {
              if (pOut.paths!.isNotEmpty) {
                pOut.paths!.forEach(
                  (RPath path) {
                    multiRoutes.add(
                      VnptMapUtils.convertPath2Route(
                        pathInput.originPoint,
                        pathInput.destPoint,
                        path,
                      ),
                    );
                  },
                );
              }
            } catch (e) {}

            try {
              /// Sắp xếp đường đi theo thứ tự ngắn nhất -> dài nhất
              multiRoutes.sort(
                (SingleRouteOutput p1, SingleRouteOutput p2) =>
                    p2.distance!.compareTo(
                  p1.distance!,
                ),
              );
            } catch (e) {}

            _getMultiRouteController.sink.add(
              MultiRouteOutput(
                originPoint: pathInput.originPoint,
                destPoint: pathInput.destPoint,
                routes: multiRoutes,
              ),
            );
          } else {
            _getMultiRouteController.sink.add(null);
          }
        },
      );
    } catch (err) {
      _getMultiRouteController.sink.add(null);
    }
  }

  /// Lấy thông tin đia chỉ theo tọa độ
  /// #required accessToken
  getAddressByLatlng(
    LatLng point,
  ) {
    _onRequiredAccessToken();
    try {
      _repository
          .getAddressByLatlng(
        this._accessToken,
        point,
      )
          .then(
        (BaseResp baseResp) {
          int errorCode = baseResp.error;
          if (errorCode == ErrorCode.SUCCESS ||
              errorCode == ErrorCode.SUCCESS_200) {
            AddressInfo addressInfo = AddressInfo.fromJson(baseResp.result);
            addressInfo.point = point;
            _getAddressByLatlngController.sink.add(addressInfo);
          } else {
            _getAddressByLatlngController.sink.add(null);
          }
        },
      );
    } catch (err) {
      _getAddressByLatlngController.sink.add(null);
    }
  }

  getNearbyRoad(
    NearbyInput input,
  ) {
    _onRequiredAccessToken();
    try {
      _repository
          .getNearbyRoad(
        this._accessToken,
        data: input.toJson(),
      )
          .then(
        (BaseResp baseResp) {
          int errorCode = baseResp.error;
          if (errorCode == ErrorCode.SUCCESS ||
              errorCode == ErrorCode.SUCCESS_200) {
            NearbyOutput nearbyOutput = NearbyOutput.fromJson(baseResp.result);
            try {
              nearbyOutput.points = VnptMapUtils().decodeGeoEncoded(
                nearbyOutput.geomEncoded!,
              );
            } catch (e) {}
            _getNearbyRoadController.sink.add(nearbyOutput);
          } else {
            _getNearbyRoadController.sink.add(null);
          }
        },
      );
    } catch (err) {
      _getNearbyRoadController.sink.add(null);
    }
  }

  getNearbySearch(
    NearbyInput input,
  ) {
    _onRequiredAccessToken();
    try {
      _repository
          .getNearbySearch(
        this._accessToken,
        data: input.toJson(),
      )
          .then(
        (BaseResp baseResp) {
          int errorCode = baseResp.error;
          if (errorCode == ErrorCode.SUCCESS ||
              errorCode == ErrorCode.SUCCESS_200) {
            if (baseResp.result == null) {
              _getNearbySearchController.sink.add(
                <NearBySearch>[],
              );
              return;
            }
            List<NearBySearch> nearBySearchs = (baseResp.result as List)
                .map((e) => NearBySearch.fromJson(e))
                .toList();
            _getNearbySearchController.sink.add(
              nearBySearchs,
            );
          } else {
            _getNearbySearchController.sink.add(
              <NearBySearch>[],
            );
          }
        },
      );
    } catch (err) {
      _getNearbySearchController.sink.add(
        <NearBySearch>[],
      );
    }
  }

  /// Lấy thông tin tọa độ theo địa chỉ, tìm kiếm tọa độ theo thông tin địa chỉ
  /// #required accessToken
  getLatlngByAddress(
    String searchKey, {
    ResultPlaceFrom resultPlaceFrom = ResultPlaceFrom.google_maps,
    Function(List<PlaceResult>)? onData,
  }) {
    _onRequiredAccessToken();
    try {
      LatlngByAddressInput latlngByAddressInput = LatlngByAddressInput(
        q: searchKey,
        address: searchKey,
      );
      _repository
          .getLatlngByAddress(
        this._accessToken,
        latlngByAddressInput,
      )
          .then(
        (BaseResp baseResp) {
          int errorCode = baseResp.error;
          if (errorCode == ErrorCode.SUCCESS ||
              errorCode == ErrorCode.SUCCESS_200) {
            if (baseResp.result != null) {
              List<PlaceResult> placeResults = (baseResp.result as List).map(
                (resp) {
                  return PlaceResult.fromJson(resp);
                },
              ).toList();
              if (onData != null) {
                onData(placeResults);
              }
              _getLatlngByAddressController.sink.add(placeResults);
              return;
            }
            _getLatlngByAddressController.sink.add(
              <PlaceResult>[],
            );
            if (onData != null) {
              onData(
                <PlaceResult>[],
              );
            }
            return;
          }
          _getLatlngByAddressController.sink.add(
            <PlaceResult>[],
          );
          if (onData != null) {
            onData(
              <PlaceResult>[],
            );
          }
        },
      );
    } catch (err) {
      _getLatlngByAddressController.sink.add(
        <PlaceResult>[],
      );
    }
  }

  /// Vùng phủ của tỉnh/thành
  getProvincePolygons({
    required String provinceCode,
  }) {
    _onRequiredAccessToken();
    try {
      String input = '["$provinceCode"]';
      _repository
          .getProvincePolygon(
        this._accessToken,
        input,
      )
          .then(
        (BaseResp baseResp) {
          int errorCode = baseResp.error;
          if (errorCode == ErrorCode.SUCCESS ||
              errorCode == ErrorCode.SUCCESS_200) {
            List<Geoboundaries> geoboundaries = (baseResp.result as List)
                .map((e) => Geoboundaries.fromJson(e))
                .toList();
            try {
              List<Geoboundaries> provincePolygons = [];
              Geoboundaries provincePolygon = geoboundaries[0];

              // Split encoded string by ";". Province has multiple polygons
              List<String> encodedStrings =
                  provincePolygon.geomEncoded!.split(';');
              encodedStrings.forEach((encoded) {
                Geoboundaries polygon = new Geoboundaries(
                  name: provincePolygon.name,
                  geomType: provincePolygon.geomType,
                  id: provincePolygon.id,
                  type: provincePolygon.type,
                );
                polygon.points = VnptMapUtils().decodeGeoEncoded(
                  encoded,
                );
                polygon.geomEncoded = encoded;
                provincePolygons.add(polygon);
              });
              _getProvincesPolygonController.sink.add(provincePolygons);
            } catch (e) {
              print(e.toString());
            }
          } else {}
        },
      );
    } catch (err) {}
  }

  getVietNamPolygon() {
    _onListenerGetPolygonVietnam();
    unawaited(
      _geoJson.parse(
        Raw().getVietnamPolygonRaw(),
        nameProperty: 'vietnam',
        verbose: true,
      ),
    );
  }

  _onListenerGetPolygonVietnam() {
    _geoJson.processedMultiPolygons.listen(
      (GeoJsonMultiPolygon multiPolygon) {
        List<List<LatLng>> list = [];
        for (final polygon in multiPolygon.polygons) {
          final geoSerie = GeoSerie(
            type: GeoSerieType.polygon,
            name: polygon.geoSeries[0].name,
            geoPoints: <GeoPoint>[],
          );
          for (final serie in polygon.geoSeries) {
            geoSerie.geoPoints.addAll(serie.geoPoints);
          }
          list.add(geoSerie.toLatLng(ignoreErrors: true));
        }
        _getProvincePolygonVietNamController.sink.add(list);
      },
    );
  }

  getIsochrone(
    IsochronesInput isochronesInput,
  ) {
    _onRequiredAccessToken();
    try {
      _repository
          .getIsochrone(
        this._accessToken,
        data: _RequestBodyUtils.getIIsochrones(isochronesInput),
      )
          .then(
        (BaseResp baseResp) {
          int errorCode = baseResp.error;
          if (errorCode == ErrorCode.SUCCESS ||
              errorCode == ErrorCode.SUCCESS_200) {
            Isochrone isochrone = Isochrone.fromJson(baseResp.result);
            try {
              if (isochrone.datas!.isEmpty) {
                _getIsochroneController.sink.add(null);
              }
            } catch (e) {}
            try {
              IsochronesOutput isochronesOutput = IsochronesOutput(
                orgPoint: isochronesInput.point,
                pointsGeomEncoded: VnptMapUtils().decodeGeoEncoded(
                  isochrone.datas!.first.geomEncoded!,
                ),
                geomEncoded: isochrone.datas!.first.geomEncoded,
                labels: isochrone.datas!.first.labels,
                type: isochronesInput.type,
              );
              _getIsochroneController.sink.add(isochronesOutput);
            } catch (e) {
              _getIsochroneController.sink.add(null);
            }
            return;
          }
          _getIsochroneController.sink.add(null);
        },
      );
    } catch (err) {
      _getIsochroneController.sink.add(null);
    }
  }

  getIsochrones(
    IsochronesInput isochronesInput,
  ) {
    _onRequiredAccessToken();
    try {
      _repository
          .getIsochrones(
        this._accessToken,
        data: _RequestBodyUtils.getIIsochrones(isochronesInput),
      )
          .then(
        (BaseResp baseResp) {
          int errorCode = baseResp.error;
          if (errorCode == ErrorCode.SUCCESS ||
              errorCode == ErrorCode.SUCCESS_200) {
            Isochrones isochrones = Isochrones.fromJson(baseResp.result);
            try {
              IsochronesOutput output = IsochronesOutput(
                orgPoint: isochronesInput.point,
                pointsGeomEncoded: VnptMapUtils().decodeGeoEncoded(
                  isochrones.data!.geomEncoded!,
                ),
                geomEncoded: isochrones.data!.geomEncoded,
                labels: isochrones.data!.labels,
              );
              _getIsochroneController.sink.add(output);
            } catch (e) {
              _getIsochroneController.sink.add(null);
            }
            return;
          }
          _getIsochroneController.sink.add(null);
        },
      );
    } catch (err) {
      _getIsochroneController.sink.add(null);
    }
  }

  getLalbelsBetweenIsochrone(
    LabelIsochroneInput labelInput,
  ) {
    _onRequiredAccessToken();
    try {
      _repository
          .getLabelBetweenIsochrones(
        this._accessToken,
        data: _RequestBodyUtils.getILabelIsochrones(labelInput),
      )
          .then(
        (BaseResp baseResp) {
          int errorCode = baseResp.error;
          if (errorCode == ErrorCode.SUCCESS ||
              errorCode == ErrorCode.SUCCESS_200) {
            LabelIsochroneOutput isochrone =
                LabelIsochroneOutput.fromJson(baseResp.result);
            _getLabelBetweenIsochroneController.sink.add(isochrone);
          } else {
            _getLabelBetweenIsochroneController.sink.add(null);
          }
        },
      );
    } catch (err) {
      _getLabelBetweenIsochroneController.sink.add(null);
    }
  }

  getFacilityClosest(
    IsochronesInput isochronesInput,
  ) {
    _onRequiredAccessToken();
    try {
      _repository
          .getFacilityClosest(
        this._accessToken,
        data: _RequestBodyUtils.getIIsochrones(isochronesInput),
      )
          .then(
        (BaseResp baseResp) {
          int errorCode = baseResp.error;
          if (errorCode == ErrorCode.SUCCESS ||
              errorCode == ErrorCode.SUCCESS_200) {
            List<FacilityClosestOutput> facilities =
                (baseResp.result['facility'] as List)
                    .map((e) => FacilityClosestOutput.fromJson(e))
                    .toList();
            _getFacilityClosestController.sink.add(facilities);
          } else {
            _getFacilityClosestController.sink.add(null);
          }
        },
      );
    } catch (err) {
      _getFacilityClosestController.sink.add(null);
    }
  }

  _onRequiredAccessToken() {
    if (VnptMapUtils.isNullOrBlank(this._accessToken))
      throw ('AccessToken Is Required. Must be call registerMapConfig() First!');
  }
}

class _RequestBodyUtils {
  static Map<String, dynamic> getIIsochrones(
    IsochronesInput input,
  ) {
    try {
      input.pointString = VnptMapUtils.convertStringPoint(
        input.point!,
      );
    } catch (e) {}
    return input.toJson();
  }

  static Map<String, dynamic> getILabelIsochrones(
    LabelIsochroneInput input,
  ) {
    return input.toJson();
  }
}
