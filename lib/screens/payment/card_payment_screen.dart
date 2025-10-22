import 'package:flutter/material.dart';
import 'package:ihc_app/services/cart_manager.dart';
import 'package:ihc_app/widgets/custom_header.dart';
import 'package:ihc_app/widgets/circle_back_button.dart';
import '../delivery_tracking_screen.dart';

class CardPaymentScreen extends StatefulWidget {
  final double totalAmount;
  final List<CartItem> cartItems;

  const CardPaymentScreen({
    super.key,
    required this.totalAmount,
    required this.cartItems,
  });

  @override
  State<CardPaymentScreen> createState() => _CardPaymentScreenState();
}

class _CardPaymentScreenState extends State<CardPaymentScreen> {
  Widget _buildCardChip(String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 13,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
  final Color primaryColor = const Color(0xFFFF6B35); // Naranja principal
  bool isProcessing = false;
  
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _nameController = TextEditingController();
  bool _termsAccepted = false;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _processPayment() async {
    if (_formKey.currentState!.validate()) {
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
            paymentMethod: 'Tarjeta',
          ),
        ),
      );
    }
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
                      'Pago con Tarjeta',
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildOrderSummary(),
                    const SizedBox(height: 24),
                    _buildCardForm(),
                  ],
                ),
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

  Widget _buildCardForm() {
    return Container(
      padding: const EdgeInsets.all(20),
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
          // Chips de tarjetas
          Row(
            children: [
              _buildCardChip('VISA', Colors.blue, Colors.white),
              const SizedBox(width: 8),
              _buildCardChip('MC', Colors.red, Colors.white),
              const SizedBox(width: 8),
              _buildCardChip('AMEX', Colors.lightBlue.shade700, Colors.white),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Pago con Tarjeta',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Ingresa los datos de tu tarjeta para completar el pago',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 20),
          _buildTextField(
            'Número de tarjeta',
            '1234 5678 9012 3456',
            _cardNumberController,
            icon: Icons.credit_card,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ingrese el número de tarjeta';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  'Fecha de expiración',
                  'MM/AA',
                  _expiryController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Fecha requerida';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  'CVV',
                  '123',
                  _cvvController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'CVV requerido';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTextField(
            'Nombre del titular',
            'Juan Pérez',
            _nameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ingrese el nombre del titular';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Checkbox(
                value: _termsAccepted,
                onChanged: (value) {
                  setState(() {
                    _termsAccepted = value ?? false;
                  });
                },
                activeColor: primaryColor,
              ),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 13, color: Colors.black87),
                    children: [
                      const TextSpan(text: 'Acepto la '),
                      TextSpan(
                        text: 'política de privacidad',
                        style: const TextStyle(color: Colors.red, decoration: TextDecoration.underline),
                        // on enter, you could add gesture recognizer
                      ),
                      const TextSpan(text: ' y '),
                      TextSpan(
                        text: 'términos del servicio',
                        style: const TextStyle(color: Colors.red, decoration: TextDecoration.underline),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String hintText,
    TextEditingController controller, {
    String? Function(String?)? validator,
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: primaryColor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentButton() {
    // Calcular el total correcto basándose en los items del carrito
    final subtotal = widget.cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
    final deliveryFee = 5.0;
    final calculatedTotal = subtotal + deliveryFee;
    
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
          onPressed: isProcessing || !_termsAccepted ? null : _processPayment,
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
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
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.lock, color: Colors.white, size: 22),
                    const SizedBox(width: 8),
                    Text(
                      'Pagar Bs ${calculatedTotal.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}