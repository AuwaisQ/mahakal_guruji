class Muhuratdata {
  int? status;
  List<Muhurat>? muhurat;

  Muhuratdata({this.status, this.muhurat});

  Muhuratdata.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['muhurat'] != null) {
      muhurat = <Muhurat>[];
      json['muhurat'].forEach((v) {
        muhurat!.add(Muhurat.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (muhurat != null) {
      data['muhurat'] = muhurat!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Muhurat {
  int? id;
  String? enName;
  String? hiName;
  List<String>? images;
  String? thumbnail;
  String? productType;
  int? counsellingMainPrice;
  int? counsellingSellingPrice;

  Muhurat(
      {this.id,
      this.enName,
      this.hiName,
      this.images,
      this.thumbnail,
      this.productType,
      this.counsellingMainPrice,
      this.counsellingSellingPrice});

  Muhurat.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    enName = json['en_name'];
    hiName = json['hi_name'];
    images = json['images'].cast<String>();
    thumbnail = json['thumbnail'];
    productType = json['product_type'];
    counsellingMainPrice = json['counselling_main_price'];
    counsellingSellingPrice = json['counselling_selling_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['en_name'] = enName;
    data['hi_name'] = hiName;
    data['images'] = images;
    data['thumbnail'] = thumbnail;
    data['product_type'] = productType;
    data['counselling_main_price'] = counsellingMainPrice;
    data['counselling_selling_price'] = counsellingSellingPrice;
    return data;
  }
}
