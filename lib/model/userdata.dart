class UserData {
  String email;
  String username;
  String profilepic;
  String docId;

  static const EMAIL = 'email';
  static const USERNAME = 'username';
  static const PROFILEPIC = 'profilepic';

  UserData({
    this.email,
    this.username,
    this.profilepic,
    this.docId,
  });

  UserData.clone(UserData u) {
    this.email = u.email;
    this.username = u.username;
    this.profilepic = u.profilepic;
    this.docId = u.docId;
  }

  void assign(UserData u) {
    this.email = u.email;
    this.username = u.username;
    this.profilepic = u.profilepic;
    this.docId = u.docId;
  }

  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      EMAIL: this.email,
      USERNAME: this.username,
      PROFILEPIC: this.profilepic,
    };
  }

  static UserData deserialize(Map<String, dynamic> doc, String docId) {
    return UserData(
      docId: docId,
      email: doc[EMAIL],
      username: doc[USERNAME],
      profilepic: doc[PROFILEPIC],
    );
  }
}
