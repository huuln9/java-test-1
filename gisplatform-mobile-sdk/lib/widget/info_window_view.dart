import 'package:flutter/material.dart';
import 'package:flutter_vnpt_map/flutter_vnpt_map.dart';

class InfoWindowView extends StatefulWidget {
  InfoWindowView({
    this.latlng,
    this.title,
    this.content,
    this.titleStyle,
    this.contentStyle,
    this.bgColor,
    this.child,
  });

  final LatLng? latlng;
  final String? title;
  final String? content;
  final TextStyle? titleStyle;
  final TextStyle? contentStyle;
  final Color? bgColor;
  final Widget? child;

  @override
  _InfoWindowState createState() => _InfoWindowState();
}

class _InfoWindowState extends State<InfoWindowView> {
  @override
  Widget build(BuildContext context) {
    return widget.child ??
        Container(
          constraints: BoxConstraints(minWidth: 100, maxWidth: 200),
          padding: EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: widget.bgColor ?? Color(0xFF2C3E50),
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: Colors.grey[400]!,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.title ??
                    'Bạn click vào bản đồ vị trí có kinh độ: ${widget.latlng!.latitude} và vĩ độ: ${widget.latlng!.longitude}',
                style: widget.titleStyle ??
                    TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
              ),
              !VnptMapUtils.isNullOrBlank(widget.content)
                  ? Padding(
                      padding: EdgeInsets.only(top: 4.0),
                      child: Text(
                        widget.content!,
                        style: widget.contentStyle ??
                            TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                      ),
                    )
                  : Container(),
            ],
          ),
        );
  }
}
