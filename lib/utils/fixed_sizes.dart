import 'package:flutter/material.dart';

class FixedSizes {
  static double _width(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static bool _isMobile(BuildContext context) => _width(context) < 600;
  static bool _isTablet(BuildContext context) =>
      _width(context) >= 600 && _width(context) <= 1024;
  static bool isDesktop(BuildContext context) => _width(context) > 1024;

  // --- Spacing ---
  static double spacing(BuildContext context) {
    if (_isMobile(context)) return 12.0;
    if (_isTablet(context)) return 16.0;
    return 20.0;
  }

  // --- Font sizes ---
  static double font10(BuildContext context) => _isMobile(context)
      ? 10
      : _isTablet(context)
      ? 11
      : 12;
  static double font12(BuildContext context) => _isMobile(context)
      ? 12
      : _isTablet(context)
      ? 12
      : 14;
  static double font14(BuildContext context) => _isMobile(context)
      ? 14
      : _isTablet(context)
      ? 14
      : 16;
  static double font16(BuildContext context) => _isMobile(context)
      ? 14
      : _isTablet(context)
      ? 16
      : 18;
  static double font18(BuildContext context) => _isMobile(context)
      ? 16
      : _isTablet(context)
      ? 18
      : 20;
  static double font20(BuildContext context) => _isMobile(context)
      ? 16
      : _isTablet(context)
      ? 18
      : 20;
  static double font22(BuildContext context) => _isMobile(context)
      ? 18
      : _isTablet(context)
      ? 20
      : 22;
  static double font24(BuildContext context) => _isMobile(context)
      ? 20
      : _isTablet(context)
      ? 22
      : 24;
      static double font28(BuildContext context) => _isMobile(context)
      ? 24
      : _isTablet(context)
      ? 26
      : 28;
  static double font32(BuildContext context) => _isMobile(context)
      ? 28
      : _isTablet(context)
      ? 30
      : 32;

  static double font35(BuildContext context) => _isMobile(context)
      ? 28
      : _isTablet(context)
      ? 32
      : 35;
  static double font40(BuildContext context) => _isMobile(context)
      ? 32
      : _isTablet(context)
      ? 38
      : 40;
  static double fontSmall(BuildContext context) => _isMobile(context)
      ? 12
      : _isTablet(context)
      ? 13
      : 14;

  // --- Box sizes ---
  static double box2(BuildContext context) => _isMobile(context)
      ? 2
      : _isTablet(context)
      ? 2
      : 3;
  static double box4(BuildContext context) => _isMobile(context)
      ? 4
      : _isTablet(context)
      ? 4
      : 5;
      static double box5(BuildContext context) => _isMobile(context)
      ? 5
      : _isTablet(context)
      ? 5
      : 6;
  static double box6(BuildContext context) => _isMobile(context)
      ? 6
      : _isTablet(context)
      ? 6
      : 7;
  static double box8(BuildContext context) => _isMobile(context)
      ? 8
      : _isTablet(context)
      ? 10
      : 12;
      static double box10(BuildContext context) => _isMobile(context)
      ? 10
      : _isTablet(context)
      ? 12
      : 14;
  static double box12(BuildContext context) => _isMobile(context)
      ? 10
      : _isTablet(context)
      ? 12
      : 14;

      static double box14(BuildContext context) => _isMobile(context)
      ? 12
      : _isTablet(context)
      ? 14
      : 16;
  static double box16(BuildContext context) => _isMobile(context)
      ? 14
      : _isTablet(context)
      ? 16
      : 18;
  static double box20(BuildContext context) => _isMobile(context)
      ? 16
      : _isTablet(context)
      ? 20
      : 24;
  static double box24(BuildContext context) => _isMobile(context)
      ? 20
      : _isTablet(context)
      ? 24
      : 28;
  static double box25(BuildContext context) => _isMobile(context)
      ? 20
      : _isTablet(context)
      ? 25
      : 28;
  static double box28(BuildContext context) => _isMobile(context)
      ? 24
      : _isTablet(context)
      ? 28
      : 32;
  static double box30(BuildContext context) => _isMobile(context)
      ? 24
      : _isTablet(context)
      ? 30
      : 36;
  static double box32(BuildContext context) => _isMobile(context)
      ? 28
      : _isTablet(context)
      ? 32
      : 36;
  static double box35(BuildContext context) => _isMobile(context)
      ? 30
      : _isTablet(context)
      ? 32
      : 35;
  static double box40(BuildContext context) => _isMobile(context)
      ? 30
      : _isTablet(context)
      ? 40
      : 50;
  static double box48(BuildContext context) => _isMobile(context)
      ? 44
      : _isTablet(context)
      ? 48
      : 52;
  static double box50(BuildContext context) => _isMobile(context)
      ? 50
      : _isTablet(context)
      ? 55
      : 60;
      static double box56(BuildContext context) => _isMobile(context)
      ? 55
      : _isTablet(context)
      ? 60
      : 65;
  static double box80(BuildContext context) => _isMobile(context)
      ? 80
      : _isTablet(context)
      ? 90
      : 100;
  static double box100(BuildContext context) => _isMobile(context)
      ? 100
      : _isTablet(context)
      ? 120
      : 140;
  static double box150(BuildContext context) => _isMobile(context)
      ? 120
      : _isTablet(context)
      ? 140
      : 150;
  static double box240(BuildContext context) => _isMobile(context)
      ? 200
      : _isTablet(context)
      ? 220
      : 240;
  static double box620(BuildContext context) => _isMobile(context)
      ? 500
      : _isTablet(context)
      ? 580
      : 620;
  static double box18(BuildContext context) => _isMobile(context)
      ? 16
      : _isTablet(context)
      ? 18
      : 20;
  static double box60(BuildContext context) => _isMobile(context)
      ? 50
      : _isTablet(context)
      ? 60
      : 70;
  static double box120(BuildContext context) => _isMobile(context)
      ? 100
      : _isTablet(context)
      ? 120
      : 140;
  static double box200(BuildContext context) => _isMobile(context)
      ? 180
      : _isTablet(context)
      ? 200
      : 220;
  static double box300(BuildContext context) => _isMobile(context)
      ? 250
      : _isTablet(context)
      ? 280
      : 300;
  static double box350(BuildContext context) => _isMobile(context)
      ? 300
      : _isTablet(context)
      ? 330
      : 350;
  static double box220(BuildContext context) => _isMobile(context)
      ? 180
      : _isTablet(context)
      ? 200
      : 220;

  // --- Border radii ---
  static double radius4(BuildContext context) => _isMobile(context)
      ? 4
      : _isTablet(context)
      ? 4
      : 6;
  static double radius8(BuildContext context) => _isMobile(context)
      ? 8
      : _isTablet(context)
      ? 8
      : 10;
      static double radius10(BuildContext context) => _isMobile(context)
      ? 10
      : _isTablet(context)
      ? 10
      : 12;
  static double radius12(BuildContext context) => _isMobile(context)
      ? 12
      : _isTablet(context)
      ? 12
      : 14;
  static double radius16(BuildContext context) => _isMobile(context)
      ? 14
      : _isTablet(context)
      ? 16
      : 18;
      
  static double radius24(BuildContext context) => _isMobile(context)
      ? 20
      : _isTablet(context)
      ? 22
      : 24;
  static double radius50(BuildContext context) => _isMobile(context)
      ? 40
      : _isTablet(context)
      ? 50
      : 60;
  static double borderRadius(BuildContext context) => _isMobile(context)
      ? 20
      : _isTablet(context)
      ? 24
      : 30;

  // --- Headings ---
  static double fontHeading(BuildContext context) => _isMobile(context)
      ? 28
      : _isTablet(context)
      ? 32
      : 36;
  static double fontSubtitle(BuildContext context) => _isMobile(context)
      ? 16
      : _isTablet(context)
      ? 18
      : 20;
  static double fontHeadingAuth(BuildContext context) => _isMobile(context)
      ? 24
      : _isTablet(context)
      ? 26
      : 28;
  static double fontBody(BuildContext context) => _isMobile(context)
      ? 12
      : _isTablet(context)
      ? 14
      : 16;
  static double fontTitle(BuildContext context) => _isMobile(context)
      ? 18
      : _isTablet(context)
      ? 20
      : 22;

  // --- Icon sizes ---
  static double iconSize(BuildContext context) => _isMobile(context)
      ? 16
      : _isTablet(context)
      ? 20
      : 24;
  static double icon16(BuildContext context) => _isMobile(context)
      ? 14
      : _isTablet(context)
      ? 16
      : 18;
  static double icon20(BuildContext context) => _isMobile(context)
      ? 18
      : _isTablet(context)
      ? 20
      : 22;
      static double icon24(BuildContext context) => _isMobile(context)
      ? 22
      : _isTablet(context)
      ? 22
      : 24;
      static double icon28(BuildContext context) => _isMobile(context)
      ? 26
      : _isTablet(context)
      ? 26
      : 28;
      static double icon32(BuildContext context) => _isMobile(context)
      ? 30
      : _isTablet(context)
      ? 30
      : 32;
      static double icon40(BuildContext context) => _isMobile(context)
      ? 38
      : _isTablet(context)
      ? 38
      : 40;
      static double icon48(BuildContext context) => _isMobile(context)
      ? 46
      : _isTablet(context)
      ? 48
      : 50;

  // --- Button sizes ---
  static double buttonHeightStandard(BuildContext context) => box48(context);
  static double buttonWidthStandard(BuildContext context) => box100(context);
  static double buttonSize(BuildContext context) => _isMobile(context)
      ? 48
      : _isTablet(context)
      ? 56
      : 64;
  static double buttonHeight(BuildContext context) => box48(context);
  static double buttonWidth(BuildContext context) => box100(context);

  static double authButtonWidth(BuildContext context) => _isMobile(context)
      ? 250
      : _isTablet(context)
      ? 280
      : 300;
  static double welcomeButtonWidth(BuildContext context) => _isMobile(context)
      ? 200
      : _isTablet(context)
      ? 250
      : 300;

  // --- Form max width ---
  static double formMaxWidth(BuildContext context) => _isMobile(context)
      ? 320
      : _isTablet(context)
      ? 400
      : 480;

  // --- Avatar ---
  static double avatarRadius(BuildContext context) => _isMobile(context)
      ? 40
      : _isTablet(context)
      ? 50
      : 60;

  // --- Google button/icon ---
  static double googleIcon(BuildContext context) => _isMobile(context)
      ? 80
      : _isTablet(context)
      ? 90
      : 100;
  // --- Custom helper ---
  static double custom(
    double mobile,
    double tablet,
    double desktop,
    BuildContext context,
  ) {
    if (_isMobile(context)) return mobile;
    if (_isTablet(context)) return tablet;
    return desktop;
  }
}
