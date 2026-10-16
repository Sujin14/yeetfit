import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/models/plan_model.dart';
import 'plan_provider.dart';

/// One-shot outcome of a favourite toggle. The screen shows feedback and then
/// calls [PlanDetailController.consume].
sealed class PlanDetailEvent {
  const PlanDetailEvent();
}

class PlanFavoriteToggled extends PlanDetailEvent {
  final bool isFavorite;

  const PlanFavoriteToggled({required this.isFavorite});
}

class PlanFavoriteToggleFailed extends PlanDetailEvent {
  final String message;

  const PlanFavoriteToggleFailed(this.message);
}

final planDetailControllerProvider =
    NotifierProvider.autoDispose<PlanDetailController, PlanDetailEvent?>(
      PlanDetailController.new,
    );

class PlanDetailController extends Notifier<PlanDetailEvent?> {
  bool _isToggling = false;

  @override
  PlanDetailEvent? build() => null;

  Future<void> toggleFavorite(PlanModel plan) async {
    if (_isToggling || plan.id == null) return;
    _isToggling = true;
    final newValue = !plan.isFavorite;
    try {
      await ref
          .read(planDataSourceProvider)
          .toggleFavorite(plan.id!, plan.type, newValue);
      if (!ref.mounted) return;
      // The toggle succeeded even if this reload fails; the favourites
      // filter shows its own load error.
      await ref
          .refresh(favoritePlansProvider.future)
          .catchError((_) => const <PlanModel>[]);
      if (!ref.mounted) return;
      state = PlanFavoriteToggled(isFavorite: newValue);
    } catch (e) {
      if (!ref.mounted) return;
      state = PlanFavoriteToggleFailed(
        e.toString().contains('PERMISSION_DENIED')
            ? 'Permission denied: Only admins can update plans'
            : 'Error: $e',
      );
    } finally {
      _isToggling = false;
    }
  }

  void consume() => state = null;
}
