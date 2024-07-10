import 'package:get_it/get_it.dart';
import 'package:icoc_admin_pannel/injection.config.dart';

import 'package:injectable/injectable.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies(String env) => getIt.init(environment: env);
