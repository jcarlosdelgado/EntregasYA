import 'package:flutter/material.dart';
import 'package:ihc_app/models/delivery_address.dart';

// Servicio para manejar las direcciones de envío
class AddressManager extends ChangeNotifier {
  static final AddressManager _instance = AddressManager._internal();
  factory AddressManager() => _instance;
  AddressManager._internal();

  final List<DeliveryAddress> _addresses = [];
  DeliveryAddress? _selectedAddress;

  // Getters
  List<DeliveryAddress> get addresses => List.unmodifiable(_addresses);
  DeliveryAddress? get selectedAddress => _selectedAddress;
  bool get hasAddresses => _addresses.isNotEmpty;
  
  // Obtener dirección por defecto
  DeliveryAddress? get defaultAddress {
    try {
      return _addresses.firstWhere((address) => address.isDefault);
    } catch (e) {
      return _addresses.isNotEmpty ? _addresses.first : null;
    }
  }

  // Inicializar con direcciones de ejemplo
  void initializeWithSampleData() {
    if (_addresses.isEmpty) {
      _addresses.addAll([
        DeliveryAddress(
          id: '1',
          label: 'Casa',
          fullAddress: 'Av. Simón López #1234',
          city: 'La Paz',
          zone: 'Sopocachi',
          reference: 'Edificio azul, cerca del parque',
          isDefault: true,
        ),
        DeliveryAddress(
          id: '2',
          label: 'Trabajo',
          fullAddress: 'Calle Comercio #567',
          city: 'La Paz',
          zone: 'Centro',
          reference: 'Edificio Torre Central, piso 3',
          isDefault: false,
        ),
      ]);
      _selectedAddress = defaultAddress;
      notifyListeners();
    }
  }

  // Agregar nueva dirección
  void addAddress(DeliveryAddress address) {
    // Si es la primera dirección o se marca como por defecto
    bool shouldBeDefault = _addresses.isEmpty || address.isDefault;
    
    if (shouldBeDefault) {
      // Quitar el default de las demás direcciones
      for (int i = 0; i < _addresses.length; i++) {
        if (_addresses[i].isDefault) {
          _addresses[i] = _addresses[i].copyWith(isDefault: false);
        }
      }
    }

    final newAddress = shouldBeDefault 
        ? address.copyWith(isDefault: true) 
        : address;
    
    _addresses.add(newAddress);

    // Si es la primera dirección, seleccionarla automáticamente
    if (_selectedAddress == null || shouldBeDefault) {
      _selectedAddress = newAddress;
    }

    notifyListeners();
  }

  // Actualizar dirección existente
  void updateAddress(String id, DeliveryAddress updatedAddress) {
    final index = _addresses.indexWhere((address) => address.id == id);
    if (index != -1) {
      // Si se marca como por defecto, quitar el default de las demás
      if (updatedAddress.isDefault) {
        for (int i = 0; i < _addresses.length; i++) {
          if (i != index && _addresses[i].isDefault) {
            _addresses[i] = _addresses[i].copyWith(isDefault: false);
          }
        }
      }
      
      _addresses[index] = updatedAddress;
      
      // Si la dirección seleccionada fue actualizada, actualizarla
      if (_selectedAddress?.id == id) {
        _selectedAddress = updatedAddress;
      }
      
      notifyListeners();
    }
  }

  // Eliminar dirección
  void removeAddress(String id) {
    final index = _addresses.indexWhere((address) => address.id == id);
    if (index != -1) {
      final removedAddress = _addresses[index];
      _addresses.removeAt(index);
      
      // Si se eliminó la dirección seleccionada, seleccionar otra
      if (_selectedAddress?.id == id) {
        _selectedAddress = defaultAddress;
      }
      
      // Si se eliminó la dirección por defecto, hacer la primera como por defecto
      if (removedAddress.isDefault && _addresses.isNotEmpty) {
        _addresses[0] = _addresses[0].copyWith(isDefault: true);
        if (_selectedAddress == null) {
          _selectedAddress = _addresses[0];
        }
      }
      
      notifyListeners();
    }
  }

  // Seleccionar dirección para el envío
  void selectAddress(DeliveryAddress address) {
    if (_addresses.contains(address)) {
      _selectedAddress = address;
      notifyListeners();
    }
  }

  // Seleccionar dirección por ID
  void selectAddressById(String id) {
    final address = _addresses.where((addr) => addr.id == id).firstOrNull;
    if (address != null) {
      selectAddress(address);
    }
  }

  // Establecer dirección por defecto
  void setAsDefault(String id) {
    // Quitar el default de todas las direcciones
    for (int i = 0; i < _addresses.length; i++) {
      _addresses[i] = _addresses[i].copyWith(isDefault: false);
    }
    
    // Establecer la nueva dirección por defecto
    final index = _addresses.indexWhere((address) => address.id == id);
    if (index != -1) {
      _addresses[index] = _addresses[index].copyWith(isDefault: true);
      _selectedAddress = _addresses[index];
      notifyListeners();
    }
  }

  // Obtener dirección por ID
  DeliveryAddress? getAddressById(String id) {
    try {
      return _addresses.firstWhere((address) => address.id == id);
    } catch (e) {
      return null;
    }
  }

  // Limpiar todas las direcciones (para testing)
  void clearAll() {
    _addresses.clear();
    _selectedAddress = null;
    notifyListeners();
  }

  // Generar ID único simple
  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  // Crear nueva dirección con ID generado
  DeliveryAddress createNewAddress({
    required String label,
    required String fullAddress,
    required String city,
    required String zone,
    String? reference,
    bool isDefault = false,
  }) {
    return DeliveryAddress(
      id: _generateId(),
      label: label,
      fullAddress: fullAddress,
      city: city,
      zone: zone,
      reference: reference,
      isDefault: isDefault,
    );
  }
}