import 'package:hooks_riverpod/hooks_riverpod.dart';

final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());