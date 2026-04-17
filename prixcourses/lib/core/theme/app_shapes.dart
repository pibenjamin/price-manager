/// Material Design 3 Shapes
/// PrixCourses - Professional Price Comparison App
///
/// Corner radii following M3 specifications

import 'package:flutter/material.dart';

class AppShapes {
  AppShapes._();

  // M3 Corner Sizes
  static const double extraSmall = 4.0;
  static const double small = 8.0;
  static const double medium = 12.0;
  static const double large = 16.0;
  static const double extraLarge = 28.0;
  static const double full = 999999.0;

  // Shape Borders
  static BorderRadius get extraSmallBorder => BorderRadius.circular(extraSmall);
  static BorderRadius get smallBorder => BorderRadius.circular(small);
  static BorderRadius get mediumBorder => BorderRadius.circular(medium);
  static BorderRadius get largeBorder => BorderRadius.circular(large);
  static BorderRadius get extraLargeBorder => BorderRadius.circular(extraLarge);
  static BorderRadius get fullBorder => BorderRadius.circular(full);

  // Shape Themes
  static ShapeBorder get extraSmallShape => RoundedRectangleBorder(
        borderRadius: extraSmallBorder,
      );

  static ShapeBorder get smallShape => RoundedRectangleBorder(
        borderRadius: smallBorder,
      );

  static ShapeBorder get mediumShape => RoundedRectangleBorder(
        borderRadius: mediumBorder,
      );

  static ShapeBorder get largeShape => RoundedRectangleBorder(
        borderRadius: largeBorder,
      );

  static ShapeBorder get extraLargeShape => RoundedRectangleBorder(
        borderRadius: extraLargeBorder,
      );

  static ShapeBorder get fullShape => RoundedRectangleBorder(
        borderRadius: fullBorder,
      );

  static ShapeBorder get filledButtonShape => RoundedRectangleBorder(
        borderRadius: fullBorder,
      );

  static ShapeBorder get outlinedButtonShape => RoundedRectangleBorder(
        borderRadius: fullBorder,
      );

  static ShapeBorder get cardShape => RoundedRectangleBorder(
        borderRadius: mediumBorder,
      );

  static ShapeBorder get chipShape => RoundedRectangleBorder(
        borderRadius: smallBorder,
      );

  static ShapeBorder get dialogShape => RoundedRectangleBorder(
        borderRadius: extraLargeBorder,
      );

  static ShapeBorder get bottomSheetShape => const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(extraLarge),
          topRight: Radius.circular(extraLarge),
        ),
      );

  static ShapeBorder get snackBarShape => RoundedRectangleBorder(
        borderRadius: smallBorder,
      );

  // M3 Elevation Surfaces (for tonal elevation simulation)
  static Color getSurfaceTint(BuildContext context, Color defaultColor) {
    final colorScheme = Theme.of(context).colorScheme;
    return colorScheme.primary;
  }
}
