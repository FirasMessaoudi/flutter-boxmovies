import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moviebox/src/core/model/watchlist.dart';
import 'package:moviebox/src/shared/util/utilities.dart';

class WatchListRepo extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final fireStoreInstance = FirebaseFirestore.instance;
  var id = '';

  Future addToWatchList(String id, String title, String poster, String date,
      double rate, bool isMovie, String backdrop, List<int>? genres) async {
    String uid = _auth.currentUser!.uid;
    String genresString = isMovie
        ? getMoviesCategorieNames(genres!)
        : getTvCategorieNames(genres!);
    if (genresString != '') {
      genresString =
          genresString.substring(0, genresString.lastIndexOf(',') - 1);
    }
    if (isMovie) {
      await fireStoreInstance
          .collection('watchlist')
          .doc(uid)
          .collection('watchlists')
          .doc(id)
          .set({
        'id': id,
        'title': title,
        'poster': poster,
        'date': date,
        'rate': rate,
        'watched': false,
        'genres': genresString,
        'isMovie': isMovie,
        'backdrop': backdrop,
        'creationDate': DateTime.now()
      });
    } else {
      await FirebaseFirestore.instance
          .collection('UserTvList')
          .doc(uid)
          .collection('tvList')
          .doc(id)
          .set({
        "creationDate":DateTime.now(),
        "id": id,
        "title": title,
        "poster": poster,
        "date": date,
        "rate": rate,
        "genres": genresString,
        "backdrop": backdrop
      });
    }
    showToast('Added to watchlist');
    notifyListeners();
  }

  Future<bool> existInMovieWatchList(String id) async {
    String uid = _auth.currentUser!.uid;
    QuerySnapshot<Map<String, dynamic>> collection = await fireStoreInstance
        .collection('watchlist')
        .doc(uid)
        .collection('watchlists')
        .where('id', isEqualTo: id)
        .limit(1)
        .get();
    if (collection.size > 0) {
      notifyListeners();
      return true;
    }
    notifyListeners();
    return false;
  }

  Future<bool> existInTvWatchList(String id) async {
    String uid = _auth.currentUser!.uid;
    QuerySnapshot<Map<String, dynamic>> collection = await fireStoreInstance
        .collection('UserTvList')
        .doc(uid)
        .collection('tvList')
        .where('id', isEqualTo: id)
        .limit(1)
        .get();
    if (collection.size > 0) {
      notifyListeners();
      return true;
    }
    notifyListeners();
    return false;
  }

  Future deleteFromWatchList(String id, bool isMovie) async {
    String uid = _auth.currentUser!.uid;
    if (isMovie) {
      await fireStoreInstance
          .collection('watchlist')
          .doc(uid)
          .collection('watchlists')
          .doc(id)
          .delete();
    } else {
      await fireStoreInstance
          .collection('UserTvList')
          .doc(uid)
          .collection('tvList')
          .doc(id)
          .delete();
      fireStoreInstance
          .collection('UserTvList')
          .doc(uid)
          .collection('tvList')
          .doc(id)
          .collection('episodes')
          .get()
          .then((value) => {
                for (var ds in value.docs) {ds.reference.delete()}
              });

      final collection = fireStoreInstance
          .collection('UserTvList')
          .doc(uid)
          .collection('allEpisodes');
      final snapshot = await collection.where('tvId', isEqualTo: id).get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    }
    notifyListeners();
  }

  Future<List> getWatchList(DocumentSnapshot? dc, bool isMovie) async {
    String uid = _auth.currentUser!.uid;
    if (dc == null) {
      final doc = await FirebaseFirestore.instance
          .collection('watchlist')
          .doc(uid)
          .collection('watchlists')
          .where('isMovie', isEqualTo: isMovie)
          .limit(10)
          .get();
      id = uid;
      return [
        FavoriteWatchListModelList.fromDoc(doc),
        doc.docs.isNotEmpty ? doc.docs[doc.docs.length - 1] : null
      ];
    } else {
      final doc = await FirebaseFirestore.instance
          .collection('watchlist')
          .doc(uid)
          .collection('watchlists')
          .startAfterDocument(dc)
          .where('isMovie', isEqualTo: isMovie)
          .limit(10)
          .get();
      return [
        FavoriteWatchListModelList.fromDoc(doc),
        doc.docs.length != 0 ? doc.docs[doc.docs.length - 1] : null
      ];
    }
  }

  Future<List> getTvList(DocumentSnapshot? dc) async {
    String uid = _auth.currentUser!.uid;
    if (dc == null) {
      final doc = await FirebaseFirestore.instance
          .collection('UserTvList')
          .doc(uid)
          .collection('tvList')
          .limit(10)
          .get();
      id = uid;
      return [
        FavoriteWatchListModelList.fromDoc(doc),
        doc.docs.isNotEmpty ? doc.docs[doc.docs.length - 1] : null
      ];
    } else {
      final doc = await FirebaseFirestore.instance
          .collection('UserTvList')
          .doc(uid)
          .collection('tvList')
          .startAfterDocument(dc)
          .limit(10)
          .get();
      return [
        FavoriteWatchListModelList.fromDoc(doc),
        doc.docs.length != 0 ? doc.docs[doc.docs.length - 1] : null
      ];
    }
  }

  Future<List> getFilteredTvList(DocumentSnapshot? dc, bool watched) async {
    String uid = _auth.currentUser!.uid;
    if (dc == null) {
      final doc = await FirebaseFirestore.instance
          .collection('UserTvList')
          .doc(uid)
          .collection('tvList')
          .limit(10)
          .get();
      if(watched==true) {
        doc.docs.forEach((element) {
          print('episode');
          if (element.data()['episodes'] == null) {
            doc.docs.remove(element);
          }
        });
      }else {
        doc.docs.forEach((element) {
          if (element.data()['episodes'] != null) {
            doc.docs.remove(element);
          }
        });
      }
      return [
        FavoriteWatchListModelList.fromDoc(doc),
        doc.docs.isNotEmpty ? doc.docs[doc.docs.length - 1] : null
      ];
    } else {
      final doc = await FirebaseFirestore.instance
          .collection('UserTvList')
          .doc(uid)
          .collection('tvList')
          .startAfterDocument(dc)
          .limit(10)
          .get();
      return [
        FavoriteWatchListModelList.fromDoc(doc),
        doc.docs.length != 0 ? doc.docs[doc.docs.length - 1] : null
      ];
    }
  }

  Future<List> getFilteredWatchlist(
      DocumentSnapshot? dc, bool isMovie, bool isWatched) async {
    String uid = await _auth.currentUser!.uid;
    if (dc == null) {
      final doc = await FirebaseFirestore.instance
          .collection('watchlist')
          .doc(uid)
          .collection('watchlists')
          .where('watched', isEqualTo: isWatched)
          .where('isMovie', isEqualTo: isMovie)
          .limit(10)
          .get();
      id = uid;
      return [
        FavoriteWatchListModelList.fromDoc(doc),
        doc.docs.isNotEmpty ? doc.docs[doc.docs.length - 1] : null
      ];
    } else {
      final doc = await FirebaseFirestore.instance
          .collection('watchlist')
          .doc(uid)
          .collection('watchlists')
          .startAfterDocument(dc)
          .where('watched', isEqualTo: isWatched)
          .limit(10)
          .get();
      return [
        FavoriteWatchListModelList.fromDoc(doc),
        doc.docs.length != 0 ? doc.docs[doc.docs.length - 1] : null
      ];
    }
  }

  Future<void> updateWatchlist(
      //notifyListeners
      FavoriteWatchListModel movie,
      bool watched) async {
    String uid = await _auth.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('watchlist')
        .doc(uid)
        .collection('watchlists')
        .doc(movie.id)
        .update(
            {'watched': watched, 'watchDate': watched ? DateTime.now() : ''});
    notifyListeners();
  }

  Future<void> rateMovieOrTvShow(
      FavoriteWatchListModel movie, double note) async {
    String uid = _auth.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('watchlist')
        .doc(uid)
        .collection('watchlists')
        .doc(movie.id)
        .update({'note': note});
  }

  Future getNbWatchedEpisode() async {
    String uid = _auth.currentUser!.uid;
    final doc = await FirebaseFirestore.instance
        .collection('UserTvList')
        .doc(uid)
        .collection('allEpisodes')
        .get();
    return doc.docs.length;
  }

  Future getNbWatchedMovies() async {
    String uid = _auth.currentUser!.uid;
    final doc = await FirebaseFirestore.instance
        .collection('watchlist')
        .doc(uid)
        .collection('watchlists')
        .where('watched', isEqualTo: true)
        .get();
    return doc.docs.length;
  }

  Future getMovieListCount() async {
    String uid = _auth.currentUser!.uid;
    final doc = await FirebaseFirestore.instance
        .collection('watchlist')
        .doc(uid)
        .collection('watchlists')
        .get();
    return doc.docs.length;
  }

  Future getTvListCount() async {
    String uid = _auth.currentUser!.uid;
    final doc = await FirebaseFirestore.instance
        .collection('UserTvList')
        .doc(uid)
        .collection('tvList')
        .get();
    return doc.docs.length;
  }

  Future getCollectionCount() async {
    String uid = _auth.currentUser!.uid;
    final doc = await FirebaseFirestore.instance
        .collection('UserCollections')
        .doc(uid)
        .collection('CollectionInfo')
        .get();
    return doc.docs.length;
  }

  Future getFavCount() async {
    String uid = _auth.currentUser!.uid;
    final doc = await FirebaseFirestore.instance
        .collection('fav')
        .doc(uid)
        .collection('favorits')
        .get();
    return doc.docs.length;
  }

  Future getNbMinutesOfEpisodes() async{
    String uid = _auth.currentUser!.uid;
    int nb=0;
    final doc = await FirebaseFirestore.instance
        .collection('UserTvList')
        .doc(uid)
        .collection('allEpisodes')
        .get();
    doc.docs.forEach((element) {
      if(element.data()["runtime"]!=null){
        nb+= int.parse(element.data()["runtime"].toString().substring(0,element.data()["runtime"].toString().indexOf(' ')));
      }
    });
    return nb;
  }

  Future getNbWatchedEpisodesBySerie(String id) async{
    String uid = _auth.currentUser!.uid;
    final doc = await FirebaseFirestore.instance
        .collection('UserTvList')
        .doc(uid)
        .collection('tvList')
        .doc(id)
        .collection('episodes')
        .get();
    if(doc.size>0){
    return  doc.docs.length;
    }

    return 0;
  }
}
