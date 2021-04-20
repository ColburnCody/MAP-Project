import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/userdata.dart';
import 'package:lesson3/screen/myview/myimage.dart';

class UserSettingsScreen extends StatefulWidget {
  static const routeName = '/userSettingsScreen';
  @override
  State<StatefulWidget> createState() {
    return _UserSettingsState();
  }
}

class _UserSettingsState extends State<UserSettingsScreen> {
  User user;
  UserData userData;
  _Controller con;
  bool editMode = false;
  String progressMessage;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    user ??= args[Constant.ARG_USER];
    userData ??= args[Constant.ARG_USERDATA];
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings screen for ${user.displayName}'),
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
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: userData.profilepic == null
                        ? Icon(Icons.person)
                        : MyImage.network(url: userData.profilepic, context: context),
                  ),
                  TextFormField(
                    enabled: editMode,
                    style: Theme.of(context).textTheme.headline6,
                    decoration: InputDecoration(
                      hintText: 'Enter username',
                    ),
                    initialValue: userData.username,
                    autocorrect: false,
                    onSaved: con.saveUsername,
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                ],
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

  void update() {}
  void edit() {}
  void saveUsername(String value) {}
}
