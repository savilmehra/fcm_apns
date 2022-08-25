import 'package:get_it/get_it.dart';

import 'config/fcm_module/fcm_service.dart';


GetIt locator = GetIt.instance;

void setupLocator() {

  locator.registerLazySingleton(() => FcmService());
}
