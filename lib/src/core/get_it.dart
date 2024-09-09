
import 'package:get_it/get_it.dart';
import 'package:test_app/src/feature/news/repository/repository.dart';

final getIt = GetIt.instance;

void setupGetIt() {
 getIt.registerLazySingleton(() => NewsRepository());
}
