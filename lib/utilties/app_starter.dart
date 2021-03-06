import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:get_it/get_it.dart';
import 'package:pokedex_web/apis/api_service.dart';
import 'package:pokedex_web/persistor/state_persistor.dart';
import 'package:pokedex_web/persistor/storage_engine_web.dart';
import 'package:pokedex_web/pokdex_app.dart';
import 'package:pokedex_web/state/app_state.dart';

final getIt = GetIt.instance;

Future<void> startApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  final persistor = StatePersistor<AppState>(
    StandardEngine(),
    AppStateSerializer(),
  );

  AppState? state;
  try {
    state = await persistor.readState();
  } catch (e) {
    debugPrint(e.toString());
  }

  final store = Store<AppState>(
    initialState: state ?? AppState.init(),
    actionObservers: [Log.printer(formatter: Log.verySimpleFormatter)],
    persistor: persistor,
  );

  getIt.registerLazySingleton<ApiService>(() => ApiService());

  runApp(PokedexApp(store: store));
}
