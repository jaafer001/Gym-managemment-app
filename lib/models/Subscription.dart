class Subscription {
  int? id;
  String type;
  int duration; // in days
  DateTime startDate;
  DateTime endDate;
  bool isActive;

  Subscription({
    this.id,
    required this.type,
    required this.duration,
    required this.startDate,
    required this.endDate,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'duration': duration,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'isActive': isActive,
      };

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
        id: json['id'],
        type: json['type'],
        duration: json['duration'],
        startDate: DateTime.parse(json['startDate']),
        endDate: DateTime.parse(json['endDate']),
        isActive: json['isActive'],
      );
}