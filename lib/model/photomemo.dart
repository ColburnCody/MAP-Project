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
  int likes;
  int dislikes;
  List<dynamic> likedBy;
  List<dynamic> dislikedBy;

  // key for Firestore document
  static const TITLE = 'title';
  static const MEMO = 'memo';
  static const CREATED_BY = 'createdBy';
  static const PHOTO_URL = 'photoURL';
  static const PHOTO_FILENAME = 'photoFilename';
  static const TIMESTAMP = 'timestamp';
  static const SHARED_WITH = 'sharedWith';
  static const IMAGE_LABELS = 'imageLabels';
  static const LIKES = 'likes';
  static const DISLIKES = 'dislikes';
  static const LIKED_BY = 'likedBy';
  static const DISLIKED_BY = 'dislikedBy';

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
    this.likes,
    this.likedBy,
    this.dislikes,
    this.dislikedBy,
  }) {
    this.sharedWith ??= [];
    this.imageLabels ??= [];
    this.likedBy ??= [];
    this.dislikedBy ??= [];
  }

  PhotoMemo.clone(PhotoMemo p) {
    this.docId = p.docId;
    this.createdBy = p.createdBy;
    this.memo = p.memo;
    this.photoFilename = p.photoFilename;
    this.photoURL = p.photoURL;
    this.timestamp = p.timestamp;
    this.title = p.title;
    this.sharedWith = [];
    this.sharedWith.addAll(p.sharedWith); // deep copy
    this.imageLabels = [];
    this.imageLabels.addAll(p.imageLabels); // deep copy
    this.likes = p.likes;
    this.dislikes = p.dislikes;
    this.likedBy = [];
    this.likedBy.addAll(p.likedBy);
    this.dislikedBy = [];
    this.dislikedBy.addAll(p.dislikedBy);
  }

  // a = b ==> a.assign(b)
  void assign(PhotoMemo p) {
    this.docId = p.docId;
    this.createdBy = p.createdBy;
    this.memo = p.memo;
    this.photoFilename = p.photoFilename;
    this.photoURL = p.photoURL;
    this.timestamp = p.timestamp;
    this.title = p.title;
    this.sharedWith.clear();
    this.sharedWith.addAll(p.sharedWith);
    this.imageLabels.clear();
    this.imageLabels.addAll(p.imageLabels);
    this.likes = p.likes;
    this.likedBy.clear();
    this.likedBy.addAll(p.likedBy);
    this.dislikes = p.dislikes;
    this.dislikedBy.clear();
    this.dislikedBy.addAll(p.dislikedBy);
  }

  // from Dart object to Firestore document
  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      TITLE: this.title,
      CREATED_BY: this.createdBy,
      MEMO: this.memo,
      PHOTO_FILENAME: this.photoFilename,
      PHOTO_URL: this.photoURL,
      TIMESTAMP: this.timestamp,
      SHARED_WITH: this.sharedWith,
      IMAGE_LABELS: this.imageLabels,
      LIKES: this.likes,
      LIKED_BY: this.likedBy,
      DISLIKES: this.dislikes,
      DISLIKED_BY: this.dislikedBy,
    };
  }

  static PhotoMemo deserialize(Map<String, dynamic> doc, String docId) {
    return PhotoMemo(
      docId: docId,
      createdBy: doc[CREATED_BY],
      title: doc[TITLE],
      memo: doc[MEMO],
      photoFilename: doc[PHOTO_FILENAME],
      photoURL: doc[PHOTO_URL],
      sharedWith: doc[SHARED_WITH],
      imageLabels: doc[IMAGE_LABELS],
      likes: doc[LIKES],
      likedBy: doc[LIKED_BY],
      dislikes: doc[DISLIKES],
      dislikedBy: doc[DISLIKED_BY],
      timestamp: doc[TIMESTAMP] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(doc[TIMESTAMP].millisecondsSinceEpoch),
    );
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
