import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/firebasecontroller.dart';
import 'package:lesson3/model/comment.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/notif.dart';
import 'package:lesson3/model/photomemo.dart';
import 'package:lesson3/screen/comment_screen.dart';
import 'package:lesson3/screen/sharedwith_screen.dart';

class NotificationsScreen extends StatefulWidget {
  static const routeName = '/notificationsScreen';
  @override
  State<StatefulWidget> createState() {
    return _NotificationsState();
  }
}

class _NotificationsState extends State<NotificationsScreen> {
  User user;
  List<Notif> notifications;
  List<PhotoMemo> photoMemo;
  _Controller con;

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
    notifications ??= args[Constant.ARG_NOTIFICATIONS];
    photoMemo ??= args[Constant.ARG_PHOTOMEMOLIST];
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: notifications.length == 0
          ? Text('No new notifications')
          : ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: notifications.length,
              itemBuilder: con.buildList,
            ),
    );
  }
}

class _Controller extends _NotificationsState {
  _NotificationsState state;
  _Controller(this.state);

  Widget buildList(BuildContext context, int index) {
    return Container(
      child: ListTile(
        title: Text('${state.notifications[index].message}'),
        subtitle: Text('${state.notifications[index].timestamp}'),
        onTap: () => goToScreen(
            state.notifications[index].type, state.notifications[index].photoURL),
      ),
    );
  }

  void goToScreen(String type, String url) async {
    var tempMemo;
    for (var i = 0; i < state.photoMemo.length; i++) {
      if (state.photoMemo[i].photoURL == url) {
        tempMemo = state.photoMemo[i];
      }
    }
    List<Comment> commentList = await FirebaseController.getCommentList(photoURL: url);
    if (type == 'comment') {
      await Navigator.pushNamed(state.context, CommentScreen.routeName, arguments: {
        Constant.ARG_USER: state.user,
        Constant.ARG_ONE_PHOTOMEMO: tempMemo,
        Constant.ARG_COMMENTlIST: commentList,
      });
    } else if (type == 'sharedWith') {
      await Navigator.pushNamed(state.context, SharedWithScreen.routeName, arguments: {
        Constant.ARG_USER: state.user,
        Constant.ARG_PHOTOMEMOLIST: state.photoMemo,
      });
    }
    state.render(() {});
  }
}
