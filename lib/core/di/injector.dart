import 'package:get_it/get_it.dart';
import '../services/storage_service.dart';
import '../services/storage_service_impl.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  final storageService = StorageServiceImpl();
  await storageService.init();
  getIt.registerSingleton<StorageService>(storageService);
}
