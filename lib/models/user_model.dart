class Users {
  String? uid;
  String? name;
  String? email;
  String? profileImg;

  Users({this.uid, this.name, this.email, this.profileImg});

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      profileImg: json['profile_img'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'profile_img': profileImg,
    };
  }

  Users copyWith({
    String? uid,
    String? name,
    String? email,
    String? profileImg,
  }) {
    return Users(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImg: profileImg ?? this.profileImg,
    );
  }
}
