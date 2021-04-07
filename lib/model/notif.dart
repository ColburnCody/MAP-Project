class Notif {
  String docId;
  String sender;
  String message;
  String photoURL;
  String notified;
  DateTime timestamp;

  static const SENDER = 'sender';
  static const MESSAGE = 'message';
  static const NOTIFIED = 'notified';
  static const PHOTOURL = 'photoURL';
  static const TIMESTAMP = 'timestamp';

  Notif({
    this.docId,
    this.sender,
    this.message,
    this.notified,
    this.photoURL,
    this.timestamp,
  });

  Notif.clone(Notif n) {
    this.docId = n.docId;
    this.sender = n.sender;
    this.message = n.message;
    this.notified = n.notified;
    this.photoURL = n.photoURL;
    this.timestamp = n.timestamp;
  }

  void assign(Notif n) {
    this.docId = n.docId;
    this.sender = n.sender;
    this.message = n.message;
    this.notified = n.notified;
    this.photoURL = n.photoURL;
    this.timestamp = n.timestamp;
  }

  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      SENDER: this.sender,
      MESSAGE: this.message,
      NOTIFIED: this.notified,
      PHOTOURL: this.photoURL,
      TIMESTAMP: this.timestamp,
    };
  }

  static Notif deserialize(Map<String, dynamic> doc, String docId) {
    return Notif(
      docId: docId,
      sender: doc[SENDER],
      message: doc[MESSAGE],
      notified: doc[NOTIFIED],
      photoURL: doc[PHOTOURL],
      timestamp: doc[TIMESTAMP] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(doc[TIMESTAMP].millisecondsSinceEpoch),
    );
  }
}
