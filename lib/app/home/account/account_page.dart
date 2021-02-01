import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/common_widgets/avatar.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class AccountPage extends StatelessWidget {

  Future<void> _signOut(BuildContext context) async {
    try {
      final authBase = Provider.of<AuthBase>(
        context,
        listen: false,
      );
      await authBase.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(
      context,
      title: 'Logout',
      content: 'Are you sure that you want to logout ?',
      defaultActionText: 'Logout',
      cancelActionText: 'Cancel',
    );
    if (didRequestSignOut == true) _signOut(context);
  }


  Widget _buildUserInfo(User currentUser) {
    return Avatar(
      photoUrl: currentUser.photoURL,
      radius: 50,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authBase = Provider.of<AuthBase>(context, listen: false);
    authBase.currentUser;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Account'),
        actions: [
          IconButton(
            onPressed: () => _confirmSignOut(context),
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(130.0),
          child: _buildUserInfo(authBase.currentUser),
        ),
      ),
    );
  }
}

