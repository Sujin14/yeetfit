import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/datasource/admin_service.dart';
import '../../data/model/admin_model.dart';

final adminsProvider = StreamProvider<List<AdminModel>>(
  (ref) => AdminService().getAdmins(),
);
