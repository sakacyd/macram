import 'package:macram/models/product.dart';

class CartItem {
  final Product product;
  int quantity;
  final String flavor;

  CartItem({
    required this.product,
    this.quantity = 1,
    required this.flavor,
  });

  double get total => product.price * quantity;

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
      flavor: json['flavor'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
      'flavor': flavor,
    };
  }
}