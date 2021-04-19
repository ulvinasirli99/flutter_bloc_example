import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_app_example/screens/AlbumsScreen.dart';
import 'package:flutter_bloc_app_example/service/http/services.dart';
import 'package:flutter_bloc_app_example/settings/preferences.dart';

import 'bloc/albums/AlbumsBloc.dart';
import 'bloc/theme/theme_bloc.dart';
import 'equtable/theme_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeBloc(),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (BuildContext context, ThemeState themeState) {
          return MaterialApp(
            title: 'Flutter Bloc Demo',
            debugShowCheckedModeBanner: false,
            theme: themeState.themeData,
            home: BlocProvider(
              create: (context) => AlbumsBloc(albumsRepo: AlbumServices()),
              child: AlbumsScreen(),
            ),
          );
        },
      ),
    );
  }
}
