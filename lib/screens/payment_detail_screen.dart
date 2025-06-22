import 'package:flutter/material.dart';
import 'package:macram/providers/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:macram/screens/payment_screen.dart';

class PaymentDetailScreen extends StatefulWidget {
  const PaymentDetailScreen({Key? key}) : super(key: key);

  @override
  State<PaymentDetailScreen> createState() => _PaymentDetailScreenState();
}

class _PaymentDetailScreenState extends State<PaymentDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  String? selectedPaymentMethod;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final List<Map<String, dynamic>> paymentMethods = [
    {
      'name': 'BCA',
      'logo': 'assets/images/iconBCA.png', // Ganti dengan URL logo BCA
      'type': 'bank',
    },
    {'name': 'BRI', 'logo': 'assets/images/iconBRI.png', 'type': 'bank'},
    {'name': 'BNI', 'logo': 'assets/images/iconBNI.png', 'type': 'bank'},
    {
      'name': 'Mandiri',
      'logo': 'assets/images/iconMandiri.png',
      'type': 'bank',
    },
    {
      'name': 'E-Wallet',
      'logo': 'assets/images/iconDANA.png',
      'type': 'ewallet',
    },
    {
      'name': 'COD',
      'logo': 'https://cdn-icons-png.flaticon.com/512/1554/1554401.png',
      'type': 'cod',
    },
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Pembayaran')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Data Penerima',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: 'Alamat',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Alamat tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Nomor Telepon',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nomor telepon tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                const Text(
                  'Metode Pembayaran',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ...paymentMethods.map(
                  (method) => RadioListTile(
                    title: Row(
                      children: [
                        method['logo'].toString().startsWith('http')
                            ? Image.network(method['logo'], height: 30)
                            : Image.asset(method['logo'], height: 30),

                        const SizedBox(width: 8),
                        Text(method['name']),
                      ],
                    ),
                    value: method['name'],
                    groupValue: selectedPaymentMethod,
                    onChanged: (value) {
                      setState(() {
                        selectedPaymentMethod = value as String;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Pembayaran',
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
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: selectedPaymentMethod == null
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              final cartItems = List.from(
                                cart.items,
                              ); // Ambil cart items
                              final total = cart.total;
                              cart.clearCart();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PaymentScreen(
                                    name: _nameController.text,
                                    address: _addressController.text,
                                    phone: _phoneController.text,
                                    paymentMethod: selectedPaymentMethod!,
                                    total: total,
                                    cartItems: cartItems, // Kirim cart items
                                  ),
                                ),
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Lanjutkan Pembayaran',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
