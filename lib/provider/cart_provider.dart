import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String name;
  final int price;
  final String imageUrl;
  final String selectedSize;
  final String selectedColor;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.selectedSize,
    required this.selectedColor,
    this.quantity = 1,
  });
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get itemCount => _items.length;

  int get totalPrice {
    return _items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  void addItem({
    required String id,
    required String name,
    required int price,
    required String imageUrl,
    required String selectedSize,
    required String selectedColor,
  }) {
    final existingIndex = _items.indexWhere(
          (item) =>
      item.id == id &&
          item.selectedSize == selectedSize &&
          item.selectedColor == selectedColor,
    );

    if (existingIndex >= 0) {
      _items[existingIndex].quantity += 1;
    } else {
      _items.add(CartItem(
        id: id,
        name: name,
        price: price,
        imageUrl: imageUrl,
        selectedSize: selectedSize,
        selectedColor: selectedColor,
      ));
    }
    notifyListeners();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void updateQuantity(int index, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(index);
    } else {
      _items[index].quantity = newQuantity;
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}