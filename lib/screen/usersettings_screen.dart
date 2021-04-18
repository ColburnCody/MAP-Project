import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/profilepictures.dart';

class UserSettingsScreen extends StatefulWidget {
  static const routeName = '/userSettingsScreen';
  @override
  State<StatefulWidget> createState() {
    return _UserSettingsState();
  }
}

class _UserSettingsState extends State<UserSettingsScreen> {
  User user;
  List<ProfilePicture> profilePictureList;
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
    // ignore: unnecessary_statements
    profilePictureList ?? args[Constant.ARG_PROFILEPICTURELIST];
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings screen for ${user.email}'),
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
}
