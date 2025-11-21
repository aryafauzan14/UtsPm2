import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/order_cubit.dart';
import '../models/menu_model.dart';

class OrderSummaryPage extends StatelessWidget {
  const OrderSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Background abu muda konsisten
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Ringkasan Pesanan",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        actions: [
           BlocBuilder<OrderCubit, OrderState>(
             builder: (context, state) {
               if(state.items.isNotEmpty) {
                 return IconButton(
                   tooltip: "Hapus Semua",
                   icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                   onPressed: () => _showClearConfirmation(context),
                 );
               }
               return const SizedBox.shrink();
             },
           )
        ],
      ),
      body: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          if (state.items.isEmpty) {
            return _buildEmptyState();
          }

          // --- LOGIKA BONUS (Hitung Diskon Transaksi) ---
          int subtotal = state.totalPrice;
          double finalDiscount = 0;
          // Jika total belanja lebih dari 100.000, diskon 10%
          if (subtotal > 100000) {
            finalDiscount = subtotal * 0.10;
          }
          int finalTotal = (subtotal - finalDiscount).toInt();
          // -------------------------------------------

          return Column(
            children: [
              // List Item di Keranjang
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.items.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = state.items[index];
                    return _buildCartItem(context, item);
                  },
                ),
              ),
              
              // Bagian Bawah: Ringkasan Pembayaran
              _buildPaymentSummary(context, subtotal, finalDiscount, finalTotal),
            ],
          );
        },
      ),
    );
  }

  // Widget Tampilan Saat Kosong
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            "Keranjang Kosong",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[700]),
          ),
          const SizedBox(height: 8),
          Text("Yuk, pesan menu favoritmu!", style: TextStyle(color: Colors.grey[500])),
        ],
      ),
    );
  }

  // Widget Kartu Item di Keranjang (Custom, bukan ListTile biasa)
  Widget _buildCartItem(BuildContext context, OrderItem item) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))
        ]
      ),
      child: Row(
        children: [
          // Ikon Menu Kecil
          Container(
            width: 50, height: 50,
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.fastfood_rounded, color: Colors.blueAccent[700], size: 24),
          ),
          const SizedBox(width: 12),
          // Nama dan Harga Satuan
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.menu.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 4),
                Text("Rp ${item.menu.getDiscountedPrice()}", style: TextStyle(color: Colors.grey[600], fontSize: 13)),
              ],
            ),
          ),
          // Kontrol Kuantitas (+ / -) yang rapi
          Row(
            children: [
              _buildQtyButton(
                icon: Icons.remove,
                onTap: () => context.read<OrderCubit>().updateQuantity(item.menu, item.quantity - 1),
                color: Colors.redAccent[100]!,
                iconColor: Colors.redAccent[700]!
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text("${item.quantity}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              _buildQtyButton(
                icon: Icons.add,
                onTap: () => context.read<OrderCubit>().updateQuantity(item.menu, item.quantity + 1),
                color: Colors.blueAccent[100]!,
                iconColor: Colors.blueAccent[700]!
              ),
            ],
          )
        ],
      ),
    );
  }

  // Tombol kecil untuk + dan -
  Widget _buildQtyButton({required IconData icon, required VoidCallback onTap, required Color color, required Color iconColor}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: iconColor),
      ),
    );
  }

  // Bagian Ringkasan Pembayaran di Bawah
  Widget _buildPaymentSummary(BuildContext context, int subtotal, double finalDiscount, int finalTotal) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))
        ]
      ),
      child: Column(
        children: [
          _buildSummaryRow("Subtotal", "Rp $subtotal"),
          if (finalDiscount > 0) ...[
            const SizedBox(height: 10),
            _buildSummaryRow("Diskon Transaksi (10%)", "- Rp ${finalDiscount.toInt()}", isDiscount: true),
          ],
          const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider()),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("TOTAL BAYAR", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text("Rp $finalTotal", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent[700])),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 5,
                shadowColor: Colors.blueAccent.withOpacity(0.4)
              ),
              onPressed: () {
                 context.read<OrderCubit>().clearOrder();
                 Navigator.pop(context);
                 _showSuccessDialog(context);
              },
              child: const Text("BAYAR SEKARANG", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 15)),
        Text(value, style: TextStyle(
          fontWeight: isDiscount ? FontWeight.bold : FontWeight.normal,
          color: isDiscount ? Colors.green : Colors.black87,
          fontSize: 15
        )),
      ],
    );
  }
  
  void _showClearConfirmation(BuildContext context) {
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: const Text("Hapus Keranjang?"),
      content: const Text("Semua item akan dihapus dari pesananmu."),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Batal", style: TextStyle(color: Colors.grey))),
        TextButton(onPressed: () {
          context.read<OrderCubit>().clearOrder();
          Navigator.pop(ctx);
        }, child: const Text("Hapus", style: TextStyle(color: Colors.red))),
      ],
    ));
  }

  void _showSuccessDialog(BuildContext context) {
     showDialog(
       context: context,
       barrierDismissible: false,
       builder: (ctx) => Dialog(
         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
         child: Padding(
           padding: const EdgeInsets.all(24.0),
           child: Column(
             mainAxisSize: MainAxisSize.min,
             children: [
               Container(
                 padding: const EdgeInsets.all(16),
                 decoration: BoxDecoration(color: Colors.green[50], shape: BoxShape.circle),
                 child: Icon(Icons.check_rounded, color: Colors.green[600], size: 40)
               ),
               const SizedBox(height: 16),
               const Text("Pembayaran Berhasil!", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
               const SizedBox(height: 8),
               Text("Terima kasih telah memesan.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[600])),
               const SizedBox(height: 24),
               SizedBox(
                 width: double.infinity,
                 child: ElevatedButton(
                   style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                   onPressed: () => Navigator.pop(ctx), 
                   child: const Text("Tutup", style: TextStyle(color: Colors.white))
                 ),
               )
             ],
           ),
         ),
       )
     );
  }
}