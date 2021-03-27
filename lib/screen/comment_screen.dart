import 'package:flutter/material.dart';

class CommentScreen extends StatefulWidget {
  static const routeName = '/commentScreen';
  @override
  State<StatefulWidget> createState() {
    return _CommentState();
  }
}

class _CommentState extends State<CommentScreen> {
  _Controller con;

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
        title: Text('Comment Screen'),
      ),
    );
  }
}

class _Controller {
  _CommentState state;
  _Controller(this.state);
}
