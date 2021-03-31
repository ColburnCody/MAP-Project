import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/model/comment.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/photomemo.dart';

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
  PhotoMemo photoMemo;
  String progressMessage;
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
    photoMemo ??= args[Constant.ARG_ONE_PHOTOMEMO];
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: Column(
        children: [
          photoMemo.comments.length == 0
              ? Text(
                  'No comments yet!',
                  style: Theme.of(context).textTheme.headline5,
                )
              : ListView.builder(
                  itemCount: photoMemo.comments.length,
                  itemBuilder: con.buildList,
                ),
          TextField(
            autocorrect: true,
            keyboardType: TextInputType.multiline,
            onSubmitted: (val) {
              con.addComment(val);
              render(() {});
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
        title: Text('${state.photoMemo.comments[index].postedBy}'),
        subtitle: Text('${state.photoMemo.comments[index].messageContent}'),
      ),
    );
  }

  void addComment(String value) {
    tempComment.postedBy = state.user.email;
    tempComment.messageContent = value;
    tempComment.timestamp = DateTime.now();
    state.photoMemo.comments.add(tempComment);
  }
}
