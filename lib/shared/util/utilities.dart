import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:moviebox/core/model/categorie.model.dart';
import 'package:moviebox/core/routes/app_routes.dart';
import 'package:moviebox/ui/home/all_movies/all_movies.controller.dart';
import 'package:moviebox/ui/home/all_tv_show/all_tv_shows.controller.dart';
import 'package:moviebox/ui/movies_details/movies_details.controller.dart';
import 'package:moviebox/ui/tv_show_details/tv_show_details.controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../themes.dart';

final countries = [
  "Afghanistan",
  "Albania",
  "Algeria",
  "Andorra",
  "Angola",
  "Anguilla",
  "Antigua Barbuda",
  "Argentina",
  "Armenia",
  "Aruba",
  "Australia",
  "Austria",
  "Azerbaijan",
  "Bahamas",
  "Bahrain",
  "Bangladesh",
  "Barbados",
  "Belarus",
  "Belgium",
  "Belize",
  "Benin",
  "Bermuda",
  "Bhutan",
  "Bolivia",
  "Bosnia  Herzegovina",
  "Botswana",
  "Brazil",
  "British Virgin Islands",
  "Brunei",
  "Bulgaria",
  "Burkina Faso",
  "Burundi",
  "Cambodia",
  "Cameroon",
  "Cape Verde",
  "Cayman Islands",
  "Chad",
  "Chile",
  "China",
  "Colombia",
  "Congo",
  "Cook Islands",
  "Costa Rica",
  "Cote D Ivoire",
  "Croatia",
  "Cruise Ship",
  "Cuba",
  "Cyprus",
  "Czech Republic",
  "Denmark",
  "Djibouti",
  "Dominica",
  "Dominican Republic",
  "Ecuador",
  "Egypt",
  "El Salvador",
  "Equatorial Guinea",
  "Estonia",
  "Ethiopia",
  "Falkland Islands",
  "Faroe Islands",
  "Fiji",
  "Finland",
  "France",
  "French Polynesia",
  "French West Indies",
  "Gabon",
  "Gambia",
  "Georgia",
  "Germany",
  "Ghana",
  "Gibraltar",
  "Greece",
  "Greenland",
  "Grenada",
  "Guam",
  "Guatemala",
  "Guernsey",
  "Guinea",
  "Guinea Bissau",
  "Guyana",
  "Haiti",
  "Honduras",
  "Hong Kong",
  "Hungary",
  "Iceland",
  "India",
  "Indonesia",
  "Iran",
  "Iraq",
  "Ireland",
  "Isle of Man",
  "Israel",
  "Italy",
  "Jamaica",
  "Japan",
  "Jersey",
  "Jordan",
  "Kazakhstan",
  "Kenya",
  "Kuwait",
  "Kyrgyz Republic",
  "Laos",
  "Latvia",
  "Lebanon",
  "Lesotho",
  "Liberia",
  "Libya",
  "Liechtenstein",
  "Lithuania",
  "Luxembourg",
  "Macau",
  "Macedonia",
  "Madagascar",
  "Malawi",
  "Malaysia",
  "Maldives",
  "Mali",
  "Malta",
  "Mauritania",
  "Mauritius",
  "Mexico",
  "Moldova",
  "Monaco",
  "Mongolia",
  "Montenegro",
  "Montserrat",
  "Morocco",
  "Mozambique",
  "Namibia",
  "Nepal",
  "Netherlands",
  "Netherlands Antilles",
  "New Caledonia",
  "New Zealand",
  "Nicaragua",
  "Niger",
  "Nigeria",
  "Norway",
  "Oman",
  "Pakistan",
  "Palestine",
  "Panama",
  "Papua New Guinea",
  "Paraguay",
  "Peru",
  "Philippines",
  "Poland",
  "Portugal",
  "Puerto Rico",
  "Qatar",
  "Reunion",
  "Romania",
  "Russia",
  "Rwanda",
  "Saint Pierre  Miquelon",
  "Samoa",
  "San Marino",
  "Satellite",
  "Saudi Arabia",
  "Senegal",
  "Serbia",
  "Seychelles",
  "Sierra Leone",
  "Singapore",
  "Slovakia",
  "Slovenia",
  "South Africa",
  "South Korea",
  "Spain",
  "Sri Lanka",
  "St Kitts  Nevis",
  "St Lucia",
  "St Vincent",
  "St. Lucia",
  "Sudan",
  "Suriname",
  "Swaziland",
  "Sweden",
  "Switzerland",
  "Syria",
  "Taiwan",
  "Tajikistan",
  "Tanzania",
  "Thailand",
  "Timor L'Este",
  "Togo",
  "Tonga",
  "Trinidad  Tobago",
  "Tunisia",
  "Turkey",
  "Turkmenistan",
  "Turks  Caicos",
  "Uganda",
  "Ukraine",
  "United Arab Emirates",
  "United Kingdom",
  "Uruguay",
  "Uzbekistan",
  "Venezuela",
  "Vietnam",
  "Virgin Islands (US)",
  "Yemen",
  "Zambia",
  "Zimbabwe"
];
final movieGenres = [
  {"id": 28, "name": "Action", "nameAr": "حركة"},
  {"id": 12, "name": "Adventure", "nameAr": "مغامرة"},
  {"id": 16, "name": "Animation", "nameAr": "إنيمشن"},
  {"id": 35, "name": "Comedy", "nameAr": "كوميديا"},
  {"id": 80, "name": "Crime", "nameAr": "جريمة"},
  {"id": 99, "name": "Documentary", "nameAr": "وثائقي"},
  {"id": 18, "name": "Drama", "nameAr": "دراما"},
  {"id": 10751, "name": "Family", "nameAr": "عائلي"},
  {"id": 14, "name": "Fantasy", "nameAr": "فانتازيا"},
  {"id": 36, "name": "History", "nameAr": "تاريخي"},
  {"id": 27, "name": "Horror", "nameAr": "رعب"},
  {"id": 10402, "name": "Music", "nameAr": "موسيقي"},
  {"id": 9648, "name": "Mystery", "nameAr": "غموض"},
  {"id": 10749, "name": "Romance", "nameAr": "رومنسي"},
  {"id": 878, "name": "Science Fiction", "nameAr": "خيال علمي"},
  {"id": 10770, "name": "TV Movie", "nameAr": "فيلم تلفزي"},
  {"id": 53, "name": "Thriller", "nameAr": "اثارة"},
  {"id": 10752, "name": "War", "nameAr": "حرب"},
  {"id": 37, "name": "Western", "nameAr": "غربي"}
];
final tvGenres = [
  {"id": 10759, "name": "Action & Adventure"},
  {"id": 16, "name": "Animation"},
  {"id": 35, "name": "Comedy"},
  {"id": 80, "name": "Crime"},
  {"id": 99, "name": "Documentary"},
  {"id": 18, "name": "Drama"},
  {"id": 10751, "name": "Family"},
  {"id": 10762, "name": "Kids"},
  {"id": 9648, "name": "Mystery"},
  {"id": 10763, "name": "News"},
  {"id": 10764, "name": "Reality"},
  {"id": 10765, "name": "Sci-Fi & Fantasy"},
  {"id": 10766, "name": "Soap"},
  {"id": 10767, "name": "Talk"},
  {"id": 10768, "name": "War & Politics"},
  {"id": 37, "name": "Western"}
];

