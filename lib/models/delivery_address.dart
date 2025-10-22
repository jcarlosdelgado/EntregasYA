class DeliveryAddress {
  final String id;
  final String label; // e.g., "Casa", "Trabajo", "Oficina"
  final String fullAddress; // Dirección completa
  final String city; // Ciudad
  final String zone; // Zona o barrio
  final String? reference; // Referencias adicionales
  final bool isDefault; // Si es la dirección por defecto
  final double? latitude; // Para futuras mejoras con mapas
  final double? longitude; // Para futuras mejoras con mapas

  DeliveryAddress({
    required this.id,
    required this.label,
    required this.fullAddress,
    required this.city,
    required this.zone,
    this.reference,
    this.isDefault = false,
    this.latitude,
    this.longitude,
  });

  // Crear una copia con cambios específicos
  DeliveryAddress copyWith({
    String? id,
    String? label,
    String? fullAddress,
    String? city,
    String? zone,
    String? reference,
    bool? isDefault,
    double? latitude,
    double? longitude,
  }) {
    return DeliveryAddress(
      id: id ?? this.id,
      label: label ?? this.label,
      fullAddress: fullAddress ?? this.fullAddress,
      city: city ?? this.city,
      zone: zone ?? this.zone,
      reference: reference ?? this.reference,
      isDefault: isDefault ?? this.isDefault,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  // Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'fullAddress': fullAddress,
      'city': city,
      'zone': zone,
      'reference': reference,
      'isDefault': isDefault,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  // Crear desde JSON
  factory DeliveryAddress.fromJson(Map<String, dynamic> json) {
    return DeliveryAddress(
      id: json['id'],
      label: json['label'],
      fullAddress: json['fullAddress'],
      city: json['city'],
      zone: json['zone'],
      reference: json['reference'],
      isDefault: json['isDefault'] ?? false,
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
    );
  }

  // Obtener dirección formateada para mostrar
  String get formattedAddress {
    String formatted = fullAddress;
    if (zone.isNotEmpty) {
      formatted += ', $zone';
    }
    if (city.isNotEmpty) {
      formatted += ', $city';
    }
    return formatted;
  }

  @override
  String toString() {
    return 'DeliveryAddress{id: $id, label: $label, formattedAddress: $formattedAddress}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeliveryAddress &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}