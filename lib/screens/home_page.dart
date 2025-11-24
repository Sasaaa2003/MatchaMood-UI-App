import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'detail_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with TickerProviderStateMixin {
  final List<bool> _isHovered = List.generate(5, (_) => false);
  final List<bool> _isFavorite = List.generate(5, (_) => false);
  final List<AnimationController?> _controllers = [];
  final List<Animation<double>?> _animations = [];
  String _selectedCategory = '';

  int _selectedNavIndex = 0;
  int _hoveredNavIndex = -1;

  late final AnimationController _bannerController;
  late final Animation<double> _bannerAnimation;

  final List<Map<String, dynamic>> matchaMenu = const [
    {
      'name': 'Matcha Latte',
      'image': 'assets/image2.png',
      'price': 45,
      'rating': 4.8,
      'category': 'Latte',
    },
    {
      'name': 'Matcha Original',
      'image': 'assets/image4.png',
      'price': 25,
      'rating': 4.9,
      'category': 'Latte',
    },
    {
      'name': 'Matcha Strawberry',
      'image': 'assets/image5.png',
      'price': 25,
      'rating': 4.9,
      'category': 'Dessert',
    },
    {
      'name': 'Matcha Ice Cream',
      'image': 'assets/image6.png',
      'price': 25,
      'rating': 4.9,
      'category': 'Ice Cream',
    },
    
  ];

  final List<String> categories = [
    'Latte',
    'Dessert',
    'Ice Cream',
    'All',
  ];

  @override
  void initState() {
    super.initState();

    // Banner animation
    _bannerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _bannerAnimation = Tween<double>(begin: 0, end: -15)
        .chain(CurveTween(curve: Curves.easeInOutSine))
        .animate(_bannerController);

    // Menu card animation
    for (int i = 0; i < matchaMenu.length; i++) {
      final controller = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 3),
      );

      final animation = Tween<double>(begin: 0, end: -12)
          .chain(CurveTween(curve: Curves.easeInOutSine))
          .animate(controller);

      _controllers.add(controller);
      _animations.add(animation);
    }
  }

  @override
  void dispose() {
    _bannerController.dispose();
    for (var c in _controllers) {
      c?.dispose();
    }
    super.dispose();
  }

  Widget _buildCategoryButton(String label, double buttonWidth) {
    final bool active =
        (_selectedCategory.isEmpty && label == 'All') || _selectedCategory == label;

    IconData icon;
    switch (label) {
      case 'Latte':
        icon = Icons.local_cafe_rounded;
        break;
      case 'Dessert':
        icon = Icons.cake;
        break;
      case 'Ice Cream':
        icon = Icons.icecream;
        break;
      case 'All':
      default:
        icon = Icons.menu;
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          if (label == 'All') {
            _selectedCategory = '';
          } else {
            _selectedCategory = (_selectedCategory == label) ? '' : label;
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: buttonWidth,
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          gradient: active
              ? const LinearGradient(
                  colors: [Color(0xFF2E7D32), Color(0xFF60AD5E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: active ? null : const Color.fromARGB(255, 242, 245, 243),
          borderRadius: BorderRadius.circular(20),
          border: !active
              ? Border.all(color: const Color.fromARGB(255, 201, 207, 203))
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: active ? Colors.white : const Color(0xFF2E7D32),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: active ? Colors.white : const Color(0xFF2E7D32),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    final navItems = [
      {"icon": Icons.home_rounded, "label": "Home"},
      {"icon": Icons.local_cafe_rounded, "label": "Menu"},
      {"icon": Icons.favorite_rounded, "label": "Favorite"},
      {"icon": Icons.notifications_rounded, "label": "Notif"},
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(navItems.length, (index) {
          final item = navItems[index];
          final isActive = _selectedNavIndex == index;
          final isHovered = _hoveredNavIndex == index;

          Color iconColor = isActive || isHovered
              ? const Color(0xFF2E7D32)
              : const Color(0xFFA0A0A0);

          return MouseRegion(
            onEnter: (_) => setState(() => _hoveredNavIndex = index),
            onExit: (_) => setState(() => _hoveredNavIndex = -1),
            child: GestureDetector(
              onTap: () => setState(() => _selectedNavIndex = index),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    transform: isHovered
                        ? Matrix4.translationValues(0, -5, 0)
                        : Matrix4.identity(),
                    child: Icon(
                      item['icon'] as IconData,
                      size: 26,
                      color: iconColor,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item['label'] as String,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isActive
                          ? const Color(0xFF2E7D32)
                          : const Color(0xFFA0A0A0),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibleIndices = List<int>.generate(matchaMenu.length, (i) => i)
        .where((i) =>
            _selectedCategory.isEmpty ||
            matchaMenu[i]['category'] == _selectedCategory)
        .toList();

    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFDFCF3), Color(0xFFE4F2D9), Color(0xFFB6E2A1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage('assets/profile.jpg'),
                    ),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "Hallo, welcome back Anisa!",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(255, 245, 245, 245),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(Icons.notifications_none,
                          color: Color(0xFF8ED86C), size: 26),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Search
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: "Search Matcha Menu...",
                      hintStyle: TextStyle(color: Color(0x992E7D32)),
                      prefixIcon: Icon(Icons.search, color: Color(0xFF2E7D32)),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 180),
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // Title
                const Text(
                  "Perfect Matcha In Your Hands",
                  style: TextStyle(
                    color: Color(0xFF2E7D32),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                // Banner
                Container(
                  height: 113,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    image: const DecorationImage(
                      image: AssetImage("assets/bg.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 16,
                        top: 16,
                        bottom: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Special Offer",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "Get 20% off on Matcha Drinks",
                              style: TextStyle(color: Color(0xCCFFFFFF)),
                            ),
                            const SizedBox(height: 5),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2E7D32),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {},
                              child: const Text("Order Now",
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      ),
                      // Animated image1.png
                      Positioned(
                        right: -16,
                        bottom: -26,
                        child: AnimatedBuilder(
                          animation: _bannerAnimation,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, _bannerAnimation.value),
                              child: child,
                            );
                          },
                          child: Image.asset(
                            "assets/image1.png",
                            height: 170,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),

                // Categories
                const Text(
                  "Categories",
                  style: TextStyle(
                    color: Color(0xFF2E7D32),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                LayoutBuilder(builder: (context, constraints) {
                  double totalMargin = 6 * 2 * categories.length.toDouble();
                  double buttonWidth =
                      (constraints.maxWidth - totalMargin) / categories.length;
                  return Row(
                    children: categories
                        .map((c) => _buildCategoryButton(c, buttonWidth))
                        .toList(),
                  );
                }),
                const SizedBox(height: 12),

                // Menu Cards
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: visibleIndices.length,
                    itemBuilder: (context, idx) {
                      final i = visibleIndices[idx];
                      final item = matchaMenu[i];
                      final isHovered = _isHovered[i];
                      final controller = _controllers[i];
                      final animation = _animations[i];

                      return MouseRegion(
                        onEnter: (_) {
                          setState(() => _isHovered[i] = true);
                          controller?.repeat(reverse: true);
                        },
                        onExit: (_) {
                          setState(() => _isHovered[i] = false);
                          controller?.animateTo(
                            0.0,
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeOutCubic,
                          );
                        },
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => DetailPage(data: item)),
                            );
                          },
                          child: Stack(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                width: 135,
                                height: 186,
                                margin: const EdgeInsets.only(right: 12),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isHovered
                                      ? const Color(0xFF2E7D32)
                                      : const Color(0xFFA8D480),
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: isHovered
                                      ? [
                                          BoxShadow(
                                            color:
                                                Colors.green.withOpacity(0.4),
                                            blurRadius: 10,
                                            offset: const Offset(0, 6),
                                          )
                                        ]
                                      : [],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AnimatedBuilder(
                                      animation: controller!,
                                      builder: (context, child) {
                                        return Transform.translate(
                                          offset: Offset(0, animation!.value),
                                          child: child,
                                        );
                                      },
                                      child: Image.asset(
                                        item['image'],
                                        height: 90,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      item['name'],
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${item['rating']}",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13),
                                        ),
                                        const SizedBox(width: 4),
                                        Row(
                                          children: List.generate(
                                              5, (iStar) {
                                            if (iStar <
                                                item['rating'].floor()) {
                                              return const Icon(
                                                  Icons.star,
                                                  color: Colors.yellow,
                                                  size: 14);
                                            } else if (iStar <
                                                item['rating']) {
                                              return const Icon(
                                                  Icons.star_half,
                                                  color: Colors.yellow,
                                                  size: 14);
                                            } else {
                                              return const Icon(
                                                  Icons.star_border,
                                                  color: Colors.yellow,
                                                  size: 14);
                                            }
                                          }),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Rp ${item['price']}k",
                                      style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              // Favorite icon
                              Positioned(
                                top: 6,
                                right: 23,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(
                                        () => _isFavorite[i] = !_isFavorite[i]);
                                  },
                                  child: Icon(
                                    _isFavorite[i]
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: _isFavorite[i]
                                        ? Colors.pinkAccent
                                        : Colors.white,
                                    size: 25,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }
}
