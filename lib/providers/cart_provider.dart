import 'package:flutter/foundation.dart';
import '../models/book.dart';

class CartItem {
  final Book book;
  int quantity;

  CartItem({required this.book, this.quantity = 1});
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get totalItems =>
      _items.fold(0, (total, item) => total + item.quantity);

  double get totalPrice => _items.fold(
        0,
        (total, item) => total + item.book.price * item.quantity,
      );

  void addItem(Book book) {
    final index = _items.indexWhere((item) => item.book.id == book.id);

    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(book: book));
    }

    notifyListeners();
  }

  // Mengurangi satu jumlah. Jika jumlah menjadi 0, buku dihapus dari keranjang.
  void removeItem(Book book) {
    final index = _items.indexWhere((item) => item.book.id == book.id);
    if (index == -1) return;

    if (_items[index].quantity > 1) {
      _items[index].quantity--;
    } else {
      _items.removeAt(index);
    }

    notifyListeners();
  }

  // Menghapus seluruh jumlah buku tertentu dari keranjang.
  void removeBook(Book book) {
    _items.removeWhere((item) => item.book.id == book.id);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
