import "package:circles_app/circles_localization.dart";
import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/domain/redux/authentication/auth_actions.dart";
import "package:circles_app/presentation/login/auth_button.dart";
import "package:circles_app/presentation/settings/privacy_settings_button.dart";
import "package:circles_app/util/logger.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:flutter_redux/flutter_redux.dart";

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text("Euonia", style: TextStyle(color: Colors.black,)),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(40.0),
              child: _SignUpForm(),
            ),
            PrivacySettingsButton(),
          ],
        ),
      ),
    );
  }
}


// MARK:SignUp Form

class _SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() {
    return _SignUpFormState();
  }
}

class _SignUpFormState extends State<_SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _userTextEditingController = TextEditingController();
  final _userNameTextEditingController = TextEditingController();
  final _passwordTextEditingController = TextEditingController();

  @override
  void dispose() {
    // Suggested to be disposed: https://flutter.dev/docs/cookbook/forms/retrieve-input#1-create-a-texteditingcontroller
    _userNameTextEditingController.dispose();
    _userTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final submitCallback = () {
      if (_formKey.currentState.validate()) {
        final signupAction = SignUp(
            username:_userNameTextEditingController.text,
            email: _userTextEditingController.text,
            password: _passwordTextEditingController.text);

        StoreProvider.of<AppState>(context).dispatch(signupAction);
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text("Signing you in...")));

        signupAction.completer.future.catchError((error) {
          Scaffold.of(context).hideCurrentSnackBar();
          Logger.w(error.code.toString());
          Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(CirclesLocalizations.of(context)
                  .authErrorMessage(error.code.toString()))));
        });
      }
    };

    final submitButton =
    AuthButton(buttonText: "SignUp", onPressedCallback: submitCallback);

    final _userTextField = TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(labelText: "Username"),
      controller: _userNameTextEditingController,
      validator: (value) {
        if (value.isEmpty) {
          return "Please enter your Username";
        }
        return null;
      },
    );
    TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(labelText: "Email"),
      controller: _userTextEditingController,
      validator: (value) {
        if (value.isEmpty) {
          return "Please enter your email";
        }
        return null;
      },
    );

    final _passwordTextField = TextFormField(
      decoration: const InputDecoration(labelText: "Password"),
      controller: _passwordTextEditingController,
      validator: (value) {
        if (value.isEmpty) {
          return "Please enter your password";
        }
        return null;
      },
      obscureText: true,
    );

    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[_userTextField, _passwordTextField, submitButton],
      ),
    );
  }
}
