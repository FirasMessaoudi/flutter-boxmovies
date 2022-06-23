import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:moviebox/ui/collection/add_to_collection.dart';
import '../../../themes.dart';
import 'cubit/add_collection_cubit.dart';
import 'cubit/add_collection_state.dart';

class AddCollectionIcon extends StatefulWidget {
  final String title;
  final String image;
  final String movieid;
  final String backdrop;
  final Color likeColor;
  final Color unLikeColor;
  final String date;
  final double rate;
  final bool isMovie;
  final bool justIcon;

  AddCollectionIcon(
      {Key? key,
      required this.title,
      required this.image,
      required this.movieid,
      required this.backdrop,
      required this.likeColor,
      required this.unLikeColor,
      required this.date,
      required this.isMovie,
      required this.rate,
      this.justIcon = false})
      : super(key: key);

  @override
  State<AddCollectionIcon> createState() => _AddCollectionIconState();
}

class _AddCollectionIconState extends State<AddCollectionIcon> {
  bool isCollection = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CollectionCubit, CollectionState>(
      builder: (context, state) {
        if (!widget.justIcon) {
          return ListTile(
              onTap: () async {
                var devid = FirebaseAuth.instance.currentUser!.uid;
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BlocProvider<CollectionCubit>(
                    create: (context) =>
                        CollectionCubit()..init(widget.movieid),
                    child: AddToCollection(
                      date: widget.date,
                      image: widget.image,
                      isMovie: widget.isMovie,
                      title: widget.title,
                      rate: widget.rate,
                      movieid: widget.movieid,
                      devid: devid,
                      backdrop: widget.backdrop,
                      justIcon: widget.justIcon,
                    ),
                  ),
                ));
              },
              leading: Icon(
                Icons.list,
                color:
                    state.isCollection ? widget.likeColor : widget.unLikeColor,
                size: 30,
              ),
              title: Text(
                !state.isCollection
                    ? "bottom_sheet_actions.add_to_collection".tr
                    : "bottom_sheet_actions.already_in".tr+ "${state.collectionname}",
                style: normalText.copyWith(
                  color: widget.unLikeColor,
                ),
              ));
        } else {
          return IconButton(
              onPressed: () async {
                if (!state.isCollection) {
                  var devid = FirebaseAuth.instance.currentUser!.uid;
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (_) => CollectionCubit()..init(widget.movieid),
                      child: AddToCollection(
                        date: widget.date,
                        image: widget.image,
                        isMovie: widget.isMovie,
                        title: widget.title,
                        rate: widget.rate,
                        movieid: widget.movieid,
                        devid: devid,
                        backdrop: widget.backdrop,
                        justIcon: widget.justIcon,
                      ),
                    ),
                  ));
                } else {
                  final devid = await FirebaseAuth.instance.currentUser!.uid;
                  BlocProvider.of<CollectionCubit>(context)
                      .deleteFromCollection(devid, widget.movieid);
                }
              },
              icon: Icon(!state.isCollection
                  ? Icons.add_circle
                  : Icons.remove_circle));
        }
      },
    );
  }
}
