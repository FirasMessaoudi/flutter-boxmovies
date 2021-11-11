
import 'package:equatable/equatable.dart';

class FavMovieState extends Equatable {
  final bool isFavMovie;
  const FavMovieState(
      this.isFavMovie,
      );
  factory FavMovieState.initial() {
    return FavMovieState(
      false,
    );
  }
  @override
  List<Object> get props => [isFavMovie];

  FavMovieState copyWith({
    bool? isFavMovie,
  }) {
    return FavMovieState(
      isFavMovie ?? this.isFavMovie,
    );
  }
}
