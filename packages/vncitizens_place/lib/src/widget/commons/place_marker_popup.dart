import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_place/src/controller/place_controller.dart';
import 'package:vncitizens_place/src/model/place_marker.dart';

class PlaceMarkerPopup extends StatelessWidget {
  PlaceMarkerPopup(this.marker, {Key? key}) : super(key: key);

  final PlaceMarker marker;
  final _ctrl = Get.put(PlaceController());

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(5),
        constraints: const BoxConstraints(minWidth: 100, maxWidth: 300),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              width: 300,
              child: Text(
                marker.place.name,
                style: GoogleFonts.roboto(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                softWrap: false,
              ),
            ),
            _buildContentPopup(
                const Icon(Icons.location_on, size: 16), marker.place.address),
            _buildContentPopup(
                InkWell(
                  child: const Icon(Icons.phone_in_talk, size: 16),
                  onTap: () {
                    if (marker.place.data != null &&
                        marker.place.data['phone'] != null) {
                      _ctrl.makeCall(marker.place.data['phone']);
                    }
                  },
                ),
                marker.place.data != null && marker.place.data['phone'] != null
                    ? marker.place.data['phone']
                    : ''),
          ],
        ),
      ),
    );
  }

  Widget _buildContentPopup(Widget widget, String content) {
    return Container(
      constraints: const BoxConstraints(minWidth: 100, maxWidth: 300),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          widget,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              content,
              style: GoogleFonts.roboto(
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: false,
            ),
          ),
        ],
      ),
    );
  }
}
