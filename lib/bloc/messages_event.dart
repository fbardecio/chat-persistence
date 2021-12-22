part of 'messages_bloc.dart';

class MessagesEvent extends Equatable {
  const MessagesEvent();

  @override
  List<Object?> get props => [];
}

class ChannelsLoad extends MessagesEvent {
  const ChannelsLoad();

  @override
  List<Object?> get props => [];
}

class ChannelsLoaded extends MessagesEvent {
  const ChannelsLoaded({required this.channels});

  final List<Channel> channels;

  @override
  List<Object?> get props => [channels];
}
