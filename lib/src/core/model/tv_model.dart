class TvModel {
  final String title;
  final String poster;
  final String id;
  final String backdrop;
  final double vote_average;
  final String year;
  final String release_date;
  final List<int> genres;

  TvModel({
    required this.title,
    required this.poster,
    required this.id,
    required this.backdrop,
    required this.vote_average,
    required this.year,
    required this.release_date,
    required this.genres,
  });

  factory TvModel.fromJson(Map<String, dynamic> json) {
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
            "${monthgenrater(json['first_air_date'].split("-")[1])} ${json['first_air_date'].split("-")[2]}, ${json['first_air_date'].split("-")[0]}";
      } catch (e) {
        print(e.toString());
      }
    }

    getString();
    return new TvModel(
      backdrop: json['backdrop_path'] != null
          ? "https://image.tmdb.org/t/p/original" + json['backdrop_path']
          : "https://www.prokerala.com/movies/assets/img/no-poster-available.jpg",
      poster: json['poster_path'] != null
          ? "https://image.tmdb.org/t/p/w500" + json['poster_path']
          : "https://www.prokerala.com/movies/assets/img/no-poster-available.jpg",
      id: json['id'].toString(),
      title: json['name'],
      year: json['first_air_date'].toString(),
      vote_average: json['vote_average'].toDouble() ?? 0.0,
      release_date: string,
      genres: List<int>.from(json["genre_ids"].map((x) => x)),
    );
  }
}

class TvModelList {
  final List<TvModel> movies;

  TvModelList({
    required this.movies,
  });

  factory TvModelList.fromJson(List<dynamic> json) {
    return new TvModelList(
        movies: (json as List).map((list) => TvModel.fromJson(list)).toList());
  }
}
