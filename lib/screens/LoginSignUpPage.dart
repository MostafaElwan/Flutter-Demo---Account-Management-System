import 'package:account_managment/common/AppUtil.dart';
import 'package:account_managment/manager/NavigatorManager.dart';
import 'package:account_managment/manager/PreferencesManager.dart';
import 'package:account_managment/manager/RemoteManager.dart';
import 'package:account_managment/model/lov/AppBarActionLOV.dart';
import 'package:account_managment/model/lov/enums.dart';
import 'package:account_managment/screens/AccountsViewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';


class LoginSignUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginSignUpPageState();
}

class _LoginSignUpPageState extends State<LoginSignUpPage> {
  BuildContext _scaffoldContext;
  FormMode _formMode = FormMode.LOGIN;
  final _formKey = new GlobalKey<FormState>();
  String _email;
  String _password;

  @override
  Widget build(BuildContext context) {
    String user = PreferencesManager.createInstance().getUser();
    if(user != null)
      return AccountsViewer();

    return Scaffold(
        appBar: _buildAppBar(),
        body: Builder(
          builder: (BuildContext  bc) {
            _scaffoldContext = bc;

            return _buildBody();
          }
      ),
    );
  }

  _buildAppBar() {
    return AppBar(
      title: Text('Account Managment System'),
      actions: <Widget>[
        IconButton(
          icon: new Icon(AppBarActionLOV.firstScreenActions[0].icon),
          tooltip: AppBarActionLOV.firstScreenActions[0].title,
          onPressed: AppUtil.getOnChangeLanguageListener,
        ),
      ],
    );
  }

  _buildBody(){
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            _buildAppLogo(),
            _buildEmailInput(),
            _buildPasswordInput(),
            _buildResetPasswordLink(),
            _buildPrimaryButton(),
            _buildGoogleButton(),
            _buildFacebookButton(),
            _buildSecondaryButton(),
          ],
        ),
      )
    );
  }

  _buildAppLogo() {
    return Hero(
      tag: 'AMS',
      child: Padding(
        padding: EdgeInsets.all(10),
        child: SizedBox(
          child: Image.asset('assets/images/ams_logo.png'),
          height: 150,
          width: 150,
        ),
      ),
    );
  }

  _buildEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: true,
        decoration: InputDecoration(
            hintText: 'Email',
            icon: Icon(
              Icons.mail,
              color: Colors.amber,
            )),
        validator: (value) => value.isEmpty ? 'Email is mandatory !' : null,
        onSaved: (value) => _email = value,
      ),
    );
  }

  _buildPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Password',
            icon: Icon(
              Icons.lock,
              color: Colors.amber,
            )),
//        validator: (value) => value.isEmpty ? 'Password is mandatory !' : null,
        onSaved: (value) => _password = value,
      ),
    );
  }

  _buildPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: SignInButtonBuilder(
            text: _formMode == FormMode.LOGIN ? 'Login': 'Create account',
            icon: Icons.email,
            backgroundColor: Colors.blueGrey[700],
            onPressed: () async {
              AppUtil.onLoading(context, 'Logging to AMS ...');

              bool isValid = _validateForm();
              if(isValid) {
                try {
                  if (_formMode == FormMode.LOGIN) {
                    await RemoteManager.createInstance().signIn(_email, _password);
                  } else {
                    await RemoteManager.createInstance().signUp(_email, _password);
                    RemoteManager.createInstance().sendEmailVerification();
                    _showVerifyEmailSentDialog();
                  }

                  PreferencesManager.createInstance().setUser(_email);

                  NavigatorManager.createInstance().back(context);
                  NavigatorManager.createInstance().goToAccountsViewer(context);
                } catch (e) {
                  AppUtil.showMessageBar(_scaffoldContext, e.message);
                  NavigatorManager.createInstance().back(context);
                }
              } else {
                NavigatorManager.createInstance().back(context);
              }
            },
          ),
        ));
  }

  _buildGoogleButton() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: SignInButton(
            Buttons.Google,
            text: "Sign up with Google",
            onPressed: () async {
              AppUtil.onLoading(context, 'Logging to AMS ...');
              await RemoteManager.createInstance().signInByGoogleAccount();
              NavigatorManager.createInstance().back(context);
              NavigatorManager.createInstance().goToAccountsViewer(context);
            },
          ),
        )
    );

  }

  _buildFacebookButton() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: SignInButton(
            Buttons.Facebook,
            text: "Sign up with Facebook",
            onPressed: () async {
              try {
                AppUtil.onLoading(context, 'Logging to AMS ...');
                await RemoteManager.createInstance().signInByFacebookAccount();
                NavigatorManager.createInstance().back(context);
                NavigatorManager.createInstance().goToAccountsViewer(context);
              } catch (e) {
                AppUtil.showMessageBar(_scaffoldContext, e);
              }
            },
          ),
        )
    );

  }

  _buildResetPasswordLink() {
    if(_formMode == FormMode.LOGIN) {
        return Container(
            padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
            child: FlatButton(
              child:Text('Reset password',
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300)
              ),
              onPressed: () => AppUtil.showAlertDialog(context, "Confirm Password Reset", "Are your sure you want to reset password ?", "No", "Yes", () async {
                AppUtil.onLoading(context, "Resetting password ...");

                bool isValid = _validateForm();
                if(isValid) {
                  await RemoteManager.createInstance().resetPassword(_email);
                  AppUtil.showMessageBar(_scaffoldContext, "Password reset link sent to your mail");
                }

                NavigatorManager.createInstance().back(context);
              }),
            )
        );
    } else {
        return Container();
    }
  }

  _buildSecondaryButton() {
    return FlatButton(
      child: _formMode == FormMode.LOGIN
      ? Text('Create an account',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)
      )
      : Text('Have an account? Sign in',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)
      ),
//      onPressed: _formMode == FormMode.LOGIN ? _changeFormToSignUp : _changeFormToLogin,
      onPressed: _switchView,
    );
  }

  _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content: new Text("Link to verify account has been sent to your email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
//                _changeFormToLogin();
                _switchView();
                NavigatorManager.createInstance().back(context);
              },
            ),
          ],
        );
      },
    );
  }

//  _changeFormToSignUp() {
//    _formKey.currentState.reset();
//    setState(() {
//      _formMode = FormMode.SIGNUP;
//    });
//  }
//
//  _changeFormToLogin() {
//    _formKey.currentState.reset();
//    setState(() {
//      _formMode = FormMode.LOGIN;
//    });
//  }

  _switchView() {
    _formKey.currentState.reset();
    setState(() {
      _formMode = _formMode == FormMode.LOGIN ? FormMode.SIGNUP : FormMode.LOGIN;
    });
  }


  _validateForm() {
    final form = _formKey.currentState;
    if(!form.validate())
      return false;

      form.save();
      return true;
  }
}