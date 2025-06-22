import 'package:macram/config/supabase_config.dart';
import 'package:macram/models/product.dart';

class ProductService {
  static Future<List<Product>> getProducts() async {
    try {
      final response = await SupabaseConfig.client
          .from('products')
          .select()
          .order('id')
          .then((value) => value);

      if (response == null) return [];

      return (response as List)
          .map((json) => Product.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }

  static Future<List<Product>> getProductsByCategory(String category) async {
    try {
      final response = await SupabaseConfig.client
          .from('products')
          .select()
          .eq('category', category)
          .order('id')
          .then((value) => value);

      if (response == null) return [];

      return (response as List)
          .map((json) => Product.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching products by category: $e');
      return [];
    }
  }
}