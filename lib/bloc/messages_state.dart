part of 'messages_bloc.dart';

class MessagesState extends Equatable {
  const MessagesState({
    this.channels = const [],
  });

  final List<Channel> channels;

  MessagesState copyWith({List<Channel>? channels}) {
    return MessagesState(
      channels: channels ?? this.channels,
    );
  }

  @override
  List<Object?> get props => [channels];
}
