class Comment {
  String docId;
  String postedBy;
  String messageContent;
  String photoURL;
  DateTime timestamp;

  static const POSTEDBY = 'postedBy';
  static const MESSAGECONTENT = 'messageContent';
  static const PHOTOURL = 'photoURL';
  static const TIMESTAMP = 'timestamp';
  Comment({
    this.docId,
    this.postedBy,
    this.messageContent,
    this.photoURL,
    this.timestamp,
  });

  Comment.clone(Comment c) {
    this.docId = c.docId;
    this.postedBy = c.postedBy;
    this.messageContent = c.messageContent;
    this.photoURL = c.photoURL;
    this.timestamp = c.timestamp;
  }

  void assign(Comment c) {
    this.docId = c.docId;
    this.postedBy = c.postedBy;
    this.messageContent = c.messageContent;
    this.photoURL = c.photoURL;
    this.timestamp = c.timestamp;
  }

  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      POSTEDBY: this.postedBy,
      MESSAGECONTENT: this.messageContent,
      PHOTOURL: this.photoURL,
      TIMESTAMP: this.timestamp,
    };
  }

  static Comment deserialize(Map<String, dynamic> doc, String docId) {
    return Comment(
      docId: docId,
      postedBy: doc[POSTEDBY],
      messageContent: doc[MESSAGECONTENT],
      photoURL: doc[PHOTOURL],
      timestamp: doc[TIMESTAMP] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(doc[TIMESTAMP].millisecondsSinceEpoch),
    );
  }
}
