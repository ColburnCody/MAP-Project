import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lesson3/controller/firebasecontroller.dart';
import 'package:lesson3/model/comment.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/photomemo.dart';
import 'package:lesson3/model/userdata.dart';
import 'package:lesson3/screen/comment_screen.dart';
import 'package:lesson3/screen/myview/mydialog.dart';
import 'package:lesson3/screen/myview/myimage.dart';

class DetailedViewScreen extends StatefulWidget {
  static const routeName = '/detailedViewScreen';
  @override
  State<StatefulWidget> createState() {
    return _DetailedViewState();
  }
}

class _DetailedViewState extends State<DetailedViewScreen> {
  _Controller con;
  User user;
  PhotoMemo onePhotoMemoOriginal;
  PhotoMemo onePhotoMemoTemp;
  List<Comment> commentList;
  UserData userData;
  bool editMode = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String progressMessage;

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
    onePhotoMemoOriginal ??= args[Constant.ARG_ONE_PHOTOMEMO];
    onePhotoMemoTemp ??= PhotoMemo.clone(onePhotoMemoOriginal);
    commentList ??= args[Constant.ARG_COMMENTlIST];
    userData ??= args[Constant.ARG_USERDATA];
    return Scaffold(
      appBar: AppBar(
        title: Text('Detailed View'),
        actions: [
          IconButton(
            icon: commentList.length == 0
                ? Icon(Icons.chat)
                : Icon(
                    Icons.chat,
                    color: Colors.red,
                  ),
            onPressed: con.comment,
          ),
          editMode
              ? IconButton(
                  icon: Icon(Icons.check),
                  onPressed: con.update,
                )
              : IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: con.edit,
                ),
        ],
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: con.photoFile == null
                        ? MyImage.network(
                            url: onePhotoMemoTemp.photoURL,
                            context: context,
                          )
                        : Image.file(
                            con.photoFile,
                            fit: BoxFit.fill,
                          ),
                  ),
                  editMode
                      ? Positioned(
                          right: 0.0,
                          bottom: 0.0,
                          child: Container(
                            color: Colors.green[100],
                            child: PopupMenuButton<String>(
                              onSelected: con.getPhoto,
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: Constant.SRC_CAMERA,
                                  child: Row(
                                    children: [
                                      Icon(Icons.photo_camera),
                                      Text(Constant.SRC_CAMERA),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: Constant.SRC_GALLERY,
                                  child: Row(
                                    children: [
                                      Icon(Icons.photo_library),
                                      Text(Constant.SRC_GALLERY),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : SizedBox(
                          height: 1.0,
                        ),
                ],
              ),
              progressMessage == null
                  ? SizedBox(height: 1.0)
                  : Text(
                      progressMessage,
                      style: Theme.of(context).textTheme.headline6,
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(icon: Icon(Icons.thumb_up), onPressed: null),
                  GestureDetector(
                    child: Text(onePhotoMemoTemp.likedBy == null
                        ? '0'
                        : '${onePhotoMemoTemp.likedBy.length}'),
                    onTap: null,
                  ),
                  IconButton(
                    icon: Icon(Icons.thumb_down),
                    onPressed: null,
                  ),
                  GestureDetector(
                    child: Text(onePhotoMemoTemp.dislikedBy == null
                        ? '0'
                        : '${onePhotoMemoTemp.dislikedBy.length}'),
                    onTap: null,
                  ),
                ],
              ),
              RaisedButton(
                onPressed: con.setProfilepic,
                child: Text('Set as profile picture',
                    style: Theme.of(context).textTheme.button),
              ),
              TextFormField(
                enabled: editMode,
                style: Theme.of(context).textTheme.headline6,
                decoration: InputDecoration(
                  hintText: 'Enter Title',
                ),
                initialValue: onePhotoMemoTemp.title,
                autocorrect: true,
                validator: PhotoMemo.validateTitle,
                onSaved: con.saveTitle,
              ),
              TextFormField(
                enabled: editMode,
                decoration: InputDecoration(
                  hintText: 'Enter memo',
                ),
                initialValue: onePhotoMemoTemp.memo,
                autocorrect: true,
                keyboardType: TextInputType.multiline,
                maxLines: 6,
                validator: PhotoMemo.validateMemo,
                onSaved: con.saveMemo,
              ),
              TextFormField(
                enabled: editMode,
                decoration: InputDecoration(
                  hintText: 'Enter shared with (email list)',
                ),
                initialValue: onePhotoMemoTemp.sharedWith.join(','),
                autocorrect: false,
                keyboardType: TextInputType.multiline,
                maxLines: 2,
                validator: PhotoMemo.validateSharedWith,
                onSaved: con.saveSharedWith,
              ),
              SizedBox(
                height: 5.0,
              ),
              Constant.DEV
                  ? Text(
                      'Image Labels generated by ML',
                      style: Theme.of(context).textTheme.bodyText1,
                    )
                  : SizedBox(
                      height: 1.0,
                    ),
              Constant.DEV
                  ? Text(onePhotoMemoTemp.imageLabels.join(' | '))
                  : SizedBox(height: 1.0),
            ],
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _DetailedViewState state;
  _Controller(this.state);
  File photoFile; // camera or gallery

  void setProfilepic() async {
    state.userData.profilepic = state.onePhotoMemoTemp.photoURL;
    Map<String, dynamic> updateInfo = {};
    updateInfo[UserData.PROFILEPIC] = state.userData.profilepic;
    await FirebaseController.updateUserData(state.userData.docId, updateInfo);
    state.render(() {});
    Navigator.pop(state.context);
  }

  void update() async {
    if (!state.formKey.currentState.validate()) return;
    state.formKey.currentState.save();

    try {
      MyDialog.circularProgressStart(state.context);
      Map<String, dynamic> updateInfo = {};
      if (photoFile != null) {
        Map photoInfo = await FirebaseController.uploadPhotoFile(
          photo: photoFile,
          filename: state.onePhotoMemoTemp.photoFilename,
          uid: state.user.uid,
          listener: (double message) {
            state.render(() {
              if (message == null)
                state.progressMessage = null;
              else {
                message *= 100;
                state.progressMessage = 'Uploading: ' + message.toStringAsFixed(1) + '%';
              }
            });
          },
        );

        state.onePhotoMemoTemp.photoURL = photoInfo[Constant.ARG_DOWNLOADURL];
        state.render(() => state.progressMessage = 'ML image labeler started');
        List<dynamic> labels =
            await FirebaseController.getImageLabels(photoFile: photoFile);
        state.onePhotoMemoTemp.imageLabels = labels;
        updateInfo[PhotoMemo.PHOTO_URL] = photoInfo[Constant.ARG_DOWNLOADURL];
        updateInfo[PhotoMemo.IMAGE_LABELS] = labels;
      }

      // determine updated fields
      if (state.onePhotoMemoOriginal.title != state.onePhotoMemoTemp.title)
        updateInfo[PhotoMemo.TITLE] = state.onePhotoMemoTemp.title;

      if (state.onePhotoMemoOriginal.memo != state.onePhotoMemoTemp.memo)
        updateInfo[PhotoMemo.MEMO] = state.onePhotoMemoTemp.memo;

      if (!listEquals(
          state.onePhotoMemoOriginal.sharedWith, state.onePhotoMemoTemp.sharedWith))
        updateInfo[PhotoMemo.SHARED_WITH] = state.onePhotoMemoTemp.sharedWith;
      updateInfo[PhotoMemo.TIMESTAMP] = DateTime.now();

      await FirebaseController.updatePhotoMemo(state.onePhotoMemoTemp.docId, updateInfo);

      state.onePhotoMemoOriginal.assign(state.onePhotoMemoTemp);
      MyDialog.circularProgressStop(state.context);
      Navigator.pop(state.context);
    } catch (e) {
      MyDialog.circularProgressStop(state.context);
      MyDialog.info(
          context: state.context, title: 'Update PhotoMemo Error', content: '$e');
    }
  }

  void edit() {
    state.render(() => state.editMode = true);
  }

  void getPhoto(String src) async {
    try {
      PickedFile _photoFile;
      if (src == Constant.SRC_CAMERA) {
        _photoFile = await ImagePicker().getImage(source: ImageSource.camera);
      } else {
        _photoFile = await ImagePicker().getImage(source: ImageSource.gallery);
      }
      if (_photoFile == null) return; // selection cancelled
      state.render(() => photoFile = File(_photoFile.path));
    } catch (e) {
      MyDialog.info(
        context: state.context,
        title: 'getPhoto error',
        content: '$e',
      );
    }
  }

  void saveTitle(String value) {
    state.onePhotoMemoTemp.title = value;
  }

  void saveMemo(String value) {
    state.onePhotoMemoTemp.memo = value;
  }

  void saveSharedWith(String value) {
    if (value.trim().length != 0) {
      state.onePhotoMemoTemp.sharedWith =
          value.split(RegExp('(,| )+')).map((e) => e.trim()).toList();
    }
  }

  void comment() async {
    List<Comment> commentList = await FirebaseController.getCommentList(
        photoURL: state.onePhotoMemoOriginal.photoURL);
    await Navigator.pushNamed(state.context, CommentScreen.routeName, arguments: {
      Constant.ARG_USER: state.user,
      Constant.ARG_COMMENTlIST: commentList,
      Constant.ARG_ONE_PHOTOMEMO: state.onePhotoMemoTemp,
    });
    state.render(() {});
  }
}
