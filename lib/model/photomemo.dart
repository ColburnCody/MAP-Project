class PhotoMemo {
  String docId; // Firestore auto generated ID
  String createdBy;
  String title;
  String memo;
  String photoFilename; // stored at Storage
  String photoURL;
  DateTime timestamp;
  List<dynamic> sharedWith; // list of emails
  List<dynamic> imageLabels; // image identity by ML

  PhotoMemo({
    this.docId,
    this.createdBy,
    this.memo,
    this.photoFilename,
    this.photoURL,
    this.timestamp,
    this.title,
    this.sharedWith,
    this.imageLabels,
  }) {
    this.sharedWith ??= [];
    this.imageLabels ??= [];
  }

  static String validateTitle(String value) {
    if (value == null || value.length < 3)
      return 'too short';
    else
      return null;
  }

  static String validateMemo(String value) {
    if (value == null || value.length < 5)
      return 'too short';
    else
      return null;
  }

  static String validateSharedWith(String value) {
    if (value == null || value.trim().length == 0) return null;

    List<String> emailList = value.split(RegExp('(,| )+')).map((e) => e.trim()).toList();
    for (String email in emailList) {
      if (email.contains('@') && email.contains('.'))
        continue;
      else
        return 'Comma(,) or space separated email list';
    }
    return null;
  }
}
