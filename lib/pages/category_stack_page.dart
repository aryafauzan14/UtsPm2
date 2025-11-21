import 'package:flutter/material.dart';

class CategoryStackPage extends StatelessWidget {
  final Function(String) onCategorySelected;

  const CategoryStackPage({super.key, required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180, 
      child: ListView(
        // Membuat efek scroll membal (bouncy) yang enak dirasakan
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        scrollDirection: Axis.horizontal,
        children: [
          _buildStackCategory(context, "Makanan", Colors.orange, Icons.lunch_dining, "Makanan"),
          _buildStackCategory(context, "Minuman", Colors.blue, Icons.local_cafe, "Minuman"),
          _buildStackCategory(context, "Snack", Colors.green, Icons.cookie, "Snack"),
        ],
      ),
    );
  }

  Widget _buildStackCategory(BuildContext context, String title, Color color, IconData icon, String categoryKey) {
    return GestureDetector(
      onTap: () => onCategorySelected(categoryKey),
      child: Container(
        width: 140,
        margin: const EdgeInsets.all(8),
        child: Stack(
          children: [
            // Layer 1: Background dengan Gradient & Shadow
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color.withOpacity(0.9),
                    color.withOpacity(0.6),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ]
              ),
            ),
            // Layer 2: Icon Besar Transparan (Dekorasi di pojok kanan bawah)
            Positioned(
              right: -10,
              bottom: -10,
              child: Icon(
                icon,
                size: 80,
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            // Layer 3: Konten Utama (Icon Kecil & Judul)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Icon bulat kecil di atas
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle
                    ),
                    child: Icon(icon, color: Colors.white, size: 24),
                  ),
                  // Teks Judul Kategori
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}