import 'package:equatable/equatable.dart';

abstract class ShowInfoEvent extends Equatable {
  const ShowInfoEvent();

  @override
  List<Object> get props => [];
}

class LoadTvInfo extends ShowInfoEvent {
  final String id;

  LoadTvInfo({
    required this.id,
  });
}
