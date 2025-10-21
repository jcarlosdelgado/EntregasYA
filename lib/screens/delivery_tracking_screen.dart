import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:ihc_app/screens/order_completed_screen.dart';
import 'package:ihc_app/services/cart_manager.dart';
import 'package:ihc_app/services/notification_service.dart';

class DeliveryTrackingScreen extends StatefulWidget {
  final double totalAmount;
  final String orderNumber;
  final List<CartItem> cartItems;
  final String paymentMethod;

  const DeliveryTrackingScreen({
    super.key,
    required this.totalAmount,
    required this.orderNumber,
    required this.cartItems,
    required this.paymentMethod,
  });

  @override
  State<DeliveryTrackingScreen> createState() => _DeliveryTrackingScreenState();
}

class _DeliveryTrackingScreenState extends State<DeliveryTrackingScreen>
    with TickerProviderStateMixin {
  final Color primaryColor = const Color(0xFFFF6B35); // Naranja principal

  // Estados del delivery
  int currentStep = 0;
  final List<String> deliverySteps = [
    'Pedido confirmado',
    'Preparando tu pedido en el supermercado',
    'Repartidor en camino a tu domicilio',
    'Entregado en tu domicilio',
  ];

  // Simulación del repartidor
  double deliveryProgress = 0.0;
  Timer? progressTimer;
  late AnimationController _pulseController;
  late AnimationController _moveController;

  String estimatedTime = '25-30 min';
  String driverName = 'Carlos Mendoza';
  String driverPhone = '+591 7123 4567';
  double driverRating = 4.8;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _moveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _startDeliverySimulation();
  }

  @override
  void dispose() {
    progressTimer?.cancel();
    _pulseController.dispose();
    _moveController.dispose();
    super.dispose();
  }

  void _startDeliverySimulation() {
    // Simular progreso del delivery cada 3 segundos
    progressTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        if (currentStep < deliverySteps.length - 1) {
          if (deliveryProgress >= 1.0) {
            currentStep++;
            deliveryProgress = 0.0;
            _updateEstimatedTime();
            _sendDeliveryStepNotification();
          } else {
            deliveryProgress += 0.2;
          }
        } else {
          timer.cancel();
          // Navegar a pantalla de pedido completado después de 2 segundos
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder:
                    (context) => OrderCompletedScreen(
                      orderNumber: widget.orderNumber,
                      totalAmount: widget.totalAmount,
                      cartItems: widget.cartItems,
                      paymentMethod: widget.paymentMethod,
                    ),
              ),
            );
          });
        }
      });
    });
  }

  void _updateEstimatedTime() {
    setState(() {
      switch (currentStep) {
        case 1:
          estimatedTime = '20-25 min';
          break;
        case 2:
          estimatedTime = '10-15 min';
          break;
        case 3:
          estimatedTime = 'Entregado';
          break;
      }
    });
  }

  void _sendDeliveryStepNotification() {
    if (currentStep < deliverySteps.length) {
      NotificationService().showDeliveryNotification(
        orderNumber: widget.orderNumber,
        message: deliverySteps[currentStep],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Seguimiento Pedido',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFFFF6B35), // Fondo naranja
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.white),
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Mapa simulado
            _buildMapSection(),

            // Información del pedido
            _buildOrderInfo(),

            // Estado del delivery
            _buildDeliveryStatus(),

            // Información del repartidor
            _buildDriverInfo(),

            // Botones de acción
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildMapSection() {
    return Container(
      height: 250,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Fondo del mapa simulado
            Container(
              color: Colors.green.shade50,
              child: CustomPaint(
                size: const Size(double.infinity, 250),
                painter: MapPainter(
                  progress: deliveryProgress + currentStep,
                  animation: _moveController,
                ),
              ),
            ),

            // Indicadores en el mapa
            Positioned(
              bottom: 20,
              left: 20,
              child: _buildMapIndicator(
                'Tu Domicilio',
                Colors.blue,
                Icons.home,
              ),
            ),

            Positioned(
              top: 20,
              right: 20,
              child: _buildMapIndicator(
                'SuperMercado Fresh',
                primaryColor,
                Icons.store,
              ),
            ),

            // Repartidor animado - se mueve del supermercado (top-right) al domicilio (bottom-left)
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                final screenWidth = MediaQuery.of(context).size.width;
                final progressPercent = (deliveryProgress + currentStep) / 4;

                // Posiciones: Supermercado (80% width, 30% height) -> Domicilio (20% width, 80% height)
                final startX = screenWidth * 0.8 - 16; // Supermercado
                final endX = screenWidth * 0.2 - 16; // Domicilio
                final startY = 60.0; // Top del supermercado
                final endY = 180.0; // Bottom cerca del domicilio

                final currentX = startX + (endX - startX) * progressPercent;
                final currentY = startY + (endY - startY) * progressPercent;

                return Positioned(
                  left: currentX,
                  top:
                      currentY +
                      sin(_moveController.value * 2 * pi) *
                          5, // Movimiento suave
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(
                            0.5 + 0.3 * sin(_pulseController.value * 2 * pi),
                          ),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.delivery_dining,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapIndicator(String label, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pedido #${widget.orderNumber}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Pagado',
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.schedule, color: primaryColor, size: 20),
              const SizedBox(width: 8),
              Text(
                'Tiempo estimado: $estimatedTime',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.payments, color: primaryColor, size: 20),
              const SizedBox(width: 8),
              Text(
                'Total: Bs ${widget.totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryStatus() {
    return Container(
      margin: const EdgeInsets.all(16),
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
          const Text(
            'Estado del pedido',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Stepper vertical
          ...deliverySteps.asMap().entries.map((entry) {
            int index = entry.key;
            String step = entry.value;

            bool isCompleted = index < currentStep;
            bool isCurrent = index == currentStep;
            bool isFuture = index > currentStep;

            return _buildStepItem(
              step: step,
              isCompleted: isCompleted,
              isCurrent: isCurrent,
              isFuture: isFuture,
              isLast: index == deliverySteps.length - 1,
              progress:
                  isCurrent ? deliveryProgress : (isCompleted ? 1.0 : 0.0),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildStepItem({
    required String step,
    required bool isCompleted,
    required bool isCurrent,
    required bool isFuture,
    required bool isLast,
    required double progress,
  }) {
    Color stepColor =
        isCompleted || isCurrent ? primaryColor : Colors.grey.shade300;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            // Círculo del paso
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: stepColor,
                shape: BoxShape.circle,
              ),
              child:
                  isCompleted
                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                      : isCurrent
                      ? AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          return Container(
                            width: 12,
                            height: 12,
                            margin: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(
                                    0.5 +
                                        0.5 *
                                            sin(
                                              _pulseController.value * 2 * pi,
                                            ),
                                  ),
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          );
                        },
                      )
                      : null,
            ),

            // Línea conectora
            if (!isLast) Container(width: 2, height: 40, color: stepColor),
          ],
        ),

        const SizedBox(width: 16),

        // Texto del paso
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isFuture ? Colors.grey.shade500 : Colors.black,
                  ),
                ),
                if (isCurrent && progress > 0)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: progress,
                      child: Container(
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDriverInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
      child: Row(
        children: [
          // Avatar del repartidor
          CircleAvatar(
            radius: 30,
            backgroundColor: primaryColor,
            child: Text(
              driverName.split(' ').map((name) => name[0]).join(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Información del repartidor
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  driverName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '$driverRating',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      ' • Repartidor',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Botón de llamar
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Llamando a $driverName...')),
              );
            },
            icon: Icon(Icons.phone, color: primaryColor),
            style: IconButton.styleFrom(
              backgroundColor: primaryColor.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (currentStep < deliverySteps.length - 1) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Compartiendo ubicación en tiempo real...'),
                    ),
                  );
                },
                icon: const Icon(Icons.share_location),
                label: const Text('Compartir mi ubicación'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ayuda y soporte contactados')),
                );
              },
              icon: const Icon(Icons.help_outline),
              label: const Text('Ayuda y Soporte'),
              style: OutlinedButton.styleFrom(
                foregroundColor: primaryColor,
                side: BorderSide(color: primaryColor),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Painter personalizado para el mapa
class MapPainter extends CustomPainter {
  final double progress;
  final Animation<double> animation;

  MapPainter({required this.progress, required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.green.shade200
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke;

    // Dibujar calles simuladas
    final path = Path();

    // Calle principal horizontal
    path.moveTo(0, size.height * 0.6);
    path.lineTo(size.width, size.height * 0.6);

    // Calles verticales
    path.moveTo(size.width * 0.2, 0);
    path.lineTo(size.width * 0.2, size.height);

    path.moveTo(size.width * 0.8, 0);
    path.lineTo(size.width * 0.8, size.height);

    // Calle secundaria
    path.moveTo(0, size.height * 0.3);
    path.lineTo(size.width * 0.8, size.height * 0.3);

    canvas.drawPath(path, paint);

    // Dibujar ruta del delivery
    final routePaint =
        Paint()
          ..color = Colors.red
          ..strokeWidth = 4
          ..style = PaintingStyle.stroke;

    final routePath = Path();
    routePath.moveTo(size.width * 0.8, size.height * 0.3); // Supermercado
    routePath.lineTo(size.width * 0.8, size.height * 0.6); // Bajar
    routePath.lineTo(size.width * 0.2, size.height * 0.6); // Ir a la izquierda
    routePath.lineTo(size.width * 0.2, size.height * 0.8); // Casa

    canvas.drawPath(routePath, routePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
