import 'package:flutter/material.dart';

class CustomMarkerWidgetNature extends StatelessWidget {
  static const double _iconSize = 30;
  VoidCallback onPress;

  CustomMarkerWidgetNature({Key? key, required this.onPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Stack(
        clipBehavior: Clip.antiAlias,
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 12,
            left: 6,
            height: 28,
            child: Container(
              width: 28,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF61ABFF).withOpacity(0.5)
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: 14,
            height: 12,
            child: Container(
              width: 12,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white
              ),
            ),
          ),
          Positioned(
            top: 21,
            left: 15,
            height: 10,
            child: Container(
              width: 10,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF2272CD)
              ),
            ),
          ),
          const Align(
            alignment: Alignment.topCenter,
            child: Icon(
              Icons.location_on,
              color: Color(0xFF377DCD),
              size: _iconSize,
            ),
          ),
        ],
      ),
    );
  }
}
