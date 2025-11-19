// lib/features/dashboard/presentation/providers/selected_date_provider.dart
import 'package:hooks_riverpod/hooks_riverpod.dart';

final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());