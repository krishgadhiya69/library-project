class Book {
  String title;
  String author;
  String isbn;
  int quantity;
  bool issued;

  Book({
    required this.title,
    required this.author,
    required this.isbn,
    required this.quantity,
    this.issued = false,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "author": author,
      "isbn": isbn,
      "quantity": quantity,
      "issued": issued
    };
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: json["title"],
      author: json["author"],
      isbn: json["isbn"],
      quantity: json["quantity"],
      issued: json["issued"],
    );
  }
}