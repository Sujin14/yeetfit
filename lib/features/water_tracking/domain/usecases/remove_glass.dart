import '../repositories/water_repository.dart';

// Use case for removing a glass of water.
class RemoveGlass {
  final WaterRepository _repository;

  const RemoveGlass(this._repository);

  Future<void> call(String userId) async {
    await _repository.removeGlass(userId);
  }
}