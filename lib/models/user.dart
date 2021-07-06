class User {
  late int id;
  String? name;
  String? avatar;
  String? createdDate;

  User({
    required this.id,
    this.name,
    this.avatar,
    this.createdDate,
  });

  User.fromJson(dynamic json) {
    id = json["id"];
    name = json["name"];
    avatar = json["avatar"];
    createdDate = json["createdDate"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["name"] = name;
    map["avatar"] = avatar;
    map["createdDate"] = createdDate;
    return map;
  }
}
