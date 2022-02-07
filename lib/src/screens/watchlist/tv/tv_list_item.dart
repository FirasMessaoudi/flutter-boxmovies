import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:moviebox/src/core/model/watchlist.dart';
import 'package:moviebox/src/core/repo/fav_repo.dart';
import 'package:moviebox/src/core/repo/movies_repo.dart';
import 'package:moviebox/src/core/repo/tv_shows_repo.dart';
import 'package:moviebox/src/core/repo/watchlist_repo.dart';
import 'package:moviebox/src/responsive/responsive.dart';
import 'package:moviebox/src/shared/util/fav_type.dart';
import 'package:moviebox/src/shared/util/utilities.dart';
import 'package:moviebox/src/shared/widget/actions_bottom_sheet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../../../themes.dart';


class TvListItem extends StatefulWidget {
  final FavoriteWatchListModel movie;
   final String sortBy;

  const TvListItem(
      {Key? key,
      required this.movie, required this.sortBy,
   })
      : super(key: key);

  @override
  _TvListItemState createState() => _TvListItemState();
}

class _TvListItemState extends State<TvListItem> {
  bool isDeleted = false;
  final repo = new FavRepo();
  final watchlistRepo = new WatchListRepo();
  final tvRepo = new TVRepo();
  final movieRepo = new MoviesRepo();
  dynamic tvInfo;
  int nbEpisodes = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      tvRepo.getTvDataById(widget.movie.id).then((value) => {
        setState(() {
      tvInfo = value;
        })
      });
      watchlistRepo.getNbWatchedEpisodesBySerie(widget.movie.id).then((value) => {
        nbEpisodes = value
      });

  }

  @override
  void didUpdateWidget(covariant TvListItem oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 0.0),
        child:
        resultItem()
           );
  }

  Widget resultItem() {
      if(widget.sortBy=='1'){
        //finished
        if(tvInfo.status=='Ended' && tvInfo.numberEpisodes == nbEpisodes){
          return item();
        }else {
          return SizedBox(height: 0);
        }
      }else if(widget.sortBy=='2'){
        //watching
        if(nbEpisodes>0 && nbEpisodes<tvInfo.numberEpisodes){
          return item();
        }else {
          return SizedBox(height: 0);
        }
      }else if (widget.sortBy=='3'){
        //up to date
        if(tvInfo.status!='Ended' && nbEpisodes==tvInfo.numberEpisodes){
          return item();
        }else {
          return SizedBox(height: 0);
        }
      }
      else if (widget.sortBy=='4'){
        //not started
        if(nbEpisodes==0){
          return item();
        }else {
          return SizedBox(height: 0);
        }
      }else {
        //all
        return item();

      }

  }
  Widget item(){
    return tvInfo!=null? Container(
      padding: EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  moveToInfo(context, false, widget.movie.id,
                      widget.movie.backdrop, widget.movie.title);
                },
                onLongPress: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      builder: (context) {
                        return BottomSheet(
                          //backgroundColor: color,
                          onClosing: () {},
                          builder: (context) => ActionsBottomSheet(
                              widget.movie.id,
                              widget.movie.title,
                              widget.movie.poster,
                              widget.movie.date,
                              widget.movie.isMovie,
                              widget.movie.rate,
                              widget.movie.backdrop,
                              Theme.of(context).brightness ==
                                  Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                              FavType.tv,
                              '',
                              '',
                              null),
                        );
                      });
                },
                child: Container(
                  color: Colors.grey.shade900,
                  child: CachedNetworkImage(
                    imageUrl: Responsive.isDesktop(context)?tvInfo.backdrops:tvInfo.poster,
                    height: 190,
                    fit: BoxFit.cover,
                  ),
                ),
              )),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tvInfo.title,
                          style: heading.copyWith(
                            fontSize: 16,
                            //  color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(convertDate(tvInfo.date,context.locale.languageCode),
                            style: normalText.copyWith(
                              fontSize: 14
                              // color: Colors.white,
                            )),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            IconTheme(
                              data: IconThemeData(
                                // color: Colors.yellowAccent,
                                size: 20,
                              ),
                              child: Icon(Icons.star,
                                  color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                      ? Colors.yellow
                                      : Colors.black45),
                            ),
                            // Icon(Icons.star, color: Colors.yellow),

                            Text(
                              "" +
                                  widget.movie.rate.toString() +
                                  "/10",
                              style: normalText.copyWith(
                                fontSize: 14,
                                //color: Colors.white,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 9),
                        RichText(
                          text: TextSpan(
                            style: normalText.copyWith(fontSize: 14, color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black),
                            children: [
                              ...tvInfo.genres
                                  .map(
                                    (genre) => TextSpan(text: "${genre.name}, "),
                              )
                                  .toList()
                            ],
                          ),
                        ),
                        SizedBox(height: 9),
                        tvInfo!=null?Text(
                          nbEpisodes.toString()+'/'+tvInfo.numberEpisodes.toString(),
                          style: normalText,
                        ):Text(''),
                        SizedBox(height: 5),
                        if(tvInfo!=null)
                        new LinearPercentIndicator(
                          lineHeight: 18.0,
                          percent: nbEpisodes/tvInfo.numberEpisodes,
                          center: new Text(
                              (nbEpisodes/tvInfo.numberEpisodes *100).toStringAsFixed(0)+'%',
                            style: TextStyle(
                              color: isFinished()?Colors.white:Colors.black
                            ),

                          ),
                          progressColor: isFinished()?Colors.purple:isUpToDate()?Colors.green: Colors.yellowAccent,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ):Container();
  }
   isFinished(){
    return tvInfo.status=='Ended' && nbEpisodes ==tvInfo.numberEpisodes;
   }
  isUpToDate(){
    return tvInfo.status!='Ended' && nbEpisodes ==tvInfo.numberEpisodes;
  }
}

