import 'package:flutter/material.dart';
import 'package:tutor_me/theme/theme.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MessagingScreenWidget extends StatefulWidget {
  final String _name;
  const MessagingScreenWidget(this._name, {Key? key}) : super(key: key);

  @override
  _MessagingScreenWidgetState createState() =>
      _MessagingScreenWidgetState(_name);
}

class _MessagingScreenWidgetState extends State<MessagingScreenWidget> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final String _name;
  final channel = WebSocketChannel.connect(
    Uri.parse('wss://tutor-me-drp.herokuapp.com/textChat/chat'),
  );

  _MessagingScreenWidgetState(this._name);

  String _msgBuffer = "";
  final _messages = <String>[];

  @override
  void dispose() {
    channel.sink.close();
    _controller.dispose();
    super.dispose();
  }

  Widget _buildMessages(ScrollController controller) {
    return StreamBuilder(
      stream: channel.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var message = '${snapshot.data}';
          if (!_messages.contains(message)) {
            _messages.add(message);
          }
        }
        return ListView.builder(
          controller: controller,
          itemBuilder: (context, i) {
            final msg = _messages[i];
            final mine = msg.startsWith(_name);
            final text = msg.split("says: ")[1];
            return ListTile(
              title: Align(
                alignment: mine ? Alignment.topRight : Alignment.topLeft,
                child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: mine ? Colors.grey[200] : mainTheme.primaryColor,
                      borderRadius:
                          const BorderRadius.all(const Radius.circular(10)),
                    ),
                    child: Text(
                      text,
                      style: TextStyle(
                        color: !mine ? Colors.grey[200] : mainTheme.primaryColor,
                      ),
                    )),
              ),
            );
          },
          itemCount: _messages.length,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Chat"),
        ),
        body: Column(
          children: [
            Flexible(child: _buildMessages(_scrollController)),
            Row(
              children: [
                Flexible(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: TextField(
                      textInputAction: TextInputAction.newline,
                      style: const TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                  const Radius.circular(100)))),
                      minLines: 1,
                      maxLines: 3,
                      controller: _controller,
                      onChanged: (String value) {
                        _msgBuffer = value;
                      },
                    ),
                  ),
                ),
                FloatingActionButton(
                    onPressed: () {
                      if (_msgBuffer != "") {
                        var msg = _name + " says: " + _msgBuffer;
                        channel.sink.add(msg);
                        setState(() {
                          _messages.add(msg);
                        });
                        FocusScope.of(context).unfocus();
                        _controller.clear();
                        _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: Duration(milliseconds: 2000),
                          curve: Curves.linear,
                        );
                        _msgBuffer = "";
                      }
                    },
                    backgroundColor: mainTheme.primaryColor,
                    foregroundColor: mainTheme.accentColor,
                    child: Icon(Icons.send)),
              ],
            ),
          ],
        ));
  }
}
