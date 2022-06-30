import 'package:flutter/material.dart';
import 'package:flutter_vnpt_map/model/index.dart';

class DirectionUtils {
  static const String k_text = 'text';
  static const String k_icon = 'icon';
  static const String k_sign = 'sign';

  static const String k_continueOn = 'continueOn';
  static const String k_turnSlightRight = 'turnSlightRight';
  static const String k_turnRight = 'turnRight';
  static const String k_turnSharpRight = 'turnSharpRight';
  static const String k_finish = 'finish';
  static const String k_viaReached = 'viaReached';
  static const String k_atRoundabout = 'atRoundabout';
  static const String k_keepRight = 'keepRight';
  static const String k_unk8 = 'unk8';
  static const String k_turnSlightLeft = 'turnSlightLeft';
  static const String k_turnLeft = 'turnLeft';
  static const String k_turnSharpLeft = 'turnSharpLeft';
  static const String k_unk6 = 'unk6';
  static const String k_keepLeft = 'keepLeft';
  static const String k_uTurn = 'uTurn';

  static const String ic_continue_on = 'assets/icons/continue.png';
  static const String ic_finish = 'assets/icons/finish.png';
  static const String ic_keep_left = 'assets/icons/keep-left.png';
  static const String ic_keep_right = 'assets/icons/keep-right.png';
  static const String ic_roundabout = 'assets/icons/roundabout.png';
  static const String ic_turn_left = 'assets/icons/turn-left.png';
  static const String ic_turn_right = 'assets/icons/turn-right.png';
  static const String ic_turn_shape_left = 'assets/icons/turn-sharp-left.png';
  static const String ic_turn_shape_right = 'assets/icons/turn-sharp-right.png';
  static const String ic_turn_slight_left = 'assets/icons/turn-slight-left.png';
  static const String ic_turn_slight_right =
      'assets/icons/turn-slight-right.png';
  static const String ic_u_turn = 'assets/icons/u-turn.png';
  static const String ic_unknow = 'assets/icons/unknow.png';

  static const int sign_continue_on = 0;
  static const int sign_turn_slight_right = 1;
  static const int sign_turn_right = 2;
  static const int sign_turn_shape_right = 3;
  static const int sign_finish = 4;
  static const int sign_via_reached = 5;
  static const int sign_roundabout = 6;
  static const int sign_keep_right = 7;
  static const int sign_unk_8 = 8;
  static const int sign_turn_slight_left = -1;
  static const int sign_turn_left = -2;
  static const int sign_turn_shape_left = -3;
  static const int sign_unk_u6 = -6;
  static const int sign_keep_left = -7;
  static const int sign_u_turn = -8;

  Map<String, dynamic> getDirectionSignMap() {
    return {
      k_continueOn: {
        k_text: 'Tiếp tục đi thẳng',
        k_icon: ic_continue_on,
        k_sign: sign_continue_on
      },
      k_turnSlightRight: {
        k_text: 'Hơi rẽ sang phải vào',
        k_icon: ic_turn_slight_right,
        k_sign: sign_turn_slight_right
      },
      k_turnRight: {
        k_text: 'Rẽ phải vào',
        k_icon: ic_turn_right,
        k_sign: sign_turn_right
      },
      k_turnSharpRight: {
        k_text: 'Ôm sát sang phải vào',
        k_icon: ic_turn_shape_right,
        k_sign: sign_turn_shape_right
      },
      k_finish: {k_text: 'Kết thúc', k_icon: ic_finish, k_sign: sign_finish},
      k_viaReached: {
        k_text: 'Tiếp cận',
        k_icon: ic_unknow,
        k_sign: sign_via_reached
      },
      k_atRoundabout: {
        k_text: 'Tại vòng xoay, đi theo lối ra vào',
        k_icon: ic_roundabout,
        k_sign: sign_roundabout
      },
      k_keepRight: {
        k_text: 'Đi về hướng bên phải',
        k_icon: ic_keep_right,
        k_sign: sign_keep_right
      },
      k_unk8: {
        k_text: 'Chưa rõ chỉ đường',
        k_icon: ic_unknow,
        k_sign: sign_unk_8
      },
      k_turnSlightLeft: {
        k_text: 'Hơi rẽ sang trái vào',
        k_icon: ic_turn_slight_left,
        k_sign: sign_turn_slight_left
      },
      k_turnLeft: {
        k_text: 'Rẽ trái vào',
        k_icon: ic_turn_left,
        k_sign: sign_turn_left
      },
      k_turnSharpLeft: {
        k_text: 'Ôm sát sang trái vào',
        k_icon: ic_turn_shape_left,
        k_sign: sign_turn_shape_left
      },
      k_unk6: {
        k_text: 'Chưa rõ chỉ đường',
        k_icon: ic_unknow,
        k_sign: sign_unk_u6
      },
      k_keepLeft: {
        k_text: 'Đi về hướng bên trái',
        k_icon: ic_keep_left,
        k_sign: sign_keep_left
      },
      k_uTurn: {
        k_text: 'Quay đầu lại vào',
        k_icon: ic_u_turn,
        k_sign: sign_u_turn
      }
    };
  }

