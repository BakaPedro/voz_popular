import 'package:get_it/get_it.dart';
import 'package:voz_popular/data/repositories/api_auth_repository.dart';
import 'package:voz_popular/data/repositories/auth_repository.dart';
//import 'package:voz_popular/data/repositories/mock_auth_repository.dart';
import 'package:voz_popular/data/repositories/api_occurrence_repository.dart';
import 'package:voz_popular/data/repositories/data_repository.dart';
import 'package:voz_popular/data/repositories/api_data_repository.dart';

//don't stop
final GetIt locator = GetIt.instance;

void setupLocator() {
  //locator.registerLazySingleton<AuthRepository>(() => MockAuthRepository());
  //coisas acontecerão aqui //estão acontecendo
  locator.registerLazySingleton<AuthRepository>(() => ApiAuthRepository());
  locator.registerLazySingleton<OccurrenceRepository>(() => ApiOccurrenceRepository());
  locator.registerLazySingleton<DataRepository>(() => ApiDataRepository());
}