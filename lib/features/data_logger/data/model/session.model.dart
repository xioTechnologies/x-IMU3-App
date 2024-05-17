class Session {
  String name;
  DateTime date;

  double? size; //kb

  Session({
    required this.name,
    required this.date,
    this.size,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      name: json['name'],
      date: DateTime.parse(json['date']),
      size: json['size'],
    );
  }
}
