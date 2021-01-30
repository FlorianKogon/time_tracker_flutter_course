import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class SignInManager {
  SignInManager({@required this.authBase, @required this.isLoading});
  final AuthBase authBase;
  final ValueNotifier<bool> isLoading;

  Future<User> _signIn(Future<User> Function() signInMethod) async {
    try {
      isLoading.value = true;
      return await signInMethod();
    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }

  Future<User> signInWithGoogle() async =>
      await _signIn(authBase.signInWithGoogle);
  Future<User> signInWithFacebook() async =>
      await _signIn(authBase.signInWithFacebook);
  Future<User> signInAnonymously() async =>
      await _signIn(authBase.signInAnonymously);
}
