import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_app_example/equtable/states.dart';
import 'package:flutter_bloc_app_example/model/album.dart';
import 'package:flutter_bloc_app_example/service/exception/InvalidFormatException.dart';
import 'package:flutter_bloc_app_example/service/exception/NoInternetException.dart';
import 'package:flutter_bloc_app_example/service/exception/NoServiceFoundException.dart';
import 'package:flutter_bloc_app_example/service/exception/UnknownException.dart';
import 'package:flutter_bloc_app_example/service/http/services.dart';

import 'events.dart';

class AlbumsBloc extends Bloc<AlbumEvents, AlbumsState> {
  final AlbumsRepo albumsRepo;
  List<Album> albums;
  AlbumsBloc({this.albumsRepo}) : super(AlbumsInitState());
  @override
  Stream<AlbumsState> mapEventToState(AlbumEvents event) async* {
    switch (event) {
      case AlbumEvents.fetchAlbums:
        yield AlbumsLoading();
        try {
          albums = await albumsRepo.getAlbumList();
          yield AlbumsLoaded(albums: albums);
        } on SocketException {
          yield AlbumsListError(
            error: NoInternetException('No Internet'),
          );
        } on HttpException {
          yield AlbumsListError(
            error: NoServiceFoundException('No Service Found'),
          );
        } on FormatException {
          yield AlbumsListError(
            error: InvalidFormatException('Invalid Response format'),
          );
        } catch (e) {
          yield AlbumsListError(
            error: UnknownException('Unknown Error'),
          );
        }
        break;
    }
  }
}
