import 'package:flutter/material.dart';
import 'package:macram/providers/cart_provider.dart';
import 'package:macram/widgets/cart_item_card.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String? selectedBank;

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang'),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.items.isEmpty) {
            return const Center(
              child: Text('Keranjang belanja kosong'),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    return CartItemCard(item: cart.items[index]);
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          formatter.format(cart.total),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Metode Pembayaran',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Column(
                      children: [
                        RadioListTile(
                          title: Image.network(
                            'https://logos-download.com/wp-content/uploads/2016/06/Bank_BCA_logo.png',
                            height: 30,
                          ),
                          value: 'bca',
                          groupValue: selectedBank,
                          onChanged: (value) {
                            setState(() {
                              selectedBank = value as String;
                            });
                          },
                        ),
                        RadioListTile(
                          title: Image.network(
                            'https://upload.wikimedia.org/wikipedia/commons/thumb/6/68/BANK_BRI_logo.svg/2560px-BANK_BRI_logo.svg.png',
                            height: 30,
                          ),
                          value: 'bri',
                          groupValue: selectedBank,
                          onChanged: (value) {
                            setState(() {
                              selectedBank = value as String;
                            });
                          },
                        ),
                        RadioListTile(
                          title: Image.network(
                            'https://upload.wikimedia.org/wikipedia/id/thumb/5/55/BNI_logo.svg/2560px-BNI_logo.svg.png',
                            height: 30,
                          ),
                          value: 'bni',
                          groupValue: selectedBank,
                          onChanged: (value) {
                            setState(() {
                              selectedBank = value as String;
                            });
                          },
                        ),
                        RadioListTile(
                          title: Image.network(
                            'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ad/Bank_Mandiri_logo_2016.svg/2560px-Bank_Mandiri_logo_2016.svg.png',
                            height: 30,
                          ),
                          value: 'mandiri',
                          groupValue: selectedBank,
                          onChanged: (value) {
                            setState(() {
                              selectedBank = value as String;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: selectedBank == null ? null : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Pesanan berhasil! Silakan lakukan pembayaran.'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Bayar Sekarang',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              )),
            ],
          );
        },
      ),
    );
  }
}