class Wpis {
  final int id;
  final String title;
  final String body;

  Wpis({required this.id, required this.title, required this.body});

  factory Wpis.fromJson(Map<String, dynamic> json) {
    return Wpis(
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}