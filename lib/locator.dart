import 'package:get_it/get_it.dart';
import 'package:voz_popular/data/repositories/auth_repository.dart';
import 'package:voz_popular/data/repositories/mock_auth_repository.dart';

//don't stop
final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<AuthRepository>(() => MockAuthRepository());
  //coisas acontecerão aqui
}