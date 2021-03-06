import 'package:intl/intl.dart';

class CastPersonalInfo {
   String? image;
   String? name;
   String? bio;
   String? id;
   String? birthday;
   String? placeOfBirth;
   String? knownfor;
   String? imdbId;
   String? old;
   String? gender;

  CastPersonalInfo({
     this.image,
     this.name,
     this.bio,
     this.id,
     this.birthday,
     this.placeOfBirth,
     this.knownfor,
     this.imdbId,
     this.old,
     this.gender,
  });

  factory CastPersonalInfo.fromJson(json) {
    getyears(String birthDateString) {
      String datePattern = "yyyy-MM-dd";

      DateTime birthDate = DateFormat(datePattern).parse(birthDateString);
      DateTime today = DateTime.now();

      int yearDiff = today.year - birthDate.year;
      int monthDiff = today.month - birthDate.month;
      int dayDiff = today.day - birthDate.day;
      return yearDiff;
    }

    List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    monthgenrater(String date) {
      switch (date) {
        case "01":
          return months[0];
        case "02":
          return months[1];
        case "03":
          return months[2];
        case "04":
          return months[3];
        case "05":
          return months[4];
        case "06":
          return months[5];
        case "07":
          return months[6];
        case "08":
          return months[7];
        case "09":
          return months[8];
        case "10":
          return months[9];
        case "11":
          return months[10];
        case "12":
          return months[11];
        default:
          return date + ",";
      }
    }

    var string = '';
    try {
      string =
          "${monthgenrater(json['birthday'].split("-")[1])} ${json['birthday'].split("-")[2]}, ${json['birthday'].split("-")[0]}";
    } catch (e) {}
    return new CastPersonalInfo(
      bio: json['biography'] ?? '',
      birthday: string,
      id: json['id'].toString(),
      image: json['profile_path'] != null
          ? "https://image.tmdb.org/t/p/original" + json['profile_path']
          : "https://www.prokerala.com/movies/assets/img/no-poster-available.jpg",
      imdbId: json['imdb_id'] ?? "",
      name: json['name'] ?? '',
      placeOfBirth: json['place_of_birth'] ?? '',
      knownfor: json['known_for_department'] ?? '',
      gender: json['gender'] == 2 ? 'Male' : 'Female',
      old: json['birthday'] != null
          ? getyears(json['birthday']).toString() + " years"
          : "N/A",
    );
  }
}

class SocialMediaInfo {
   String? instagram;
   String? twitter;
   String? facebook;
   String? imdbId;

  SocialMediaInfo({
     this.instagram,
     this.twitter,
     this.facebook,
     this.imdbId,
  });

  factory SocialMediaInfo.fromJson(json) {
    return new SocialMediaInfo(
      facebook: json['facebook_id'] != null
          ? "https://facebook.com/" + json['facebook_id']
          : "",
      imdbId: json['imdb_id'] != null
          ? "https://www.imdb.com/name/" + json['imdb_id']
          : "",
      instagram: json['instagram_id'] != null
          ? "https://www.instagram.com/" + json['instagram_id']
          : "",
      twitter: json['twitter_id'] != null
          ? "https://twitter.com/" + json['twitter_id']
          : "",
    );
  }
}
