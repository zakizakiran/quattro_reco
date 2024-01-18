class OrderProduct {
  String? oid;
  String? uid;
  String? address;
  String? phone;
  String? payment;
  String? imgUrl;
  String? title;
  int? price;
  DateTime? createdAt;

  OrderProduct(
      {this.oid,
      this.uid,
      this.address,
      this.phone,
      this.title,
      this.payment,
      this.createdAt,
      this.price,
      this.imgUrl});

  factory OrderProduct.fromJson(Map<String, dynamic> json) {
    return OrderProduct(
      oid: json['oid'],
      uid: json['uid'],
      address: json['address'],
      phone: json['phone'],
      payment: json['payment'],
      title: json['title'],
      createdAt: DateTime.tryParse(json['created_at'].toDate().toString()),
      imgUrl: json['imgUrl'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'oid': oid,
      'uid': uid,
      'address': address,
      'phone': phone,
      'payment': payment,
      'title': title,
      'created_at': createdAt,
      'imgUrl': imgUrl,
      'price': price,
    };
  }

  OrderProduct copyWith({
    String? oid,
    String? uid,
    String? address,
    String? phone,
    String? payment,
    String? title,
    DateTime? createdAt,
    String? imgUrl,
    int? price,
  }) {
    return OrderProduct(
      oid: oid ?? this.oid,
      uid: uid ?? this.uid,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      payment: payment ?? this.payment,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      imgUrl: imgUrl ?? this.imgUrl,
      price: price ?? this.price,
    );
  }
}
