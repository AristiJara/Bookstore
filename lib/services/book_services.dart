import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class BookServices {
  final String baseUrl = "http://192.168.0.20:3000/books";
  final String? token;

  BookServices({this.token});

  Map<String, String> get _headers {
    final headers = {"Content-Type": "application/json"};
    if (token != null) headers["Authorization"] = "Bearer $token";
    return headers;
  }

  Future<List<Book>> getBooks() async {
    final response = await http.get(Uri.parse(baseUrl), headers: _headers);

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => Book.fromJson(json)).toList();
    } else {
      throw Exception("Error al obtener libros: ${response.body}");
    }
  }

  Future<Book> createBook(Book book) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: _headers,
      body: json.encode(book.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Book.fromJson(json.decode(response.body));
    } else {
      throw Exception("Error al crear libro: ${response.body}");
    }
  }

  Future<void> deleteBook(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception("Error al eliminar libro: ${response.body}");
    }
  }
}
