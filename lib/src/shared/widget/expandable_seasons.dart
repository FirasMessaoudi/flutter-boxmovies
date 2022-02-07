import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviebox/src/core/bloc/tv_info/widget/episode_info.dart';
import 'package:moviebox/src/core/model/season_info.dart';
import 'package:moviebox/src/core/model/tv_shows_info.dart';
import 'package:moviebox/src/core/repo/season_repo.dart';
import 'package:moviebox/src/shared/util/time_ago/timeago.dart' as timeago;
import 'package:moviebox/src/shared/util/utilities.dart';
import 'package:moviebox/src/shared/widget/watched_episode/toggle_watch_episode.dart';
import 'package:moviebox/src/shared/widget/watched_episode/watched_episode_cubit.dart';
import 'package:moviebox/themes.dart';

class ExpandableSeason extends StatefulWidget {
  final bool isExpanded;
  final Widget header;
  final List<ListTile>? items;
  final Widget? expandedIcon;
  final Widget? collapsedIcon;
  final EdgeInsets? headerEdgeInsets;
  final Color? headerBackgroundColor;
  final Color? textColor;
  final Seasons season;
  final int tvId;
  final String tvName;
  final String tvImage;
  final String tvDate;
  final double? tvRate;
  final String epRuntime;
  final String? tvGenre;
  final String backdrop;

  ExpandableSeason(
      {Key? key,
      this.isExpanded = false,
      required this.header,
      required this.items,
      required this.season,
      required this.tvId,
      this.expandedIcon,
      this.collapsedIcon,
      this.headerEdgeInsets,
      required this.tvName,
      this.tvImage = '',
      this.tvDate = '',
      this.tvRate,
      this.tvGenre,
      this.epRuntime = '',
      this.textColor,
      this.backdrop = '',
      this.headerBackgroundColor})
      : super(key: key);

  @override
  _ExpandableSeasonState createState() => _ExpandableSeasonState();
}

class _ExpandableSeasonState extends State<ExpandableSeason> {
  late bool _isExpanded;
  String local = 'en';
  final repo = SeasonRepo();

  @override
  void initState() {
    super.initState();
    _updateExpandState(widget.isExpanded);
  }

  void _updateExpandState(bool isExpanded) =>
      setState(() => _isExpanded = isExpanded);

  @override
  Widget build(BuildContext context) {
    currentLanguage().then((value) => {
          local = value!.substring(0, 2),
          print(local),
          timeago.setDefaultLocale(local)
        });
    return _isExpanded ? _buildListItems(context) : _wrapHeader();
  }

  Widget _wrapHeader() {
    List<Widget> children = [];
    if (!widget.isExpanded) {
      children.add(Divider(thickness: 1));
    }
    children.add(ListTile(
      contentPadding: widget.headerEdgeInsets != null
          ? widget.headerEdgeInsets
          : EdgeInsets.only(left: 0.0, right: 16.0),
      title: widget.header,
      trailing: _isExpanded
          ? widget.expandedIcon ?? Icon(Icons.keyboard_arrow_down)
          : widget.collapsedIcon ?? Icon(Icons.keyboard_arrow_right),
      onTap: () => _updateExpandState(!_isExpanded),
    ));
    return Ink(
      color:
          widget.headerBackgroundColor ?? Theme.of(context).appBarTheme.color,
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildListItems(BuildContext context) {
    return FutureBuilder<SeasonModel>(
        future: repo.getSeasonInfo(widget.tvId.toString(), widget.season.snum),
        builder: (context, AsyncSnapshot<SeasonModel> snapshot) {
          return Column(
            children: [
              _wrapHeader(),
              if (snapshot.hasData) ...[
                for (int i = 0; i < snapshot.data!.episodes.length; i++) ...[
                  _buildTile(snapshot.data!.episodes[i]),
                  if (i < snapshot.data!.episodes.length - 1)
                    Divider(
                      color: widget.textColor,
                    ),
                  SizedBox(
                    height: 5,
                  )
                ]
              ] else if (snapshot.connectionState == ConnectionState.waiting)
                Container(
                    child: Center(
                  child: CircularProgressIndicator(
                    color: redColor,
                  ),
                ))
              else
                Container()

              //  ListTile.divideTiles(tiles: _buildTile(snapshot.data!.episodes),context: context),
            ],
          );
        });
  }

  Widget _buildTile(EpisodeModel episode) {
    return ListTile(
        onTap: () {
          showModalBottomSheet(
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              context: context,
              builder: (context) {
                return BottomSheet(
                  builder: (context) => EpisodeInfo(
                    color: widget.headerBackgroundColor!,
                    model: episode,
                    textColor: widget.textColor!,
                  ),
                  onClosing: () {},
                );
              });
        },
        leading: Image.network(episode.stillPath),
        title: Text(
          'S' + widget.season.snum + ' | E' + episode.number,
          style: TextStyle(color: widget.textColor),
        ),
        subtitle: Text(episode.name, style: TextStyle(color: widget.textColor)),
        trailing: (DateTime.now().isBefore(DateTime.parse(episode.date)) ||
                FirebaseAuth.instance.currentUser == null)
            ? Text(timeago.format(DateTime.parse(episode.date),
                allowFromNow: true), style: TextStyle(color: widget.textColor))
            : BlocProvider(
                create: (context) => WatchedEpisodeCubit()
                  ..init(widget.tvName, widget.tvId.toString(), episode.id),
                child: ToggleWatchEpisode(
                    epTitle: episode.name,
                    epId: episode.id,
                    tvName: widget.tvName,
                    tvGenre: widget.tvGenre,
                    tvDate: widget.tvDate,
                    tvRate: widget.tvRate,
                    tvId: widget.tvId.toString(),
                    tvImage: widget.tvImage,
                    epRate: episode.voteAverage,
                    epRuntime: widget.epRuntime,
                    backdrop: widget.backdrop)));
  }
}
