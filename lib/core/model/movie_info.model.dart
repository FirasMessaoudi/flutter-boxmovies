import 'dart:convert';

import 'categorie.model.dart';

class MovieInfoModel {
   int? id;
   String? tmdbId;
   String? overview;
   String? title;
   List? languages;
   String? backdrops;
   String? poster;
   int? budget;
   String? tagline;
   double? rateing;
   int? vote_count;
   String? dateByMonth;
   int? runtime;
   String? homepage;
   String? imdbid;
   List<Categorie>? genres;
   String? releaseDate;
   List<CompaniesModel>? production_companies;
   List<CountriesModel>? production_countries;
   int? revenue;

  MovieInfoModel(
      { this.id,
       this.tmdbId,
       this.overview,
       this.title,
       this.languages,
       this.backdrops,
       this.poster,
       this.budget,
       this.tagline,
       this.rateing,
       this.vote_count,
       this.dateByMonth,
       this.runtime,
       this.homepage,
       this.imdbid,
       this.genres,
       this.releaseDate,
       this.production_companies,
        this.revenue,
       this.production_countries});

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
      revenue: json['revenue'] ?? 0,
      production_companies: List<CompaniesModel>.from(
          json['production_companies']?.map((x) => CompaniesModel.fromMap(x))),
      production_countries: List<CountriesModel>.from(
          json['production_countries']?.map((x) => CountriesModel.fromMap(x))),
    );
  }
}

class MovieInfoImdb {
   String? genre;
   String? runtime;
   String? director;
   String? writer;
   String? actors;
   String? language;
   String? awards;
   String? released;
   String? country;
   String? boxOffice;
   String? year;
   String? rated;
   String? plot;
   String? production;

  MovieInfoImdb({
     this.genre,
     this.runtime,
     this.director,
     this.writer,
     this.actors,
     this.language,
     this.awards,
     this.released,
     this.country,
     this.boxOffice,
     this.year,
     this.rated,
     this.plot,
     this.production,
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
   String? id;
   String? site;
   String? name;
   String? key;

  TrailerModel({
     this.id,
     this.site,
     this.name,
     this.key,
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
   List<TrailerModel>? trailers;

  TrailerList({
     this.trailers,
  });

  factory TrailerList.fromJson(json) {
    return TrailerList(
        trailers: (json['results'] as List)
            .map((trailer) => TrailerModel.fromJson(trailer))
            .toList());
  }
}

class ImageBackdrop {
   String? image;

  ImageBackdrop({
     this.image,
  });

  factory ImageBackdrop.fromJson(json) {
    return new ImageBackdrop(
      image: "https://image.tmdb.org/t/p/original" + json['file_path'],
    );
  }
}

class ImageBackdropList {
   List<ImageBackdrop>? backdrops;
   List<ImageBackdrop>? posters;
   List<ImageBackdrop>? logos;

  ImageBackdropList({
     this.posters,
     this.logos,
     this.backdrops,
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
   String? name;
   String? character;
   String? image;
   String? id;

  CastInfo({
     this.name,
     this.character,
     this.image,
     this.id,
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
   List<CastInfo>? castList;

  CastInfoList({
     this.castList,
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
   String? name;
   int? id;

  CompaniesModel({
     this.name,
     this.id,
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
   String? iso_3166_1;
   String? name;

  CountriesModel({
     this.iso_3166_1,
     this.name,
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
