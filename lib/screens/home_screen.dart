import 'package:bookshop/core/utils/widget_helpers.dart';
import 'package:bookshop/providers/books_provider.dart';
import 'package:bookshop/providers/user_provider.dart';
import 'package:bookshop/screens/add_book_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class HomeScreenContent extends ConsumerWidget {
  const HomeScreenContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final bool isAdmin = user?.role == 'admin';
    final books = ref.watch(booksProvider);

    final bookService = ref.read(bookServiceProvider);

    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = (screenWidth - 12 * 4) / 3;

    Future<void> loadBooks() async {
      final fetchedBooks = await bookService.getBooks();
      ref.read(booksProvider.notifier).setBooks(fetchedBooks);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (books.isEmpty) {
        loadBooks();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const TextField(
            decoration: InputDecoration(
              hintText: "Search for books...",
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              prefixIcon: Icon(Icons.search_outlined, color: Color(0xFF382110)),
              contentPadding: EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
        actions: [
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddBookScreen()),
                );
              },
            ),
        ],
      ),
      body: books.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: loadBooks,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔹 "Most Popular"
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Most Popular",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF382110),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(height: 1, color: const Color(0xFF382110)),
                      ],
                    ),
                  ),

                  // 🔹 Horizontal List
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      itemCount: books.length > 5 ? 5 : books.length,
                      itemBuilder: (context, index) {
                        final book = books[index];
                        return Container(
                          width: itemWidth,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey[300],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: buildBookImage(book.image),
                          ),
                        );
                      },
                    ),
                  ),

                  // 🔹 Vertical List
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.only(top: 8),
                      itemCount: books.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final book = books[index];
                        return Card(
                          color: const Color(0xFFFAF8F6),
                          elevation: 6,
                          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: SizedBox(
                            height: 240,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 140,
                                    height: 230,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.grey[300],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: buildBookImage(book.image),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          book.title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Color(0xFF382110),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          book.author,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          book.genre,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // 🔹 Precio + acciones
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "COP ${book.price.toStringAsFixed(2)}",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        ElevatedButton.icon(
                                          onPressed: () {},
                                          icon: const Icon(Icons.shopping_cart),
                                          label: const Text("Add to cart"),
                                        ),
                                        const SizedBox(height: 8),
                                        if (isAdmin)
                                          ElevatedButton.icon(
                                            onPressed: () async {
                                              try {
                                                await bookService.deleteBook(book.id!);
                                                ref.read(booksProvider.notifier).removeBook(book.id!);
                                              } catch (e) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text('Error al eliminar libro: $e')),
                                                );
                                              }
                                            },
                                            icon: const Icon(Icons.delete),
                                            label: const Text("Delete"),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(0xFFEF5350),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
