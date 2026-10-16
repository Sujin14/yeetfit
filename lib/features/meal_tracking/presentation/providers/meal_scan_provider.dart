import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../data/datasources/meal_scan_datasource.dart';
import 'package:yeetfit/core/services/streak_service.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import '../../domain/entities/food_item.dart';
import '../../domain/entities/scanned_meal.dart';

final mealScanDataSourceProvider = Provider<MealScanDataSource>(
  (ref) => MealScanDataSource(),
);

/// Loading while a photo is being analysed; error holds a
/// [MealScanException] the UI can show directly.
final mealScanControllerProvider =
    AsyncNotifierProvider<MealScanController, void>(MealScanController.new);

class MealScanController extends AsyncNotifier<void> {
  // Keeps the base64 payload well under the 10 MB callable limit while
  // leaving enough detail for food recognition.
  static const double _maxImageDimension = 1280;
  static const int _imageQuality = 80;

  final ImagePicker _picker = ImagePicker();

  @override
  FutureOr<void> build() {}

  /// Returns `null` when the user cancels the picker, crop, or the scan fails.
  Future<ScannedMeal?> scan(BuildContext context, ImageSource source) async {
    try {
      // Android blocks the camera intent when CAMERA is declared but not yet
      // granted. iOS shows its own prompt via image_picker (permission_handler
      // there would need Podfile macros to report anything but denied).
      if (source == ImageSource.camera &&
          defaultTargetPlatform == TargetPlatform.android) {
        final status = await Permission.camera.request();
        if (!status.isGranted) {
          if (ref.mounted) {
            state = AsyncError(
              const MealScanException(
                'Camera access is needed to scan meals. Enable it in Settings.',
              ),
              StackTrace.current,
            );
          }
          return null;
        }
      }

      final image = await _picker.pickImage(
        source: source,
        maxWidth: _maxImageDimension,
        maxHeight: _maxImageDimension,
        imageQuality: _imageQuality,
      );
      if (image == null || !context.mounted) return null;

      final colors = Theme.of(context).extension<AppColors>()!;
      final cropped = await ImageCropper().cropImage(
        sourcePath: image.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Food Photo',
            toolbarColor: colors.primary,
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: false,
            showCropGrid: true,
          ),
          IOSUiSettings(
            title: 'Crop Food Photo',
            aspectRatioLockEnabled: false,
            showActivitySheetOnDone: false,
          ),
        ],
      );
      if (cropped == null) return null;

      state = const AsyncLoading();
      final croppedFile = XFile(cropped.path);
      final bytes = await croppedFile.readAsBytes();
      final meal = await ref
          .read(mealScanDataSourceProvider)
          .scanImage(bytes, _mimeTypeOf(croppedFile));
      if (ref.mounted) state = const AsyncData(null);
      return meal;
    } on MealScanException catch (e, stack) {
      if (ref.mounted) state = AsyncError(e, stack);
    } on PlatformException catch (e, stack) {
      debugPrint('Image picker failed: $e');
      if (ref.mounted) {
        state = AsyncError(
          const MealScanException(
            'Camera or photo access was denied. Check app permissions.',
          ),
          stack,
        );
      }
    } catch (e, stack) {
      debugPrint('Meal scan failed: $e');
      if (ref.mounted) {
        state = AsyncError(
          const MealScanException('Something went wrong. Please try again.'),
          stack,
        );
      }
    }
    return null;
  }

  static String _mimeTypeOf(XFile image) {
    final declared = image.mimeType;
    if (declared != null && declared.startsWith('image/')) return declared;
    final path = image.path.toLowerCase();
    if (path.endsWith('.png')) return 'image/png';
    if (path.endsWith('.webp')) return 'image/webp';
    if (path.endsWith('.heic')) return 'image/heic';
    return 'image/jpeg';
  }
}

/// Food log entry for a scanned meal. Fiber isn't estimated by the scan.
FoodItem scannedMealToFoodItem(ScannedMeal meal, String mealType) {
  return FoodItem(
    date: StreakService.todayKey(),
    mealType: mealType,
    foodName: meal.foodName,
    calories: meal.calories,
    protein: meal.protein,
    fat: meal.fat,
    carbs: meal.carbs,
    fiber: 0,
    quantity: _gramsFromServing(meal.servingSize),
  );
}

// Serving sizes look like "1 bowl (250 g)"; the food log stores grams.
double _gramsFromServing(String servingSize) {
  const defaultQuantityGrams = 100.0;
  final match = RegExp(
    r'(\d+(?:\.\d+)?)\s*(?:g|grams?)\b',
    caseSensitive: false,
  ).firstMatch(servingSize);
  return match == null ? defaultQuantityGrams : double.parse(match.group(1)!);
}