convertDate(String stringDate, String local) {
  try {
    DateTime date = DateTime.parse(stringDate);
    String formattedDate = DateFormat('dd MMMM yyyy', local).format(date);
    return formattedDate;
  } catch (e) {
    return stringDate;
  }
}

getCatgoryNameFromCatgeoryObject(List<Categorie> categories) {
  String categoriesName = '';
  categories.forEach((element) {
    categoriesName += element.name + ', ';
  });
  print(categoriesName);
  return categoriesName;
}

String getMoviesCategorieNamesAr(List<int> ids) {
  String categories = '';
  ids.forEach((id) {
    categories += movieGenres
            .firstWhere((element) => element['id'] == id)['nameAr']
            .toString() +
        ' , ';
  });
  return categories;
}

String getMoviesCategorieNames(List<int> ids) {
  String categories = '';
  ids.forEach((id) {
    categories += movieGenres
            .firstWhere((element) => element['id'] == id)['name']
            .toString() +
        ' , ';
  });
  return categories;
}

String getTvCategorieNames(List<int> ids) {
  String categories = '';
  ids.forEach((id) {
    categories += tvGenres
            .firstWhere((element) => element['id'] == id)['name']
            .toString() +
        ' , ';
  });
  return categories;
}

List<int> getOnlyIds(List<dynamic> list) {
  List<int> result = [];
  list.forEach((element) {
    result.add(element.id);
  });
  return result;
}

Future<String?> currentLanguage() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? language = pref.getString('language');
  return language;
}

Future<String?> getCurrentLanguageLabel() async {
  String? lang = await currentLanguage();
  print(lang);
  switch (lang) {
    case 'en-US':
      return 'English';
    case 'ar-SA':
      return 'Arabic';
    case 'fr-FR':
      return 'French';
    case 'it-IT':
      return 'Italian';
    case 'es-ES':
      return 'Spanish';
    default:
      return 'English';
  }
}

void showLoaderDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(color: redColor),
        Container(margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

void showToast([String? text]) {
  Fluttertoast.showToast(
      msg: text ?? '',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black45,
      textColor: Colors.white,
      fontSize: 16.0);
}

void moveToInfo(BuildContext context, bool isMovie, String id, String backdrop,
    String name) {
  if (isMovie) {
    // go to movie
    Get.toNamed(AppRoutes.movieDetails,arguments: backdrop);
    MoviesDetailsController.instance.getDetails(id);

  } else {
    // go to tv
    Get.toNamed(AppRoutes.tvShowDetails,arguments: backdrop);
    TvShowsDetailsController.instance.getDetails(id);
  }
}
