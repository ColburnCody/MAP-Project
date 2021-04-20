import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/firebasecontroller.dart';
import 'package:lesson3/model/comment.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/notif.dart';
import 'package:lesson3/model/photomemo.dart';
import 'package:lesson3/model/userdata.dart';
import 'package:lesson3/screen/addphotomeme_screen.dart';
import 'package:lesson3/screen/detailedview_screen.dart';
import 'package:lesson3/screen/myview/mydialog.dart';
import 'package:lesson3/screen/myview/myimage.dart';
import 'package:lesson3/screen/notifications_screen.dart';
import 'package:lesson3/screen/sharedwith_screen.dart';
import 'package:lesson3/screen/usersettings_screen.dart';

class UserHomeScreen extends StatefulWidget {
  static const routeName = '/userHomeScreen';
  @override
  State<StatefulWidget> createState() {
    return _UserHomeState();
  }
}

class _UserHomeState extends State<UserHomeScreen> {
  _Controller con;
  User user;
  UserData userData;
  List<PhotoMemo> photoMemoList;
  List<Notif> notifications;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
    photoMemoList ??= args[Constant.ARG_PHOTOMEMOLIST];
    notifications ??= args[Constant.ARG_NOTIFICATIONS];
    userData ??= args[Constant.ARG_USERDATA];
    return WillPopScope(
      onWillPop: () => Future.value(false), // disable Android system back button
      child: Scaffold(
        appBar: AppBar(
          actions: [
            con.delIndex != null
                ? IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: con.cancelDelete,
                  )
                : Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Search',
                            fillColor: Theme.of(context).backgroundColor,
                            filled: true,
                          ),
                          autocorrect: true,
                          onSaved: con.saveSearchKeyString,
                        ),
                      ),
                    ),
                  ),
            con.delIndex != null
                ? IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: con.delete,
                  )
                : IconButton(
                    icon: Icon(Icons.search),
                    onPressed: con.search,
                  ),
            notifications.length == 0
                ? IconButton(
                    icon: Icon(Icons.notifications),
                    onPressed: con.gotoNotifications,
                  )
                : IconButton(
                    icon: Icon(
                      Icons.notification_important,
                      color: Colors.red,
                    ),
                    onPressed: con.gotoNotifications,
                  ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                currentAccountPicture: Icon(
                  Icons.person,
                  size: 100.0,
                ),
                accountName: Text(userData.username),
                accountEmail: Text(user.email),
              ),
              ListTile(
                leading: Icon(Icons.people),
                title: Text('Shared With Me'),
                onTap: con.sharedWithMe,
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: con.goToSettings, //con.settings,
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Sign Out'),
                onTap: con.signOut,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: con.addButton,
        ),
        body: photoMemoList.length == 0
            ? Text(
                'No PhotoMemos found!',
                style: Theme.of(context).textTheme.headline5,
              )
            : ListView.builder(
                itemCount: photoMemoList.length,
                itemBuilder: (BuildContext context, int index) => Container(
                  color: con.delIndex != null && con.delIndex == index
                      ? Theme.of(context).highlightColor
                      : Theme.of(context).scaffoldBackgroundColor,
                  child: ListTile(
                    leading: MyImage.network(
                      url: photoMemoList[index].photoURL,
                      context: context,
                    ),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    title: Text(photoMemoList[index].title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(photoMemoList[index].memo.length >= 20
                            ? photoMemoList[index].memo.substring(0, 20) + '...'
                            : photoMemoList[index].memo),
                        Text('Created by: ${photoMemoList[index].createdBy}'),
                        Text('Shared with: ${photoMemoList[index].sharedWith}'),
                        Text('Updated at: ${photoMemoList[index].timestamp}'),
                      ],
                    ),
                    onTap: () => con.onTap(index),
                    onLongPress: () => con.onLongPress(index),
                  ),
                ),
              ),
      ),
    );
  }
}

class _Controller {
  _UserHomeState state;
  _Controller(this.state);
  int delIndex;
  String keyString;

