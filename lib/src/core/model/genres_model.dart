import 'package:flutter/material.dart';

class Genres {
  final String id;
  final String name;
  final String image;
  final Color color;
  Genres({
    required this.color,
    required this.image,
    required this.id,
    required this.name,
  });
  factory Genres.fromJson(json) {
    return Genres(
      id: json['id'].toString(),
      name: json['name'],
      image: json['image'].toString(),
      color: json['color'],
    );
  }
}

class GenresList {
  final List<Genres> list;
  GenresList({
    required this.list,
  });
  factory GenresList.fromJson(json) {
    return GenresList(
        list: (json as List).map((genre) => Genres.fromJson(genre)).toList());
  }
}

final genreslist = [
  {
    "id": 28,
    "name": "Action",
    "image":
        "action.jpg",
    "color": Color(0xff526605),
  },
  {
    "id": 12,
    "name": "Adventure",
    "image":
        "adventure.jpg",
    "color": Color(0xff1d0d87)
  },
  {
    "id": 16,
    "name": "Animation",
    "image":
        "animation.jpg",
    "color": Color(0xff51ac06)
  },
  {
    "id": 35,
    "name": "Comedy",
    "image":
        "comedy.jpg",
    "color": Color(0xff375304)
  },
  {
    "id": 80,
    "name": "Crime",
    "image":
        "crime.jpg",
    "color": Color(0xff4004d7)
  },
  {
    "id": 99,
    "name": "Documentary",
    "image":
        "documentary.jpg",
    "color": Color(0xff0b6a33)
  },
  {
    "id": 18,
    "name": "Drama",
    "image":
        "drama.jpg",
    "color": Color(0xff039620)
  },
  {
    "id": 10751,
    "name": "Family",
    "image":
        "family.jpg",
    "color": Color(0xff4004d7)
  },
  {
    "id": 14,
    "name": "Fantasy",
    "image":
        "fantasy.jpg",
    "color": Color(0xff039620)
  },
  {
    "id": 36,
    "name": "History",
    "image":
        "historycat.jpg",
    "color": Color(0xffb49208)
  },
  {
    "id": 27,
    "name": "Horror",
    "image":
        "horror.jpg",
    "color": Color(0xff0c6803)
  },
  {
    "id": 10402,
    "name": "Music",
    "image":
        "music.jpg",
    "color": Color(0xffc01111)
  },
  {
    "id": 9648,
    "name": "Mystery",
    "image":
        "mystery.jpg",
    "color": Color(0xff504907)
  },
  {
    "id": 10749,
    "name": "Romance",
    "image":
        "romance.jpg",
    "color": Color(0xffa00e80)
  },
  {
    "id": 878,
    "name": "Science Fiction",
    "image":
        "scify.jpg",
    "color": Color(0xff8a08b5)
  },
  {
    "id": 53,
    "name": "Thriller",
    "image":
        "thriller.jpg",
    "color": Color(0xff0b7f1e)
  },
  {
    "id": 10752,
    "name": "War",
    "image":
        "war.jpg",
    "color": Color(0xff9d105b)
  },
  {
    "id": 37,
    "name": "Western",
    "image":
        "western.jpg",
    "color": Color(0xffb49208)
  },

  // {
  //   "id": 10762,
  //   "name": "Kids",
  // },

  // {
  //   "id": 10763,
  //   "name": "News",
  // },
  // {
  //   "id": 10764,
  //   "name": "Reality",
  // },
  // {
  //   "id": 10765,
  //   "name": "Sci-Fi & Fantasy",
  // },
  // {
  //   "id": 10766,
  //   "name": "Soap",
  // },
  // {
  //   "id": 10767,
  //   "name": "Talk",
  // },
  // {
  //   "id": 10768,
  //   "name": "War & Politics",
  // },
];
//  Action Color(0xff526605)
//  Adventure Color(0xff1d0d87)
//  Animation Color(0xff375304)
//  Comedy Color(0xff51ac06)
//  Crime Color(0xff4004d7)
//  Documentary Color(0xff0b6a33)
//  Drama Color(0xff49ad0b)
//  Family Color(0xff019356)
//  Fantasy Color(0xff039620)
// History Color(0xffb49208)
//  Horror Color(0xff0c6803)
//  Music Color(0xffc01111)
//  Mystery Color(0xff504907)
//  Romance Color(0xffa00e80)
//  Science Fiction Color(0xff044452)
//  Thriller Color(0xff8a08b5)
//  War Color(0xff0b7f1e)
//  Western Color(0xff9d105b)