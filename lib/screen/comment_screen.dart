import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/firebasecontroller.dart';
import 'package:lesson3/model/comment.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/notif.dart';
import 'package:lesson3/model/photomemo.dart';
import 'package:lesson3/screen/leavecomment_screen.dart';
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
  PhotoMemo photoMemo;
  List<Comment> comments;

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
              itemBuilder: (BuildContext context, int index) => Container(
                child: ListTile(
                  title: Text('${comments[index].postedBy} says:'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(comments[index].messageContent),
                      Text('${comments[index].timestamp}'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.thumb_up),
                            onPressed: () => con.likeComment(comments[index]),
                          ),
                          GestureDetector(
                            child: Text(comments[index].likedBy.length == 0
                                ? '0'
                                : '${comments[index].likedBy.length}'),
                            onTap: () => con.showLiked(comments[index]),
                          ),
                          IconButton(
                            icon: Icon(Icons.thumb_down),
                            onPressed: () => con.dislikeComment(comments[index]),
                          ),
                          GestureDetector(
                            child: Text(comments[index].dislikedBy.length == 0
                                ? '0'
                                : '${comments[index].dislikedBy.length}'),
                            onTap: () => con.showDisliked(comments[index]),
                          ),
                        ],
                      ),
                    ],
                  ),
                  onTap: () => con.reply(comments[index].postedBy),
                ),
              ),
            ),
    );
  }
}

class _Controller {
  _CommentState state;
  _Controller(this.state);
  Notif tempNotif = Notif();

  void likeComment(Comment c) async {
    if (c.likedBy.length != 0) {
      c.likedBy.remove(state.user.email);
    } else {
      c.likedBy.add(state.user.email);
      c.dislikedBy.remove(state.user.email);
    }
    Map<String, dynamic> updateInfo = {};
    updateInfo[Comment.LIKED_BY] = c.likedBy;
    await FirebaseController.updateComment(c.docId, updateInfo);
    tempNotif.sender = state.user.email;
    tempNotif.message = '${tempNotif.sender} liked your comment!';
    tempNotif.photoURL = state.photoMemo.photoURL;
    tempNotif.notified = c.postedBy;
    tempNotif.timestamp = DateTime.now();
    tempNotif.type = 'voteC';
    String notifdocid = await FirebaseController.addNotification(tempNotif);
    tempNotif.docId = notifdocid;
    state.render(() {});
  }

  void dislikeComment(Comment c) async {
    if (c.dislikedBy.length != 0) {
      c.dislikedBy.remove(state.user.email);
    } else {
      c.dislikedBy.add(state.user.email);
      c.likedBy.remove(state.user.email);
    }
    Map<String, dynamic> updateInfo = {};
    updateInfo[Comment.DISLIKED_BY] = c.dislikedBy;
    await FirebaseController.updateComment(c.docId, updateInfo);
    tempNotif.sender = state.user.email;
    tempNotif.message = '${tempNotif.sender} disliked your comment!';
    tempNotif.photoURL = state.photoMemo.photoURL;
    tempNotif.notified = c.postedBy;
    tempNotif.type = 'voteC';
    tempNotif.timestamp = DateTime.now();
    String notifdocid = await FirebaseController.addNotification(tempNotif);
    tempNotif.docId = notifdocid;
    state.render(() {});
  }

  void showLiked(Comment c) {
    if (c.likedBy.length == 0) {
      MyDialog.info(
          context: state.context,
          title: 'Liked by',
          content: 'No one has liked this comment yet, be the first!');
    } else {
      MyDialog.info(
          context: state.context, title: 'Liked by', content: c.likedBy.toString());
    }
  }

  void showDisliked(Comment c) {
    if (c.dislikedBy.length == 0) {
      MyDialog.info(
          context: state.context,
          title: 'Disiked by',
          content: 'This comment is awesome, no one has disliked it!');
    } else {
      MyDialog.info(
          context: state.context, title: 'Disiked by', content: c.dislikedBy.toString());
    }
  }

  void reply(String email) async {
    await Navigator.pushNamed(state.context, LeaveCommentScreen.routeName, arguments: {
      Constant.ARG_USER: state.user,
      Constant.ARG_ONE_PHOTOMEMO: state.photoMemo,
      Constant.ARG_COMMENTlIST: state.comments,
      Constant.REPLY: email,
    });
    state.render(() {});
  }

  void addComment() async {
    await Navigator.pushNamed(state.context, LeaveCommentScreen.routeName, arguments: {
      Constant.ARG_USER: state.user,
      Constant.ARG_ONE_PHOTOMEMO: state.photoMemo,
      Constant.ARG_COMMENTlIST: state.comments,
    });
    state.render(() {});
  }
}
