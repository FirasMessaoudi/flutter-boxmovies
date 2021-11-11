import 'package:flutter/material.dart';

class Network {
  final String id;
  final String name;
  final String image;
  final Color color;
  final String logo_path;
  Network({
    required this.color,
    required this.image,
    required this.id,
    required this.name,
    required this.logo_path
  });
  factory Network.fromJson(json) {
    return Network(
      id: json['id'].toString(),
      name: json['name'],
      image: json['image'].toString(),
      color: json['color'],
      logo_path: json['logo_path'].toString()
    );
  }
}

class NetworkList {
  final List<Network> list;
  NetworkList({
    required this.list,
  });
  factory NetworkList.fromJson(json) {
    return NetworkList(
        list: (json as List).map((genre) => Network.fromJson(genre)).toList());
  }
}

final networklist = [
  {
    "id": 213,
    "name": "NETFLIX",
    "image":
        "netflix.png",
    "color": Color(0xff526605),
  },
  {
    "id": 1024,
    "name": "AMAZON PRIME",
    "image":
        "amazon.jpg",
    "color": Color(0xff1d0d87)
  },
  {
    "id": 71,
    "name": "CW",
    "image":
        "cw.jpg",
    "color": Color(0xff51ac06)
  },
  {
    "id": 2552,
    "name": "Apple",
    "image":
        "Apple-tv-logo.jpg",
    "color": Color(0xff375304)
  },
  {
    "id": 2360,
    "name": "History",
    "image":
        "history.jpg",
    "color": Color(0xff4004d7)
  },
  {
    "id": 453,
    "name": "HULU",
    "image":
        "hulu.jpg",
    "color": Color(0xff0b6a33)
  },
  {
    "id": 318,
    "name": "Starz",
    "image":
        "starzplay.png",
    "color": Color(0xff039620)
  },
  {
    "id": 2739,
    "name": "Disney +",
    "image":
        "disneyplus.jpg",
    "color": Color(0xff4004d7)
  },
  {
    "id": 3186,
    "name": "HBO Max",
    "image":
        "hbomax.jpg",
    "color": Color(0xff039620)
  },
   {
    "id": 67,
    "name": "Showtime",
    "image":
        "showtime-logo.png",
    "color": Color(0xff039620)
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

//companies

final companylist = [
  {
    "id": 420,
    "name": "Marvel",
    "image":
        "marvel.jpg",
    "color": Color(0xff526605),
  },
  {
    "id": 429,
    "name": "DC Universe",
    "image":
        "DC_Comics_logo.svg.png",
    "color": Color(0xff1d0d87)
  },
  {
    "id": 174,
    "name": "WARNER",
    "image":
        "warner.png",
    "color": Color(0xff51ac06)
  },
  {
    "id": 34,
    "name": "Sony",
    "image":
        "sony.jpg",
    "color": Color(0xff375304)
  },
  {
    "id": 2,
    "name": "Disney",
    "image":
        "waltdisney.jpg",
    "color": Color(0xff4004d7)
  },
  {
    "id": 33,
    "name": "Universal",
    "image":
        "universal.jpg",
    "color": Color(0xff0b6a33)
  },
  {
    "id": 25,
    "name": "Fox",
    "image":
        "20fox.png",
    "color": Color(0xff039620)
  },
  {
    "id": 4,
    "name": "Paramount",
    "image":
        "paramount.jpg",
    "color": Color(0xff4004d7)
  },
  {
    "id": 1632,
    "name": "Lionsgate",
    "image":
        "lionsgate.jpg",
    "color": Color(0xff039620)
  },
   {
    "id": 5,
    "name": "Columbia",
    "image":
        "columbia.png",
    "color": Color(0xff039620)
  },
   {
    "id": 21,
    "name": "MGM",
    "image":
        "mgm.jpg",
    "color": Color(0xff039620)
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
class NetworksList {
  final List<Network> list;
  NetworksList({
    required this.list,
  });
  factory NetworksList.fromJson(json) {
    return NetworksList(
        list: (json as List).map((genre) => Network.fromJson(genre)).toList());
  }
}
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