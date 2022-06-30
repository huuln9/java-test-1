# flutter_vnpt_map

SDK/Plugin VNPT Maps

## Dependencies:

## Requirement

Android:

- add these permissions below into manifest android

`<uses-permission android:name="android.permission.INTERNET"/>`

IOS: Processing

## Note:

## Usage

```dart
flutter_vnpt_map:
    path: ../gisplatform-mobile-sdk
```

## Example

- VNPT Maps App

```dart
import 'package:flutter/material.dart';
import 'package:flutter_vnpt_map/flutter_vnpt_map.dart';

class Home extends StatefulWidget {
  final String title;

  Home({required this.title,});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late VnptMap _vnptMap;

  List<Marker> _markers = <Marker>[
    Marker(
      height: 40,
      width: 40,
      point: LatLng(10.778924, 106.6880843),
      builder: (ctx) => Icon(
        Icons.location_on,
        color: Colors.blue,
        size: 40.0,
      ),
    ),
  ];

  @override
  void initState() {
    _vnptMap = VnptMap();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: _buildVnptMap(),
    );
  }

  _buildVnptMap() {
    return _vnptMap.onInit(
      zoom: 15.0,
      target: _markers.first.point,
      markers: _markers,
    );
  }
}
```
