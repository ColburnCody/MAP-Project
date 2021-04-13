class Comment {
  String docId;
  String postedBy;
  String messageContent;
  String photoURL;
  DateTime timestamp;
  int likes;
  int dislikes;
  List<dynamic> likedBy;
  List<dynamic> dislikedBy;

  static const POSTEDBY = 'postedBy';
  static const MESSAGECONTENT = 'messageContent';
  static const PHOTOURL = 'photoURL';
  static const TIMESTAMP = 'timestamp';
  static const LIKES = 'likes';
  static const DISLIKES = 'dislikes';
  static const LIKED_BY = 'likedBy';
  static const DISLIKED_BY = 'dislikedBy';

  Comment({
    this.docId,
    this.postedBy,
    this.messageContent,
    this.photoURL,
    this.timestamp,
    this.likes,
    this.dislikes,
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
    this.likes = c.likes;
    this.dislikes = c.dislikes;
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
    this.likes = c.likes;
    this.dislikes = c.dislikes;
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
      LIKES: likes,
      DISLIKES: dislikes,
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
      likes: doc[LIKES],
      dislikes: doc[DISLIKES],
      likedBy: doc[LIKED_BY],
      dislikedBy: doc[DISLIKED_BY],
      timestamp: doc[TIMESTAMP] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(doc[TIMESTAMP].millisecondsSinceEpoch),
    );
  }
}
