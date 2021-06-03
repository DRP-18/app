// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'messaging.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) {
    return MaterialApp(
        title: "Text Messager",
        home: MessagingWidget(),
    );
  }
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Name Generator',
//       home: RandomWords(),
//       theme: ThemeData(
//         primaryColor: Colors.green,
//       ),
//     );
//   }
// }

// class RandomWords extends StatefulWidget {
//   const RandomWords({Key? key}) : super(key: key);

//   @override
//   _RandomWordsState createState() => _RandomWordsState();
// }

// class _RandomWordsState extends State<RandomWords> {
//   final _suggestions = <WordPair>[];
//   final _saved = <WordPair>{};
//   final _biggerText = TextStyle(fontSize: 18);

//   Widget _buildSuggestions() {
//     return ListView.builder(
//       padding: EdgeInsets.all(16.0),
//       itemBuilder: /*1*/ (context, i) {
//         if (i.isOdd) return Divider(); /*2*/

//         final index = i ~/ 2; /*3*/
//         if (index >= _suggestions.length) {
//           _suggestions.addAll(generateWordPairs().take(10)); /*4*/
//         }
//         return _buildRow(_suggestions[index]);
//       },
//       itemCount: 20,
//     );
//   }

//   Widget _buildRow(WordPair pair) {
//     final alreadySaved = _saved.contains(pair);
//     return ListTile(
//       title: Text(
//         pair.asPascalCase,
//         style: _biggerText,
//       ),
//       trailing: Icon(
//         alreadySaved ? Icons.favorite : Icons.favorite_border,
//         color: alreadySaved ? Colors.red : null,
//       ),
//       onTap: () {
//         setState(() {
//           if (alreadySaved) {
//             _saved.remove(pair);
//           } else {
//             _saved.add(pair);
//           }
//         });
//       },
//     );
//   }

//   void _pushSaved() {
//     Navigator.of(context).push(MaterialPageRoute<void>(
//       builder: (BuildContext ctx) {
//         final tiles = _saved.map((WordPair pair) {
//           return ListTile(
//             title: Text(
//               pair.asPascalCase,
//               style: _biggerText,
//             ),
//           );
//         });
//         final divided = tiles.isNotEmpty
//             ? ListTile.divideTiles(
//                 context: ctx,
//                 tiles: tiles,
//               ).toList()
//             : <Widget>[];
//         return Scaffold(
//           appBar: AppBar(
//             title: Text("Saved suggestions"),
//           ),
//           body: ListView(children: divided),
//         );
//       },
//     ));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Hello there"),
//         actions: [
//           IconButton(onPressed: _pushSaved, icon: Icon(Icons.list)),
//         ],
//       ),
//       body: _buildSuggestions(),
//     );
//   }
// }

