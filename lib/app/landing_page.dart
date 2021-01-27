import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/home_page.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_page.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key key, @required this.authBase}) : super(key: key);
  final AuthBase authBase;

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  User _user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _updateUser(widget.authBase.currentUser);
  }

  void _updateUser(User user) {
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return SignInPage(
        authBase: widget.authBase,
        onSignIn: _updateUser,
      );
    }
    return HomePage(
      authBase: widget.authBase,
      onSignOut: () => _updateUser(null),
    );
  }
}
