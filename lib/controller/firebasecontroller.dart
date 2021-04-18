import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/model/comment.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/photomemo.dart';
import 'package:lesson3/model/notif.dart';
import 'package:lesson3/model/profilepictures.dart';

class FirebaseController {
  static Future<User> signIn({
    @required String email,
    @required String password,
  }) async {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return userCredential.user;
  }

  static Future<void> createAccount(
      {@required String email, @required String password}) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future<Map<String, String>> uploadPhotoFile({
    @required File photo,
    String filename,
    @required String uid,
    @required Function listener,
  }) async {
    filename ??= '${Constant.PHOTOIMAGE_FOLDER}/$uid/${DateTime.now()}';
    UploadTask task = FirebaseStorage.instance.ref(filename).putFile(photo);
    task.snapshotEvents.listen((TaskSnapshot event) {
      double progress = event.bytesTransferred / event.totalBytes;
      if (event.bytesTransferred == event.totalBytes) progress = null;
      listener(progress);
    });
    await task;
    String downloadURL = await FirebaseStorage.instance.ref(filename).getDownloadURL();
    return <String, String>{
      Constant.ARG_DOWNLOADURL: downloadURL,
      Constant.ARG_FILENAME: filename,
    };
  }

  static Future<Map<String, String>> uploadProfilePicture({
    @required File photo,
    String filename,
    @required String uid,
    @required Function listener,
  }) async {
    filename ??= '${Constant.PROFILEPICTURE_FOLDER}/$uid/${DateTime.now()}';
    UploadTask task = FirebaseStorage.instance.ref(filename).putFile(photo);
    task.snapshotEvents.listen((TaskSnapshot event) {
      double progress = event.bytesTransferred / event.totalBytes;
      if (event.bytesTransferred == event.totalBytes) progress = null;
      listener(progress);
    });
    await task;
    String downloadURL = await FirebaseStorage.instance.ref(filename).getDownloadURL();
    return <String, String>{
      Constant.ARG_DOWNLOADURL: downloadURL,
      Constant.ARG_FILENAME: filename,
    };
  }

  static Future<String> addProfilePic(ProfilePicture profilePicture) async {
    var ref = await FirebaseFirestore.instance
        .collection(Constant.PROFILEPICTURE_COLLECTION)
        .add(profilePicture.serialize());
    return ref.id;
  }

  static Future<String> addPhotoMemo(PhotoMemo photoMemo) async {
    var ref = await FirebaseFirestore.instance
        .collection(Constant.PHOTOMEMO_COLLECTION)
        .add(photoMemo.serialize());
    return ref.id;
  }

  static Future<String> addComment(Comment comment) async {
    var ref = await FirebaseFirestore.instance
        .collection(Constant.COMMENTS_COLLECTION)
        .add(comment.serialize());
    return ref.id;
  }

  static Future<String> addNotification(Notif notification) async {
    var ref = await FirebaseFirestore.instance
        .collection(Constant.NOTIFICATIONS_COLLECTION)
        .add(notification.serialize());
    return ref.id;
  }

