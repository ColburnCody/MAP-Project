class Comment {
  String postedBy;
  String messageContent;
  DateTime timestamp;

  static const POSTEDBY = 'postedBy';
  static const MESSAGECONTENT = 'messageContent';
  static const TIMESTAMP = 'timestamp';
  Comment({
    this.postedBy,
    this.messageContent,
    this.timestamp,
  });

  Comment.clone(Comment c) {
    this.postedBy = c.postedBy;
    this.messageContent = c.messageContent;
    this.timestamp = c.timestamp;
  }

  void assign(Comment c) {
    this.postedBy = c.postedBy;
    this.messageContent = c.messageContent;
    this.timestamp = c.timestamp;
  }

  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      POSTEDBY: this.postedBy,
      MESSAGECONTENT: this.messageContent,
      TIMESTAMP: this.timestamp,
    };
  }

  static Comment deserialize(Map<String, dynamic> doc, String docId) {
    return Comment(
      postedBy: doc[POSTEDBY],
      messageContent: doc[MESSAGECONTENT],
      timestamp: doc[TIMESTAMP] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(doc[TIMESTAMP].millisecondsSinceEpoch),
    );
  }
}
