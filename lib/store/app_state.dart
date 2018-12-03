import 'package:built_value/built_value.dart';
import 'package:built_collection/built_collection.dart';

import 'package:built_value/serializer.dart';
import 'package:owmflutter/store/store.dart';

part 'app_state.g.dart';

abstract class AppState implements Built<AppState, AppStateBuilder> {
  AuthState get authState;
  EntitiesState get entitiesState;

  LinksState get linksState;
  MyWykopState get myWykopState;
  MikroblogState get mikroblogState;
  EntryScreensState get entryScreensState;
  TagsState get tagsState;

  factory AppState() {
    return _$AppState._(
        authState: AuthState(),
        linksState: LinksState(),
        mikroblogState: MikroblogState(),
        myWykopState: MyWykopState(),
        tagsState: TagsState(),
        entitiesState: EntitiesState(),
        entryScreensState: EntryScreensState());
  }

  AppState._();
  static Serializer<AppState> get serializer => _$appStateSerializer;
}