  static Future<List<PhotoMemo>> getPhotoMemoList({@required String email}) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.PHOTOMEMO_COLLECTION)
        .where(PhotoMemo.CREATED_BY, isEqualTo: email)
        .orderBy(PhotoMemo.TIMESTAMP, descending: true)
        .get();

    var result = <PhotoMemo>[];
    querySnapshot.docs.forEach((doc) {
      result.add(PhotoMemo.deserialize(doc.data(), doc.id));
    });
    return result;
  }

  static Future<List<ProfilePicture>> getProfilePictureList(
      {@required String email}) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.PROFILEPICTURE_COLLECTION)
        .where(ProfilePicture.CREATED_BY, isEqualTo: email)
        .orderBy(ProfilePicture.TIMESTAMP, descending: true)
        .get();

    var result = <ProfilePicture>[];
    querySnapshot.docs.forEach((doc) {
      result.add(ProfilePicture.deserialize(doc.data(), doc.id));
    });
    return result;
  }

  static Future<List<Notif>> getNotifications({@required String email}) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.NOTIFICATIONS_COLLECTION)
        .where(Notif.NOTIFIED, isEqualTo: email)
        .orderBy(Notif.TIMESTAMP, descending: false)
        .get();

    var result = <Notif>[];
    querySnapshot.docs.forEach((doc) {
      result.add(Notif.deserialize(doc.data(), doc.id));
    });
    return result;
  }

  static Future<List<Comment>> getCommentList({
    @required String photoURL,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.COMMENTS_COLLECTION)
        .where(Comment.PHOTOURL, isEqualTo: photoURL)
        .orderBy(Comment.TIMESTAMP, descending: false)
        .get();

    var result = <Comment>[];
    querySnapshot.docs.forEach((doc) {
      result.add(Comment.deserialize(doc.data(), doc.id));
    });
    return result;
  }

  static Future<List<dynamic>> getImageLabels({@required File photoFile}) async {
    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(photoFile);
    final ImageLabeler cloudLabeler = FirebaseVision.instance.cloudImageLabeler();
    final List<ImageLabel> cloudLabels = await cloudLabeler.processImage(visionImage);
    List<dynamic> labels = <dynamic>[];
    for (ImageLabel label in cloudLabels) {
      if (label.confidence >= Constant.MIN_ML_CONFIDENCE)
        labels.add(label.text.toLowerCase());
    }
    return labels;
  }

  static Future<void> updateComment(String docId, Map<String, dynamic> updateInfo) async {
    await FirebaseFirestore.instance
        .collection(Constant.COMMENTS_COLLECTION)
        .doc(docId)
        .update(updateInfo);
  }

  static Future<void> updatePhotoMemo(
      String docId, Map<String, dynamic> updateInfo) async {
    await FirebaseFirestore.instance
        .collection(Constant.PHOTOMEMO_COLLECTION)
        .doc(docId)
        .update(updateInfo);
  }

  static Future<List<Comment>> getCommentSharedWithMe({
    @required String photoURL,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.COMMENTS_COLLECTION)
        .where(PhotoMemo.PHOTO_URL, isEqualTo: photoURL)
        .orderBy(Comment.TIMESTAMP, descending: true)
        .get();

    var result = <Comment>[];
    querySnapshot.docs.forEach((doc) {
      result.add(Comment.deserialize(doc.data(), doc.id));
    });
    return result;
  }

  static Future<List<PhotoMemo>> getPhotoMemoSharedWithMe(
      {@required String email}) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.PHOTOMEMO_COLLECTION)
        .where(PhotoMemo.SHARED_WITH, arrayContains: email)
        .orderBy(PhotoMemo.TIMESTAMP, descending: true)
        .get();

    var result = <PhotoMemo>[];
    querySnapshot.docs.forEach((doc) {
      result.add(PhotoMemo.deserialize(doc.data(), doc.id));
    });
    return result;
  }

  static Future<void> deletePhotoMemo(PhotoMemo p) async {
    await FirebaseFirestore.instance
        .collection(Constant.PHOTOMEMO_COLLECTION)
        .doc(p.docId)
        .delete();
    await FirebaseStorage.instance.ref().child(p.photoFilename).delete();
  }

  static Future<void> deleteNotification(Notif n) async {
    await FirebaseFirestore.instance
        .collection(Constant.NOTIFICATIONS_COLLECTION)
        .doc(n.docId)
        .delete();
  }

  static Future<List<PhotoMemo>> searchImage({
    @required String createdBy,
    @required List<String> searchLabels,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.PHOTOMEMO_COLLECTION)
        .where(PhotoMemo.CREATED_BY, isEqualTo: createdBy)
        .where(PhotoMemo.IMAGE_LABELS, arrayContainsAny: searchLabels)
        .orderBy(PhotoMemo.TIMESTAMP, descending: true)
        .get();
    var results = <PhotoMemo>[];
    querySnapshot.docs
        .forEach((doc) => results.add(PhotoMemo.deserialize(doc.data(), doc.id)));
    return results;
  }
}
