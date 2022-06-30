import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  CircleButton({
    this.size = 40.0,
    this.icon = Icons.add,
    this.iconColor = Colors.blue,
    this.bgColor = Colors.white,
    this.hasBoxShadow = true,
    required this.onTap,
  });

  final double size;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final bool hasBoxShadow;
  final Function()? onTap;

  _buildView() {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(size / 2),
              ),
              color: bgColor,
              boxShadow: hasBoxShadow
                  ? <BoxShadow>[
                      BoxShadow(
                        color: Colors.black45,
                        blurRadius: 2.0,
                      ),
                    ]
                  : <BoxShadow>[
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 0.5,
                      ),
                    ],
            ),
            child: Center(
              child: Icon(
                icon,
                color: iconColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildView();
  }
}
