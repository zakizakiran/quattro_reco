class Feeds {
  String? fid;
  String? uid;
  String? author;
  String? authorImg;
  String? title;
  String? captions;
  DateTime? createdAt;
  String? imgUrl;

  Feeds(
      {this.fid,
      this.uid,
      this.author,
      this.authorImg,
      this.title,
      this.captions,
      this.createdAt,
      this.imgUrl});

  factory Feeds.fromJson(Map<String, dynamic> json) {
    return Feeds(
      fid: json['fid'],
      uid: json['uid'],
      author: json['author'],
      authorImg: json['author_img'],
      title: json['title'],
      captions: json['captions'],
      createdAt: DateTime.tryParse(json['created_at'].toDate().toString()),
      imgUrl: json['imgUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fid': fid,
      'uid': uid,
      'author': author,
      'author_img': authorImg,
      'title': title,
      'captions': captions,
      'created_at': createdAt,
      'imgUrl': imgUrl,
    };
  }

  Feeds copyWith({
    String? fid,
    String? uid,
    String? author,
    String? authorImg,
    String? title,
    String? captions,
    DateTime? createdAt,
    String? imgUrl,
  }) {
    return Feeds(
      fid: fid ?? this.fid,
      uid: uid ?? this.uid,
      author: author ?? this.author,
      authorImg: authorImg ?? this.authorImg,
      title: title ?? this.title,
      captions: captions ?? this.captions,
      createdAt: createdAt ?? this.createdAt,
      imgUrl: imgUrl ?? this.imgUrl,
    );
  }
}
