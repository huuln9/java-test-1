import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vnpt_map/flutter_vnpt_map.dart';

class PlacesCompleteWidget extends StatefulWidget {
  PlacesCompleteWidget({
    required this.mapConfig,
    this.appbar,
    this.inputDecoration,
    this.itemBuilder,
    this.onData,
  });

  final MapConfig mapConfig;
  final PreferredSizeWidget? appbar;
  final InputDecoration? inputDecoration;
  final Widget Function(BuildContext, PlaceResult)? itemBuilder;
  final Function(PlaceResult)? onData;
  @override
  _AutoCompleteMapPageState createState() => _AutoCompleteMapPageState();
}

class _AutoCompleteMapPageState extends State<PlacesCompleteWidget> {
  MapService _mapService = MapService();

  List<PlaceResult> _placeResults = <PlaceResult>[];

  _fetchData(String value) {
    _mapService.getLatlngByAddress(
      value,
      onData: (List<PlaceResult> address) {
        _placeResults = address;
        setState(() {});
      },
    );
  }

  Widget _contentView() {
    return TypeAheadField<PlaceResult>(
      textFieldConfiguration: TextFieldConfiguration(
        decoration: widget.inputDecoration ??
            InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Nhập thông tin',
              hintStyle: TextStyle(
                fontSize: 18.0,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
        onChanged: (String? value) {
          _fetchData(value ?? '');
        },
      ),
      suggestionsCallback: (String pattern) async {
        return _placeResults;
      },
      itemBuilder: (context, PlaceResult result) {
        if (widget.itemBuilder != null)
          return widget.itemBuilder!(
            context,
            result,
          );
        return ListTile(
          title: Text(result.address ?? '--'),
        );
      },
      onSuggestionSelected: (PlaceResult output) {
        if (widget.onData != null) {
          widget.onData!(
            output,
          );
        }
      },
    );
  }

  @override
  void initState() {
    _mapService.setMapConfig(
      widget.mapConfig,
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appbar ??
          AppBar(
            title: Text('Tìm kiếm thông tin'),
          ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _contentView(),
      ),
    );
  }
}
