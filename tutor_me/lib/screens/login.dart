import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tutor_me/theme/theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final textStyle = TextStyle(
    color: mainTheme.accentColor,
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );

  String _username = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainTheme.primaryColor,
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome to",
              style: GoogleFonts.roboto(textStyle: textStyle),
            ),
            Text(
              "TUTOR ME",
              style: GoogleFonts.roboto(
                  textStyle: textStyle.copyWith(fontSize: 50)),
            ),
            SizedBox(
              height: 100,
            ),
            Container(
              width: 300,
              child: TextField(
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: textStyle.copyWith(
                      fontSize: 20, color: mainTheme.primaryColor),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      borderSide: BorderSide(color: mainTheme.primaryColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      borderSide: BorderSide(color: mainTheme.primaryColor),
                    ),
                    fillColor: mainTheme.accentColor,
                    filled: true,
                    hintText: "USERNAME",
                    hintStyle: textStyle.copyWith(
                        fontSize: 20, color: mainTheme.primaryColor),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _username = value;
                    });
                  },
                  ),
            ),
            ElevatedButton(
              onPressed: _login,
              child: Text("LOGIN"),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(mainTheme.accentColor),
                  foregroundColor:
                      MaterialStateProperty.all(mainTheme.primaryColor),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)))),
            )
          ],
        ),
      ),
    );
  }

  //Makes a http request to the backend and then reads the user_id cookie
  void _login() {

  }
}
