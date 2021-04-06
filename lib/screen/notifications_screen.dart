import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/firebasecontroller.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/notif.dart';

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
      ),
    );
  }

  void delete(Notif notification) {}
}
