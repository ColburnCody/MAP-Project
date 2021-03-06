class Comment {
  String docId;
  String postedBy;
  String messageContent;
  String photoURL;
  DateTime timestamp;
  List<dynamic> likedBy;
  List<dynamic> dislikedBy;

  static const POSTEDBY = 'postedBy';
  static const MESSAGECONTENT = 'messageContent';
  static const PHOTOURL = 'photoURL';
  static const TIMESTAMP = 'timestamp';
  static const LIKED_BY = 'likedBy';
  static const DISLIKED_BY = 'dislikedBy';

  Comment({
    this.docId,
    this.postedBy,
    this.messageContent,
    this.photoURL,
    this.timestamp,
    this.likedBy,
    this.dislikedBy,
  }) {
    this.likedBy ??= [];
    this.dislikedBy ??= [];
  }

  Comment.clone(Comment c) {
    this.docId = c.docId;
    this.postedBy = c.postedBy;
    this.messageContent = c.messageContent;
    this.photoURL = c.photoURL;
    this.timestamp = c.timestamp;
    this.likedBy = [];
    this.likedBy.addAll(c.likedBy);
    this.dislikedBy = [];
    this.dislikedBy.addAll(c.dislikedBy);
  }

  void assign(Comment c) {
    this.docId = c.docId;
    this.postedBy = c.postedBy;
    this.messageContent = c.messageContent;
    this.photoURL = c.photoURL;
    this.timestamp = c.timestamp;
    this.likedBy.clear();
    this.likedBy.addAll(c.likedBy);
    this.dislikedBy.clear();
    this.dislikedBy.addAll(c.dislikedBy);
  }

  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      POSTEDBY: this.postedBy,
      MESSAGECONTENT: this.messageContent,
      PHOTOURL: this.photoURL,
      TIMESTAMP: this.timestamp,
      LIKED_BY: likedBy,
      DISLIKED_BY: dislikedBy,
    };
  }

  static Comment deserialize(Map<String, dynamic> doc, String docId) {
    return Comment(
      docId: docId,
      postedBy: doc[POSTEDBY],
      messageContent: doc[MESSAGECONTENT],
      photoURL: doc[PHOTOURL],
      likedBy: doc[LIKED_BY],
      dislikedBy: doc[DISLIKED_BY],
      timestamp: doc[TIMESTAMP] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(doc[TIMESTAMP].millisecondsSinceEpoch),
    );
  }
}
