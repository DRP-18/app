import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'theme/theme.dart';
import 'screens/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      title: 'Tutor Me',
      theme: mainTheme,
      home: LoginScreen(),
    );
  }
}
