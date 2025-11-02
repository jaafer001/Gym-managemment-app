import 'Subscription.dart';

class Member {
  int? id;
  String name;
  int age;
  String gender;
  String phone;
  String? email;
  String? photoPath;
  List<Subscription> subscriptions;

  Member({
    this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.phone,
    this.email,
    this.photoPath,
    required this.subscriptions,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'age': age,
        'gender': gender,
        'phone': phone,
        'email': email,
        'photoPath': photoPath,
        'subscriptions': subscriptions.map((s) => s.toJson()).toList(),
      };

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        id: json['id'],
        name: json['name'],
        age: json['age'],
        gender: json['gender'],
        phone: json['phone'],
        email: json['email'],
        photoPath: json['photoPath'],
        subscriptions: (json['subscriptions'] as List)
            .map((s) => Subscription.fromJson(s))
            .toList(),
      );
}