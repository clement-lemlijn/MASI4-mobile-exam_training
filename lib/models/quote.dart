class Quote {

  final String quote;
  final String author;

  Quote({required this.quote, required this.author});

  // TODO: extract quote information from JSON data
  factory Quote.fromJson(Map<String, dynamic> json) => Quote(
    quote: json['quote'],
    author: json['author'],
  );

  factory Quote.fromNaasJson(Map<String, dynamic> json) => Quote(
    quote: json['reason'],
    author: "Isalman",
  );

  @override
  String toString() => '"$quote" — $author';
}
