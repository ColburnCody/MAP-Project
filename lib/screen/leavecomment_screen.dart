import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/firebasecontroller.dart';
import 'package:lesson3/model/comment.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/notif.dart';
import 'package:lesson3/model/photomemo.dart';
import 'package:lesson3/screen/comment_screen.dart';
import 'package:lesson3/screen/myview/mydialog.dart';

class LeaveCommentScreen extends StatefulWidget {
  static const routeName = '/leaveCommentScreen';

  @override
  State<StatefulWidget> createState() {
    return _LeaveCommentState();
  }
}

class _LeaveCommentState extends State<LeaveCommentScreen> {
  _Controller con;
  User user;
  PhotoMemo photoMemo;
  String reply;
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
    reply ??= args[Constant.REPLY];
    return Scaffold(
      appBar: AppBar(
        title: Text('Leave a comment!'),
      ),
      body: Column(
        children: [
          Container(
            child: TextField(
              autocorrect: true,
              autofocus: true,
              onSubmitted: con.addComment,
            ),
          ),
        ],
      ),
    );
  }
}

class _Controller extends _LeaveCommentState {
  _LeaveCommentState state;
  _Controller(this.state);
  Comment tempComment = Comment();
  Notif tempNotif = Notif();

  void addComment(String comment) async {
    try {
      tempComment.postedBy = state.user.email;
      tempComment.messageContent =
          state.reply == null ? comment : '@${state.reply}, ' + comment;
      tempComment.timestamp = DateTime.now();
      tempComment.photoURL = state.photoMemo.photoURL;
      String docId = await FirebaseController.addComment(tempComment);
      tempComment.docId = docId;
      state.comments.add(tempComment);
      if (state.user.email != state.photoMemo.createdBy &&
          state.photoMemo.createdBy != state.reply) {
        tempNotif.sender = state.user.email;
        tempNotif.message = '${tempNotif.sender} left a comment on your photo';
        tempNotif.notified = state.photoMemo.createdBy;
        tempNotif.photoURL = state.photoMemo.photoURL;
        tempNotif.type = 'comment';
        tempNotif.timestamp = DateTime.now();
        String notifdocId = await FirebaseController.addNotification(tempNotif);
        tempNotif.docId = notifdocId;
      }
      if (state.reply != null) {
        tempNotif.sender = state.user.email;
        tempNotif.message = '${tempNotif.sender} replied to your comment!';
        tempNotif.notified = state.reply;
        tempNotif.photoURL = state.photoMemo.photoURL;
        tempNotif.timestamp = DateTime.now();
        tempNotif.type = 'comment';
        String notifdocId = await FirebaseController.addNotification(tempNotif);
        tempNotif.docId = notifdocId;
      }
      for (var i = 0; i < state.photoMemo.sharedWith.length; i++) {
        tempNotif.sender = state.user.email;
        tempNotif.message =
            '${tempNotif.sender} left a comment on a photo shared with you!';
        if (state.photoMemo.sharedWith[i] != state.user.email ||
            state.reply != state.photoMemo.sharedWith[i]) {
          tempNotif.notified = state.photoMemo.sharedWith[i];
        }
        tempNotif.photoURL = state.photoMemo.photoURL;
        tempNotif.type = 'comment';
        tempNotif.timestamp = DateTime.now();
        String notifdocId = await FirebaseController.addNotification(tempNotif);
        tempNotif.docId = notifdocId;
      }
      Navigator.pop(state.context);
    } catch (e) {
      MyDialog.info(context: state.context, title: 'Comment error', content: '$e');
    }
  }
}
