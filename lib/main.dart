import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'user_dashboard.dart';
import 'coach_dashboard.dart';
import 'first_time_setup_screen.dart';
import 'forgot_pass.dart';
import 'package:get/get.dart';
import 'package:flutter/gestures.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  final String role = prefs.getString('role') ?? '';
  final bool profileCompleted = prefs.getBool('profileCompleted') ?? false;

  runApp(MyApp(
    isLoggedIn: isLoggedIn,
    role: role,
    profileCompleted: profileCompleted,
  ));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final String role;
  final bool profileCompleted;

  const MyApp({
    super.key,
    required this.isLoggedIn,
    required this.role,
    required this.profileCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFFFF6B00),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF6B00),
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF6B00),
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white.withOpacity(0.9),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFFF6B00), width: 2),
          ),
          hintStyle: const TextStyle(color: Colors.black54),
        ),
      ),
      home: isLoggedIn
          ? profileCompleted
              ? _getHomeScreen(role)
              : const FirstTimeSetupScreen()
          : const WelcomeScreen(),
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/userDashboard': (context) => UserDashboard(),
        '/coachDashboard': (context) => CoachDashboard(),
        '/FirstTimeSetup': (context) => const FirstTimeSetupScreen(),
        '/forgotPassword': (context) => ForgotPasswordScreen(),
      },
    );
  }

  Widget _getHomeScreen(String role) {
    switch (role.toLowerCase()) {
      case 'coach':
        return CoachDashboard();
      case 'customer':
        return UserDashboard();
      default:
        return const WelcomeScreen();
    }
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/gym.6.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.6),
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(flex: 1),
                // Logo with animation
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 800),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.scale(
                        scale: value,
                        child: Image.asset(
                          'assets/images/gym.logo.png',
                          height: 120,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 40),
                // Welcome Text with animation
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOut,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: "C",
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFF6B00),
                                ),
                              ),
                              TextSpan(
                                text: "NERGY GYM",
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOut,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: const Text(
                          "Transform your body, transform your life",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const Spacer(flex: 2),
                // Create Account Button
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOut,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/signup');
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 56),
                          ),
                          child: const Text(
                            "CREATE ACCOUNT",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                // Sign In Button
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOut,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 56),
                            side: const BorderSide(color: Colors.white, width: 2),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "SIGN IN",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool _acceptTerms = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black26,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/gym.2.jpeg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.7),
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with animation
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOut,
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 20 * (1 - value)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Create Account",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Start your fitness journey today",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                  // Form with animation
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOut,
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 20 * (1 - value)),
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Name field
                                TextFormField(
                                  controller: nameController,
                                  style: const TextStyle(color: Colors.black),
                                  decoration: const InputDecoration(
                                    hintText: "Full Name",
                                    prefixIcon: Icon(Icons.person, color: Colors.black54),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Email field
                                TextFormField(
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  style: const TextStyle(color: Colors.black),
                                  decoration: const InputDecoration(
                                    hintText: "Email Address",
                                    prefixIcon: Icon(Icons.email, color: Colors.black54),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Password field
                                TextFormField(
                                  controller: passwordController,
                                  obscureText: obscurePassword,
                                  style: const TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    hintText: "Password",
                                    prefixIcon: const Icon(Icons.lock, color: Colors.black54),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        obscurePassword ? Icons.visibility_off : Icons.visibility,
                                        color: Colors.black54,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          obscurePassword = !obscurePassword;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Confirm Password field
                                TextFormField(
                                  controller: confirmPasswordController,
                                  obscureText: obscureConfirmPassword,
                                  style: const TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    hintText: "Confirm Password",
                                    prefixIcon: const Icon(Icons.lock_outline, color: Colors.black54),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                                        color: Colors.black54,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          obscureConfirmPassword = !obscureConfirmPassword;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                // Terms and conditions
                                Row(
                                  children: [
                                    Checkbox(
                                      value: _acceptTerms,
                                      onChanged: (value) {
                                        setState(() {
                                          _acceptTerms = value ?? false;
                                        });
                                      },
                                      fillColor: MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                          if (states.contains(MaterialState.selected)) {
                                            return const Color(0xFFFF6B00);
                                          }
                                          return Colors.white;
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "I agree to the Terms of Service and Privacy Policy",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                // Sign up button
                                ElevatedButton(
                                  onPressed: _acceptTerms ? () {
                                    // Implement sign up logic
                                    Get.snackbar(
                                      "Coming Soon",
                                      "Sign up functionality will be implemented soon!",
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.orange,
                                      colorText: Colors.white,
                                    );
                                  } : null,
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(double.infinity, 56),
                                    backgroundColor: const Color(0xFFFF6B00),
                                    disabledBackgroundColor: Colors.grey,
                                  ),
                                  child: const Text(
                                    "CREATE ACCOUNT",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  // Already have an account
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Already have an account? ",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        children: [
                          TextSpan(
                            text: "Sign In",
                            style: const TextStyle(
                              color: Color(0xFFFF6B00),
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushNamed(context, '/login');
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Modern CAPTCHA Widget
class ModernCaptcha extends StatefulWidget {
  final Function(bool) onCaptchaCompleted;
  final VoidCallback onRefresh;

  const ModernCaptcha({
    Key? key,
    required this.onCaptchaCompleted,
    required this.onRefresh,
  }) : super(key: key);

  @override
  _ModernCaptchaState createState() => _ModernCaptchaState();
}

class _ModernCaptchaState extends State<ModernCaptcha>
    with TickerProviderStateMixin {
  CaptchaType currentType = CaptchaType.slider;
  bool isCompleted = false;
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late Animation<double> _slideAnimation;
  late Animation<double> _pulseAnimation;

  // Slider CAPTCHA
  double sliderValue = 0.0;
  double targetPosition = 0.7;
  bool sliderCompleted = false;

  // Pattern CAPTCHA
  List<int> correctPattern = [];
  List<int> userPattern = [];
  List<Color> buttonColors = [];
  bool patternCompleted = false;

  // Math CAPTCHA
  int mathA = 0;
  int mathB = 0;
  int correctAnswer = 0;
  int? selectedAnswer;
  List<int> answerOptions = [];

  // Tap sequence CAPTCHA
  List<Offset> tapSequence = [];
  List<Offset> userTapSequence = [];
  bool showTapTargets = false;
  int currentTapIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _generateNewChallenge();
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeInOut),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.elasticInOut),
    );

    _pulseController.repeat(reverse: true);
  }

  void _generateNewChallenge() {
    final random = Random();
    final types = CaptchaType.values;
    currentType = types[random.nextInt(types.length)];

    setState(() {
      isCompleted = false;
      sliderCompleted = false;
      patternCompleted = false;
    });

    switch (currentType) {
      case CaptchaType.slider:
        _generateSliderChallenge();
        break;
      case CaptchaType.pattern:
        _generatePatternChallenge();
        break;
      case CaptchaType.math:
        _generateMathChallenge();
        break;
      case CaptchaType.tapSequence:
        _generateTapSequenceChallenge();
        break;
    }
  }

  void _generateSliderChallenge() {
    final random = Random();
    targetPosition = 0.6 + random.nextDouble() * 0.3;
    sliderValue = 0.0;
  }

  void _generatePatternChallenge() {
    final random = Random();
    correctPattern = List.generate(4, (_) => random.nextInt(6));
    userPattern.clear();
    buttonColors = List.generate(6, (index) {
      return correctPattern.contains(index)
          ? Colors.orange.withOpacity(0.3)
          : Colors.grey.withOpacity(0.3);
    });
  }

  void _generateMathChallenge() {
    final random = Random();
    mathA = random.nextInt(10) + 1;
    mathB = random.nextInt(10) + 1;
    correctAnswer = mathA + mathB;
    
    answerOptions = [correctAnswer];
    while (answerOptions.length < 4) {
      int wrongAnswer = correctAnswer + random.nextInt(10) - 5;
      if (wrongAnswer > 0 && !answerOptions.contains(wrongAnswer)) {
        answerOptions.add(wrongAnswer);
      }
    }
    answerOptions.shuffle();
    selectedAnswer = null;
  }

  void _generateTapSequenceChallenge() {
    final random = Random();
    tapSequence.clear();
    userTapSequence.clear();
    currentTapIndex = 0;
    
    for (int i = 0; i < 3; i++) {
      tapSequence.add(Offset(
        50 + random.nextDouble() * 200,
        50 + random.nextDouble() * 200,
      ));
    }
    
    Timer(const Duration(milliseconds: 500), () {
      setState(() {
        showTapTargets = true;
      });
      Timer(const Duration(seconds: 2), () {
        setState(() {
          showTapTargets = false;
        });
      });
    });
  }

  void _checkCompletion() {
    bool completed = false;
    
    switch (currentType) {
      case CaptchaType.slider:
        completed = sliderCompleted;
        break;
      case CaptchaType.pattern:
        completed = patternCompleted;
        break;
      case CaptchaType.math:
        completed = selectedAnswer == correctAnswer;
        break;
      case CaptchaType.tapSequence:
        completed = userTapSequence.length == tapSequence.length;
        break;
    }

    if (completed && !isCompleted) {
      setState(() {
        isCompleted = true;
      });
      _slideController.forward();
      widget.onCaptchaCompleted(true);
      
      // Success feedback
      HapticFeedback.lightImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Security Verification',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              IconButton(
                onPressed: () {
                  _generateNewChallenge();
                  widget.onRefresh();
                },
                icon: Icon(Icons.refresh, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _buildCurrentChallenge(),
          ),
          if (isCompleted) ...[
            const SizedBox(height: 16),
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(_slideAnimation),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.check_circle, color: Colors.white, size: 16),
                    SizedBox(width: 8),
                    Text(
                      'Verification Complete',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCurrentChallenge() {
    switch (currentType) {
      case CaptchaType.slider:
        return _buildSliderChallenge();
      case CaptchaType.pattern:
        return _buildPatternChallenge();
      case CaptchaType.math:
        return _buildMathChallenge();
      case CaptchaType.tapSequence:
        return _buildTapSequenceChallenge();
    }
  }

  Widget _buildSliderChallenge() {
    return Column(
      key: const ValueKey('slider'),
      children: [
        const Text(
          'Slide to complete the puzzle',
          style: TextStyle(fontSize: 14, color: Colors.black87),
        ),
        const SizedBox(height: 16),
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(25),
          ),
          child: Stack(
            children: [
              // Target zone indicator
              Positioned(
                left: targetPosition * (MediaQuery.of(context).size.width - 100),
                child: Container(
                  width: 40,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              // Slider
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 50,
                  thumbShape: CustomSliderThumb(),
                  overlayShape: SliderComponentShape.noOverlay,
                  activeTrackColor: Colors.transparent,
                  inactiveTrackColor: Colors.transparent,
                ),
                child: Slider(
                  value: sliderValue,
                  onChanged: (value) {
                    setState(() {
                      sliderValue = value;
                      if ((value - targetPosition).abs() < 0.05) {
                        sliderCompleted = true;
                        _checkCompletion();
                      }
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPatternChallenge() {
    return Column(
      key: const ValueKey('pattern'),
      children: [
        const Text(
          'Tap the highlighted buttons in order',
          style: TextStyle(fontSize: 14, color: Colors.black87),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
            bool isCorrect = correctPattern.contains(index);
            bool isPressed = userPattern.contains(index);
            
            return AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: isCorrect && !isPressed ? _pulseAnimation.value : 1.0,
                  child: GestureDetector(
                    onTap: () {
                      if (correctPattern.contains(index) && !userPattern.contains(index)) {
                        setState(() {
                          userPattern.add(index);
                          if (userPattern.length == correctPattern.length) {
                            patternCompleted = true;
                            _checkCompletion();
                          }
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isPressed
                            ? Colors.green
                            : (isCorrect ? Colors.orange.withOpacity(0.7) : Colors.grey[300]),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isCorrect ? Colors.orange : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: isPressed
                            ? const Icon(Icons.check, color: Colors.white)
                            : Text(
                                '${index + 1}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isCorrect ? Colors.white : Colors.grey[600],
                                ),
                              ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildMathChallenge() {
    return Column(
      key: const ValueKey('math'),
      children: [
        const Text(
          'Solve the math problem',
          style: TextStyle(fontSize: 14, color: Colors.black87),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '$mathA + $mathB = ?',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          children: answerOptions.map((answer) {
            bool isSelected = selectedAnswer == answer;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedAnswer = answer;
                  _checkCompletion();
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.orange : Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? Colors.orange : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Text(
                  answer.toString(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTapSequenceChallenge() {
    return Column(
      key: const ValueKey('tapSequence'),
      children: [
        const Text(
          'Remember the sequence and tap in order',
          style: TextStyle(fontSize: 14, color: Colors.black87),
        ),
        const SizedBox(height: 16),
        Container(
          height: 300,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: GestureDetector(
            onTapDown: (details) {
              if (!showTapTargets && userTapSequence.length < tapSequence.length) {
                RenderBox box = context.findRenderObject() as RenderBox;
                Offset localPosition = box.globalToLocal(details.globalPosition);
                
                // Check if tap is close to the expected position
                if (currentTapIndex < tapSequence.length) {
                  Offset expectedPosition = tapSequence[currentTapIndex];
                  double distance = (localPosition - expectedPosition).distance;
                  
                  if (distance < 30) {
                    setState(() {
                      userTapSequence.add(localPosition);
                      currentTapIndex++;
                      if (userTapSequence.length == tapSequence.length) {
                        _checkCompletion();
                      }
                    });
                  }
                }
              }
            },
            child: Stack(
              children: [
                // Show targets during demonstration
                if (showTapTargets)
                  ...tapSequence.asMap().entries.map((entry) {
                    int index = entry.key;
                    Offset position = entry.value;
                    return Positioned(
                      left: position.dx - 20,
                      top: position.dy - 20,
                      child: AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _pulseAnimation.value,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.orange.withOpacity(0.5),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }).toList(),
                // Show user taps
                ...userTapSequence.asMap().entries.map((entry) {
                  int index = entry.key;
                  Offset position = entry.value;
                  return Positioned(
                    left: position.dx - 15,
                    top: position.dy - 15,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }
}

class CustomSliderThumb extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(50, 50);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;
    
    final Paint paint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(center, 20, paint);
    
    final Paint iconPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    // Draw arrow icon
    final Path arrowPath = Path();
    arrowPath.moveTo(center.dx - 8, center.dy);
    arrowPath.lineTo(center.dx + 8, center.dy - 6);
    arrowPath.lineTo(center.dx + 8, center.dy + 6);
    arrowPath.close();
    
    canvas.drawPath(arrowPath, iconPaint);
  }
}

enum CaptchaType {
  slider,
  pattern,
  math,
  tapSequence,
}

// Updated Login Screen with Modern CAPTCHA
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  bool obscurePassword = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isButtonDisabled = false;
  int countdownTime = 0;
  bool isAccountLocked = false;

  bool showCaptcha = false;
  bool captchaCompleted = false;

  // Animation controller
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // CSRF token management
  String? csrfToken;
  final Map<String, String> _cookies = {};

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
    
    _animationController.forward();
  }

  String sanitizeInput(String input) {
    return input.replaceAll(RegExp(r'[<>/\\]'), '');
  }

  bool validateRequest(String email, String password) {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill in all fields",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      Get.snackbar(
        "Error",
        "Please enter a valid email address",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }

  void _updateCookies(http.Response response) {
    String? rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      List<String> cookies = rawCookie.split(',');
      for (String cookie in cookies) {
        List<String> parts = cookie.split(';')[0].split('=');
        if (parts.length == 2) {
          _cookies[parts[0].trim()] = parts[1].trim();
        }
      }
    }
  }

  Map<String, String> _getCookieHeaders() {
    if (_cookies.isEmpty) return {};
    String cookieString = _cookies.entries
        .map((entry) => '${entry.key}=${entry.value}')
        .join('; ');
    return {'Cookie': cookieString};
  }

  void loginUser() async {
    if (isButtonDisabled || isAccountLocked) {
      return;
    }

    String email = sanitizeInput(emailController.text.trim());
    String password = sanitizeInput(passwordController.text.trim());

    if (!validateRequest(email, password)) {
      return;
    }

    if (!captchaCompleted) {
      Get.snackbar(
        "Error",
        "Please complete the security verification",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    var url = Uri.parse('http://localhost/cynergy/loginapp.php');

    Map<String, dynamic> requestData = {
      "email": email,
      "password": password,
    };

    if (csrfToken != null) {
      requestData["csrf_token"] = csrfToken;
    }

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          ..._getCookieHeaders(),
        },
        body: jsonEncode(requestData),
      );

      _updateCookies(response);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data.containsKey("error")) {
          String errorMessage = data["error"];
          
          if (errorMessage.contains("CSRF token validation failed") && data.containsKey('csrf_token')) {
            setState(() {
              csrfToken = data['csrf_token'];
            });
            Get.snackbar(
              "Session Error",
              "Please try logging in again.",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.orange,
              colorText: Colors.white,
            );
            return;
          }
          
          if (errorMessage.contains("Too many failed attempts")) {
            setState(() {
              isAccountLocked = true;
            });
          }
          
          Get.snackbar(
            "Error",
            errorMessage,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }

        if (data.containsKey("redirect") && data.containsKey("user_role")) {
          String role = data['user_role'];
          String redirectUrl = data['redirect'];
          
          if (role.toLowerCase() == 'admin' || role.toLowerCase() == 'staff') {
            Get.snackbar(
              "Access Denied",
              "Admin and Staff access is only available through the web interface. Please use your computer to access the admin panel.",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.orange,
              colorText: Colors.white,
              duration: const Duration(seconds: 5),
            );
            return;
          }
          
          if (data.containsKey('csrf_token')) {
            csrfToken = data['csrf_token'];
          }

          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString('role', role);
          await prefs.setString('csrf_token', csrfToken ?? '');

          String routeName = _getRouteFromRedirect(redirectUrl, role);
          if (routeName != '/login') {
            Navigator.pushReplacementNamed(context, routeName);
            
            Get.snackbar(
              "Success",
              "Login successful!",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
          }
        }
      } else {
        Get.snackbar(
          "Server Error",
          "Server error. Try again later.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Connection error: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  String _getRouteFromRedirect(String redirectUrl, String role) {
    switch (role.toLowerCase()) {
      case 'coach':
        return '/coachDashboard';
      case 'customer':
        return '/userDashboard';
      case 'admin':
      case 'staff':
        Get.snackbar(
          "Access Denied",
          "Admin and Staff access is only available through the web interface. Please use your computer to access the admin panel.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
        return '/login';
      default:
        Get.snackbar(
          "Error",
          "Unknown user role. Please contact support.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return '/login';
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black26,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            height: constraints.maxHeight,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/images/gym.2.jpeg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.7),
                  BlendMode.darken,
                ),
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header with animation
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Welcome Back",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Sign in to continue your fitness journey",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        // Form with animation
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.2),
                              end: Offset.zero,
                            ).animate(_animationController),
                            child: Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  // Email field
                                  TextFormField(
                                    controller: emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    style: const TextStyle(color: Colors.black),
                                    decoration: const InputDecoration(
                                      hintText: "Email Address",
                                      prefixIcon: Icon(Icons.email, color: Colors.black54),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  // Password field
                                  TextFormField(
                                    controller: passwordController,
                                    obscureText: obscurePassword,
                                    style: const TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      hintText: "Password",
                                      prefixIcon: const Icon(Icons.lock, color: Colors.black54),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          obscurePassword ? Icons.visibility_off : Icons.visibility,
                                          color: Colors.black54,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            obscurePassword = !obscurePassword;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  // Security verification button
                                  if (!showCaptcha)
                                    Container(
                                      width: double.infinity,
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          setState(() {
                                            showCaptcha = true;
                                          });
                                        },
                                        icon: const Icon(Icons.security, size: 20),
                                        label: const Text("Verify Security"),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.orange.withOpacity(0.8),
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                        ),
                                      ),
                                    ),
                                  // Modern CAPTCHA
                                  if (showCaptcha) ...[
                                    const SizedBox(height: 16),
                                    ModernCaptcha(
                                      onCaptchaCompleted: (completed) {
                                        setState(() {
                                          captchaCompleted = completed;
                                        });
                                      },
                                      onRefresh: () {
                                        setState(() {
                                          captchaCompleted = false;
                                        });
                                      },
                                    ),
                                  ],
                                  const SizedBox(height: 16),
                                  // Forgot password
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(context, '/forgotPassword');
                                      },
                                      child: const Text(
                                        "Forgot Password?",
                                        style: TextStyle(
                                          color: Color(0xFFFF6B00),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  // Login button
                                  if (isButtonDisabled)
                                    Text(
                                      "Try again in $countdownTime seconds",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  const SizedBox(height: 10),
                                  Visibility(
                                    visible: !isAccountLocked,
                                    child: ElevatedButton(
                                      onPressed: (isButtonDisabled || !captchaCompleted) ? null : loginUser,
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: const Size(double.infinity, 56),
                                        backgroundColor: captchaCompleted 
                                            ? const Color(0xFFFF6B00) 
                                            : Colors.grey,
                                      ),
                                      child: Text(
                                        captchaCompleted ? "SIGN IN" : "COMPLETE VERIFICATION FIRST",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Don't have an account
                        Center(
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: RichText(
                              text: TextSpan(
                                text: "Don't have an account? ",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                                children: [
                                  TextSpan(
                                    text: "Create Account",
                                    style: const TextStyle(
                                      color: Color(0xFFFF6B00),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pushNamed(context, '/signup');
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}