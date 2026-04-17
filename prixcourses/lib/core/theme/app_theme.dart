/// EPIC X: [Titre Epic]
/// STORY X.Y: [Titre Story]
///
/// Responsabilités:
/// - Fournit le thème Material Design 3
/// - Supporte Light/Dark Mode
/// - Exporte les couleurs fonctionnelles (prix)
///
/// Critères d'acceptation:
/// - ThemeData avec ColorScheme M3
/// - Support dark mode natif
/// - Typography M3
/// - Shapes M3

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_shapes.dart';

class AppTheme {
  AppTheme._();

  static const Color priceGood = AppColors.priceGood;
  static const Color priceBad = AppColors.priceBad;
  static const Color priceNeutral = AppColors.priceNeutral;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: AppColors.lightColorScheme,
      textTheme: AppTypography.textTheme.apply(
        bodyColor: AppColors.onSurfaceLight,
        displayColor: AppColors.onSurfaceLight,
      ),
      scaffoldBackgroundColor: AppColors.backgroundLight,

      // AppBar
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 3,
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.onSurfaceLight,
        surfaceTintColor: AppColors.surfaceTintLight,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),

      // Navigation Bar (M3)
      navigationBarTheme: NavigationBarThemeData(
        height: 80,
        elevation: 3,
        backgroundColor: AppColors.surfaceLight,
        surfaceTintColor: AppColors.surfaceTintLight,
        indicatorColor: AppColors.primaryContainerLight,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(
              color: AppColors.onPrimaryContainerLight,
              size: 24,
            );
          }
          return const IconThemeData(
            color: AppColors.onSurfaceVariantLight,
            size: 24,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTypography.labelMedium.copyWith(
              color: AppColors.onSurfaceLight,
            );
          }
          return AppTypography.labelMedium.copyWith(
            color: AppColors.onSurfaceVariantLight,
          );
        }),
      ),

      // Cards (M3)
      cardTheme: CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: AppShapes.mediumBorder,
        ),
        color: AppColors.surfaceLight,
        surfaceTintColor: AppColors.surfaceTintLight,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 1,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: AppShapes.fullBorder,
          ),
          backgroundColor: AppColors.primaryLight,
          foregroundColor: AppColors.onPrimaryLight,
        ),
      ),

      // Filled Button (M3)
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: AppShapes.fullBorder,
          ),
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: AppShapes.fullBorder,
          ),
          side: const BorderSide(color: AppColors.outlineLight),
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: AppShapes.fullBorder,
          ),
        ),
      ),

      // FAB (M3)
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 3,
        highlightElevation: 4,
        backgroundColor: AppColors.primaryContainerLight,
        foregroundColor: AppColors.onPrimaryContainerLight,
        shape: RoundedRectangleBorder(
          borderRadius: AppShapes.largeBorder,
        ),
      ),

      // Input Decoration (M3)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariantLight.withValues(alpha: 0.5),
        border: OutlineInputBorder(
          borderRadius: AppShapes.extraLargeBorder,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppShapes.extraLargeBorder,
          borderSide: const BorderSide(color: AppColors.outlineLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppShapes.extraLargeBorder,
          borderSide: const BorderSide(color: AppColors.primaryLight, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppShapes.extraLargeBorder,
          borderSide: const BorderSide(color: AppColors.errorLight),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),

      // Chips (M3)
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceLight,
        selectedColor: AppColors.secondaryContainerLight,
        labelStyle: AppTypography.labelLarge,
        shape: RoundedRectangleBorder(
          borderRadius: AppShapes.smallBorder,
        ),
        side: const BorderSide(color: AppColors.outlineLight),
      ),

      // List Tile (M3)
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppShapes.small)),
        ),
      ),

      // Dialog (M3)
      dialogTheme: DialogThemeData(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: AppShapes.extraLargeBorder,
        ),
        backgroundColor: AppColors.surfaceLight,
        surfaceTintColor: AppColors.surfaceTintLight,
      ),

      // Bottom Sheet (M3)
      bottomSheetTheme: const BottomSheetThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppShapes.extraLarge),
            topRight: Radius.circular(AppShapes.extraLarge),
          ),
        ),
        backgroundColor: AppColors.surfaceLight,
        surfaceTintColor: AppColors.surfaceTintLight,
        showDragHandle: true,
        dragHandleColor: AppColors.onSurfaceVariantLight,
      ),

      // Snackbar (M3)
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: AppShapes.smallBorder,
        ),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: AppColors.outlineVariantLight,
        thickness: 1,
        space: 1,
      ),

      // Icon
      iconTheme: const IconThemeData(
        color: AppColors.onSurfaceVariantLight,
        size: 24,
      ),

      // Bottom Navigation (legacy)
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceLight,
        selectedItemColor: AppColors.primaryLight,
        unselectedItemColor: AppColors.onSurfaceVariantLight,
      ),

      // Progress Indicator
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primaryLight,
        linearTrackColor: AppColors.surfaceVariantLight,
        circularTrackColor: AppColors.surfaceVariantLight,
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.onPrimaryLight;
          }
          return AppColors.outlineLight;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryLight;
          }
          return AppColors.surfaceVariantLight;
        }),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: AppColors.darkColorScheme,
      textTheme: AppTypography.textTheme.apply(
        bodyColor: AppColors.onSurfaceDark,
        displayColor: AppColors.onSurfaceDark,
      ),
      scaffoldBackgroundColor: AppColors.backgroundDark,

      // AppBar
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 3,
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: AppColors.onSurfaceDark,
        surfaceTintColor: AppColors.surfaceTintDark,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),

      // Navigation Bar (M3)
      navigationBarTheme: NavigationBarThemeData(
        height: 80,
        elevation: 3,
        backgroundColor: AppColors.surfaceDark,
        surfaceTintColor: AppColors.surfaceTintDark,
        indicatorColor: AppColors.primaryContainerDark,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(
              color: AppColors.onPrimaryContainerDark,
              size: 24,
            );
          }
          return const IconThemeData(
            color: AppColors.onSurfaceVariantDark,
            size: 24,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTypography.labelMedium.copyWith(
              color: AppColors.onSurfaceDark,
            );
          }
          return AppTypography.labelMedium.copyWith(
            color: AppColors.onSurfaceVariantDark,
          );
        }),
      ),

      // Cards (M3)
      cardTheme: CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: AppShapes.mediumBorder,
        ),
        color: AppColors.surfaceDark,
        surfaceTintColor: AppColors.surfaceTintDark,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 1,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: AppShapes.fullBorder,
          ),
          backgroundColor: AppColors.primaryDark,
          foregroundColor: AppColors.onPrimaryDark,
        ),
      ),

      // Filled Button (M3)
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: AppShapes.fullBorder,
          ),
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: AppShapes.fullBorder,
          ),
          side: const BorderSide(color: AppColors.outlineDark),
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: AppShapes.fullBorder,
          ),
        ),
      ),

      // FAB (M3)
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 3,
        highlightElevation: 4,
        backgroundColor: AppColors.primaryContainerDark,
        foregroundColor: AppColors.onPrimaryContainerDark,
        shape: RoundedRectangleBorder(
          borderRadius: AppShapes.largeBorder,
        ),
      ),

      // Input Decoration (M3)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariantDark.withValues(alpha: 0.5),
        border: OutlineInputBorder(
          borderRadius: AppShapes.extraLargeBorder,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppShapes.extraLargeBorder,
          borderSide: const BorderSide(color: AppColors.outlineDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppShapes.extraLargeBorder,
          borderSide: const BorderSide(color: AppColors.primaryDark, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppShapes.extraLargeBorder,
          borderSide: const BorderSide(color: AppColors.errorDark),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),

      // Chips (M3)
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceDark,
        selectedColor: AppColors.secondaryContainerDark,
        labelStyle: AppTypography.labelLarge,
        shape: RoundedRectangleBorder(
          borderRadius: AppShapes.smallBorder,
        ),
        side: const BorderSide(color: AppColors.outlineDark),
      ),

      // List Tile (M3)
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppShapes.small)),
        ),
      ),

      // Dialog (M3)
      dialogTheme: DialogThemeData(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: AppShapes.extraLargeBorder,
        ),
        backgroundColor: AppColors.surfaceDark,
        surfaceTintColor: AppColors.surfaceTintDark,
      ),

      // Bottom Sheet (M3)
      bottomSheetTheme: const BottomSheetThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppShapes.extraLarge),
            topRight: Radius.circular(AppShapes.extraLarge),
          ),
        ),
        backgroundColor: AppColors.surfaceDark,
        surfaceTintColor: AppColors.surfaceTintDark,
        showDragHandle: true,
        dragHandleColor: AppColors.onSurfaceVariantDark,
      ),

      // Snackbar (M3)
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: AppShapes.smallBorder,
        ),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: AppColors.outlineVariantDark,
        thickness: 1,
        space: 1,
      ),

      // Icon
      iconTheme: const IconThemeData(
        color: AppColors.onSurfaceVariantDark,
        size: 24,
      ),

      // Bottom Navigation (legacy)
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceDark,
        selectedItemColor: AppColors.primaryDark,
        unselectedItemColor: AppColors.onSurfaceVariantDark,
      ),

      // Progress Indicator
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primaryDark,
        linearTrackColor: AppColors.surfaceVariantDark,
        circularTrackColor: AppColors.surfaceVariantDark,
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.onPrimaryDark;
          }
          return AppColors.outlineDark;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryDark;
          }
          return AppColors.surfaceVariantDark;
        }),
      ),
    );
  }
}
