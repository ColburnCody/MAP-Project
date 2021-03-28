class Comment {
  String messageContent;
  String userName;
  String commentFilename;
  String commentURL;
  DateTime timestamp;

  Comment({
    this.messageContent,
    this.userName,
    this.commentFilename,
    this.commentURL,
    this.timestamp,
  });

  static const MESSAGECONTENT = 'messagecontent';
  static const USERNAME = 'username';
  static const COMMENT_FILENAME = 'commentFilename';
  static const TIMESTAMP = 'timestamp';
  static const COMMENTURL = 'commentURL';

  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      MESSAGECONTENT: this.messageContent,
      USERNAME: this.userName,
      COMMENT_FILENAME: this.commentFilename,
      COMMENTURL: this.commentURL,
      TIMESTAMP: this.timestamp,
    };
  }
}
