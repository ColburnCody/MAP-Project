import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/firebasecontroller.dart';
import 'package:lesson3/model/comment.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/notif.dart';
import 'package:lesson3/model/photomemo.dart';
import 'package:lesson3/screen/comment_screen.dart';
import 'package:lesson3/screen/myview/mydialog.dart';
import 'package:lesson3/screen/myview/myimage.dart';

class SharedWithScreen extends StatefulWidget {
  static const routeName = '/sharedWithScreen';

  @override
  State<StatefulWidget> createState() {
    return _SharedWithState();
  }
}

class _SharedWithState extends State<SharedWithScreen> {
  _Controller con;
  User user;
  List<PhotoMemo> photoMemoList;

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Shared with me'),
      ),
      body: photoMemoList.length == 0
          ? Text('No PhotoMemos shared with me',
              style: Theme.of(context).textTheme.headline5)
          : ListView.builder(
              itemCount: photoMemoList.length,
              itemBuilder: (context, index) => Card(
                elevation: 7.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: MyImage.network(
                        url: photoMemoList[index].photoURL,
                        context: context,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.thumb_up),
                          onPressed: () => con.likePhoto(photoMemoList[index]),
                        ),
                        GestureDetector(
                          child: Text(photoMemoList[index].likedBy.length == 0
                              ? '0'
                              : '${photoMemoList[index].likedBy.length}'),
                          onTap: () => con.showLiked(photoMemoList[index]),
                        ),
                        IconButton(
                          icon: Icon(Icons.thumb_down),
                          onPressed: () => con.dislikePhoto(photoMemoList[index]),
                        ),
                        GestureDetector(
                          child: Text(photoMemoList[index].dislikedBy.length == 0
                              ? '0'
                              : '${photoMemoList[index].dislikedBy.length}'),
                          onTap: () => con.showDisliked(photoMemoList[index]),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.comment),
                      onPressed: () => con.goToComments(index),
                    ),
                    Text(
                      'Memo: ${photoMemoList[index].memo}',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text(
                      'Created by: ${photoMemoList[index].createdBy}',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text(
                      'Updated at: ${photoMemoList[index].timestamp}',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text(
                      'Shared with: ${photoMemoList[index].sharedWith}',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _Controller {
  _SharedWithState state;
  _Controller(this.state);
  Notif tempNotif = Notif();

  void showLiked(PhotoMemo p) {
    if (p.likedBy.length == 0) {
      MyDialog.info(
          context: state.context,
          title: 'Liked by',
          content: 'No one has liked this photo yet, be the first!');
    } else {
      MyDialog.info(
          context: state.context, title: 'Liked by', content: p.likedBy.toString());
    }
  }

  void showDisliked(PhotoMemo p) {
    if (p.dislikedBy.length == 0) {
      MyDialog.info(
          context: state.context,
          title: 'Disliked by',
          content: 'This photo is awesome, no one has disliked it!');
    } else {
      MyDialog.info(
          context: state.context, title: 'Disliked by', content: p.dislikedBy.toString());
    }
  }

  void dislikePhoto(PhotoMemo p) async {
    if (p.dislikedBy.length == 0) {
      p.dislikedBy.add(state.user.email);
      p.likedBy.remove(state.user.email);
      tempNotif.sender = state.user.email;
      tempNotif.message = '${tempNotif.sender} liked your photo!';
      tempNotif.photoURL = p.photoURL;
      tempNotif.notified = p.createdBy;
      tempNotif.type = 'vote';
      String notifdocid = await FirebaseController.addNotification(tempNotif);
      tempNotif.docId = notifdocid;
    } else {
      p.dislikedBy.remove(state.user.email);
    }
    Map<String, dynamic> updateInfo = {};
    updateInfo[PhotoMemo.DISLIKED_BY] = p.dislikedBy;
    await FirebaseController.updatePhotoMemo(p.docId, updateInfo);
    tempNotif.sender = state.user.email;
    tempNotif.message = '${tempNotif.sender} liked your photo!';
    tempNotif.photoURL = p.photoURL;
    tempNotif.notified = p.createdBy;
    tempNotif.type = 'vote';
    String notifdocid = await FirebaseController.addNotification(tempNotif);
    tempNotif.docId = notifdocid;
    state.render(() {});
  }

  void likePhoto(PhotoMemo p) async {
    if (p.likedBy.length == 0) {
      p.likedBy.add(state.user.email);
      p.dislikedBy.remove(state.user.email);
      tempNotif.sender = state.user.email;
      tempNotif.message = '${tempNotif.sender} disliked your photo!';
      tempNotif.photoURL = p.photoURL;
      tempNotif.notified = p.createdBy;
      tempNotif.type = 'vote';
      String notifdocid = await FirebaseController.addNotification(tempNotif);
      tempNotif.docId = notifdocid;
    } else {
      p.likedBy.remove(state.user.email);
    }
    Map<String, dynamic> updateInfo = {};
    updateInfo[PhotoMemo.LIKED_BY] = p.likedBy;
    await FirebaseController.updatePhotoMemo(p.docId, updateInfo);
    state.render(() {});
  }

  void goToComments(int index) async {
    List<Comment> comments = await FirebaseController.getCommentSharedWithMe(
        photoURL: state.photoMemoList[index].photoURL);
    await Navigator.pushNamed(state.context, CommentScreen.routeName, arguments: {
      Constant.ARG_USER: state.user,
      Constant.ARG_ONE_PHOTOMEMO: state.photoMemoList[index],
      Constant.ARG_COMMENTlIST: comments,
    });
  }
}
