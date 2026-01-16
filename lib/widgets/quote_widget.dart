import 'package:flutter/material.dart';
import '../models/quote.dart';
import '../services/quote_provider.dart';

class QuoteWidget extends StatelessWidget {
  const QuoteWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Quote>(
      future: QuoteProvider.fetchQuote(), // ici, on utilise la classe directement
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text("Erreur : ${snapshot.error}");
        } else if (!snapshot.hasData) {
          return const Text("Aucune citation");
        } else {
          final quote = snapshot.data!;
          return Column(
            children: [
              Text(
                quote.quote,
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
              Text(
                "- ${quote.author}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          );
        }
      },
    );
  }
}
