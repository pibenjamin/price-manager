/// Material Design 3 Color Tokens - Cold Blue Theme
/// PrixCourses - Professional Price Comparison App
///
/// Theme: Cold Blue (Professional, Trustworthy)
/// Primary: #1565C0 (Blue)
/// Secondary: #00897B (Teal)
/// Tertiary: #7B1FA2 (Purple)

import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary - Blue (Trust, Professionalism)
  static const Color primaryLight = Color(0xFF1565C0);
  static const Color onPrimaryLight = Color(0xFFFFFFFF);
  static const Color primaryContainerLight = Color(0xFFD6E3FF);
  static const Color onPrimaryContainerLight = Color(0xFF001B3D);

  static const Color primaryDark = Color(0xFFA8C8FF);
  static const Color onPrimaryDark = Color(0xFF00315E);
  static const Color primaryContainerDark = Color(0xFF004785);
  static const Color onPrimaryContainerDark = Color(0xFFD6E3FF);

  // Secondary - Teal (Balance, Clarity)
  static const Color secondaryLight = Color(0xFF00897B);
  static const Color onSecondaryLight = Color(0xFFFFFFFF);
  static const Color secondaryContainerLight = Color(0xFFA7F5EC);
  static const Color onSecondaryContainerLight = Color(0xFF002020);

  static const Color secondaryDark = Color(0xFF80D4CC);
  static const Color onSecondaryDark = Color(0xFF003735);
  static const Color secondaryContainerDark = Color(0xFF00504D);
  static const Color onSecondaryContainerDark = Color(0xFFA7F5EC);

  // Tertiary - Purple (Premium, Analytics)
  static const Color tertiaryLight = Color(0xFF7B1FA2);
  static const Color onTertiaryLight = Color(0xFFFFFFFF);
  static const Color tertiaryContainerLight = Color(0xFFFFD6FF);
  static const Color onTertiaryContainerLight = Color(0xFF310035);

  static const Color tertiaryDark = Color(0xFFE9B3FF);
  static const Color onTertiaryDark = Color(0xFF490052);
  static const Color tertiaryContainerDark = Color(0xFF620077);
  static const Color onTertiaryContainerDark = Color(0xFFFFD6FF);

  // Error
  static const Color errorLight = Color(0xFFBA1A1A);
  static const Color onErrorLight = Color(0xFFFFFFFF);
  static const Color errorContainerLight = Color(0xFFFFDAD6);
  static const Color onErrorContainerLight = Color(0xFF410002);

  static const Color errorDark = Color(0xFFFFB4AB);
  static const Color onErrorDark = Color(0xFF690005);
  static const Color errorContainerDark = Color(0xFF93000A);
  static const Color onErrorContainerDark = Color(0xFFFFDAD6);

  // Surface - Light
  static const Color surfaceLight = Color(0xFFFEFBFF);
  static const Color onSurfaceLight = Color(0xFF1B1B1F);
  static const Color surfaceVariantLight = Color(0xFFE0E2EC);
  static const Color onSurfaceVariantLight = Color(0xFF44474E);
  static const Color outlineLight = Color(0xFF74777F);
  static const Color outlineVariantLight = Color(0xFFC4C6D0);

  // Surface - Dark
  static const Color surfaceDark = Color(0xFF1B1B1F);
  static const Color onSurfaceDark = Color(0xFFE4E1E6);
  static const Color surfaceVariantDark = Color(0xFF44474E);
  static const Color onSurfaceVariantDark = Color(0xFFC4C6D0);
  static const Color outlineDark = Color(0xFF8E9099);
  static const Color outlineVariantDark = Color(0xFF44474E);

  // Background
  static const Color backgroundLight = Color(0xFFFEFBFF);
  static const Color onBackgroundLight = Color(0xFF1B1B1F);
  static const Color backgroundDark = Color(0xFF1B1B1F);
  static const Color onBackgroundDark = Color(0xFFE4E1E6);

  // Inverse
  static const Color inverseSurfaceLight = Color(0xFF303033);
  static const Color onInverseSurfaceLight = Color(0xFFF2F0F4);
  static const Color inversePrimaryLight = Color(0xFFA6C8FF);

  static const Color inverseSurfaceDark = Color(0xFFE4E1E6);
  static const Color onInverseSurfaceDark = Color(0xFF303033);
  static const Color inversePrimaryDark = Color(0xFF4A6FAA);

  // Scrim
  static const Color scrim = Color(0xFF000000);

  // Shadow
  static const Color shadowLight = Color(0xFF000000);
  static const Color shadowDark = Color(0xFF000000);

  // Surface Tones (M3 Elevation)
  static const Color surfaceTintLight = primaryLight;
  static const Color surfaceTintDark = primaryDark;

  // Functional Colors
  static const Color priceGood = Color(0xFF4CAF50);
  static const Color priceBad = Color(0xFFFF9800);
  static const Color priceNeutral = Color(0xFF9E9E9E);

  // Light Color Scheme
  static ColorScheme get lightColorScheme => const ColorScheme(
        brightness: Brightness.light,
        primary: primaryLight,
        onPrimary: onPrimaryLight,
        primaryContainer: primaryContainerLight,
        onPrimaryContainer: onPrimaryContainerLight,
        secondary: secondaryLight,
        onSecondary: onSecondaryLight,
        secondaryContainer: secondaryContainerLight,
        onSecondaryContainer: onSecondaryContainerLight,
        tertiary: tertiaryLight,
        onTertiary: onTertiaryLight,
        tertiaryContainer: tertiaryContainerLight,
        onTertiaryContainer: onTertiaryContainerLight,
        error: errorLight,
        onError: onErrorLight,
        errorContainer: errorContainerLight,
        onErrorContainer: onErrorContainerLight,
        surface: surfaceLight,
        onSurface: onSurfaceLight,
        surfaceContainerHighest: surfaceVariantLight,
        onSurfaceVariant: onSurfaceVariantLight,
        outline: outlineLight,
        outlineVariant: outlineVariantLight,
        shadow: shadowLight,
        scrim: scrim,
        inverseSurface: inverseSurfaceLight,
        onInverseSurface: onInverseSurfaceLight,
        inversePrimary: inversePrimaryLight,
        surfaceTint: surfaceTintLight,
      );

  // Dark Color Scheme
  static ColorScheme get darkColorScheme => const ColorScheme(
        brightness: Brightness.dark,
        primary: primaryDark,
        onPrimary: onPrimaryDark,
        primaryContainer: primaryContainerDark,
        onPrimaryContainer: onPrimaryContainerDark,
        secondary: secondaryDark,
        onSecondary: onSecondaryDark,
        secondaryContainer: secondaryContainerDark,
        onSecondaryContainer: onSecondaryContainerDark,
        tertiary: tertiaryDark,
        onTertiary: onTertiaryDark,
        tertiaryContainer: tertiaryContainerDark,
        onTertiaryContainer: onTertiaryContainerDark,
        error: errorDark,
        onError: onErrorDark,
        errorContainer: errorContainerDark,
        onErrorContainer: onErrorContainerDark,
        surface: surfaceDark,
        onSurface: onSurfaceDark,
        surfaceContainerHighest: surfaceVariantDark,
        onSurfaceVariant: onSurfaceVariantDark,
        outline: outlineDark,
        outlineVariant: outlineVariantDark,
        shadow: shadowDark,
        scrim: scrim,
        inverseSurface: inverseSurfaceDark,
        onInverseSurface: onInverseSurfaceDark,
        inversePrimary: inversePrimaryDark,
        surfaceTint: surfaceTintDark,
      );
}
