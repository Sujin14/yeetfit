import '../repositories/water_repository.dart';

class AddGlass {
  final WaterRepository _repository;

  AddGlass(this._repository);

  Future<void> call(String userId) async {
    await _repository.addGlass(userId);
  }
}