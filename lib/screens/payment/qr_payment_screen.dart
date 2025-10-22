import 'package:flutter/material.dart';
import 'package:ihc_app/services/cart_manager.dart';
import 'package:ihc_app/widgets/custom_header.dart';
import 'package:ihc_app/widgets/circle_back_button.dart';
import '../delivery_tracking_screen.dart';

class QRPaymentScreen extends StatefulWidget {
  final double totalAmount;
  final List<CartItem> cartItems;

  const QRPaymentScreen({
    super.key,
    required this.totalAmount,
    required this.cartItems,
  });

  @override
  State<QRPaymentScreen> createState() => _QRPaymentScreenState();
}

class _QRPaymentScreenState extends State<QRPaymentScreen> {
  final Color primaryColor = const Color(0xFFFF6B35); // Naranja principal
  bool isProcessing = false;
  bool _termsAccepted = false;

  Future<void> _processPayment() async {
    setState(() => isProcessing = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => isProcessing = false);

    // Calcular el total correcto basándose en los items del carrito
    final subtotal = widget.cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
    final deliveryFee = 5.0;
    final calculatedTotal = subtotal + deliveryFee;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DeliveryTrackingScreen(
          totalAmount: calculatedTotal,
          orderNumber:
              'ORD-${(DateTime.now().millisecondsSinceEpoch % 10000).toString().padLeft(4, '0')}',
          cartItems: widget.cartItems,
          paymentMethod: 'QR',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomHeader(
            title: 'Te lo llevo',
            showCartButton: false,
            showSearchBar: false,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                CircleBackButton(
                  onTap: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Center(
                    child: Text(
                      'Pago con QR',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOrderSummary(),
                  const SizedBox(height: 24),
                  _buildQRForm(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          _buildPaymentButton(),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    // Calcular el subtotal basándose en los items del carrito pasados como parámetro
    final subtotal = widget.cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
    final deliveryFee = 5.0; // Costo fijo de envío
    final calculatedTotal = subtotal + deliveryFee;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resumen de tu pedido',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.cartItems.length} productos',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
              Text(
                'Bs ${subtotal.toStringAsFixed(2)}',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Costo de envío',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
              Text(
                'Bs ${deliveryFee.toStringAsFixed(2)}',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Divider(color: Colors.grey.shade300, height: 1),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                'Bs ${calculatedTotal.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQRForm() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Pago con QR',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            'Escanea este código con tu app bancaria\npara completar la compra',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 18),
          Center(
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.08),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ClipRRect(
                  
                  child: Image.network(
                    'https://docs.lightburnsoftware.com/legacy/img/QRCode/ExampleCode.png',
                    width: 120,
                    height: 120,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.qr_code, size: 80, color: Colors.grey),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Tu pedido se validará automáticamente cuando el pago sea recibido',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.black45),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
            decoration: BoxDecoration(
              color: Color(0xFFFFE5DE),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Esperando pago...',
              style: TextStyle(color: Color(0xFFFF6B35), fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
  

  
  Widget _buildPaymentButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isProcessing ? null : _processPayment,
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            disabledBackgroundColor: Colors.grey.shade300,
          ),
          child: isProcessing
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text(
                  'Confirmar pago',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }
}