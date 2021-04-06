class Notif {
  String docId;
  String sender;
  String message;
  String photoURL;
  List<dynamic> notified;
  String type;
  DateTime timestamp;

  static const SENDER = 'sender';
  static const MESSAGE = 'message';
  static const NOTIFIED = 'notified';
  static const TYPE = 'type';
  static const PHOTOURL = 'photoURL';
  static const TIMESTAMP = 'timestamp';

  Notif({
    this.docId,
    this.sender,
    this.message,
    this.notified,
    this.type,
    this.photoURL,
    this.timestamp,
  }) {
    this.notified ??= [];
  }

  Notif.clone(Notif n) {
    this.docId = n.docId;
    this.sender = n.sender;
    this.message = n.message;
    this.notified = [];
    this.notified.addAll(n.notified);
    this.type = n.type;
    this.photoURL = n.photoURL;
    this.timestamp = n.timestamp;
  }

  void assign(Notif n) {
    this.docId = n.docId;
    this.sender = n.sender;
    this.message = n.message;
    this.notified.clear();
    this.notified.addAll(n.notified);
    this.type = n.type;
    this.photoURL = n.photoURL;
    this.timestamp = n.timestamp;
  }

  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      SENDER: this.sender,
      MESSAGE: this.message,
      NOTIFIED: this.notified,
      TYPE: this.type,
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
      type: doc[TYPE],
      photoURL: doc[PHOTOURL],
      timestamp: doc[TIMESTAMP] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(doc[TIMESTAMP].millisecondsSinceEpoch),
    );
  }
}