  DirectionSign getPropDirectionSign(
    int sign, {
    double size = 35.0,
    Widget? child,
  }) {
    String package = 'flutter_vnpt_map';
    DirectionSign directionSign;
    switch (sign) {
      case sign_continue_on:
        directionSign = DirectionSign(
            text: 'Tiếp tục đi thẳng',
            child: child ??
                Image.asset(
                  ic_continue_on,
                  height: size,
                  width: size,
                  package: package,
                ),
            sign: sign_continue_on);
        break;
      case sign_turn_slight_right:
        directionSign = DirectionSign(
            text: 'Hơi rẽ sang phải vào',
            child: child ??
                Image.asset(
                  ic_turn_slight_right,
                  height: size,
                  width: size,
                  package: package,
                ),
            sign: sign_turn_slight_right);
        break;
      case sign_turn_right:
        directionSign = DirectionSign(
            text: 'Rẽ phải vào',
            child: child ??
                Image.asset(
                  ic_turn_right,
                  height: size,
                  width: size,
                  package: package,
                ),
            sign: sign_turn_right);
        break;
      case sign_turn_shape_right:
        directionSign = DirectionSign(
            text: 'Ôm sát sang phải vào',
            child: child ??
                Image.asset(
                  ic_turn_shape_right,
                  height: size,
                  width: size,
                  package: package,
                ),
            sign: sign_turn_shape_right);
        break;
      case sign_finish:
        directionSign = DirectionSign(
            text: 'Kết thúc',
            child: child ??
                Image.asset(
                  ic_finish,
                  height: size,
                  width: size,
                  package: package,
                ),
            sign: sign_finish);
        break;
      case sign_via_reached:
        directionSign = DirectionSign(
            text: 'Tiếp cận',
            child: child ??
                Image.asset(
                  ic_unknow,
                  height: size,
                  width: size,
                  package: package,
                ),
            sign: sign_via_reached);
        break;
      case sign_roundabout:
        directionSign = DirectionSign(
            text: 'Tại vòng xoay, đi theo lối ra vào',
            child: child ??
                Image.asset(
                  ic_roundabout,
                  height: size,
                  width: size,
                  package: package,
                ),
            sign: sign_roundabout);
        break;
      case sign_keep_right:
        directionSign = DirectionSign(
            text: 'Đi về hướng bên phải',
            child: child ??
                Image.asset(
                  ic_keep_right,
                  height: size,
                  width: size,
                  package: package,
                ),
            sign: sign_keep_right);
        break;
      case sign_unk_8:
        directionSign = DirectionSign(
            text: 'Chưa rõ chỉ đường',
            child: child ??
                Image.asset(
                  ic_unknow,
                  height: size,
                  width: size,
                  package: package,
                ),
            sign: sign_unk_8);
        break;
      case sign_turn_slight_left:
        directionSign = DirectionSign(
            text: 'Hơi rẽ sang trái vào',
            child: child ??
                Image.asset(
                  ic_turn_slight_left,
                  height: size,
                  width: size,
                  package: package,
                ),
            sign: sign_turn_slight_left);
        break;
      case sign_turn_left:
        directionSign = DirectionSign(
            text: 'Rẽ trái vào',
            child: child ??
                Image.asset(
                  ic_turn_left,
                  height: size,
                  width: size,
                  package: package,
                ),
            sign: sign_turn_left);
        break;
      case sign_turn_shape_left:
        directionSign = DirectionSign(
            text: 'Ôm sát sang trái vào',
            child: child ??
                Image.asset(
                  ic_turn_shape_left,
                  height: size,
                  width: size,
                  package: package,
                ),
            sign: sign_turn_shape_left);
        break;
      case sign_unk_u6:
        directionSign = DirectionSign(
            text: 'Chưa rõ chỉ đường',
            child: child ??
                Image.asset(
                  ic_unknow,
                  height: size,
                  width: size,
                  package: package,
                ),
            sign: sign_unk_u6);
        break;
      case sign_keep_left:
        directionSign = DirectionSign(
            text: 'Đi về hướng bên trái',
            child: child ??
                Image.asset(
                  ic_keep_left,
                  height: size,
                  width: size,
                  package: package,
                ),
            sign: sign_keep_left);
        break;
      case sign_u_turn:
        directionSign = DirectionSign(
            text: 'Quay đầu lại vào',
            child: child ??
                Image.asset(
                  ic_u_turn,
                  height: size,
                  width: size,
                  package: package,
                ),
            sign: sign_u_turn);
        break;
      default:
        directionSign = DirectionSign(
            text: 'Chưa rõ chỉ đường',
            child: child ??
                Image.asset(
                  ic_unknow,
                  height: size,
                  width: size,
                  package: package,
                ),
            sign: sign_unk_8);
        break;
    }
    return directionSign;
  }
}
