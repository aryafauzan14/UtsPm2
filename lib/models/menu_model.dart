class MenuModel {
  final String id;
  final String name;
  final int price;
  final String category;
  final double discount; 

  MenuModel({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.discount,
  });

  int getDiscountedPrice() {
    return (price - (price * discount)).toInt();
  }
}

class OrderItem {
  final MenuModel menu;
  int quantity;

  OrderItem({required this.menu, required this.quantity});
}