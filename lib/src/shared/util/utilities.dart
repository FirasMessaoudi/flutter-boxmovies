import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moviebox/src/core/bloc/movie_info/movies_info.dart';
import 'package:moviebox/src/core/bloc/movie_info/movies_info_bloc.dart';
import 'package:moviebox/src/core/bloc/movie_info/movies_info_event.dart';
import 'package:moviebox/src/core/bloc/tv_info/show_info_bloc.dart';
import 'package:moviebox/src/core/bloc/tv_info/show_info_event.dart';
import 'package:moviebox/src/core/bloc/tv_info/widget/tv_show_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../themes.dart';

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
  {"id": 28, "name": "Action"},
  {"id": 12, "name": "Adventure"},
  {"id": 16, "name": "Animation"},
  {"id": 35, "name": "Comedy"},
  {"id": 80, "name": "Crime"},
  {"id": 99, "name": "Documentary"},
  {"id": 18, "name": "Drama"},
  {"id": 10751, "name": "Family"},
  {"id": 14, "name": "Fantasy"},
  {"id": 36, "name": "History"},
  {"id": 27, "name": "Horror"},
  {"id": 10402, "name": "Music"},
  {"id": 9648, "name": "Mystery"},
  {"id": 10749, "name": "Romance"},
  {"id": 878, "name": "Science Fiction"},
  {"id": 10770, "name": "TV Movie"},
  {"id": 53, "name": "Thriller"},
  {"id": 10752, "name": "War"},
  {"id": 37, "name": "Western"}
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
 String getMoviesCategorieNames(List<int> ids){
   String categories= '';
   ids.forEach((id) {
     categories += movieGenres.firstWhere((element) => element['id'] ==id)['name'].toString()+ ' , ';
   });
   return categories;
 }
String getTvCategorieNames(List<int> ids){
  String categories= '';
  ids.forEach((id) {
    categories += tvGenres.firstWhere((element) => element['id'] ==id)['name'].toString() + ' , ';
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
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => BlocProvider(
              create: (context) =>
                  MoviesInfoBloc()..add(LoadMoviesInfo(id: id)),
              child: MoivesInfo(
                image: backdrop,
                title: name,
              ),
            )));
  } else {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => BlocProvider(
              create: (context) => ShowInfoBloc()..add(LoadTvInfo(id: id)),
              child: TvInfo(
                image: backdrop,
                title: name,
              ),
            )));
  }
}
