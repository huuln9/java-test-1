import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';

class PlaceMarkerNoDataPopup extends StatelessWidget {
  const PlaceMarkerNoDataPopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(5),
        constraints: const BoxConstraints(minWidth: 100, maxWidth: 250),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "khong tim thay dia diem".tr.toUpperCase(),
              style: GoogleFonts.roboto(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
