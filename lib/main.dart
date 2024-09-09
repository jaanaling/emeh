import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/routes/router_config.dart';
import 'package:test_app/src/core/get_it.dart';
import 'package:test_app/src/feature/news/bloc/news_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupGetIt();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    BlocProvider(
      create: (context) => NewsBloc()..add(FetchNews(category: '')),
      child: CupertinoApp.router(
        routerConfig: buildRouter(),
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}
