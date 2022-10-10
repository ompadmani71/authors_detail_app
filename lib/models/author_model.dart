import 'dart:convert';

Author authorFromJson(String str) => Author.fromJson(jsonDecode(str));

class Author{

  Author({
    this.author_name,
    this.bookes  = const []
});

  String? author_name;
  List<String> bookes;

  factory Author.fromJson(Map<String, dynamic> json) => Author(
    author_name: json["author_name"],
    bookes: List<String>.from(json["bookes"].map((e) => e)),
  );


}