import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  static const routeName = '/notificationsScreen';
  @override
  State<StatefulWidget> createState() {
    return _NotificationsState();
  }
}

class _NotificationsState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
    );
  }
}
