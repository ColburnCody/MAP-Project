class ProfilePicture {
  String docId;
  String createdBy;
  String photoFilename;
  String photoURL;
  bool isProfilePicture;
  DateTime timestamp;

  static const CREATED_BY = 'createdBy';
  static const PHOTO_FILENAME = 'photoFilename';
  static const PHOTO_URL = 'photoURL';
  static const ISPROFILEPICTURE = 'isProfilePicture';
  static const TIMESTAMP = 'timestamp';

  ProfilePicture({
    this.docId,
    this.createdBy,
    this.photoFilename,
    this.photoURL,
    this.isProfilePicture,
    this.timestamp,
  });

  ProfilePicture.clone(ProfilePicture p) {
    this.docId = p.docId;
    this.createdBy = p.createdBy;
    this.photoFilename = p.photoFilename;
    this.photoURL = p.photoURL;
    this.isProfilePicture = p.isProfilePicture;
    this.timestamp = p.timestamp;
  }

  void assign(ProfilePicture p) {
    this.docId = p.docId;
    this.createdBy = p.createdBy;
    this.photoFilename = p.photoFilename;
    this.photoURL = p.photoURL;
    this.isProfilePicture = p.isProfilePicture;
    this.timestamp = p.timestamp;
  }

  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      CREATED_BY: this.createdBy,
      PHOTO_FILENAME: this.photoFilename,
      PHOTO_URL: this.photoURL,
      ISPROFILEPICTURE: this.isProfilePicture,
      TIMESTAMP: this.timestamp,
    };
  }

  static ProfilePicture deserialize(Map<String, dynamic> doc, String docId) {
    return ProfilePicture(
      docId: docId,
      createdBy: doc[CREATED_BY],
      photoFilename: doc[PHOTO_FILENAME],
      photoURL: doc[PHOTO_URL],
      isProfilePicture: doc[ISPROFILEPICTURE],
      timestamp: doc[TIMESTAMP] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(doc[TIMESTAMP].millisecondsSinceEpoch),
    );
  }
}
