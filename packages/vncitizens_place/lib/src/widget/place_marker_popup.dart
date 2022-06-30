import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';

import '../model/hcm_place_marker.dart';

class PlaceMarkerPopup extends StatelessWidget {
  const PlaceMarkerPopup(this.marker, {Key? key}) : super(key: key);

  final HCMPlaceMarker marker;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(8),
        constraints: BoxConstraints(minWidth: 100, maxWidth: Get.width - 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              marker.place!.name != null
                  ? marker.place!.name!.toUpperCase()
                  : '',
              style: GoogleFonts.roboto(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
            _buildContentPopup(
                Icon(
                  Icons.location_on,
                  color: ColorUtils.fromString('#D51D1D'),
                ),
                marker.place!.address ?? ''),
          ],
        ),
      ),
    );
  }

  Widget _buildContentPopup(Icon icon, String content) {
    return Container(
      constraints: BoxConstraints(minWidth: 100, maxWidth: Get.width - 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          icon,
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                content,
                style: GoogleFonts.roboto(
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
