import 'dart:convert';

import 'categorie.dart';

class MovieInfoModel {
  final int id;
  final String tmdbId;
  final String overview;
  final String title;
  final List languages;
  final String backdrops;
  final String poster;
  final int budget;
  final String tagline;
  final double rateing;
  final int vote_count;
  final String dateByMonth;
  final int runtime;
  final String homepage;
  final String imdbid;
  final List<Categorie> genres;
  final String releaseDate;
  final List<CompaniesModel> production_companies;
  final List<CountriesModel> production_countries;

  MovieInfoModel(
      {required this.id,
      required this.tmdbId,
      required this.overview,
      required this.title,
      required this.languages,
      required this.backdrops,
      required this.poster,
      required this.budget,
      required this.tagline,
      required this.rateing,
      required this.vote_count,
      required this.dateByMonth,
      required this.runtime,
      required this.homepage,
      required this.imdbid,
      required this.genres,
      required this.releaseDate,
      required this.production_companies,
      required this.production_countries});

  factory MovieInfoModel.fromJson(json) {
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
            "${monthgenrater(json['release_date'].split("-")[1])} ${json['release_date'].split("-")[2]}, ${json['release_date'].split("-")[0]}";
      } catch (e) {
        print(e.toString());
      }
    }

    getString();
    return new MovieInfoModel(
      id: json['id'],
      budget: json['budget'],
      title: json['title'] ?? '',
      homepage: json['homepage'] ?? "",
      imdbid: json['imdb_id'] ?? "",
      languages: (json['spoken_languages'] as List)
          .map((laung) => laung['english_name'])
          .toList(),
      genres: List<Categorie>.from(
          json['genres']?.map((x) => Categorie.fromMap(x))),
      overview: json['overview'] ?? json['actors'] ?? '',
      backdrops: json['backdrop_path'] != null
          ? "https://image.tmdb.org/t/p/original" + json['backdrop_path']
          : "https://www.prokerala.com/movies/assets/img/no-poster-available.jpg",
      poster: json['poster_path'] != null
          ? "https://image.tmdb.org/t/p/w500" + json['poster_path']
          : "https://www.prokerala.com/movies/assets/img/no-poster-available.jpg",
      rateing: json['vote_average'],
      vote_count: json['vote_count'],
      runtime: json['runtime'],
      tagline: json['tagline'] ?? json['actors'] ?? '',
      tmdbId: json['id'].toString(),
      releaseDate: json['release_date'] ?? '',
      dateByMonth: string,
      production_companies: List<CompaniesModel>.from(
          json['production_companies']?.map((x) => CompaniesModel.fromMap(x))),
      production_countries: List<CountriesModel>.from(
          json['production_countries']?.map((x) => CountriesModel.fromMap(x))),
    );
  }
}

class MovieInfoImdb {
  final String genre;
  final String runtime;
  final String director;
  final String writer;
  final String actors;
  final String language;
  final String awards;
  final String released;
  final String country;
  final String boxOffice;
  final String year;
  final String rated;
  final String plot;
  final String production;

  MovieInfoImdb({
    required this.genre,
    required this.runtime,
    required this.director,
    required this.writer,
    required this.actors,
    required this.language,
    required this.awards,
    required this.released,
    required this.country,
    required this.boxOffice,
    required this.year,
    required this.rated,
    required this.plot,
    required this.production,
  });

  factory MovieInfoImdb.fromJson(json) {
    return MovieInfoImdb(
      actors: json['Actors'] ?? '',
      rated: json['Rated'] ?? '',
      production: json['Production'] ?? '',
      plot: json['Plot'] ?? '',
      awards: json['Awards'] ?? '',
      director: json['Director'] ?? '',
      genre: json['Genre'] ?? '',
      language: json['Language'] ?? '',
      released: json['Released'] ?? '',
      runtime: json['Runtime'] ?? '',
      writer: json['Writer'] ?? '',
      year: json['Year'].toString(),
      boxOffice: json['BoxOffice'].toString(),
      country: json['Country'] ?? '',
    );
  }
}

class TrailerModel {
  final String id;
  final String site;
  final String name;
  final String key;

  TrailerModel({
    required this.id,
    required this.site,
    required this.name,
    required this.key,
  });

  factory TrailerModel.fromJson(json) {
    return TrailerModel(
      key: json['key'] ?? '',
      id: json['id'] ?? '',
      site: json['site'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class TrailerList {
  final List<TrailerModel> trailers;

  TrailerList({
    required this.trailers,
  });

  factory TrailerList.fromJson(json) {
    return TrailerList(
        trailers: (json['results'] as List)
            .map((trailer) => TrailerModel.fromJson(trailer))
            .toList());
  }
}

class ImageBackdrop {
  final String image;

  ImageBackdrop({
    required this.image,
  });

  factory ImageBackdrop.fromJson(json) {
    return new ImageBackdrop(
      image: "https://image.tmdb.org/t/p/original" + json['file_path'],
    );
  }
}

class ImageBackdropList {
  final List<ImageBackdrop> backdrops;
  final List<ImageBackdrop> posters;
  final List<ImageBackdrop> logos;

  ImageBackdropList({
    required this.posters,
    required this.logos,
    required this.backdrops,
  });

  factory ImageBackdropList.fromJson(backdrops, posters, logos) {
    return new ImageBackdropList(
      backdrops: (backdrops as List)
          .map((backdrop) => ImageBackdrop.fromJson(backdrop))
          .toList(),
      logos: (posters as List)
          .map((backdrop) => ImageBackdrop.fromJson(backdrop))
          .toList(),
      posters: (logos as List)
          .map((backdrop) => ImageBackdrop.fromJson(backdrop))
          .toList(),
    );
  }
}

class CastInfo {
  final String name;
  final String character;
  final String image;
  final String id;

  CastInfo({
    required this.name,
    required this.character,
    required this.image,
    required this.id,
  });

  factory CastInfo.fromJson(json) {
    return new CastInfo(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      character: json['character'] ?? '',
      image: json['profile_path'] != null
          ? "https://image.tmdb.org/t/p/w500" + json['profile_path']
          : "",
    );
  }
}

class CastInfoList {
  final List<CastInfo> castList;

  CastInfoList({
    required this.castList,
  });

  factory CastInfoList.fromJson(json) {
    return CastInfoList(
      castList: (json['cast'] as List)
          .map((cast) => CastInfo.fromJson(cast))
          .toList(),
    );
  }
}

class CompaniesModel {
  final String name;
  final int id;

  CompaniesModel({
    required this.name,
    required this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
    };
  }

  factory CompaniesModel.fromMap(Map<String, dynamic> map) {
    return CompaniesModel(
      name: map['name'],
      id: map['id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CompaniesModel.fromJson(String source) =>
      CompaniesModel.fromMap(json.decode(source));
}

class CountriesModel {
  final String iso_3166_1;
  final String name;

  CountriesModel({
    required this.iso_3166_1,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'iso_3166_1': iso_3166_1,
      'name': name,
    };
  }

  factory CountriesModel.fromMap(Map<String, dynamic> map) {
    return CountriesModel(
      iso_3166_1: map['iso_3166_1'],
      name: map['name'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CountriesModel.fromJson(String source) =>
      CountriesModel.fromMap(json.decode(source));
}
