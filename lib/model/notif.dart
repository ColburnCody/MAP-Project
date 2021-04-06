class Notif {
  String docId;
  String message;
  String notified;
  DateTime timestamp;

  static const MESSAGE = 'message';
  static const NOTIFIED = 'notified';
  static const TIMESTAMP = 'timestamp';

  Notif({
    this.docId,
    this.message,
    this.notified,
    this.timestamp,
  });

  Notif.clone(Notif n) {
    this.docId = n.docId;
    this.message = n.message;
    this.notified = n.notified;
    this.timestamp = n.timestamp;
  }

  void assign(Notif n) {
    this.docId = n.docId;
    this.message = n.message;
    this.notified = n.notified;
    this.timestamp = n.timestamp;
  }

  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      MESSAGE: this.message,
      NOTIFIED: this.notified,
      TIMESTAMP: this.timestamp,
    };
  }

  static Notif deserialize(Map<String, dynamic> doc, String docId) {
    return Notif(
      docId: docId,
      message: doc[MESSAGE],
      notified: doc[NOTIFIED],
      timestamp: doc[TIMESTAMP] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(doc[TIMESTAMP].millisecondsSinceEpoch),
    );
  }
}
