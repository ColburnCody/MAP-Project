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
          comments.length == 0
              ? Text(
                  'No comments yet!',
                  style: Theme.of(context).textTheme.headline5,
                )
              : ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: con.buildList,
                ),
          TextField(
            autocorrect: true,
            onSubmitted: (val) {
              con.addComment(val);
            },
          ),
        ],
      ),
    );
  }
}

class _Controller {
  _CommentState state;
  _Controller(this.state);
  Comment tempComment = Comment();

  Widget buildList(BuildContext context, int index) {
    return Card(
      margin: EdgeInsets.all(16.0),
      color: Colors.green,
      elevation: 15.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: ListTile(
        title: Text('${state.comments[index].postedBy}'),
        subtitle: Text('${state.comments[index].messageContent}'),
      ),
    );
  }

  void addComment(String comment) {
    tempComment.postedBy = state.user.email;
    tempComment.messageContent = comment;
    tempComment.timestamp = DateTime.now();
    state.comments.add(tempComment);
    state.render(() {});
  }
}
