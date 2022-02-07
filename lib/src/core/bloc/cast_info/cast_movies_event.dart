import 'package:equatable/equatable.dart';

abstract class CastMoviesEvent extends Equatable {
  const CastMoviesEvent();

  @override
  List<Object> get props => [];
}

class LoadCastInfo extends CastMoviesEvent {
  final String id;

  LoadCastInfo({
    required this.id,
  });
}
