import 'package:get_it/get_it.dart';
import '../repostiory_implementation/home_repository_implementation.dart';
import '../repository/favorites_repository.dart';
import '../repository/home_repository.dart';
import '../repostiory_implementation/favorites_repository_implementation.dart';
import '../services/storage_service.dart';
import '../services/storage_service_impl.dart';
import '../../presentation/favorites/cubit/favorites_cubit.dart';
import '../../presentation/profile/cubit/profile_cubit.dart';
import '../../presentation/trip/cubit/trip_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  final storageService = StorageServiceImpl();
  await storageService.init();
  getIt.registerSingleton<StorageService>(storageService);

  final HomeRepository homeRepo = HomeRepositoryImplementation();
  getIt.registerSingleton<HomeRepository>(homeRepo);

  final FavoritesRepository favoritesRepo = FavoritesRepoImplement(getIt.get());
  getIt.registerLazySingleton<FavoritesRepository>(() => favoritesRepo);

  getIt.registerFactory<FavoritesCubit>(() => FavoritesCubit(
    getIt.get<FavoritesRepository>(),
    getIt.get<HomeRepository>(),
  ));

  getIt.registerFactory<ProfileCubit>(() => ProfileCubit());

  getIt.registerFactory<TripCubit>(() => TripCubit(
    getIt.get<HomeRepository>(),
  ));
}
