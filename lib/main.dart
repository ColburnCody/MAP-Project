import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/screen/addphotomeme_screen.dart';
import 'package:lesson3/screen/comment_screen.dart';
import 'package:lesson3/screen/detailedview_screen.dart';
import 'package:lesson3/screen/leavecomment_screen.dart';
import 'package:lesson3/screen/notifications_screen.dart';
import 'package:lesson3/screen/sharedwith_screen.dart';
import 'package:lesson3/screen/signin_screen.dart';
import 'package:lesson3/screen/signup_screen.dart';
import 'package:lesson3/screen/userhome_screen.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/screen/usersettings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(PhotoMemoApp());
}

class PhotoMemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: Constant.DEV,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.green,
      ),
      initialRoute: SignInScreen.routeName,
      routes: {
        SignInScreen.routeName: (context) => SignInScreen(),
        UserHomeScreen.routeName: (context) => UserHomeScreen(),
        AddPhotoMemoScreen.routeName: (context) => AddPhotoMemoScreen(),
        DetailedViewScreen.routeName: (context) => DetailedViewScreen(),
        SignUpScreen.routeName: (context) => SignUpScreen(),
        SharedWithScreen.routeName: (context) => SharedWithScreen(),
        CommentScreen.routeName: (context) => CommentScreen(),
        LeaveCommentScreen.routeName: (context) => LeaveCommentScreen(),
        NotificationsScreen.routeName: (context) => NotificationsScreen(),
        UserSettingsScreen.routeName: (context) => UserSettingsScreen(),
      },
    );
  }
}
