import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quote.dart';

class QuoteProvider {
  // static const String _url =
  //     "http://quotes-api.westeurope.cloudapp.azure.com:8080";
  static const String _url =
      "https://naas.isalman.dev/no";

  // static Future<Quote> fetchQuote() async {
  //   // TODO: remplacer par appel HTTP si le serveur répond
  //   return Quote(quote: "Il n'est jamais trop tard pour abandonner", author: "L. Swinnen");
  // }


  static Future<Quote> fetchQuote() async {
    final response = await http.get(Uri.parse(_url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Quote.fromNaasJson(data);
    } else {
      throw Exception('Failed to load quote');
    }
  }

}
