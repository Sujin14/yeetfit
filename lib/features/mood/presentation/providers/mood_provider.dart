import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/datasources/mood_datasource.dart';
import '../../domain/entities/mood_entry.dart';

final moodDataSourceProvider = Provider<MoodDataSource>(
  (ref) => MoodDataSource(),
);

/// Today's entry; `null` until the user logs one. Auto-disposed so "today"
/// is re-evaluated after midnight.
final todayMoodProvider = StreamProvider.autoDispose.family<MoodEntry?, String>(
  (ref, userId) {
    final today = DateTime.now().toIso8601String().split('T')[0];
    return ref.watch(moodDataSourceProvider).watchEntry(userId, today);
  },
);

final moodHistoryProvider = StreamProvider.autoDispose
    .family<List<MoodEntry>, String>(
      (ref, userId) =>
          ref.watch(moodDataSourceProvider).watchLast30Days(userId),
    );
