import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/firebasecontroller.dart';
import 'package:lesson3/model/comment.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/notif.dart';
import 'package:lesson3/model/photomemo.dart';
import 'package:lesson3/screen/comment_screen.dart';
import 'package:lesson3/screen/detailedview_screen.dart';
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
  List<PhotoMemo> sharedWith;
  List<PhotoMemo> photoMemos;
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
    photoMemos ??= args[Constant.ARG_PHOTOMEMOLIST];
    sharedWith ??= args[Constant.ARG_SHAREDMEMOLIST];
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: notifications.length == 0
          ? Text(
              'No new notifications',
              style: Theme.of(context).textTheme.headline5,
            )
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
        onTap: () =>
            goToScreen(state.notifications[index].photoURL, state.notifications[index]),
      ),
    );
  }

  void goToScreen(String url, Notif n) async {
    var sharedMemo;
    for (var i = 0; i < state.sharedWith.length; i++) {
      if (state.sharedWith[i].photoURL == url) {
        sharedMemo = state.sharedWith[i];
      }
    }
    var tempMemo;
    for (var i = 0; i < state.photoMemos.length; i++) {
      if (state.photoMemos[i].photoURL == url) {
        tempMemo = state.photoMemos[i];
      }
    }
    List<Comment> commentList = await FirebaseController.getCommentList(
        photoURL: sharedMemo == null ? tempMemo.photoURL : sharedMemo.photoURL);
    if (n.type == 'sharedWith') {
      await Navigator.pushNamed(state.context, SharedWithScreen.routeName, arguments: {
        Constant.ARG_USER: state.user,
        Constant.ARG_PHOTOMEMOLIST: state.sharedWith,
      });
    } else if (n.type == 'comment') {
      await Navigator.pushNamed(state.context, CommentScreen.routeName, arguments: {
        Constant.ARG_USER: state.user,
        Constant.ARG_COMMENTlIST: commentList,
        Constant.ARG_ONE_PHOTOMEMO: sharedMemo == null ? tempMemo : sharedMemo,
      });
    } else if (n.type == 'vote') {
      await Navigator.pushNamed(
        state.context,
        DetailedViewScreen.routeName,
        arguments: {
          Constant.ARG_USER: state.user,
          Constant.ARG_ONE_PHOTOMEMO: tempMemo,
        },
      );
    }
    state.notifications.remove(n);
    await FirebaseController.deleteNotification(n);
    state.render(() {});
  }
}
