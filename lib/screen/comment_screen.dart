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
  bool commentMode = false;

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
        actions: [
          commentMode
              ? IconButton(
                  icon: Icon(Icons.check),
                  onPressed: con.update,
                )
              : IconButton(
                  icon: Icon(Icons.comment),
                  onPressed: con.comment,
                ),
        ],
      ),
      body: Stack(
        children: [
          Container(),
          TextFormField(
            enabled: commentMode,
          ),
        ],
      ),
    );
  }
}

class _Controller {
  _CommentState state;
  _Controller(this.state);

  void update() {
    state.render(() => state.commentMode = false);
  }

  void comment() {
    state.render(() => state.commentMode = true);
  }
}
