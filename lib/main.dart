import 'package:chat/bloc/messages_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_persistence/stream_chat_persistence.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final chatPersistentClient = StreamChatPersistenceClient(
    logLevel: Level.INFO,
    connectionMode: ConnectionMode.background,
  );

  final client = StreamChatClient(
    'key',
    logLevel: Level.INFO,
  )..chatPersistenceClient = chatPersistentClient;

  await client.connectUser(
    User(id: 'user'),
    '''secret''',
  );

  runApp(
    MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      builder: (context, widget) => StreamChat(
        client: client,
        child: widget,
      ),
      home: MyApp(
        client: client,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.client,
  }) : super(key: key);

  final StreamChatClient client;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MessagesBloc>(
      create: (context) =>
          MessagesBloc(streamChatClient: client)..add(const ChannelsLoad()),
      child: Scaffold(
        body: BlocBuilder<MessagesBloc, MessagesState>(
          builder: (context, state) {
            if (state.channels.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                itemCount: state.channels.length,
                itemBuilder: (context, i) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChannelPage(
                            channel: state.channels[i],
                          ),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Text(state.channels[i].name ?? 'Unnamed'),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class ChannelPage extends StatelessWidget {
  const ChannelPage({
    Key? key,
    required this.channel,
  }) : super(key: key);

  final Channel channel;

  @override
  Widget build(BuildContext context) => StreamChannel(
        channel: channel,
        child: Scaffold(
          body: Column(
            children: <Widget>[
              Expanded(
                child: MessageListView(
                  messageBuilder: (
                    context,
                    messageDetails,
                    messages,
                    defaultMessageWidget,
                  ) {
                    final isSystemMessage =
                        messageDetails.message.extraData['system'] == true;

                    if (isSystemMessage) {
                      final messageEn = messageDetails
                          .message.extraData['message_en']
                          .toString();

                      final extraData = Map<String, dynamic>.from(
                          messageDetails.message.extraData);
                      final seconds = extraData['time']['_seconds'];

                      return Container(
                        padding: const EdgeInsets.only(bottom: 24),
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Column(
                          children: [
                            Text(
                              seconds.toString(),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              messageEn,
                              maxLines: 3,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return defaultMessageWidget;
                    }
                  },
                ),
              ),
              const MessageInput(attachmentLimit: 3),
            ],
          ),
        ),
      );
}
