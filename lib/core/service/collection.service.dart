import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moviebox/core/model/collection.model.dart';

class CollectionService {
  Future<CollectionList> getCollectionList() async {
    final newid = await FirebaseAuth.instance.currentUser!.uid;
    final docs = await FirebaseFirestore.instance
        .collection('UserCollections')
        .doc(newid)
        .collection('CollectionInfo')
        .get();
    return CollectionList.fromDoc(docs);
  }

  Future<void> addToCollection(
      String devid,
      String movieid,
      String collName,
      String title,
      String image,
      String backdrop,
      double rate,
      String date,
      bool isMovie) async {
    FirebaseFirestore.instance
        .collection('UserCollections')
        .doc(devid)
        .collection('Collections')
        .doc(collName)
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
    FirebaseFirestore.instance
        .collection('UserCollections')
        .doc(devid)
        .collection('CollectionInfo')
        .doc(collName)
        .set({"name": collName, "image": image, "time": DateTime.now()});
    FirebaseFirestore.instance
        .collection('UserCollections')
        .doc(devid)
        .collection('allMovies')
        .doc(movieid)
        .set({
      "inCollection": collName,
    });
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
  }
}
