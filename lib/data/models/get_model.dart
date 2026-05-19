class GetModel {
  String? id;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  int? status;
  String? name;
  String? description;

  GetModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.status,
    this.name,
    this.description,
  });

  GetModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    status = json['status'];
    name = json['name'];
    description = json['description'];
  }
}
