import '../repositories/water_repository.dart';

class RemoveGlass {
  final WaterRepository _repository;

  RemoveGlass(this._repository);

  Future<void> call(String userId) async {
    await _repository.removeGlass(userId);
  }
}
