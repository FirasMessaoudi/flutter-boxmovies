import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'add_collection_state.dart';

class CollectionCubit extends Cubit<CollectionState> {
  CollectionCubit() : super(CollectionState.initial());

  void init(String movieid) async {
    var id = await FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('UserCollections')
        .doc(id)
        .collection('allMovies')
        .doc(movieid)
        .get()
        .then((value) {
      if (value.exists) {
        emit(
          state.copyWith(
            isCollection: true,
            collectionname: value.data()!['inCollection'],
          ),
        );
      } else {
        emit(state.copyWith(isCollection: false));
      }
    });
  }

  deleteFromCollection(String devid, String movieid) async {
    await FirebaseFirestore.instance
        .collection('UserCollections')
        .doc(devid)
        .collection('Collections')
        .doc(state.collectionname)
        .collection('movies & Tv')
        .doc(movieid)
        .delete();
    await FirebaseFirestore.instance
        .collection('UserCollections')
        .doc(devid)
        .collection('allMovies')
        .doc(movieid)
        .delete();
    emit(state.copyWith(isCollection: false));
  }

  addToExistingCollection(
      String devid,
      String name,
      String movieid,
      String title,
      String image,
      String backdrop,
      double rate,
      String date,
      bool isMovie) async {
    await FirebaseFirestore.instance
        .collection('UserCollections')
        .doc(devid)
        .collection('Collections')
        .doc(name)
        .collection('movies & Tv')
        .doc(movieid)
        .set({
      "name": title,
      "image": image,
      "id": movieid,
      "backdrop": backdrop,
      'rate': rate,
      "date": date,
      "isMovie": isMovie,
    });
    await FirebaseFirestore.instance
        .collection('UserCollections')
        .doc(devid)
        .collection('allMovies')
        .doc(movieid)
        .set({
      "inCollection": name,
    });
    emit(state.copyWith(isCollection: true));
  }

  addToNewCollection(
      String devid,
      String name,
      String movieid,
      String title,
      String image,
      double rate,
      String date,
      String backdrop,
      bool isMovie) async {
    await FirebaseFirestore.instance
        .collection('UserCollections')
        .doc(devid)
        .collection('Collections')
        .doc(name)
        .collection('movies & Tv')
        .doc(movieid)
        .set({
      "name": title,
      "image": image,
      'rate': rate,
      "id": movieid,
      "date": date,
      "backdrop": backdrop,
      "isMovie": isMovie,
    });
    await FirebaseFirestore.instance
        .collection('UserCollections')
        .doc(devid)
        .collection('CollectionInfo')
        .doc(name)
        .set({"name": name, "image": image, "time": DateTime.now()});
    await FirebaseFirestore.instance
        .collection('UserCollections')
        .doc(devid)
        .collection('allMovies')
        .doc(movieid)
        .set({
      "inCollection": name,
    });
    emit(state.copyWith(isCollection: true));
  }
}
