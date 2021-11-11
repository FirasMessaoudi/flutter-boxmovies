import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moviebox/src/core/model/watchlist.dart';
import 'package:moviebox/src/shared/util/profile_list_items.dart';
import 'package:moviebox/src/shared/util/utilities.dart';

class WatchListRepo extends ChangeNotifier {
   final FirebaseAuth _auth = FirebaseAuth.instance;
   final fireStoreInstance = FirebaseFirestore.instance;
   var id = '';
   Future addToWatchList(String id, String title,String poster, String date, double rate,bool isMovie, String backdrop,List<int>? genres) async{
      String uid= await _auth.currentUser!.uid;
      String genresString = isMovie?getMoviesCategorieNames(genres!):getTvCategorieNames(genres!);
      if(genresString!=''){
        genresString = genresString.substring(0, genresString.lastIndexOf(',')-1);
      }
     await  fireStoreInstance.collection('watchlist').doc(uid).collection('watchlists').doc(id)
      .set({
       'id':id,'title':title,
       'poster':poster,'date':date,'rate':rate,
       'watched':false,
       'genres':genresString,
       'isMovie':isMovie,'backdrop':backdrop});
       showToast('Added to watchlist');
       notifyListeners();
   }
   Future <bool> existInWatchList(String id) async {
      String uid= await _auth.currentUser!.uid;
      QuerySnapshot<Map<String, dynamic>> collection = await fireStoreInstance.collection('watchlist').doc(uid).collection('watchlists').where('id',isEqualTo: id).limit(1).get();
      if(collection.size>0){
        notifyListeners();
         return true;
      }
      notifyListeners();
      return false;
   }
   Future deleteFromWatchList(String id) async{
      String uid= await _auth.currentUser!.uid;
     await  fireStoreInstance.collection('watchlist').doc(uid).collection('watchlists').doc(id)
          .delete();
      showToast('Removed from watchlist');
      notifyListeners();

   }
   Future<List> getWatchList(DocumentSnapshot? dc, bool isMovie) async {
     String uid= await _auth.currentUser!.uid;
     if (dc == null) {
       final doc = await FirebaseFirestore.instance
           .collection('watchlist')
           .doc(uid)
           .collection('watchlists')
            .where('isMovie',isEqualTo:isMovie )
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
           .where('isMovie',isEqualTo:isMovie )
           .limit(10)
           .get();
       return [
         FavoriteWatchListModelList.fromDoc(doc),
         doc.docs.length != 0 ? doc.docs[doc.docs.length - 1] : null
       ];
     }
   }
   Future<List> getFilteredWatchlist(DocumentSnapshot? dc,bool isMovie, bool isWatched) async {
     String uid= await _auth.currentUser!.uid;
     if (dc == null) {
       final doc = await FirebaseFirestore.instance
           .collection('watchlist')
           .doc(uid)
           .collection('watchlists')
           .where('watched',isEqualTo:isWatched )
           .where('isMovie',isEqualTo: isMovie)
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
           .where('watched',isEqualTo:isWatched )
           .limit(10)
           .get();
       return [
         FavoriteWatchListModelList.fromDoc(doc),
         doc.docs.length != 0 ? doc.docs[doc.docs.length - 1] : null
       ];
     }
   }
 Future<void> updateWatchlist (FavoriteWatchListModel movie, bool watched) async {
   String uid= await _auth.currentUser!.uid;
   await FirebaseFirestore.instance
       .collection('watchlist')
       .doc(uid)
       .collection('watchlists')
       .doc(movie.id)
   .update({'watched': watched});
 }
   Future<void> rateMovieOrTvShow (FavoriteWatchListModel movie, double note) async {
     String uid= await _auth.currentUser!.uid;
     await FirebaseFirestore.instance
         .collection('watchlist')
         .doc(uid)
         .collection('watchlists')
         .doc(movie.id)
         .update({'note': note});
   }
}