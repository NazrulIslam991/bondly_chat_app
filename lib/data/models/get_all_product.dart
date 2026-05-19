class GetAllProductModel {
  String? id;
  String? status;
  String? productName;
  String? categoryId;
  double? price;
  int? stockQuantity;
  String? brandName;
  int? discount;
  String? description;
  bool? isActive;
  String? createdAt;
  String? updatedAt;
  List<String>? images;
  bool? hasImages;

  GetAllProductModel({
    this.id,
    this.status,
    this.productName,
    this.categoryId,
    this.price,
    this.stockQuantity,
    this.brandName,
    this.discount,
    this.description,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.images,
    this.hasImages,
  });

  GetAllProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] as String?;
    status = json['status'] as String?;
    productName = json['productName'] as String?;
    categoryId = json['categoryId'] as String?;
    price = (json['price'] as num?)?.toDouble();
    stockQuantity = json['stockQuantity'] as int?;
    brandName = json['brandName'] as String?;
    discount = json['discount'] as int?;
    description = json['description'] as String?;
    isActive = json['isActive'] as bool?;
    createdAt = json['createdAt'] as String?;
    updatedAt = json['updatedAt'] as String?;
    images = (json['images'] as List?)?.map((e) => e.toString()).toList();
    hasImages = json['hasImages'] as bool?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = this.id;
    data['status'] = this.status;
    data['productName'] = this.productName;
    data['categoryId'] = this.categoryId;
    data['price'] = this.price;
    data['stockQuantity'] = this.stockQuantity;
    data['brandName'] = this.brandName;
    data['discount'] = this.discount;
    data['description'] = this.description;
    data['isActive'] = this.isActive;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['images'] = this.images;
    data['hasImages'] = this.hasImages;
    return data;
  }
}
