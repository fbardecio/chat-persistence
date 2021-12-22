import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

part 'messages_event.dart';
part 'messages_state.dart';

class MessagesBloc extends Bloc<MessagesEvent, MessagesState> {
  MessagesBloc({required StreamChatClient streamChatClient})
      : _streamChatClient = streamChatClient,
        super(const MessagesState()) {
    on<ChannelsLoad>(_mapChannelLoadToState);
    on<ChannelsLoaded>(_mapChannelLoadedToState);
  }

  final StreamChatClient _streamChatClient;

  void _mapChannelLoadToState(
    ChannelsLoad event,
    Emitter<MessagesState> emit,
  ) async {
    try {
      _streamChatClient
          .queryChannels(
        paginationParams: const PaginationParams(limit: 30),
        watch: true,
        state: true,
      )
          .listen((channels) async {
        add(ChannelsLoaded(channels: channels));
      });
    } catch (e) {
      print(e);
    }
  }

  void _mapChannelLoadedToState(
    ChannelsLoaded event,
    Emitter<MessagesState> emit,
  ) async {
    try {
      emit(state.copyWith(channels: event.channels));
    } catch (e) {
      print(e);
    }
  }
}
