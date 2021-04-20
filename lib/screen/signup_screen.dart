import 'package:flutter/material.dart';
import 'package:lesson3/controller/firebasecontroller.dart';
import 'package:lesson3/model/userdata.dart';
import 'package:lesson3/screen/myview/mydialog.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/signUpScreen';
  @override
  State<StatefulWidget> createState() {
    return _SignUpState();
  }
}

class _SignUpState extends State<SignUpScreen> {
  _Controller con;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    con = _Controller(this);
    super.initState();
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create an account'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 15.0,
          left: 15.0,
        ),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text('Create an account', style: Theme.of(context).textTheme.headline5),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  validator: con.validateEmail,
                  onSaved: con.saveEmail,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Username',
                  ),
                  autocorrect: false,
                  validator: con.validateUsername,
                  onSaved: con.saveUsername,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Password',
                  ),
                  obscureText: true,
                  autocorrect: false,
                  validator: con.validatePassword,
                  onSaved: con.savePassword,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Password confirmed',
                  ),
                  obscureText: true,
                  autocorrect: false,
                  validator: con.validatePassword,
                  onSaved: con.savePasswordConfirm,
                ),
                con.passwordErrorMessage == null
                    ? SizedBox(height: 1.0)
                    : Text(
                        con.passwordErrorMessage,
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                      ),
                RaisedButton(
                  onPressed: con.createAccount,
                  child: Text(
                    'Create',
                    style: Theme.of(context).textTheme.button,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _SignUpState state;
  _Controller(this.state);
  String email;
  String password;
  String username;
  UserData temp = UserData();
  String passwordConfirm;
  String passwordErrorMessage;

  void createAccount() async {
    if (!state.formKey.currentState.validate()) return;

    state.render(() => passwordErrorMessage = null);
    state.formKey.currentState.save();

    if (password != passwordConfirm) {
      state.render(() => passwordErrorMessage = 'passwords do not match');
      return;
    }

    try {
      await FirebaseController.createAccount(email: email, password: password);
      temp.username = username;
      temp.email = email;
      temp.profilepic = null;
      String userId = await FirebaseController.addUserData(temp);
      temp.docId = userId;
      MyDialog.info(
        context: state.context,
        title: 'Account created',
        content: 'Go to sign in to use the app',
      );
    } catch (e) {
      MyDialog.info(
        context: state.context,
        title: 'Cannot create',
        content: '$e',
      );
    }
  }

  String validateEmail(String value) {
    if (value.contains('@') && value.contains('.'))
      return null;
    else
      return 'invalid email';
  }

  String validateUsername(String value) {
    if (value.length < 0)
      return 'too short';
    else
      return null;
  }

  void saveUsername(String value) {
    username = value;
  }

  void saveEmail(String value) {
    email = value;
  }

  String validatePassword(String value) {
    if (value.length < 6)
      return 'too short';
    else
      return null;
  }

  void savePassword(String value) {
    password = value;
  }

  void savePasswordConfirm(String value) {
    passwordConfirm = value;
  }
}
