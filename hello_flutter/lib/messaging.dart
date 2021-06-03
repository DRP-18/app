import 'package:flutter/material.dart';

class MessagingWidget extends StatefulWidget {
  const MessagingWidget({Key? key}) : super(key: key);

  @override
  _MessagingWidgetState createState() => _MessagingWidgetState();
}

class _MessagingWidgetState extends State<MessagingWidget> {
  late TextEditingController _controller;
  String _title = "hello";
  String _pseudoTitle = "helo";

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_title),
          backgroundColor: Colors.green[200],
        ),
        body: Column(
          children: [
            Flexible(
              child: ListView(
                children: [
                  ListTile(title: Text("0")),
                  ListTile(title: Text("1")),
                  ListTile(title: Text("2")),
                ],
              ),
            ),
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
                        _pseudoTitle = value;
                      },
                    ),
                  ),
                ),
                FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        _title = _pseudoTitle;
                        FocusScope.of(context).unfocus();
                        _controller.clear();
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
