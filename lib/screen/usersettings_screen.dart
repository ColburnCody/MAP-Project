import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/firebasecontroller.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/userdata.dart';

class UserSettingsScreen extends StatefulWidget {
  static const routeName = '/userSettingsScreen';
  @override
  State<StatefulWidget> createState() {
    return _UserSettingsState();
  }
}

class _UserSettingsState extends State<UserSettingsScreen> {
  User user;
  UserData userDataOriginal;
  UserData userDataTemp;
  _Controller con;
  bool editMode = false;
  String progressMessage;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    con = _Controller(this);
    super.initState();
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    user ??= args[Constant.ARG_USER];
    userDataOriginal ??= args[Constant.ARG_USERDATA];
    userDataTemp ??= UserData.clone(userDataOriginal);
    return Scaffold(
      appBar: AppBar(
        title: userDataTemp.username == null
            ? Text('Settings screen for ${userDataTemp.email}')
            : Text('Settings screen for ${userDataTemp.username}'),
        actions: [
          editMode
              ? IconButton(
                  icon: Icon(Icons.check),
                  onPressed: con.update,
                )
              : IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: con.edit,
                )
        ],
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                enabled: editMode,
                style: Theme.of(context).textTheme.headline6,
                decoration: InputDecoration(
                  hintText: 'Edit username',
                ),
                initialValue: userDataTemp.username,
                autocorrect: false,
                onSaved: con.saveUsername,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Controller extends _UserSettingsState {
  _UserSettingsState state;
  _Controller(this.state);

  void update() async {
    if (!state.formKey.currentState.validate()) return;
    state.formKey.currentState.save();
    Map<String, dynamic> updateInfo = {};
    updateInfo[UserData.USERNAME] = state.userDataTemp.username;
    await FirebaseController.updateUserData(state.userDataTemp.docId, updateInfo);
    state.userDataOriginal.assign(state.userDataTemp);
    Navigator.pop(state.context);
  }

  void edit() {
    state.render(() => state.editMode = true);
  }

  void saveUsername(String value) {
    state.userDataTemp.username = value;
  }
}
