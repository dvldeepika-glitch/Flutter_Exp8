
import 'package:flutter/material.dart';

void main() {
  runApp(const AnimationDemoApp());
}

class AnimationDemoApp extends StatelessWidget {
  const AnimationDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Animations Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AnimationHomePage(),
    );
  }
}

class AnimationHomePage extends StatefulWidget {
  const AnimationHomePage({super.key});

  @override
  State<AnimationHomePage> createState() => _AnimationHomePageState();
}

class _AnimationHomePageState extends State<AnimationHomePage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _rotationController;
  late AnimationController _combinedController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _combinedFadeAnimation;
  late Animation<Offset> _combinedSlideAnimation;

  bool _fadeVisible = true;

  @override
  void initState() {
    super.initState();

    // 1. Fade Animation
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    _fadeController.forward();

    // 2. Slide Animation
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.5, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _slideController,
        curve: Curves.easeOutCubic,
      ),
    );

    // 3. Scale Animation
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: Curves.elasticOut,
      ),
    );

    // 4. Rotation Animation
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _rotationController,
        curve: Curves.easeInOut,
      ),
    );

    // 5. Combined Fade and Slide Animation
    _combinedController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _combinedFadeAnimation = CurvedAnimation(
      parent: _combinedController,
      curve: Curves.easeIn,
    );

    _combinedSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.8),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _combinedController,
        curve: Curves.easeOutCubic,
      ),
    );
  }

  void _toggleFade() {
    setState(() {
      _fadeVisible = !_fadeVisible;
    });

    if (_fadeVisible) {
      _fadeController.forward();
    } else {
      _fadeController.reverse();
    }
  }

  void _playSlide() {
    _slideController.forward(from: 0);
  }

  void _playScale() {
    _scaleController.forward(from: 0).then((_) {
      if (mounted) {
        _scaleController.reverse();
      }
    });
  }

  void _playRotation() {
    _rotationController.forward(from: 0);
  }

  void _playCombined() {
    _combinedController.forward(from: 0);
  }

  void _resetAnimations() {
    _fadeController.reset();
    _slideController.reset();
    _scaleController.reset();
    _rotationController.reset();
    _combinedController.reset();

    setState(() {
      _fadeVisible = true;
    });

    _fadeController.forward();
  }

  Widget _buildAnimationCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 5,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withValues(alpha: 0.15),
              color.withValues(alpha: 0.04),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 27,
              backgroundColor: color.withValues(alpha: 0.18),
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Widget child,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        child,
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: onPressed,
            icon: const Icon(Icons.play_arrow),
            label: Text(buttonText),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _rotationController.dispose();
    _combinedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Flutter Animations Demo',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple.shade100,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Explore Flutter Animations',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Tap the buttons or cards to experience five animations.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 20),

            // 1. Fade Animation
            _buildSection(
              title: '1. Fade Animation',
              buttonText: _fadeVisible ? 'Fade Out' : 'Fade In',
              onPressed: _toggleFade,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _buildAnimationCard(
                  title: 'Fade Card',
                  description: 'Smoothly fades in and out.',
                  icon: Icons.visibility,
                  color: Colors.blue,
                ),
              ),
            ),

            // 2. Slide Animation
            _buildSection(
              title: '2. Slide Animation',
              buttonText: 'Slide from Left',
              onPressed: _playSlide,
              child: SlideTransition(
                position: _slideAnimation,
                child: _buildAnimationCard(
                  title: 'Sliding Card',
                  description: 'Slides into view from the left.',
                  icon: Icons.swipe,
                  color: Colors.green,
                ),
              ),
            ),

            // 3. Scale Animation
            _buildSection(
              title: '3. Scale Animation',
              buttonText: 'Bounce Scale',
              onPressed: _playScale,
              child: GestureDetector(
                onTap: _playScale,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: _buildAnimationCard(
                    title: 'Scaling Card',
                    description: 'Tap this card for a bounce effect.',
                    icon: Icons.zoom_in,
                    color: Colors.orange,
                  ),
                ),
              ),
            ),

            // 4. Rotation Animation
            _buildSection(
              title: '4. Rotation Animation',
              buttonText: 'Rotate 360°',
              onPressed: _playRotation,
              child: RotationTransition(
                turns: _rotationAnimation,
                child: _buildAnimationCard(
                  title: 'Rotating Card',
                  description: 'Completes a full 360-degree turn.',
                  icon: Icons.rotate_right,
                  color: Colors.purple,
                ),
              ),
            ),

            // 5. Combined Animation
            _buildSection(
              title: '5. Combined Animation',
              buttonText: 'Fade + Slide',
              onPressed: _playCombined,
              child: SlideTransition(
                position: _combinedSlideAnimation,
                child: FadeTransition(
                  opacity: _combinedFadeAnimation,
                  child: _buildAnimationCard(
                    title: 'Combined Card',
                    description: 'Fades and slides into view together.',
                    icon: Icons.auto_awesome,
                    color: Colors.pink,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton.icon(
                onPressed: _resetAnimations,
                icon: const Icon(Icons.restart_alt),
                label: const Text(
                  'Reset All Animations',
                  style: TextStyle(fontSize: 16),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Flutter Lab 8 | Animation Framework',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}