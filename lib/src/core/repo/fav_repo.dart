import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moviebox/src/core/model/categorie.dart';
import 'package:moviebox/src/core/model/watchlist.dart';
import 'package:moviebox/src/shared/util/fav_type.dart';
import 'package:moviebox/src/shared/util/utilities.dart';

class FavRepo {
  var id='';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final fireStoreInstance = FirebaseFirestore.instance;
  Future addToFav(String id, String title, FavType type,String poster, String date, double rate,String age,String backdrop,List<int>? genres) async{
    String uid= await _auth.currentUser!.uid;
    String genresString = type==FavType.movie?getMoviesCategorieNames(genres!):type==FavType.tv?getTvCategorieNames(genres!):'';
    if(genresString!=''){
      genresString = genresString.substring(0, genresString.lastIndexOf(',')-1);
    }
    await  fireStoreInstance.collection('fav').doc(uid).collection('favorits').doc(id)
        .set({'id':id,'title':title,'type':type.index,'poster':poster,'date':date,'rate':rate,'age':age,'backdrop':backdrop,'genres': genresString});


  }
  Future <bool> existInFav(String id) async {
    String uid= await _auth.currentUser!.uid;
    QuerySnapshot<Map<String, dynamic>> collection = await fireStoreInstance.collection('fav').doc(uid).collection('favorits').where('id',isEqualTo: id).limit(1).get();
    if(collection.size>0){
      return true;
    }
    return false;
  }
  Future deleteFromFav(String id) async{
    String uid= await _auth.currentUser!.uid;
    await  fireStoreInstance.collection('fav').doc(uid).collection('favorits').doc(id)
        .delete();

  }
  Future<List> getFavorite(DocumentSnapshot? dc,int type) async {
    String uid= await _auth.currentUser!.uid;
    if (dc == null) {
      final doc = await FirebaseFirestore.instance
          .collection('fav')
          .doc(uid)
          .collection('favorits')
          .where('type',isEqualTo: type)
          .limit(10)
          .get();
      id = uid;
      return [
        FavoriteWatchListModelList.fromDoc(doc),
        doc.docs.isNotEmpty ? doc.docs[doc.docs.length - 1] : null
      ];
    } else {
      final doc = await FirebaseFirestore.instance
          .collection('fav')
          .doc(uid)
          .collection('favorits')
          .startAfterDocument(dc)
          .where('type',isEqualTo: type)
          .limit(10)
          .get();
      return [
        FavoriteWatchListModelList.fromDoc(doc),
        doc.docs.length != 0 ? doc.docs[doc.docs.length - 1] : null
      ];
    }
  }
}