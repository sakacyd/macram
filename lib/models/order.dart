class OrderItem {
  final String productName;
  final int quantity;
  final String flavor;
  final double price;

  OrderItem({
    required this.productName,
    required this.quantity,
    required this.flavor,
    required this.price,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productName: json['product_name'] as String,
      quantity: json['quantity'] as int,
      flavor: json['flavor'] as String,
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_name': productName,
      'quantity': quantity,
      'flavor': flavor,
      'price': price,
    };
  }
}

class Order {
  final String id;
  final String customerName;
  final String address;
  final String phone;
  final List<OrderItem> items;
  final double totalAmount;
  final String paymentMethod;
  final String status;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.customerName,
    required this.address,
    required this.phone,
    required this.items,
    required this.totalAmount,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List<dynamic>;
    return Order(
      id: json['id'] as String,
      customerName: json['customer_name'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String,
      items: itemsJson.map((item) => OrderItem.fromJson(item)).toList(),
      totalAmount: (json['total_amount'] as num).toDouble(),
      paymentMethod: json['payment_method'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_name': customerName,
      'address': address,
      'phone': phone,
      'items': items.map((item) => item.toJson()).toList(),
      'total_amount': totalAmount,
      'payment_method': paymentMethod,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
