import 'package:flutter/material.dart';

class MessagingWidget extends StatefulWidget {
  const MessagingWidget({Key? key}) : super(key: key);

  @override
  _MessagingWidgetState createState() => _MessagingWidgetState();
}

class _MessagingWidgetState extends State<MessagingWidget> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  String name = "Jayme";
  String _msgBuffer = "";
  final _messages = <String>[];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildMessages(ScrollController controller) {
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
                      setState(() {
                        if (_msgBuffer != "") {
                          _messages.add(name + " says: " + _msgBuffer);
                          FocusScope.of(context).unfocus();
                          _controller.clear();
                          _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: Duration(milliseconds: 2000),
                            curve: Curves.linear,
                          );
                          _msgBuffer = "";
                        }
                      });
                    },
                    backgroundColor: Colors.green[200],
                    child: Icon(Icons.send)),
              ],
            ),
          ],
        ));
  }
}
