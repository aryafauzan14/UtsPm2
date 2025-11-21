import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/menu_model.dart';
import '../blocs/order_cubit.dart';

class MenuCard extends StatelessWidget {
  final MenuModel menu;

  const MenuCard({super.key, required this.menu});

  @override
  Widget build(BuildContext context) {
    // Menentukan warna berdasarkan kategori untuk variasi visual
    Color categoryColor;
    switch (menu.category) {
      case 'Makanan': categoryColor = Colors.orange; break;
      case 'Minuman': categoryColor = Colors.blue; break;
      case 'Snack': categoryColor = Colors.green; break;
      default: categoryColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08), // Bayangan lebih halus
            spreadRadius: 2,
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // 1. Kotak Gambar / Ikon dengan warna kategori
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: categoryColor.withOpacity(0.1), // Background transparan sesuai kategori
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getIconByCategory(menu.category),
                color: categoryColor, // Warna ikon sesuai kategori
                size: 40,
              ),
            ),
            const SizedBox(width: 16),

            // 2. Info Menu (Tengah)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    menu.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700, // Lebih tebal
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Badge Kategori Kecil
                  Container(
                     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                     decoration: BoxDecoration(
                       color: Colors.grey[100],
                       borderRadius: BorderRadius.circular(4)
                     ),
                    child: Text(
                      menu.category,
                      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (menu.discount > 0) ...[
                        Text(
                          "Rp${menu.price}",
                          style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        "Rp${menu.getDiscountedPrice()}",
                        style: TextStyle(
                          color: Colors.blueAccent[700],
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 3. Tombol Tambah (Kanan) yang lebih menonjol
            Container(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4)
                  )
                ]
              ),
              child: IconButton(
                onPressed: () {
                  context.read<OrderCubit>().addToOrder(menu);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar(); // Hapus snackbar lama jika ada
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.white),
                          const SizedBox(width: 10),
                          Expanded(child: Text('${menu.name} ditambahkan +1')),
                        ],
                      ),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.green[600],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      duration: const Duration(milliseconds: 1000),
                      margin: const EdgeInsets.all(16),
                    ),
                  );
                },
                icon: const Icon(Icons.add, color: Colors.white),
                tooltip: "Tambah Pesanan",
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconByCategory(String category) {
    switch (category) {
      case 'Makanan': return Icons.restaurant_menu_rounded;
      case 'Minuman': return Icons.local_cafe_rounded;
      case 'Snack': return Icons.cookie_rounded;
      default: return Icons.fastfood_rounded;
    }
  }
}