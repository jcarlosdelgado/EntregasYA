import 'package:flutter/material.dart';

class RatingScreen extends StatefulWidget {
  final String orderNumber;
  final double totalAmount;

  const RatingScreen({
    super.key,
    required this.orderNumber,
    required this.totalAmount,
  });

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen>
    with TickerProviderStateMixin {
  final Color primaryColor = const Color(0xFFFF6B35); // Naranja principal
  int selectedRating = 5;
  List<String> selectedAspects = [];
  String comment = '';
  late AnimationController _starController;
  late AnimationController _submitController;

  final List<String> positiveAspects = [
    'Entrega rápida',
    'Productos frescos',
    'Repartidor amable',
    'Empaque perfecto',
    'Precio justo',
    'Buena comunicación',
    'Puntualidad',
    'Calidad excelente',
  ];

  @override
  void initState() {
    super.initState();
    _starController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _submitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _starController.dispose();
    _submitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Califica tu experiencia',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFFFF6B35), // Fondo naranja
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header con emoji y orden
            _buildHeader(),

            const SizedBox(height: 32),

            // Rating con estrellas
            _buildStarRating(),

            const SizedBox(height: 32),

            // Aspectos positivos
            _buildAspectsSection(),

            const SizedBox(height: 32),

            // Comentario
            _buildCommentSection(),

            const SizedBox(height: 40),

            // Botón de envío
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shopping_bag_outlined,
              size: 40,
              color: Colors.green.shade600,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            '¡Pedido entregado!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade700,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Pedido #${widget.orderNumber}',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),

          Text(
            'Total: Bs ${widget.totalAmount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStarRating() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            '¿Cómo fue tu experiencia?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 24),

          // Estrellas con espaciado responsivo
          LayoutBuilder(
            builder: (context, constraints) {
              // Calcular tamaño dinámico basado en el ancho disponible
              double availableWidth =
                  constraints.maxWidth - 48; // padding interno
              double starSize = (availableWidth / 7).clamp(
                28.0,
                36.0,
              ); // 5 estrellas + 6 espacios
              double spacing = (availableWidth - (starSize * 5)) / 6;

              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedRating = index + 1;
                      });
                      _starController.forward().then((_) {
                        _starController.reverse();
                      });
                    },
                    child: AnimatedBuilder(
                      animation: _starController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale:
                              index < selectedRating
                                  ? 1.0 + (_starController.value * 0.15)
                                  : 1.0,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: spacing / 2,
                            ),
                            child: Icon(
                              Icons.star,
                              size: starSize,
                              color:
                                  index < selectedRating
                                      ? Colors.amber
                                      : Colors.grey.shade300,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
              );
            },
          ),

          const SizedBox(height: 16),

          // Texto descriptivo del rating
          Text(
            _getRatingText(selectedRating),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: _getRatingColor(selectedRating),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAspectsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
            '¿Qué te gustó más?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 4),

          Text(
            'Selecciona uno o varios aspectos',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),

          const SizedBox(height: 16),

          // Grid de aspectos
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3.5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: positiveAspects.length,
            itemBuilder: (context, index) {
              final aspect = positiveAspects[index];
              final isSelected = selectedAspects.contains(aspect);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      selectedAspects.remove(aspect);
                    } else {
                      selectedAspects.add(aspect);
                    }
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? primaryColor.withOpacity(0.1)
                            : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? primaryColor : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isSelected)
                        Icon(Icons.check_circle, size: 16, color: primaryColor),
                      if (isSelected) const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          aspect,
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                isSelected
                                    ? primaryColor
                                    : Colors.grey.shade700,
                            fontWeight:
                                isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCommentSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
            'Comentario adicional',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 4),

          Text(
            'Opcional - Cuéntanos más sobre tu experiencia',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),

          const SizedBox(height: 16),

          TextField(
            maxLines: 4,
            maxLength: 200,
            decoration: InputDecoration(
              hintText: 'Escribe aquí tu comentario...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: primaryColor, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
            onChanged: (value) {
              comment = value;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: AnimatedBuilder(
            animation: _submitController,
            builder: (context, child) {
              return ElevatedButton(
                onPressed: _submitRating,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: _submitController.value * 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_submitController.isAnimating) ...[
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Text(
                      _submitController.isAnimating
                          ? 'Enviando...'
                          : 'Enviar Calificación',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 12),

        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Ahora no',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
        ),
      ],
    );
  }

  String _getRatingText(int rating) {
    switch (rating) {
      case 1:
        return 'Muy malo 😞';
      case 2:
        return 'Malo 😕';
      case 3:
        return 'Regular 😐';
      case 4:
        return 'Bueno 😊';
      case 5:
        return 'Excelente 😍';
      default:
        return '';
    }
  }

  Color _getRatingColor(int rating) {
    switch (rating) {
      case 1:
      case 2:
        return Colors.red;
      case 3:
        return Colors.orange;
      case 4:
      case 5:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _submitRating() async {
    _submitController.forward();

    // Simular envío
    await Future.delayed(const Duration(seconds: 2));

    _submitController.stop();

    if (mounted) {
      // Mostrar mensaje de éxito
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    size: 50,
                    color: Colors.green.shade600,
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  '¡Gracias por tu calificación!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12),

                Text(
                  'Tu opinión nos ayuda a mejorar nuestro servicio',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                ),

                if (selectedAspects.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Te gustó: ${selectedAspects.join(', ')}',
                    style: TextStyle(
                      fontSize: 12,
                      color: primaryColor,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Cerrar dialog
                    Navigator.pop(context); // Cerrar pantalla de rating
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('¡Perfecto!'),
                ),
              ),
            ],
          ),
    );
  }
}
