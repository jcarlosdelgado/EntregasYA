import 'package:flutter/material.dart';
import 'package:ihc_app/services/cart_manager.dart';
import 'package:ihc_app/services/address_manager.dart';
import 'package:ihc_app/models/delivery_address.dart';
import 'package:ihc_app/widgets/custom_header.dart';
import 'package:ihc_app/widgets/circle_back_button.dart';
import 'card_payment_screen.dart';
import 'qr_payment_screen.dart';

class PaymentScreen extends StatefulWidget {
  final double totalAmount;
  final List<CartItem> cartItems;
  final DeliveryAddress? deliveryAddress;

  const PaymentScreen({
    super.key,
    required this.totalAmount,
    required this.cartItems,
    this.deliveryAddress,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final Color primaryColor = const Color(0xFFFF6B35); // Naranja principal
  final AddressManager _addressManager = AddressManager();
  int? selectedPaymentMethod; // null: nada seleccionado, 0: Tarjeta, 1: QR

  @override
  void initState() {
    super.initState();
    _addressManager.addListener(_onAddressChanged);
    _addressManager.initializeWithSampleData();
    
    // Si viene una dirección desde el carrito, seleccionarla
    if (widget.deliveryAddress != null) {
      _addressManager.selectAddress(widget.deliveryAddress!);
    }
  }

  @override
  void dispose() {
    _addressManager.removeListener(_onAddressChanged);
    super.dispose();
  }

  void _onAddressChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _navigateToPaymentScreen() {
    if (selectedPaymentMethod == null) return;
    
    // Validar que haya una dirección seleccionada
    if (_addressManager.selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Por favor selecciona una dirección de envío'),
          backgroundColor: Colors.red.shade600,
        ),
      );
      return;
    }

    // Calcular el total correcto basándose en los items del carrito
    final subtotal = widget.cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
    final deliveryFee = 5.0;
    final calculatedTotal = subtotal + deliveryFee;

    if (selectedPaymentMethod == 0) {
      // Navegar a pago con tarjeta
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CardPaymentScreen(
            totalAmount: calculatedTotal,
            cartItems: widget.cartItems,
          ),
        ),
      );
    } else {
      // Navegar a pago con QR
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QRPaymentScreen(
            totalAmount: calculatedTotal,
            cartItems: widget.cartItems,
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
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Row(
              children: [
                CircleBackButton(
                  onTap: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Center(
                    child: Text(
                      'Método de Pago',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 48), // Para balancear el espacio del botón
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDeliveryAddressSection(),
                  const SizedBox(height: 15),
                  _buildOrderSummary(),
                  const SizedBox(height: 15),
                  Text(
                    'Selecciona tu método de pago',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildPaymentMethods(),
                ],
              ),
            ),
          ),
          // Botón fijo en la parte inferior
          if (selectedPaymentMethod != null && _addressManager.selectedAddress != null)
            Container(
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
                  onPressed: _navigateToPaymentScreen,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'CONTINUAR CON EL PAGO',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
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

  Widget _buildDeliveryAddressSection() {
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
          Row(
            children: [
              Icon(Icons.location_on, color: primaryColor),
              const SizedBox(width: 8),
              const Text(
                'Dirección de Envío',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_addressManager.selectedAddress != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: primaryColor.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _addressManager.selectedAddress!.label,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _addressManager.selectedAddress!.formattedAddress,
                          style: const TextStyle(fontSize: 14),
                        ),
                        if (_addressManager.selectedAddress!.reference != null &&
                            _addressManager.selectedAddress!.reference!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Ref: ${_addressManager.selectedAddress!.reference}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => _showAddressSelectionDialog(),
                    icon: const Icon(Icons.edit),
                    color: primaryColor,
                  ),
                ],
              ),
            ),
          ] else ...[
            GestureDetector(
              onTap: () => _showAddressSelectionDialog(),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.add_location, color: Colors.grey.shade600),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Seleccionar dirección de envío',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, 
                         size: 16, 
                         color: Colors.grey.shade600),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showAddressSelectionDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Seleccionar Dirección',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/address_management');
                    },
                    child: const Text('Gestionar'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _addressManager.addresses.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 60,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No tienes direcciones guardadas',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, '/address_management');
                            },
                            icon: const Icon(Icons.add_location),
                            label: const Text('Agregar Dirección'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _addressManager.addresses.length,
                      itemBuilder: (context, index) {
                        final address = _addressManager.addresses[index];
                        final isSelected = _addressManager.selectedAddress?.id == address.id;
                        
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected ? primaryColor : Colors.grey.shade300,
                              width: isSelected ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            color: isSelected ? primaryColor.withOpacity(0.1) : Colors.white,
                          ),
                          child: ListTile(
                            leading: Icon(
                              Icons.location_on,
                              color: isSelected ? primaryColor : Colors.grey.shade600,
                            ),
                            title: Text(
                              address.label,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: isSelected ? primaryColor : Colors.black,
                              ),
                            ),
                            subtitle: Text(address.formattedAddress),
                            trailing: isSelected 
                                ? Icon(Icons.check_circle, color: primaryColor)
                                : null,
                            onTap: () {
                              _addressManager.selectAddress(address);
                              Navigator.pop(context);
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethods() {
    return Column(
      children: [
        _buildPaymentOption(
          index: 0,
          title: 'Tarjeta de Crédito/Débito',
          subtitle: 'Visa, Mastercard, American Express',
          icon: Icons.credit_card,
        ),
        const SizedBox(height: 12),
        _buildPaymentOption(
          index: 1,
          title: 'Código QR',
          subtitle: 'Pago rápido con código QR',
          icon: Icons.qr_code,
        ),
      ],
    );
  }

  Widget _buildPaymentOption({
    required int index,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = selectedPaymentMethod == index;
    return GestureDetector(
      onTap: () => setState(() => selectedPaymentMethod = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? primaryColor : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey.shade600,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? primaryColor : Colors.black,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: primaryColor, size: 24),
          ],
        ),
      ),
    );
  }
}