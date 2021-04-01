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
}
