import 'package:flutter/material.dart';

class PeerPALAppColor {
  PeerPALAppColor._();

  static MaterialColor primaryColor =
      MaterialColor(0xFF293F69, _primaryColorMap);
  static MaterialColor secondaryColor =
      MaterialColor(0xFFaeaeb2, secondaryColorMap);
  static final darkGreyColor = Color(0xff505050);

  static Map<int, Color> _primaryColorMap = {
    50: const Color.fromRGBO(1, 63, 105, .1),
    100: const Color.fromRGBO(1, 63, 105, .2),
    200: const Color.fromRGBO(1, 63, 105, .3),
    300: const Color.fromRGBO(1, 63, 105, .4),
    400: const Color.fromRGBO(1, 63, 105, .5),
    500: const Color.fromRGBO(1, 63, 105, .6),
    600: const Color.fromRGBO(1, 63, 105, .7),
    700: const Color.fromRGBO(1, 63, 105, .8),
    800: const Color.fromRGBO(1, 63, 105, .9),
    900: const Color.fromRGBO(1, 63, 105, 1),
  };

  static Map<int, Color> secondaryColorMap = {
    50: const Color.fromRGBO(174, 174, 178, .1),
    100: const Color.fromRGBO(174, 174, 178, .2),
    200: const Color.fromRGBO(174, 174, 178, .3),
    300: const Color.fromRGBO(174, 174, 178, .4),
    400: const Color.fromRGBO(174, 174, 178, .5),
    500: const Color.fromRGBO(174, 174, 178, .6),
    600: const Color.fromRGBO(174, 174, 178, .7),
    700: const Color.fromRGBO(174, 174, 178, .8),
    800: const Color.fromRGBO(174, 174, 178, .9),
    900: const Color.fromRGBO(174, 174, 178, 1),
  };
}
