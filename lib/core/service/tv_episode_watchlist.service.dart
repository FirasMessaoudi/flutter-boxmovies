import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TvWatchlistService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  addToNewTvWatchList(
      String epTitle,
      String epId,
      String tvName,
      String tvGenre,
      String tvDate,
      double tvRate,
      String tvId,
      String tvImage,
      double epRate,
      String epRuntime,
      String backdrop) async {
    String id = _auth.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('UserTvList')
        .doc(id)
        .collection('tvList')
        .doc(tvId)
        .collection('episodes')
        .doc(epId)
        .set({
      "title": epTitle,
      'rate': epRate,
      "id": epId,
      "runtime": epRuntime,
      "dateWatched": DateTime.now(),
    });
    //add tv to watchlist
    await FirebaseFirestore.instance
        .collection('UserTvList')
        .doc(id)
        .collection('tvList')
        .doc(tvId)
        .set({
      "creationDate":DateTime.now(),
      "id": tvId,
      "title": tvName,
      "poster": tvImage,
      "date": tvDate,
      "rate": tvRate,
      "genres": tvGenre,
      "backdrop": backdrop
    });
    await FirebaseFirestore.instance
        .collection('UserTvList')
        .doc(id)
        .collection('allEpisodes')
        .doc(epId)
        .set({"inTvList": tvName, "tvId": tvId, "runtime":epRuntime});
  }

  addToExistingTv(String epTitle, String epId, String tvName, String tvId,
      double epRate, String epRuntime) async {
    String id = _auth.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('UserTvList')
        .doc(id)
        .collection('tvList')
        .doc(tvId)
        .collection('episodes')
        .doc(epId)
        .set({
      "title": epTitle,
      'rate': epRate,
      "id": epId,
      "runtime": epRuntime,
      "dateWatched": DateTime.now(),
    });
    await FirebaseFirestore.instance
        .collection('UserTvList')
        .doc(id)
        .collection('allEpisodes')
        .doc(epId)
        .set({"inTvList": tvName, "tvId": tvId, "runtime":epRuntime});
  }

  Future deleteEpisode(String tvId, String epId) async {
    String uid = _auth.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('UserTvList')
        .doc(uid)
        .collection('tvList')
        .doc(tvId)
        .collection('episodes')
        .doc(epId)
        .delete();

    await FirebaseFirestore.instance
        .collection('UserTvList')
        .doc(uid)
        .collection('allEpisodes')
        .doc(epId)
        .delete();
  }
}
