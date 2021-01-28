import 'package:flutter/material.dart';
import 'auth.dart';

class AuthProvider extends InheritedWidget {
  AuthProvider({@required this.authBase, @required this.child});
  final AuthBase authBase;
  final Widget child;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  static AuthBase of(BuildContext context) {
    AuthProvider authProvider = context.dependOnInheritedWidgetOfExactType<AuthProvider>();
    return authProvider.authBase;
  }

}
