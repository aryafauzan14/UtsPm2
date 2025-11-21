import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/order_cubit.dart';
import '../models/menu_model.dart';
import '../widgets/menu_card.dart';
import 'category_stack_page.dart';
import 'order_summary_page.dart';

class OrderHomePage extends StatefulWidget {
  const OrderHomePage({super.key});

  @override
  State<OrderHomePage> createState() => _OrderHomePageState();
}

class _OrderHomePageState extends State<OrderHomePage> {
  String selectedCategory = "Makanan"; // Default category

  // --- UPDATE DUMMY DATA (LEBIH BANYAK SNACK) ---
  final List<MenuModel> allMenus = [
    // Makanan
    MenuModel(id: "1", name: "Nasi Goreng Spesial", price: 25000, category: "Makanan", discount: 0.1), // Diskon 10%
    MenuModel(id: "2", name: "Ayam Bakar Madu", price: 30000, category: "Makanan", discount: 0.0),
    
    // Minuman
    MenuModel(id: "3", name: "Es Teh Manis", price: 5000, category: "Minuman", discount: 0.0),
    MenuModel(id: "4", name: "Kopi Susu Gula Aren", price: 18000, category: "Minuman", discount: 0.2), // Diskon 20%
    
    // Snack (Tambahan Baru)
    MenuModel(id: "5", name: "Kentang Goreng", price: 12000, category: "Snack", discount: 0.0),
    MenuModel(id: "6", name: "Cireng Rujak", price: 15000, category: "Snack", discount: 0.0),
    MenuModel(id: "7", name: "Roti Bakar Coklat", price: 20000, category: "Snack", discount: 0.1), // Diskon 10%
    MenuModel(id: "8", name: "Tahu Walik Crispy", price: 10000, category: "Snack", discount: 0.0),
    MenuModel(id: "9", name: "Pisang Keju Lumer", price: 18000, category: "Snack", discount: 0.0),
  ];

  @override
  Widget build(BuildContext context) {
    // Filter menu berdasarkan kategori
    final filteredMenus = allMenus.where((m) => m.category == selectedCategory).toList();

    return Scaffold(
      backgroundColor: Colors.grey[50], 
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text(
          "Kasir App",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.black87),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OrderSummaryPage()),
              );
            },
          )
        ],
      ),

      body: Column(
        children: [
          const SizedBox(height: 10), 
          CategoryStackPage(
            onCategorySelected: (category) {
              setState(() {
                selectedCategory = category;
              });
            },
          ),
          
          // Daftar Menu
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 20),
              itemCount: filteredMenus.length,
              itemBuilder: (context, index) {
                return MenuCard(menu: filteredMenus[index]);
              },
            ),
          ),

          // Footer Total
          BlocBuilder<OrderCubit, OrderState>(
            builder: (context, state) {
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    )
                  ],
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Total Bayar",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        Text(
                          "Rp ${state.totalPrice}",
                          style: const TextStyle(
                            color: Colors.blueAccent, 
                            fontSize: 20, 
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const OrderSummaryPage()),
                        );
                      },
                      child: const Text("Lihat Pesanan"),
                    )
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}