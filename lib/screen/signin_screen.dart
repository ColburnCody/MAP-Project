import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/firebasecontroller.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/notif.dart';
import 'package:lesson3/model/photomemo.dart';
import 'package:lesson3/model/userdata.dart';
import 'package:lesson3/screen/signup_screen.dart';
import 'package:lesson3/screen/userhome_screen.dart';

import 'myview/mydialog.dart';

class SignInScreen extends StatefulWidget {
  static const routeName = '/signInScreen';

  @override
  State<StatefulWidget> createState() {
    return _SignInState();
  }
}

class _SignInState extends State<SignInScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  _Controller con;
  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 10.0,
          left: 15.0,
        ),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Text(
                    'PhotoMemo',
                    style: TextStyle(
                      fontFamily: 'HachiMaruPop',
                      fontSize: 40.0,
                    ),
                  ),
                ),
                Text(
                  'Sign in, please!',
                  style: TextStyle(
                    fontFamily: 'HachiMaruPop',
                  ),
                ),
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
                    hintText: 'Password',
                  ),
                  obscureText: true,
                  autocorrect: false,
                  validator: con.validatePassword,
                  onSaved: con.savePassword,
                ),
                RaisedButton(
                  onPressed: con.signIn,
                  child: Text(
                    'Sign In',
                    style: Theme.of(context).textTheme.button,
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                RaisedButton(
                  onPressed: con.signUp,
                  child: Text('Create a new account',
                      style: Theme.of(context).textTheme.button),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _SignInState state;

  _Controller(this.state);

  String email;
  String password;

  String validateEmail(String value) {
    if (value.contains('@') && value.contains('.'))
      return null;
    else
      return 'invalid email address';
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

  void signIn() async {
    if (!state.formKey.currentState.validate()) return;

    state.formKey.currentState.save();

    User user;
    MyDialog.circularProgressStart(state.context);
    try {
      user = await FirebaseController.signIn(email: email, password: password);
    } catch (e) {
      MyDialog.circularProgressStop(state.context);
      MyDialog.info(
        context: state.context,
        title: 'Sign In Error',
        content: e.toString(),
      );
      return;
    }

    try {
      List<PhotoMemo> photoMemoList =
          await FirebaseController.getPhotoMemoList(email: user.email);
      List<Notif> notifications =
          await FirebaseController.getNotifications(email: user.email);
      UserData userData = await FirebaseController.getUserData(email: user.email);
      MyDialog.circularProgressStop(state.context);
      Navigator.pushNamed(state.context, UserHomeScreen.routeName, arguments: {
        Constant.ARG_USER: user,
        Constant.ARG_PHOTOMEMOLIST: photoMemoList,
        Constant.ARG_NOTIFICATIONS: notifications,
        Constant.ARG_USERDATA: userData,
      });
    } catch (e) {
      MyDialog.circularProgressStop(state.context);
      MyDialog.info(context: state.context, title: 'Firestore error', content: '$e');
    }
  }

  void signUp() {
    // navigate to sign up screen
    Navigator.pushNamed(state.context, SignUpScreen.routeName);
  }
}
