import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/firebasecontroller.dart';
import 'package:lesson3/model/comment.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/photomemo.dart';
import 'package:lesson3/screen/leavecomment_screen.dart';

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
  List<Comment> comments;

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
    comments ??= args[Constant.ARG_COMMENTlIST];
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.post_add),
            onPressed: con.addComment,
          ),
        ],
      ),
      body: comments.length == 0
          ? Text(
              'No comments yet!',
              style: Theme.of(context).textTheme.headline5,
            )
          : ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: comments.length,
              itemBuilder: con.buildList,
            ),
    );
  }
}

class _Controller {
  _CommentState state;
  _Controller(this.state);

  Widget buildList(BuildContext context, int index) {
    return Container(
        child: ListTile(
      title: Text('${state.comments[index].postedBy} says: '),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${state.comments[index].messageContent}'),
          Text('${state.comments[index].timestamp}'),
        ],
      ),
      onTap: () => reply(state.comments[index].postedBy),
    ));
  }

  void reply(String email) async {
    state.comments =
        await FirebaseController.getCommentList(photoURL: state.photoMemo.photoURL);
    await Navigator.pushNamed(state.context, LeaveCommentScreen.routeName, arguments: {
      Constant.ARG_USER: state.user,
      Constant.ARG_ONE_PHOTOMEMO: state.photoMemo,
      Constant.ARG_COMMENTlIST: state.comments,
      Constant.REPLY: email,
    });
    state.render(() {});
  }

  void addComment() async {
    state.comments =
        await FirebaseController.getCommentList(photoURL: state.photoMemo.photoURL);
    await Navigator.pushNamed(state.context, LeaveCommentScreen.routeName, arguments: {
      Constant.ARG_USER: state.user,
      Constant.ARG_ONE_PHOTOMEMO: state.photoMemo,
      Constant.ARG_COMMENTlIST: state.comments,
    });
    state.render(() {});
  }
}
