import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  final Map data;
  const DetailPage({super.key, required this.data});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage>
    with SingleTickerProviderStateMixin {
  int qty = 1;
  late AnimationController _controller;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();

    // animasi gambar mengambang
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: 0, end: -12)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // background gradasi lembut
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFDFCF3),
              Color(0xFFE4F2D9),
              Color(0xFFB6E2A1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: Color(0xFF2C5E3D)),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                const SizedBox(height: 10),

                // 🖼️ Area gambar + background card
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // background seperti menu card
                   Container(
                    
  height: 210,
  margin: const EdgeInsets.only(top: 0, right: 160, left :160),
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: const Color.fromARGB(255, 168, 212, 128),
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.green.withOpacity(0.3),
        blurRadius: 10,
        offset: const Offset(0, 5),
      ),
    ],
  ),
),


                    // gambar mengambang
                    AnimatedBuilder(
                      animation: _floatAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _floatAnimation.value),
                          child: child,
                        );
                      },
                      child: Hero(
                        tag: widget.data["name"],
                        child: Image.asset(
                          widget.data["image"],
                          height: 220,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Center(
                  child: Text(
                    widget.data["name"],
                    style: const TextStyle(
                      fontSize: 26,
                      color: Color(0xFF2C5E3D),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return Icon(
                      index < 4 ? Icons.star : Icons.star_half,
                      color: Colors.yellow,
                      size: 22,
                    );
                  }),
                ),
                const SizedBox(height: 4),
                const Center(
                  child: Text(
                    "4.8 (120 reviews)",
                    style: TextStyle(
                      color: Color(0xFF6E8B55),
                      fontSize: 13,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (qty > 1) setState(() => qty--);
                      },
                      icon: const Icon(Icons.remove_circle_outline,
                          color: Color(0xFF2C5E3D)),
                    ),
                    Text(
                      "$qty",
                      style: const TextStyle(
                        color: Color(0xFF2C5E3D),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    IconButton(
                      onPressed: () => setState(() => qty++),
                      icon: const Icon(Icons.add_circle_outline,
                          color: Color(0xFF2C5E3D)),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                const Text(
                  "About Matcha",
                  style: TextStyle(
                    color: Color(0xFF2C5E3D),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Premium Japanese matcha blended with milk and cream for a rich, earthy taste. "
                  "Perfect for boosting your mood and focus anytime of the day 🍵",
                  style: TextStyle(
                    color: Color(0xFF2C5E3D),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),

                const Spacer(),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 44, 94, 61),
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    shadowColor: Colors.green.withOpacity(0.3),
                    elevation: 6,
                  ),
                  onPressed: () {},
                  child: Text(
                    "Add to Cart - Rp ${widget.data["price"] * qty}k",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

               Center(
                    child: Text(
                      " “MatchUrr makes everything brew-tiful!”",
                      style: TextStyle(
                        color: const Color.fromRGBO(46, 125, 50, 1),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
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
