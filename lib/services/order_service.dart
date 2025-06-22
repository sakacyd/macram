import 'package:macram/config/supabase_config.dart';
import 'package:macram/models/order.dart';

class OrderService {
  static Future<bool> insertOrder(Order order) async {
    try {
      final response = await SupabaseConfig.client.from('orders').insert({
        'customer_name': order.customerName,
        'address': order.address,
        'phone': order.phone,
        'items': order.items.map((item) => item.toJson()).toList(),
        'total_amount': order.totalAmount,
        'payment_method': order.paymentMethod,
        'status': order.status,
        'created_at': order.createdAt.toIso8601String(),
      });

      return response == null; // insert sukses jika tidak ada error
    } catch (e) {
      print('Error inserting order: $e');
      return false;
    }
  }
}
