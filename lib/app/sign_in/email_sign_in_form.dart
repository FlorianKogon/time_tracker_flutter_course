import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/common_widgets/form_submit_button.dart';

enum EmailSigninFormType { signIn, register }

class EmailSignInForm extends StatefulWidget {
  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  EmailSigninFormType _formType = EmailSigninFormType.signIn;

  void _submit() {
    print('email : $_emailController');
    print('password : $_passwordController');
  }

  void _toggleFormType() {
    setState(() {
      _formType = _formType == EmailSigninFormType.signIn ?
          EmailSigninFormType.register : EmailSigninFormType.signIn;
      _emailController.clear();
      _passwordController.clear();
    });
  }

  List<Widget> _buildChildren() {
    final primaryText = _formType == EmailSigninFormType.signIn ?
      'Sign in' : 'Create an account';
    final secondaryText = _formType == EmailSigninFormType.signIn ?
      'Need an account ? Register' : 'Have an account ? Sign in';
    return [
      TextField(
        controller: _emailController,
        decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'test@test.com',
        ),
      ),
      SizedBox(height: 8.0,),
      TextField(
        controller: _passwordController,
        decoration: InputDecoration(
          labelText: 'Password',
        ),
        obscureText: true,
      ),
      SizedBox(height: 8.0,),
      FormSubmitButton(
        text: primaryText,
        onPressed: _submit,
      ),
      SizedBox(height: 8.0,),
      FlatButton(
        onPressed: _toggleFormType,
        child: Text(
          secondaryText,
        ),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(),
      ),
    );
  }
}
