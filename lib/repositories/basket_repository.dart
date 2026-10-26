import 'package:southsea_cinema/models/basket_item.dart';

class BasketRepository {
  BasketRepository._internal();

  static final BasketRepository instance = BasketRepository._internal();

  final List<BasketItem> _items = [];

  List<BasketItem> getItems() {
    return List<BasketItem>.unmodifiable(_items);
  }

  void addItem(BasketItem item) {
    _items.add(item);
  }

  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
    }
  }

  int getTotalItems() {
    int total = 0;

    for (final item in _items) {
      total += item.quantity;
    }

    return total;
  }

  double getTotal() {
    double total = 0.0;

    for (final item in _items) {
      total += item.lineTotal;
    }

    return total;
  }

  double getSubtotal() {
    return getTotal();
  }

  double getTotalDue() {
    return getSubtotal();
  }

  void clear() {
    _items.clear();
  }
}
