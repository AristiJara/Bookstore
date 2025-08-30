import 'package:bookshop/models/book.dart';
import 'package:bookshop/providers/token_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bookshop/services/book_services.dart';


final bookServiceProvider = Provider<BookServices>((ref) {
  final token = ref.watch(tokenProvider);
  return BookServices(token: token);
});


class BooksNotifier extends StateNotifier<List<Book>> {
  BooksNotifier() : super([]);

  void setBooks(List<Book> books) => state = books;
  void addBook(Book book) => state = [...state, book];
  void removeBook(String id) => state = state.where((b) => b.id != id).toList();
}

final booksProvider = StateNotifierProvider<BooksNotifier, List<Book>>(
  (ref) => BooksNotifier(),
);