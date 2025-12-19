import '../repositories/water_repository.dart';

// Use case for adding a glass of water.
class AddGlass {
  final WaterRepository _repository;

  const AddGlass(this._repository);

  Future<void> call(String userId) async {
    await _repository.addGlass(userId);
  }
}