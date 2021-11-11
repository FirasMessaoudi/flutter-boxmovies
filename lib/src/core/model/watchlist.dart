import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moviebox/src/shared/util/fav_type.dart';

class FavoriteWatchListModel {
  final String title;
  final bool isMovie;
  final String poster;
  final String date;
  final double rate;
  final String id;
  final int type;
  final String age;
  final String backdrop;
  final bool watched;
  final double note;
  final genres;
  FavoriteWatchListModel({
    required this.rate,
    required this.title,
    required this.isMovie,
    required this.poster,
    required this.date,
    required this.id,
    required this.backdrop,
    this.type=0,
    this.age='',
    this.watched = false,
    this.note = 0.0,
    this.genres=''
  });
  factory FavoriteWatchListModel.fromDoc(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    return FavoriteWatchListModel(
      date: doc.data()['date'] ?? '',
      isMovie: doc.data()['isMovie'] ?? false,
      title: doc.data()['title'] ?? '',
      poster: doc.data()['poster'] ?? '',
      id: doc.data()['id'] ?? '',
      rate: doc.data()['rate'] ?? 0.0,
      type: doc.data()['type']?? 0,
      age: doc.data()['age']??'',
        backdrop: doc.data()['backdrop']??'',
        watched: doc.data()['watched']??false,
      note: doc.data()['note'] ?? 0.0,
      genres: doc.data()['genres'] ?? ''
    );
  }
}

class FavoriteWatchListModelList {
  final List<FavoriteWatchListModel> list;
  FavoriteWatchListModelList({
    required this.list,
  });
  factory FavoriteWatchListModelList.fromDoc(
      QuerySnapshot<Map<String, dynamic>> doc) {
    return new FavoriteWatchListModelList(
        list: doc.docs
            .map((all) => FavoriteWatchListModel.fromDoc(all))
            .toList());
  }
}
