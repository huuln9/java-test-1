import 'package:flutter/material.dart';
import 'package:vncitizens_notification/src/model/notification_selector_model.dart';

class NotificationSelectorCircle extends StatelessWidget {
  final NotificationSelectorModel data;

  const NotificationSelectorCircle({Key? key, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      bottom: 0,
      child: CircleAvatar(
          radius: 14,
          backgroundColor: Colors.grey,
          child: CircleAvatar(
            radius: 13,
            backgroundColor: Colors.white,
            child: data.isSelected
                ? const Icon(
                    Icons.check_circle,
                    color: Color(0xFF0DB003),
                    size: 26,
                  )
                : null,
          )),
    );
  }
}
