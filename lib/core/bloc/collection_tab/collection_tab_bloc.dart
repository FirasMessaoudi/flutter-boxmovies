import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moviebox/core/model/collection.model.dart';
import 'package:moviebox/core/service/collection.service.dart';

part 'collection_tab_event.dart';
part 'collection_tab_state.dart';

class CollectionTabBloc extends Bloc<CollectionTabEvent, CollectionTabState> {
  CollectionTabBloc() : super(CollectionTabInitial());
  final repo = CollectionService();

  @override
  Stream<CollectionTabState> mapEventToState(
    CollectionTabEvent event,
  ) async* {
    if (event is LoadCollections) {
      try {
        yield CollectionTabLoading();
        final lists = await repo.getCollectionList();
        yield CollectionTabLoaded(collections: lists.list);
      } catch (e) {
        yield CollectionTabError();
      }
    }
  }
}
