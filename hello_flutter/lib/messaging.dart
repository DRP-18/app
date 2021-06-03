import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MessagingWidget extends StatefulWidget {
  const MessagingWidget({Key? key}) : super(key: key);

  @override
  _MessagingWidgetState createState() => _MessagingWidgetState();
}

class _MessagingWidgetState extends State<MessagingWidget> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final channel = WebSocketChannel.connect(
    Uri.parse('wss://tutor-me-drp.herokuapp.com/textChat/chat'),
  );

  String name = "Leonardo";
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
            var msg = _messages[i];
            var mine = msg.startsWith(name);
            return ListTile(
              title: Align(
                alignment: mine ? Alignment.topRight : Alignment.topLeft,
                child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: mine ? Colors.grey[200] : Colors.blue[200],
                      borderRadius:
                          const BorderRadius.all(const Radius.circular(10)),
                    ),
                    child: Text(msg)),
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
          backgroundColor: Colors.green[200],
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
                        var msg = name + " says: " + _msgBuffer;
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
                    backgroundColor: Colors.green[200],
                    child: Icon(Icons.send)),
              ],
            ),
          ],
        ));
  }
}
