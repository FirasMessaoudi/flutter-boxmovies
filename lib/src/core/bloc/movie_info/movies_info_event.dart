
import 'package:equatable/equatable.dart';

abstract class MoviesInfoEvent extends Equatable {
  const MoviesInfoEvent();

  @override
  List<Object> get props => [];
}

class LoadMoviesInfo extends MoviesInfoEvent {
  final String id;
  LoadMoviesInfo({
    required this.id,
  });
}
