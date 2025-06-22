import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:macram/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:macram/providers/cart_provider.dart';
import 'package:macram/config/supabase_config.dart';

class PaymentScreen extends StatefulWidget {
  final String name;
  final String address;
  final String phone;
  final String paymentMethod;
  final double total;

  const PaymentScreen({
    Key? key,
    required this.name,
    required this.address,
    required this.phone,
    required this.paymentMethod,
    required this.total,
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? virtualAccount;

  Future<void> _saveOrderToSupabase() async {
    try {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      final items = cartProvider.items.map((item) => {
        'product_name': item.product.name,
        'quantity': item.quantity,
        'flavor': item.flavor,
        'price': item.product.price,
      }).toList();

      await SupabaseConfig.client.from('orders').insert({
        'customer_name': widget.name,
        'address': widget.address,
        'phone': widget.phone,
        'items': items,
        'total_amount': widget.total,
        'payment_method': widget.paymentMethod,
        'status': 'pending',
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}'))
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _saveOrderToSupabase();
    
    if (widget.paymentMethod != 'COD') {
      virtualAccount = '${widget.paymentMethod}${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
      Future.delayed(const Duration(seconds: 10), () {
        if (mounted) {
          _showSuccessAndNavigateHome();
        }
      });
    } else {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _showSuccessAndNavigateHome();
        }
      });
    }
  }

  void _showSuccessAndNavigateHome() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (route) => false,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pemesanan sukses!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

    if (widget.paymentMethod == 'COD') {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Total Pembayaran',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              formatter.format(widget.total),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Virtual Account',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    virtualAccount ?? '',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: virtualAccount ?? ''));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Nomor VA berhasil disalin'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Halaman akan otomatis kembali ke beranda dalam 10 detik...',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}