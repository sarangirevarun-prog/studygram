import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:study_gram/theme/colors.dart';
import 'package:study_gram/widgets/device_frame.dart';
import 'package:study_gram/views/login_view.dart';
import 'package:study_gram/views/otp_view.dart';
import 'package:study_gram/views/home_view.dart';
import 'package:study_gram/views/branch_view.dart';
import 'package:study_gram/views/subjects_view.dart';
import 'package:study_gram/views/materials_view.dart';
import 'package:study_gram/views/profile_view.dart';
import 'package:study_gram/views/about_view.dart';
import 'package:study_gram/views/splash_view.dart';
import 'package:study_gram/views/scheme_view.dart';
import 'package:study_gram/views/year_sem_view.dart';
import 'package:study_gram/views/settings_view.dart';
import 'package:study_gram/views/updates_view.dart';
import 'package:study_gram/views/saved_view.dart';
import 'package:study_gram/models/branch_db.dart';

final ValueNotifier<bool> themeNotifier = ValueNotifier(false);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: themeNotifier,
      builder: (_, isDarkMode, child) {
        return MaterialApp(
      title: 'Studygram Education',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: AppColors.isDark ? Brightness.dark : Brightness.light,
        scaffoldBackgroundColor: AppColors.bgMain,
        fontFamily: 'Inter',
        useMaterial3: true,
        colorScheme: AppColors.isDark
            ? ColorScheme.dark(
                primary: AppColors.primaryLight,
                secondary: AppColors.accent,
                surface: AppColors.bgCard,
                onPrimary: Colors.white,
                onSurface: AppColors.textPrimary,
                outline: AppColors.borderCard,
              )
            : ColorScheme.light(
                primary: AppColors.primary,
                secondary: AppColors.accent,
                surface: AppColors.bgCard,
                onPrimary: Colors.white,
                onSurface: AppColors.textPrimary,
                outline: AppColors.borderCard,
              ),
        inputDecorationTheme: InputDecorationTheme(
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
      },
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
  String _selectedCourse = "Diploma";
  String _selectedBranch = "Computer Engineering";
  String _selectedScheme = "K Scheme";
  int    _selectedYear = 1;
  int    _selectedSemester = 1;
  List<String> _selectedSemesterSubjects = [];
  String _selectedSubject = "JAVA";
  final Set<String> _bookmarkedSubjects = {"JAVA"};

  // ── Persistent login status & theme fields ───────────────────────────────
  bool _isLoggedIn = false;
  bool _showSplash = true;
  bool _isDarkMode = false;

  // ── Embedded Navigator key ────────────────────────────────────────────────
  final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();

  // ── Which screens show the bottom nav ────────────────────────────────────
  bool _showBottomNav = false;

  // ── Bottom nav active tab ─────────────────────────────────────────────────
  int _navIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final loginLoad = _loadLoginStatus();
    final splashTimer = Future.delayed(const Duration(seconds: 3));
    await Future.wait([loginLoad, splashTimer]);
    if (mounted) {
      setState(() {
        _showSplash = false;
      });
    }
  }

  Future<void> _loadLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    final savedName = prefs.getString('user_name');
    final savedPhone = prefs.getString('phone_number');
    final savedTheme = prefs.getBool('is_dark_mode') ?? false;
    setState(() {
      _isLoggedIn = isLoggedIn;
      _isDarkMode = savedTheme;
      AppColors.isDark = savedTheme;
      themeNotifier.value = savedTheme;
      if (isLoggedIn) {
        _showBottomNav = true;
        _navIndex = 0;
        if (savedName != null) _userName = savedName;
        if (savedPhone != null) _phoneNumber = savedPhone;
      }
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
        if (_navIndex == 2 || _navIndex == 3) {
          _navKey.currentState!.pushReplacement(_slideRoute(_buildUpdates(), '/updates'));
        } else {
          _push(_buildUpdates(), '/updates');
        }
        break;
      case 2:
        if (_navIndex == 1 || _navIndex == 3) {
          _navKey.currentState!.pushReplacement(_slideRoute(_buildSaved(), '/saved'));
        } else {
          _push(_buildSaved(), '/saved');
        }
        break;
      case 3:
        if (_navIndex == 1 || _navIndex == 2) {
          _navKey.currentState!.pushReplacement(_slideRoute(_buildProfile(), '/profile'));
        } else {
          _push(_buildProfile(), '/profile');
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
      setState(() {
        _isLoggedIn = true;
        _showBottomNav = true;
        _navIndex = 0;
      });
      _push(_buildHome(), '/home', clearStack: true);
    },
  );

  void _openSubject(String subject, String branch) {
    int year = 1;
    int semester = 1;
    String scheme = "K Scheme";
    List<String> subjects = [];
    final branchData = branchSemestersDb[branch];
    if (branchData != null) {
      branchData.forEach((sch, years) {
        years.forEach((y, sems) {
          sems.forEach((sem, subs) {
            if (subs.contains(subject)) {
              scheme = sch;
              year = y;
              semester = sem;
              subjects = subs;
            }
          });
        });
      });
    }
    setState(() {
      _selectedSubject = subject;
      _selectedBranch = branch;
      _selectedCourse = "Diploma";
      _selectedScheme = scheme;
      _selectedYear = year;
      _selectedSemester = semester;
      _selectedSemesterSubjects = subjects;
    });
    _push(_buildMaterials(), '/materials');
  }

  Widget _buildHome() => HomeView(
    userName: _userName,
    onCourseSelected: (course) {
      setState(() => _selectedCourse = course);
      _push(_buildChooseBranch(), '/choose_branch');
    },
    onAvatarTap: () {
      setState(() => _navIndex = 3);
      _push(_buildProfile(), '/profile');
    },
    onSubjectSelected: _openSubject,
  );

  Widget _buildChooseBranch() => BranchView(
    selectedCourse: _selectedCourse,
    onBack: () => _navKey.currentState!.pop(),
    onBranchSelected: (branch) {
      setState(() => _selectedBranch = branch);
      _push(_buildSchemeSelection(), '/scheme_select');
    },
  );

  Widget _buildSchemeSelection() => SchemeView(
    branchName: _selectedBranch,
    onBack: () => _navKey.currentState!.pop(),
    onSchemeSelected: (scheme) {
      setState(() => _selectedScheme = scheme);
      _push(_buildYearSemSelection(), '/year_sem_select');
    },
  );

  Widget _buildYearSemSelection() => YearSemView(
    branchName: _selectedBranch,
    scheme: _selectedScheme,
    onBack: () => _navKey.currentState!.pop(),
    onSemesterSelected: (year, semester, subjects) {
      setState(() {
        _selectedYear = year;
        _selectedSemester = semester;
        _selectedSemesterSubjects = subjects;
      });
      _push(_buildSubjects(), '/subjects');
    },
  );

  Widget _buildSubjects() => SubjectsView(
    selectedBranch: _selectedBranch,
    selectedScheme: _selectedScheme,
    selectedYear: _selectedYear,
    selectedSemester: _selectedSemester,
    subjects: _selectedSemesterSubjects,
    onBack: () => _navKey.currentState!.pop(),
    onSubjectSelected: (subject) {
      setState(() => _selectedSubject = subject);
      _push(_buildMaterials(), '/materials');
    },
  );

  Widget _buildMaterials() => MaterialsView(
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
  );

  Widget _buildProfile() => ProfileView(
    userName: _userName,
    phoneNumber: _phoneNumber,
    onBack: () => _navKey.currentState!.pop(),
    onUpdateName: (name) async {
      setState(() => _userName = name);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', name);
    },
    onAboutUsTap: () => _push(_buildAboutUs(), '/about'),
    onSettingsTap: () => _push(_buildSettings(), '/settings'),
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

  Widget _buildSettings() => SettingsView(
    isDarkMode: _isDarkMode,
    onThemeChanged: (isDark) async {
      setState(() {
        _isDarkMode = isDark;
        AppColors.isDark = isDark;
      });
      themeNotifier.value = isDark;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_dark_mode', isDark);
    },
    onBack: () => _navKey.currentState!.pop(),
  );

  Widget _buildUpdates() => const UpdatesView();

  Widget _buildSaved() => SavedView(
        savedSubjects: _bookmarkedSubjects,
        onSubjectSelected: (subject, branch) {
          // Instantly open the subject materials
          _openSubject(subject, branch);
        },
        onRemoveBookmark: (subject) {
          setState(() {
            _bookmarkedSubjects.remove(subject);
          });
        },
      );

  Widget _buildAboutUs() => AboutView(
    onBack: () => _navKey.currentState!.pop(),
  );

  @override
  Widget build(BuildContext context) {
    return ResponsiveDeviceFrame(
      showBottomNav: _showSplash ? false : _showBottomNav,
      navIndex: _navIndex,
      onNavTap: _onNavTap,
      // ── Animated cross-fade from splash to main navigation shell ──
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 600),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        child: _showSplash
            ? const SplashView(key: ValueKey('splash_screen'))
            : PopScope(
                key: const ValueKey('main_navigator'),
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
                          if (name == '/home') {
                            setState(() => _navIndex = 0);
                          } else if (name == '/updates') {
                            setState(() => _navIndex = 1);
                          } else if (name == '/saved') {
                            setState(() => _navIndex = 2);
                          } else if (name == '/profile') {
                            setState(() => _navIndex = 3);
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
      ),
    );
  }
}
