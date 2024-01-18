class Product {
  String? pid;
  String? uid;
  String? author;
  String? authorImg;
  String? imgUrl;
  String? title;
  int? price;
  String? captions;
  DateTime? createdAt;

  Product(
      {this.pid,
      this.uid,
      this.author,
      this.authorImg,
      this.title,
      this.captions,
      this.createdAt,
      this.price,
      this.imgUrl});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      pid: json['pid'],
      uid: json['uid'],
      author: json['author'],
      authorImg: json['author_img'],
      title: json['title'],
      captions: json['captions'],
      createdAt: DateTime.tryParse(json['created_at'].toDate().toString()),
      imgUrl: json['imgUrl'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pid': pid,
      'uid': uid,
      'author': author,
      'author_img': authorImg,
      'title': title,
      'captions': captions,
      'created_at': createdAt,
      'imgUrl': imgUrl,
      'price': price,
    };
  }

  Product copyWith(
      {String? pid,
      String? uid,
      String? author,
      String? authorImg,
      String? title,
      String? captions,
      DateTime? createdAt,
      String? imgUrl,
      int? price}) {
    return Product(
      pid: pid ?? this.pid,
      uid: uid ?? this.uid,
      author: author ?? this.author,
      authorImg: authorImg ?? this.authorImg,
      title: title ?? this.title,
      captions: captions ?? this.captions,
      createdAt: createdAt ?? this.createdAt,
      imgUrl: imgUrl ?? this.imgUrl,
      price: price ?? this.price,
    );
  }
}
