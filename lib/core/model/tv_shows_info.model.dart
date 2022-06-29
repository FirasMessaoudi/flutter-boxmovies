import 'package:moviebox/core/model/network.model.dart';

import 'categorie.model.dart';

class TvInfoModel {
   int id;
   String tmdbId;
   String overview;
   String title;
   List languages;
   String backdrops;
   String poster;
   String tagline;
   double rateing;
   int vote_count;
   String homepage;
   List<Categorie> genres;
   List<Seasons> seasons;
   List created;
   List<Network> networks;
   String numberOfSeasons;
   String date;
   String formatedDate;
   String episoderuntime;
   String nextEpisode;
   int numberEpisodes;
   String status;

  TvInfoModel(
      { this.id=0,
       this.tmdbId='',
       this.overview='',
       this.title='',
       this.languages=const [],
       this.backdrops='',
       this.poster='',
       this.tagline='',
       this.rateing=0,
     this.vote_count=0,
     this.homepage='',
     this.genres= const [],
     this.seasons= const[],
     this.created= const[],
     this.networks= const[],
     this.numberOfSeasons = '',
     this.date = '',
     this.formatedDate='',
     this.episoderuntime='',
     this.nextEpisode='',
         this.numberEpisodes=0,
         this.status='',

      });


  factory TvInfoModel.fromJson(json) {
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
          "${monthgenrater(json['first_air_date'].split("-")[1])} ${json['first_air_date'].split("-")[2]}, ${json['first_air_date'].split("-")[0]}";
    } catch (e) {}
    return TvInfoModel(
      id: json['id'],
      title: json['name'] ?? '',
      homepage: json['homepage'] ?? "",
      languages: (json['spoken_languages'] as List)
          .map((laung) => laung['english_name'])
          .toList(),
      created:
          (json['created_by'] as List).map((laung) => laung['name']).toList(),
      genres: List<Categorie>.from(
          json['genres']?.map((x) => Categorie.fromMap(x))),
      networks:
          List<Network>.from(json['networks']?.map((x) => Network.fromJson(x))),
      overview: json['overview'] ?? '',
      backdrops: json['backdrop_path'] != null
          ? "https://image.tmdb.org/t/p/original" + json['backdrop_path']
          : "https://www.prokerala.com/movies/assets/img/no-poster-available.jpg",
      poster: json['poster_path'] != null
          ? "https://image.tmdb.org/t/p/w500" + json['poster_path']
          : "https://www.prokerala.com/movies/assets/img/no-poster-available.jpg",
      rateing: json['vote_average'],
      vote_count: json['vote_count'],
      tagline: json['tagline'] ?? '',
      nextEpisode: json['next_episode_to_air'] != null
          ? json['next_episode_to_air']['air_date']
          : 'N/A',
      tmdbId: json['id'].toString(),
      numberOfSeasons: json['number_of_seasons'].toString(),
      seasons: (json['seasons'] as List)
          .map((season) => Seasons.fromJson(season))
          .toList(),
      date: json['first_air_date'] ?? '',
      episoderuntime: (json['episode_run_time'] as List).isNotEmpty
          ? json['episode_run_time'][0].toString() + " Minutes"
          : "N/A",
      formatedDate: string,
      numberEpisodes: json['number_of_episodes'],
      status:  json['status']
    );
  }

}

class Seasons {
   String overview;
   String name;
   String id;
   String image;
   String date;
   String customOverView;
   String episodes;
   String snum;

  Seasons({
     this.overview='',
     this.name='',
     this.id='',
     this.image='',
     this.date='',
     this.customOverView='',
     this.episodes='',
     this.snum='',
  });

  factory Seasons.fromJson(json) {
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

    var string = "";
    getString() {
      try {
        string =
            "premiered on ${monthgenrater(json['air_date'].split("-")[1])} ${json['air_date'].split("-")[2]}, ${json['air_date'].split("-")[0]}";
      } catch (e) {
        print(e.toString());
      }
    }

    getString();
    return Seasons(
      date: json['air_date'] ?? '',
      episodes: json['episode_count'].toString(),
      id: json['id'].toString(),
      image: json['poster_path'] != null
          ? "https://image.tmdb.org/t/p/w500" + (json['poster_path'] ?? "")
          : "https://www.prokerala.com/movies/assets/img/no-poster-available.jpg",
      name: json['name'] ?? '',
      overview: json['overview'] == "" ? "N/A" : json['overview'] ?? "",
      customOverView: string,
      snum: json['season_number'].toString(),
    );
  }
}
