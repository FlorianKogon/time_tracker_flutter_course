import 'dart:async';
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_model.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class EmailSignInBloc {
  EmailSignInBloc({@required this.authBase});
  final AuthBase authBase;
  final StreamController<EmailSignInModel> _modelController =
      StreamController<EmailSignInModel>();

  Stream<EmailSignInModel> get modelStream => _modelController.stream;
  EmailSignInModel _model = EmailSignInModel();

  void dispose() {
    _modelController.close();
  }

  void toggleFormType() {
    final formType = _model.formType == EmailSignInFormType.signIn ?
    EmailSignInFormType.register :
    EmailSignInFormType.signIn;
    updateWithMethod(
      email: '',
      password: '',
      formType: formType,
      submitted: false,
      isLoading: false,
    );
  }

  void updateEmail(String email) => updateWithMethod(email: email);
  void updatePassword(String password) => updateWithMethod(password: password);

  void updateWithMethod({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool submitted,
  }) {
    _model = _model.copyWith(email, password, formType, isLoading, submitted);
    _modelController.add(_model);
  }

  Future<void> submit() async {
    updateWithMethod(submitted: true, isLoading: true);
    try {
      if (_model.formType == EmailSignInFormType.signIn) {
        await authBase.signInWithEmailAndPassword(_model.email, _model.password);
      } else {
        await authBase.createUserWithEmailAndPassword(_model.email, _model.password);
      }
    }  catch (e) {
      updateWithMethod(isLoading: false);
      rethrow;
    }
  }
}