  void addButton() async {
    await Navigator.pushNamed(
      state.context,
      AddPhotoMemoScreen.routeName,
      arguments: {
        Constant.ARG_USER: state.user,
        Constant.ARG_PHOTOMEMOLIST: state.photoMemoList
      },
    );
    state.render(() {}); //rerender the screen
  }

  void goToSettings() async {
    await Navigator.pushNamed(
      state.context,
      UserSettingsScreen.routeName,
      arguments: {
        Constant.ARG_USER: state.user,
        Constant.ARG_USERDATA: state.userData,
      },
    );
    state.render(() {});
  }

  void signOut() async {
    try {
      await FirebaseController.signOut();
    } catch (e) {
      // do nothing
    }
    Navigator.of(state.context).pop(); // close the drawer
    Navigator.of(state.context).pop(); // pop UserHome screen
  }

  void onTap(int index) async {
    List<Comment> commentList = await FirebaseController.getCommentList(
        photoURL: state.photoMemoList[index].photoURL);
    if (delIndex != null) return;
    await Navigator.pushNamed(
      state.context,
      DetailedViewScreen.routeName,
      arguments: {
        Constant.ARG_USER: state.user,
        Constant.ARG_ONE_PHOTOMEMO: state.photoMemoList[index],
        Constant.ARG_COMMENTlIST: commentList,
      },
    );
    state.render(() {});
  }

  void gotoNotifications() async {
    List<PhotoMemo> sharedList =
        await FirebaseController.getPhotoMemoSharedWithMe(email: state.user.email);
    List<PhotoMemo> photoMemos =
        await FirebaseController.getPhotoMemoList(email: state.user.email);
    await Navigator.pushNamed(state.context, NotificationsScreen.routeName, arguments: {
      Constant.ARG_USER: state.user,
      Constant.ARG_NOTIFICATIONS: state.notifications,
      Constant.ARG_SHAREDMEMOLIST: sharedList,
      Constant.ARG_PHOTOMEMOLIST: photoMemos,
    });
    state.render(() {});
  }

  void sharedWithMe() async {
    try {
      List<PhotoMemo> photoMemoList = await FirebaseController.getPhotoMemoSharedWithMe(
        email: state.user.email,
      );
      await Navigator.pushNamed(state.context, SharedWithScreen.routeName, arguments: {
        Constant.ARG_USER: state.user,
        Constant.ARG_PHOTOMEMOLIST: photoMemoList,
      });
      Navigator.pop(state.context);
    } catch (e) {
      MyDialog.info(
          context: state.context, title: 'get shared photomemo error', content: '$e');
    }
  }

  void onLongPress(int index) {
    if (delIndex != null) return;
    state.render(() => delIndex = index);
  }

  void cancelDelete() {
    state.render(() => delIndex = null);
  }

  void delete() async {
    try {
      PhotoMemo p = state.photoMemoList[delIndex];
      await FirebaseController.deletePhotoMemo(p);
      state.render(() {
        state.photoMemoList.removeAt(delIndex);
        delIndex = null;
      });
    } catch (e) {
      MyDialog.info(
        context: state.context,
        title: 'Delete PhotoMemo error',
        content: '$e',
      );
    }
  }

  void saveSearchKeyString(String value) {
    keyString = value;
  }

  void search() async {
    state.formKey.currentState.save();
    var keys = keyString.split(',').toList();
    List<String> searchKeys = [];
    for (var k in keys) {
      if (k.trim().isNotEmpty) searchKeys.add(k.trim().toLowerCase());
    }
    try {
      List<PhotoMemo> results;
      if (searchKeys.isNotEmpty) {
        results = await FirebaseController.searchImage(
          createdBy: state.user.email,
          searchLabels: searchKeys,
        );
      } else {
        results = await FirebaseController.getPhotoMemoList(email: state.user.email);
      }
      state.render(() => state.photoMemoList = results);
    } catch (e) {
      MyDialog.info(
        context: state.context,
        title: 'Search Error',
        content: '$e',
      );
    }
  }
}
