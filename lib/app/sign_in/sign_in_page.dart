import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_page.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_button.dart';
import 'package:time_tracker_flutter_course/app/sign_in/social_sign_in_button.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _isLoading = false;

  void _showSignInError(BuildContext context, Exception exception) {
    if (exception is FirebaseException &&
        exception.code == "ERROR_ABORTED_BY_USER") {
      return;
    }
    showExceptionAlertDialog(context,
        title: 'Sign in failed', exception: exception);
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    setState(() => _isLoading = true);
    try {
      final authBase = Provider.of<AuthBase>(
        context,
        listen: false,
      );
      await authBase.signInAnonymously();
    } on FirebaseException catch (e) {
      _showSignInError(context, e);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    setState(() => _isLoading = true);
    try {
      final authBase = Provider.of<AuthBase>(
        context,
        listen: false,
      );
      await authBase.signInWithGoogle();
    } on FirebaseException catch (e) {
      _showSignInError(context, e);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    setState(() => _isLoading = true);
    try {
      final authBase = Provider.of<AuthBase>(
        context,
        listen: false,
      );
      await authBase.signInWithFacebook();
    } on FirebaseException catch (e) {
      _showSignInError(context, e);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _signInPageWithEmail(BuildContext context) {
    setState(() => _isLoading = true);
    Navigator.of(context).push(MaterialPageRoute<void>(
        fullscreenDialog: true, builder: (context) => EmailSignInPage()));
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Time Tracker"),
        elevation: 2.0,
      ),
      body: _buildContent(context),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 50.0,
            child: _buildHeader(),
          ),
          SizedBox(
            height: 48.0,
          ),
          SocialSignInButton(
            assetName: 'images/google-logo.png',
            text: "Sign in with Google",
            textColor: Colors.black87,
            color: Colors.white,
            onPressed: _isLoading ? null : () => _signInWithGoogle(context),
          ),
          SizedBox(
            height: 8.0,
          ),
          SocialSignInButton(
            assetName: 'images/facebook-logo.png',
            text: 'Sign in with Facebook',
            textColor: Colors.white,
            onPressed: _isLoading ? null : () => _signInWithFacebook(context),
            color: Color(0xFF334D92),
          ),
          SizedBox(
            height: 8.0,
          ),
          SignInButton(
            text: 'Sign in with mail',
            textColor: Colors.white,
            onPressed: _isLoading ? null : () => _signInPageWithEmail(context),
            color: Colors.teal[700],
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(
            'or',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.0, color: Colors.black87),
          ),
          SizedBox(
            height: 8.0,
          ),
          SignInButton(
            text: 'Go anonymous',
            textColor: Colors.black87,
            onPressed: _isLoading ? null : () => _signInAnonymously(context),
            color: Colors.lime[300],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return _isLoading
        ? CircularProgressIndicator(strokeWidth: 10.0,)
        : Text(
            "Sign in",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 32.0,
            ),
          );
  }
}
