import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Configuración para Android (más simple para evitar conflictos)
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Configuración para iOS
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Solicitar solo permisos básicos de notificación (Android 15 compatible)
    await _requestBasicNotificationPermissions();
  }

  Future<void> _requestBasicNotificationPermissions() async {
    try {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();

      // Solo solicitar permisos básicos de notificación
      // Compatible con Android 15 - sin alarmas exactas
      if (androidImplementation != null) {
        final bool? granted =
            await androidImplementation.requestNotificationsPermission();
        debugPrint(
          '📱 Permisos de notificación: ${granted == true ? "✅ Concedido" : "❌ Denegado"}',
        );

        // Si los permisos son denegados, mostrar un mensaje informativo
        if (granted != true) {
          debugPrint(
            '⚠️ Las notificaciones están deshabilitadas. Puedes activarlas en Configuración.',
          );
        }
      }
    } catch (e) {
      debugPrint('🔴 Error al solicitar permisos de notificación: $e');
      // La app continuará funcionando sin notificaciones si hay error
    }
  }

  void _onNotificationTap(NotificationResponse notificationResponse) {
    // Aquí puedes manejar lo que pasa cuando el usuario toca la notificación
    debugPrint('🔔 Notificación tocada: ${notificationResponse.payload}');
  }

  // Método para verificar si las notificaciones están habilitadas
  Future<bool> _areNotificationsEnabled() async {
    try {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();

      if (androidImplementation != null) {
        final bool? enabled =
            await androidImplementation.areNotificationsEnabled();
        return enabled ?? false;
      }
      return true; // Por defecto, asumimos que están habilitadas
    } catch (e) {
      debugPrint('🔴 Error verificando estado de notificaciones: $e');
      return false;
    }
  }

  Future<void> showOrderCompletedNotification({
    required String orderNumber,
    required double totalAmount,
  }) async {
    // Verificar si las notificaciones están habilitadas
    final bool enabled = await _areNotificationsEnabled();
    if (!enabled) {
      debugPrint(
        '🔕 Notificaciones deshabilitadas - no se mostrará la notificación de pedido completado',
      );
      return;
    }
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          'order_completed_channel',
          'Pedidos Completados',
          channelDescription: 'Notificaciones cuando se completa un pedido',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: Color(0xFFFF6B35), // Color naranja de la app
          playSound: true,
          enableVibration: true,
        );

    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      0, // ID de la notificación
      '🎉 ¡Pedido Completado!',
      'Tu pedido #$orderNumber ha sido entregado exitosamente. Total: Bs ${totalAmount.toStringAsFixed(2)}',
      notificationDetails,
      payload: 'order_completed:$orderNumber',
    );
  }

  Future<void> showDeliveryNotification({
    required String orderNumber,
    required String message,
  }) async {
    // Verificar si las notificaciones están habilitadas
    final bool enabled = await _areNotificationsEnabled();
    if (!enabled) {
      debugPrint(
        '🔕 Notificaciones deshabilitadas - no se mostrará la actualización de entrega',
      );
      return;
    }
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          'delivery_updates_channel',
          'Actualizaciones de Entrega',
          channelDescription: 'Notificaciones sobre el estado de la entrega',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: '@mipmap/ic_launcher',
          color: Color(0xFFFF6B35),
          playSound: false,
          enableVibration: true,
        );

    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: false,
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      1, // ID diferente para delivery updates
      '🚚 Actualización de Entrega',
      'Pedido #$orderNumber: $message',
      notificationDetails,
      payload: 'delivery_update:$orderNumber',
    );
  }

  // Método para cancelar todas las notificaciones
  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  // Método para cancelar una notificación específica
  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }
}
