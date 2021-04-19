import 'package:flutter/material.dart';

class ProfilePicScreen extends StatefulWidget {
  static const routeName = '/profilePicScreen';
  @override
  State<StatefulWidget> createState() {
    return _ProfilePicState();
  }
}

class _ProfilePicState extends State<ProfilePicScreen> {
  _Controller con;
  @override
  void initState() {
    con = _Controller(this);
    super.initState();
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

class _Controller extends _ProfilePicState {
  _ProfilePicState state;
  _Controller(this.state);
}
