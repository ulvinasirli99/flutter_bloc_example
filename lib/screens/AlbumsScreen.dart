import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_app_example/bloc/albums/AlbumsBloc.dart';
import 'package:flutter_bloc_app_example/bloc/albums/events.dart';
import 'package:flutter_bloc_app_example/bloc/theme/theme_bloc.dart';
import 'package:flutter_bloc_app_example/bloc/theme/theme_events.dart';
import 'package:flutter_bloc_app_example/equtable/states.dart';
import 'package:flutter_bloc_app_example/model/album.dart';
import 'package:flutter_bloc_app_example/settings/app_themes.dart';
import 'package:flutter_bloc_app_example/settings/preferences.dart';
import 'package:flutter_bloc_app_example/widgets/error.dart';
import 'package:flutter_bloc_app_example/widgets/list_row.dart';
import 'package:flutter_bloc_app_example/widgets/loading.dart';
import 'package:flutter_bloc_app_example/widgets/txt.dart';

class AlbumsScreen extends StatefulWidget {
  @override
  _AlbumsScreenState createState() => _AlbumsScreenState();
}

class _AlbumsScreenState extends State<AlbumsScreen> {
  //

  @override
  void initState() {
    super.initState();
    _loadTheme();
    _loadAlbums();
  }

  _loadTheme() async {
    context.bloc<ThemeBloc>().add(ThemeEvent(appTheme: Preferences.getTheme()));
  }

  _loadAlbums() async {
    context.bloc<AlbumsBloc>().add(AlbumEvents.fetchAlbums);
  }

  _setTheme(bool darkTheme) async {
    AppTheme selectedTheme =
        darkTheme ? AppTheme.lightTheme : AppTheme.darkTheme;
    context.bloc<ThemeBloc>().add(ThemeEvent(appTheme: selectedTheme));
    Preferences.saveTheme(selectedTheme);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        title: Txt(text: 'Albums'),
        actions: [
          Switch(
            value: Preferences.getTheme() == AppTheme.lightTheme,
            onChanged: (val) async {
              _setTheme(val);
            },
          )
        ],
      ),
      body: Container(
        child: _body(),
      ),
    );
  }

  _body() {
    return Column(
      children: [
        BlocBuilder<AlbumsBloc, AlbumsState>(
            builder: (BuildContext context, AlbumsState state) {
          if (state is AlbumsListError) {
            final error = state.error;
            String message = '${error.message}\nTap to Retry.';
            return ErrorTxt(
              message: message,
              onTap: _loadAlbums,
            );
          }
          if (state is AlbumsLoaded) {
            List<Album> albums = state.albums;
            return _list(albums);
          }
          return Loading();
        }),
      ],
    );
  }

  Widget _list(List<Album> albums) {
    return Expanded(
      child: ListView.builder(
        itemCount: albums.length,
        itemBuilder: (_, index) {
          Album album = albums[index];
          return ListRow(album: album);
        },
      ),
    );
  }
}
