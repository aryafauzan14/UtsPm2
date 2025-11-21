import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/menu_model.dart';

// State sederhana untuk Cubit
class OrderState {
  final List<OrderItem> items;
  final int totalPrice;

  OrderState({required this.items, required this.totalPrice});
}

class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(OrderState(items: [], totalPrice: 0));

  // Menambah menu ke order
  void addToOrder(MenuModel menu) {
    final currentItems = List<OrderItem>.from(state.items);
    
    // Cek apakah item sudah ada
    final index = currentItems.indexWhere((item) => item.menu.id == menu.id);

    if (index != -1) {
      // Jika sudah ada, tambahkan jumlahnya
      currentItems[index].quantity++;
    } else {
      // Jika belum ada, buat OrderItem baru
      currentItems.add(OrderItem(menu: menu, quantity: 1));
    }

    emit(OrderState(
      items: currentItems, 
      totalPrice: _calculateTotal(currentItems)
    ));
  }

  // Menghapus menu dari order sepenuhnya
  void removeFromOrder(MenuModel menu) {
    final currentItems = List<OrderItem>.from(state.items);
    currentItems.removeWhere((item) => item.menu.id == menu.id);
    
    emit(OrderState(
      items: currentItems, 
      totalPrice: _calculateTotal(currentItems)
    ));
  }

  // Update quantity spesifik (Dipanggil dari tombol + atau - di ringkasan)
  void updateQuantity(MenuModel menu, int qty) {
    final currentItems = List<OrderItem>.from(state.items);
    final index = currentItems.indexWhere((item) => item.menu.id == menu.id);

    if (index != -1) {
      if (qty > 0) {
        currentItems[index].quantity = qty;
      } else {
        // Jika quantity jadi 0, hapus item dari list
        currentItems.removeAt(index); 
      }
    }

    emit(OrderState(
      items: currentItems, 
      totalPrice: _calculateTotal(currentItems)
    ));
  }

  // Menghitung total harga setelah diskon per item
  int _calculateTotal(List<OrderItem> items) {
    int total = 0;
    for (var item in items) {
      total += item.menu.getDiscountedPrice() * item.quantity;
    }
    return total;
  }

  // Public method get total (sesuai permintaan soal)
  int getTotalPrice() => state.totalPrice;

  // Menghapus semua pesanan (Reset)
  void clearOrder() {
    emit(OrderState(items: [], totalPrice: 0));
  }
}