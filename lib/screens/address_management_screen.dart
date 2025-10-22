import 'package:flutter/material.dart';
import 'package:ihc_app/models/delivery_address.dart';
import 'package:ihc_app/services/address_manager.dart';
import 'package:ihc_app/widgets/custom_header.dart';

class AddressManagementScreen extends StatefulWidget {
  const AddressManagementScreen({super.key});

  @override
  State<AddressManagementScreen> createState() => _AddressManagementScreenState();
}

class _AddressManagementScreenState extends State<AddressManagementScreen> {
  final Color primaryColor = const Color(0xFFFF6B35);
  final AddressManager _addressManager = AddressManager();

  @override
  void initState() {
    super.initState();
    _addressManager.addListener(_onAddressChanged);
    _addressManager.initializeWithSampleData();
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

  void _showAddEditAddressDialog({DeliveryAddress? address}) {
    showDialog(
      context: context,
      builder: (context) => AddEditAddressDialog(
        address: address,
        primaryColor: primaryColor,
        onSave: (newAddress) {
          if (address == null) {
            _addressManager.addAddress(newAddress);
          } else {
            _addressManager.updateAddress(address.id, newAddress);
          }
        },
      ),
    );
  }

  void _confirmDeleteAddress(DeliveryAddress address) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Dirección'),
        content: Text('¿Estás seguro de que quieres eliminar "${address.label}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              _addressManager.removeAddress(address.id);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CustomHeader(
            title: 'Mis Direcciones',
            showCartButton: false,
            showSearchBar: false,
          ),
          Expanded(
            child: _addressManager.addresses.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 80,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No tienes direcciones guardadas',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () => _showAddEditAddressDialog(),
                          icon: const Icon(Icons.add_location),
                          label: const Text('Agregar Primera Dirección'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _addressManager.addresses.length,
                    itemBuilder: (context, index) {
                      final address = _addressManager.addresses[index];
                      return AddressCard(
                        address: address,
                        primaryColor: primaryColor,
                        onEdit: () => _showAddEditAddressDialog(address: address),
                        onDelete: () => _confirmDeleteAddress(address),
                        onSetDefault: () => _addressManager.setAsDefault(address.id),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: _addressManager.addresses.isNotEmpty
          ? FloatingActionButton(
              onPressed: () => _showAddEditAddressDialog(),
              backgroundColor: primaryColor,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }
}

class AddressCard extends StatelessWidget {
  final DeliveryAddress address;
  final Color primaryColor;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSetDefault;

  const AddressCard({
    super.key,
    required this.address,
    required this.primaryColor,
    required this.onEdit,
    required this.onDelete,
    required this.onSetDefault,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: address.isDefault ? primaryColor : Colors.grey.shade200,
          width: address.isDefault ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: address.isDefault 
                        ? primaryColor 
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    address.label,
                    style: TextStyle(
                      color: address.isDefault ? Colors.white : Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
                if (address.isDefault) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Por defecto',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                PopupMenuButton(
                  icon: Icon(Icons.more_vert, color: Colors.grey.shade600),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: const Row(
                        children: [
                          Icon(Icons.edit, size: 18),
                          SizedBox(width: 8),
                          Text('Editar'),
                        ],
                      ),
                    ),
                    if (!address.isDefault)
                      PopupMenuItem(
                        value: 'default',
                        child: const Row(
                          children: [
                            Icon(Icons.star, size: 18),
                            SizedBox(width: 8),
                            Text('Marcar por defecto'),
                          ],
                        ),
                      ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 18, color: Colors.red.shade600),
                          const SizedBox(width: 8),
                          Text('Eliminar', style: TextStyle(color: Colors.red.shade600)),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        onEdit();
                        break;
                      case 'default':
                        onSetDefault();
                        break;
                      case 'delete':
                        onDelete();
                        break;
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              address.formattedAddress,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (address.reference != null && address.reference!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Referencia: ${address.reference}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class AddEditAddressDialog extends StatefulWidget {
  final DeliveryAddress? address;
  final Color primaryColor;
  final Function(DeliveryAddress) onSave;

  const AddEditAddressDialog({
    super.key,
    this.address,
    required this.primaryColor,
    required this.onSave,
  });

  @override
  State<AddEditAddressDialog> createState() => _AddEditAddressDialogState();
}

class _AddEditAddressDialogState extends State<AddEditAddressDialog> {
  final _formKey = GlobalKey<FormState>();
  final _labelController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _zoneController = TextEditingController();
  final _referenceController = TextEditingController();
  bool _isDefault = false;

  @override
  void initState() {
    super.initState();
    if (widget.address != null) {
      _labelController.text = widget.address!.label;
      _addressController.text = widget.address!.fullAddress;
      _cityController.text = widget.address!.city;
      _zoneController.text = widget.address!.zone;
      _referenceController.text = widget.address!.reference ?? '';
      _isDefault = widget.address!.isDefault;
    } else {
      _cityController.text = 'La Paz'; // Ciudad por defecto
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.address == null ? 'Agregar Dirección' : 'Editar Dirección',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Flexible(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _labelController,
                        decoration: const InputDecoration(
                          labelText: 'Etiqueta *',
                          hintText: 'Ej: Casa, Trabajo, Oficina',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Este campo es obligatorio';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _addressController,
                        decoration: const InputDecoration(
                          labelText: 'Dirección *',
                          hintText: 'Ej: Av. Simón López #1234',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Este campo es obligatorio';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _zoneController,
                              decoration: const InputDecoration(
                                labelText: 'Zona *',
                                hintText: 'Ej: Sopocachi',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Este campo es obligatorio';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _cityController,
                              decoration: const InputDecoration(
                                labelText: 'Ciudad *',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Este campo es obligatorio';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _referenceController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'Referencia (opcional)',
                          hintText: 'Ej: Edificio azul, cerca del parque',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      CheckboxListTile(
                        title: const Text('Usar como dirección por defecto'),
                        value: _isDefault,
                        onChanged: (value) {
                          setState(() {
                            _isDefault = value ?? false;
                          });
                        },
                        activeColor: widget.primaryColor,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: _saveAddress,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(widget.address == null ? 'Agregar' : 'Guardar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _saveAddress() {
    if (_formKey.currentState!.validate()) {
      final addressManager = AddressManager();
      final newAddress = addressManager.createNewAddress(
        label: _labelController.text.trim(),
        fullAddress: _addressController.text.trim(),
        city: _cityController.text.trim(),
        zone: _zoneController.text.trim(),
        reference: _referenceController.text.trim().isEmpty 
            ? null 
            : _referenceController.text.trim(),
        isDefault: _isDefault,
      );

      // Si estamos editando, usar el ID existente
      final finalAddress = widget.address != null
          ? newAddress.copyWith(id: widget.address!.id)
          : newAddress;

      widget.onSave(finalAddress);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _labelController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _zoneController.dispose();
    _referenceController.dispose();
    super.dispose();
  }
}