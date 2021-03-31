import 'package:flutter/material.dart';

class Comment {
  String docId;
  String postedBy;
  String messageContent;
  String commentFileName;
  String commentURL;
  String photoFilename;
  DateTime timestamp;

  static const POSTEDBY = 'postedBy';
  static const MESSAGECONTENT = 'messageContent';
  static const PHOTO_FILENAME = 'photoFileName';
  static const TIMESTAMP = 'timestamp';
  static const COMMENT_FILENAME = 'commentFilename';
  static const COMMENTURL = 'commentURL';

  Comment({
    this.docId,
    this.postedBy,
    this.messageContent,
    this.photoFilename,
    this.timestamp,
    this.commentFileName,
    this.commentURL,
  });

  Comment.clone(Comment c) {
    this.docId = c.docId;
    this.postedBy = c.postedBy;
    this.messageContent = c.messageContent;
    this.photoFilename = c.photoFilename;
    this.timestamp = c.timestamp;
    this.commentFileName = c.commentFileName;
    this.commentURL = c.commentURL;
  }

  void assign(Comment c) {
    this.docId = c.docId;
    this.postedBy = c.postedBy;
    this.messageContent = c.messageContent;
    this.photoFilename = c.photoFilename;
    this.timestamp = c.timestamp;
    this.commentFileName = c.commentFileName;
    this.commentURL = c.commentURL;
  }

  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      POSTEDBY: this.postedBy,
      MESSAGECONTENT: this.messageContent,
      PHOTO_FILENAME: this.photoFilename,
      TIMESTAMP: this.timestamp,
      COMMENT_FILENAME: this.commentFileName,
      COMMENTURL: this.commentURL,
    };
  }

  static Comment deserialize(Map<String, dynamic> doc, String docId) {
    return Comment(
      docId: docId,
      postedBy: doc[POSTEDBY],
      messageContent: doc[MESSAGECONTENT],
      photoFilename: doc[PHOTO_FILENAME],
      commentFileName: doc[COMMENT_FILENAME],
      commentURL: doc[COMMENTURL],
      timestamp: doc[TIMESTAMP] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(doc[TIMESTAMP].millisecondsSinceEpoch),
    );
  }
}
