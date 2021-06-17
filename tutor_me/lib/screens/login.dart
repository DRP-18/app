import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tutor_me/components/users.dart';
import 'package:tutor_me/screens/home.dart';
import 'package:tutor_me/theme/theme.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _username = "";
  bool _unsuccessfulLogin = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
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
                height: 180,
              ),
              Text(
                _unsuccessfulLogin ? "User does not exist" : "",
                style: textStyle.copyWith(fontSize: 14),
              ),
              SizedBox(height: 10),
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
                  onTap: () {
                    setState(() {
                      _unsuccessfulLogin = false;
                    });
                  },
                  onChanged: (value) {
                    setState(() {
                      _username = value;
                      _unsuccessfulLogin = false;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 30,
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
      ),
    );
  }

  //Makes a http request to the backend and then reads the user_id cookie
  void _login() async {
    var response = await http.post(
        Uri.parse("https://tutor-drp.herokuapp.com/login"),
        body: {"username": _username});
    var cookies = _parseCookies(response.headers["set-cookie"]);
    var userId = cookies["user_id"];
    var userType = cookies["user_type"];
    if (userId == null || userType == null) {
      setState(() {
        _unsuccessfulLogin = true;
      });
    } else {
      await HapticFeedback.heavyImpact();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen(userId,
                  userType == "tutee" ? UserType.Tutee : UserType.Tutor, _username)));
    }
  }

  Map<String, String> _parseCookies(String? rawCookies) {
    if (rawCookies == null) {
      return Map();
    }
    var cookies = rawCookies.split(",");
    return Map.fromIterable(cookies.map((s) => s.split('=')),
        key: (vals) => vals[0], value: (vals) => vals[1]);
  }
}
