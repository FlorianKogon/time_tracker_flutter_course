import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_page.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_manager.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_button.dart';
import 'package:time_tracker_flutter_course/app/sign_in/social_sign_in_button.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key key,@required this.manager, @required this.isLoading}) : super(key: key);
  final SignInManager manager;
  final bool isLoading;

  static Widget create(BuildContext context) {
    final authBase = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => Provider<SignInManager>(
          create: (_) => SignInManager(authBase: authBase, isLoading: isLoading),
          child: Consumer<SignInManager>(
            builder: (_, manager, __) => SignInPage(manager: manager, isLoading: isLoading.value,),
          ),
        ),
      ),
    );
  }

  void _showSignInError(BuildContext context, Exception exception) {
    if (exception is FirebaseException &&
        exception.code == "ERROR_ABORTED_BY_USER") {
      return;
    }
    showExceptionAlertDialog(context,
        title: 'Sign in failed', exception: exception);
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await manager.signInAnonymously();
    } on FirebaseException catch (e) {
      _showSignInError(context, e);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await manager.signInWithGoogle();
    } on FirebaseException catch (e) {
      _showSignInError(context, e);
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      await manager.signInWithFacebook();
    } on FirebaseException catch (e) {
      _showSignInError(context, e);
    }
  }

  void _signInPageWithEmail(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute<void>(
        fullscreenDialog: true, builder: (context) => EmailSignInPage()));
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
        children: [
          SizedBox(
            child: _buildHeader(),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 48.0,
              ),
              SocialSignInButton(
                assetName: 'images/google-logo.png',
                text: "Sign in with Google",
                textColor: Colors.black87,
                color: Colors.white,
                onPressed: isLoading ? null : () => _signInWithGoogle(context),
              ),
              SizedBox(
                height: 8.0,
              ),
              SocialSignInButton(
                assetName: 'images/facebook-logo.png',
                text: 'Sign in with Facebook',
                textColor: Colors.white,
                onPressed:
                    isLoading ? null : () => _signInWithFacebook(context),
                color: Color(0xFF334D92),
              ),
              SizedBox(
                height: 8.0,
              ),
              SignInButton(
                text: 'Sign in with mail',
                textColor: Colors.white,
                onPressed:
                    isLoading ? null : () => _signInPageWithEmail(context),
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
                onPressed: isLoading ? null : () => _signInAnonymously(context),
                color: Colors.lime[300],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return isLoading
        ? CircularProgressIndicator()
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
