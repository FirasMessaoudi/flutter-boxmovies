import 'package:equatable/equatable.dart';

class WatchedEpisodeState extends Equatable {
  final bool isTvInWatchlist;
  final bool isWatchedEpisode;
  final String tvName;

  const WatchedEpisodeState(
    this.isTvInWatchlist,
    this.isWatchedEpisode,
    this.tvName,
  );

  factory WatchedEpisodeState.initial() {
    return WatchedEpisodeState(false, false, '');
  }

  @override
  List<Object> get props => [isTvInWatchlist, isWatchedEpisode, tvName];

  WatchedEpisodeState copyWith({
    bool? isTvInWatchlist,
    bool? isWatchedEpisode,
    String? tvName,
  }) {
    return WatchedEpisodeState(
      isTvInWatchlist ?? this.isTvInWatchlist,
      isWatchedEpisode ?? this.isWatchedEpisode,
      tvName ?? this.tvName,
    );
  }
}
