import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:study_gram/theme/colors.dart';
import 'package:study_gram/widgets/responsive_device_frame.dart';
import 'package:study_gram/views/login_view.dart';
import 'package:study_gram/views/otp_view.dart';
import 'package:study_gram/views/home_view.dart';
import 'package:study_gram/views/choose_branch_view.dart';
import 'package:study_gram/views/subjects_view.dart';
import 'package:study_gram/views/materials_hub_view.dart';
import 'package:study_gram/views/quiz_view.dart';
import 'package:study_gram/views/profile_view.dart';
import 'package:study_gram/views/about_us_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Studygram Education',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.bgMain,
        fontFamily: 'Inter',
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.accent,
          surface: AppColors.bgCard,
          onPrimary: Colors.white,
          onSurface: AppColors.textPrimary,
          outline: AppColors.borderCard,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: AppColors.bgCard,
          hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 14),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(14)),
            borderSide: BorderSide(color: AppColors.borderCard, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(14)),
            borderSide: BorderSide(color: AppColors.primaryLight, width: 2),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(14)),
            borderSide: BorderSide(color: AppColors.borderCard),
          ),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: AppColors.primary,
          selectionColor: AppColors.primaryLight.withValues(alpha: 0.25),
          selectionHandleColor: AppColors.primary,
        ),
      ),
      home: const AppShell(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Custom Route Observer to automatically synchronize bottom nav highlights
// ─────────────────────────────────────────────────────────────────────────────
class AppShellRouteObserver extends NavigatorObserver {
  final Function(String? routeName) onRouteChanged;
  AppShellRouteObserver({required this.onRouteChanged});

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    onRouteChanged(route.settings.name);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    onRouteChanged(previousRoute?.settings.name);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    onRouteChanged(newRoute?.settings.name);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// AppShell — holds global user state + an EMBEDDED Navigator with PopScope
// ─────────────────────────────────────────────────────────────────────────────
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  // ── Global user state ────────────────────────────────────────────────────
  String _userName       = "Varun Sarangire";
  String _phoneNumber    = "";
  int    _quizPoints     = 890;
  String _selectedCourse = "Diploma";
  String _selectedBranch = "Computer Engineering";
  String _selectedSubject = "JAVA";
  final Set<String> _bookmarkedSubjects = {"JAVA"};

  // ── Persistent login status fields ───────────────────────────────────────
  bool _isLoading = true;
  bool _isLoggedIn = false;

  // ── Embedded Navigator key ────────────────────────────────────────────────
  final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();

  // ── Which screens show the bottom nav ────────────────────────────────────
  bool _showBottomNav = false;

  // ── Bottom nav active tab ─────────────────────────────────────────────────
  int _navIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadLoginStatus();
  }

  Future<void> _loadLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    final savedName = prefs.getString('user_name');
    final savedPhone = prefs.getString('phone_number');
    final savedPoints = prefs.getInt('quiz_points');
    setState(() {
      _isLoggedIn = isLoggedIn;
      if (isLoggedIn) {
        _showBottomNav = true;
        _navIndex = 0;
        if (savedName != null) _userName = savedName;
        if (savedPhone != null) _phoneNumber = savedPhone;
        if (savedPoints != null) _quizPoints = savedPoints;
      }
      _isLoading = false;
    });
  }

  // ── Helper: slide push ───────────────────────────────────────────────────
  void _push(Widget page, String name, {bool clearStack = false}) {
    if (clearStack) {
      _navKey.currentState!.pushAndRemoveUntil(
        _slideRoute(page, name),
        (_) => false,
      );
    } else {
      _navKey.currentState!.push(_slideRoute(page, name));
    }
  }

  Route<dynamic> _slideRoute(Widget page, String name) {
    return PageRouteBuilder(
      settings: RouteSettings(name: name),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end   = Offset.zero;
        final tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: Curves.easeInOutCubic),
        );
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 320),
    );
  }

  // ── Bottom-nav tab handler ────────────────────────────────────────────────
  void _onNavTap(int index) {
    if (index == _navIndex) return;

    switch (index) {
      case 0:
        // Pop back to the home page (root of the navigator stack when logged in)
        _navKey.currentState!.popUntil((route) => route.isFirst);
        break;
      case 1:
        if (_navIndex == 2) {
          _navKey.currentState!.pushReplacement(_slideRoute(_buildProfile(), '/profile'));
        } else {
          _push(_buildProfile(), '/profile');
        }
        break;
      case 2:
        if (_navIndex == 1) {
          _navKey.currentState!.pushReplacement(_slideRoute(_buildAboutUs(), '/about'));
        } else {
          _push(_buildAboutUs(), '/about');
        }
        break;
    }
  }

  // ── Screen builders ──────────────────────────────────────────────────────
  Widget _buildLogin() => LoginView(
    onOtpSent: (phone) {
      setState(() => _phoneNumber = phone);
      _push(_buildOtp(), '/otp');
    },
  );

  Widget _buildOtp() => OtpView(
    phoneNumber: _phoneNumber,
    onBack: () => _navKey.currentState!.pop(),
    onVerified: () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', true);
      await prefs.setString('user_name', _userName);
      await prefs.setString('phone_number', _phoneNumber);
      await prefs.setInt('quiz_points', _quizPoints);
      setState(() {
        _isLoggedIn = true;
        _showBottomNav = true;
        _navIndex = 0;
      });
      _push(_buildHome(), '/home', clearStack: true);
    },
  );

  Widget _buildHome() => HomeView(
    userName: _userName,
    onCourseSelected: (course) {
      setState(() => _selectedCourse = course);
      _push(_buildChooseBranch(), '/choose_branch');
    },
    onAvatarTap: () {
      setState(() => _navIndex = 1);
      _push(_buildProfile(), '/profile');
    },
  );

  Widget _buildChooseBranch() => ChooseBranchView(
    selectedCourse: _selectedCourse,
    onBack: () => _navKey.currentState!.pop(),
    onBranchSelected: (branch) {
      setState(() => _selectedBranch = branch);
      _push(_buildSubjects(), '/subjects');
    },
  );

  Widget _buildSubjects() => SubjectsView(
    selectedBranch: _selectedBranch,
    onBack: () => _navKey.currentState!.pop(),
    onSubjectSelected: (subject) {
      setState(() => _selectedSubject = subject);
      _push(_buildMaterials(), '/materials');
    },
  );

  Widget _buildMaterials() => MaterialsHubView(
    subject: _selectedSubject,
    isBookmarked: _bookmarkedSubjects.contains(_selectedSubject),
    onBookmarkToggle: () {
      setState(() {
        if (_bookmarkedSubjects.contains(_selectedSubject)) {
          _bookmarkedSubjects.remove(_selectedSubject);
        } else {
          _bookmarkedSubjects.add(_selectedSubject);
        }
      });
    },
    onBack: () => _navKey.currentState!.pop(),
    onStartQuiz: () => _push(_buildQuiz(), '/quiz'),
  );

  Widget _buildQuiz() => QuizView(
    onQuizFinished: (score) async {
      final newPoints = _quizPoints + score * 100;
      setState(() => _quizPoints = newPoints);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('quiz_points', newPoints);
      _navKey.currentState!.pop(); // back to materials
    },
  );

  Widget _buildProfile() => ProfileView(
    userName: _userName,
    phoneNumber: _phoneNumber,
    quizScore: _quizPoints,
    onBack: () => _navKey.currentState!.pop(),
    onUpdateName: (name) async {
      setState(() => _userName = name);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', name);
    },
    onAboutUsTap: () => _push(_buildAboutUs(), '/about'),
    onLogout: () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      setState(() {
        _isLoggedIn = false;
        _showBottomNav = false;
        _navIndex = 0;
      });
      _push(_buildLogin(), '/login', clearStack: true);
    },
  );

  Widget _buildAboutUs() => AboutUsView(
    onBack: () => _navKey.currentState!.pop(),
  );

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.bgMain,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    return ResponsiveDeviceFrame(
      showBottomNav: _showBottomNav,
      navIndex: _navIndex,
      onNavTap: _onNavTap,
      // ── Embedded Navigator inside PopScope to handle system back button ──
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          final navigator = _navKey.currentState;
          if (navigator != null && navigator.canPop()) {
            navigator.pop();
          } else {
            SystemNavigator.pop();
          }
        },
        child: Navigator(
          key: _navKey,
          observers: [
            AppShellRouteObserver(
              onRouteChanged: (name) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!mounted) return;
                  if (name == '/profile') {
                    setState(() => _navIndex = 1);
                  } else if (name == '/about') {
                    setState(() => _navIndex = 2);
                  } else if (name != null && name != '/login' && name != '/otp') {
                    setState(() => _navIndex = 0);
                  }
                });
              },
            ),
          ],
          onGenerateRoute: (_) => _slideRoute(
            _isLoggedIn ? _buildHome() : _buildLogin(),
            _isLoggedIn ? '/home' : '/login',
          ),
        ),
      ),
    );
  }
}
