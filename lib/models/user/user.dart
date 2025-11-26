import 'package:hive/hive.dart';
part 'user.g.dart';

@HiveType(typeId: 0)
class User {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? token;
  @HiveField(2)
  String? name;
  @HiveField(3)
  String? email;
  @HiveField(4)
  String? phone;
  @HiveField(5)
  String? designation;
  @HiveField(6)
  bool? isApproved;

  User({
    this.id,
    this.token,
    this.name,
    this.email,
    this.phone,
    this.designation,
    this.isApproved,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    designation = json['designation'];
    token = json['token'];
    isApproved =
        json['is_approved'] != null && json['is_approved'].toString().isNotEmpty
            ? json['is_approved']
            : false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['phone'] = phone;
    data['email'] = email;
    data['designation'] = designation;
    data['token'] = token;
    data['is_approved'] = isApproved;
    return data;
  }
}
