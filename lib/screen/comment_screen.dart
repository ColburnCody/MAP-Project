import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/firebasecontroller.dart';
import 'package:lesson3/model/comment.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/screen/myview/mydialog.dart';

class CommentScreen extends StatefulWidget {
  static const routeName = '/commentScreen';
  @override
  State<StatefulWidget> createState() {
    return _CommentState();
  }
}

class _CommentState extends State<CommentScreen> {
  _Controller con;
  User user;
  String fileName;
  String progressMessage;
  String message = 'No comments yet';
  List<Comment> comments = [];
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
    fileName ??= args[Constant.ARG_FILENAME];
    return Scaffold(
        appBar: AppBar(
          title: Text('Comments'),
        ),
        body: Column(
          children: [
            Container(
              child: Text(message),
            ),
            Container(
              child: TextField(
                onSubmitted: (val) {
                  con.addComment(val);
                  render(() {});
                },
              ),
            ),
          ],
        ));
  }
}

class _Controller {
  _CommentState state;
  _Controller(this.state);
  Comment tempComment = Comment();

  void addComment(String comment) {
    state.message = comment;
  }
}
