import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auth1/Screens/authentication/register.dart';
import 'package:flutter_auth1/Screens/authentication/signIn.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> 
    with TickerProviderStateMixin {
  
  bool _isSignInPage = true;
  late PageController _pageController;
  late AnimationController _animationController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize page controller
    _pageController = PageController(initialPage: 0);
    
    // Initialize animation controllers
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    // Initialize animations
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutBack,
    ));
    
    // Start initial animations
    _animationController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _switchPage() {
    // Provide haptic feedback
    HapticFeedback.lightImpact();
    
    setState(() {
      _isSignInPage = !_isSignInPage;
    });
    
    // Animate page transition
    if (_isSignInPage) {
      _pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _pageController.animateToPage(
        1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
    
    // Reset and replay slide animation for smooth transition
    _slideController.reset();
    _slideController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFF8F9FA),
                  Color(0xFFE9ECEF),
                  Color(0xFFF8F9FA),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),
          
          // Animated background shapes
          _buildBackgroundShapes(),
          
          // Main content with page view
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  children: [
                    // Top indicator and welcome section
                    _buildTopSection(),
                    
                    // Page view container
                    Expanded(
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _isSignInPage = index == 0;
                          });
                        },
                        physics: const BouncingScrollPhysics(),
                        children: [
                          SignIn(toggle: _switchPage),
                          Register(toggle: _switchPage),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Loading overlay (if needed for future enhancements)
          _buildLoadingOverlay(),
        ],
      ),
    );
  }

  Widget _buildBackgroundShapes() {
    return Stack(
      children: [
        // Top-left circle
        Positioned(
          top: -50,
          left: -50,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFCC3333).withOpacity(0.05),
            ),
          ),
        ),
        
        // Bottom-right circle
        Positioned(
          bottom: -80,
          right: -80,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFF6B6B).withOpacity(0.05),
            ),
          ),
        ),
        
        // Middle floating shape
        Positioned(
          top: MediaQuery.of(context).size.height * 0.3,
          right: -30,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: const Color(0xFFCC3333).withOpacity(0.03),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          // Page indicator dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildIndicatorDot(isActive: _isSignInPage),
              const SizedBox(width: 8),
              _buildIndicatorDot(isActive: !_isSignInPage),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Welcome text
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              _isSignInPage ? 'Welcome Back!' : 'Create Account',
              key: ValueKey(_isSignInPage),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3436),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Subtitle
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              _isSignInPage 
                ? 'Sign in to continue your food journey'
                : 'Join us and discover amazing food',
              key: ValueKey('${_isSignInPage}_subtitle'),
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
                height: 1.3,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicatorDot({required bool isActive}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: isActive 
          ? const Color(0xFFCC3333) 
          : const Color(0xFFCC3333).withOpacity(0.3),
        boxShadow: isActive ? [
          BoxShadow(
            color: const Color(0xFFCC3333).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ] : null,
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    // This can be used for future enhancements like splash screens
    // or global loading states
    return const SizedBox.shrink();
  }

  // Method to programmatically switch to sign in
  void switchToSignIn() {
    if (!_isSignInPage) {
      _switchPage();
    }
  }

  // Method to programmatically switch to register
  void switchToRegister() {
    if (_isSignInPage) {
      _switchPage();
    }
  }

  // Method to get current page
  String getCurrentPage() {
    return _isSignInPage ? 'SignIn' : 'Register';
  }
}