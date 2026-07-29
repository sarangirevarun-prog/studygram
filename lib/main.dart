import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:study_gram/firebase_options.dart';
import 'package:study_gram/theme/colors.dart';
import 'package:study_gram/theme/l10n.dart';
import 'package:study_gram/services/update_service.dart';
import 'package:study_gram/widgets/device_frame.dart';
import 'package:study_gram/views/login_view.dart';
import 'package:study_gram/views/register_view.dart';
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
import 'package:study_gram/views/feedback_view.dart';
import 'package:study_gram/views/more_apps_view.dart';
import 'package:study_gram/models/branch_db.dart';
import 'package:study_gram/widgets/ak_floating_button.dart';
import 'package:study_gram/services/ak_assistant_service.dart';

final ValueNotifier<bool> themeNotifier = ValueNotifier(false);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Enable offline persistence & caching for smooth offline usability
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: themeNotifier,
      builder: (_, isDarkMode, child) {
        AppColors.isDark = isDarkMode;
        return MaterialApp(
      title: 'Studygram Education',
      debugShowCheckedModeBanner: false,
      themeAnimationDuration: Duration.zero,
      theme: ThemeData(
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        scaffoldBackgroundColor: AppColors.bgMain,
        fontFamily: 'Inter',
        useMaterial3: true,
        colorScheme: isDarkMode
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
          hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 16),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
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
  final ValueNotifier<String> _userNameNotifier = ValueNotifier<String>("Varun Sarangire");
  final ValueNotifier<String?> _userAvatarNotifier = ValueNotifier<String?>(null);
  String _phoneNumber    = "";
  String _selectedCourse = "Diploma";
  String _selectedBranch = "Computer Engineering";
  String _selectedScheme = "K Scheme";
  int    _selectedYear = 1;
  int    _selectedSemester = 1;
  List<String> _selectedSemesterSubjects = [];
  String _selectedSubject = "Java Programming";
  Set<String> _bookmarkedSubjects = {};

  // ── Persistent login status & theme fields ───────────────────────────────
  bool _isLoggedIn = false;
  bool _showSplash = true;
  bool _isDarkMode = false;
  bool _isAKAssistantEnabled = true;
  String _selectedLanguage = "English";
  SharedPreferences? _prefs;

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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final context = _navKey.currentContext;
        if (context != null && mounted) {
          UpdateService.checkForUpdates(context, silent: true);
        }
      });
    }
  }

  Future<void> _loadLoginStatus() async {
    _prefs = await SharedPreferences.getInstance();
    final prefs = _prefs!;
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    final savedName = prefs.getString('user_name');
    final savedPhone = prefs.getString('phone_number');
    final savedTheme = prefs.getBool('is_dark_mode') ?? false;
    final savedAkEnabled = prefs.getBool('is_ak_assistant_enabled') ?? true;
    final savedLang = prefs.getString('app_language') ?? 'English';
    setState(() {
      _isLoggedIn = isLoggedIn;
      _isDarkMode = savedTheme;
      _isAKAssistantEnabled = savedAkEnabled;
      _selectedLanguage = savedLang;
      AppColors.isDark = savedTheme;
      themeNotifier.value = savedTheme;
      AppStrings.languageNotifier.value = savedLang;
      if (savedName != null) _userNameNotifier.value = savedName;
      if (isLoggedIn) {
        _showBottomNav = true;
        _navIndex = 0;
        if (savedPhone != null) _phoneNumber = savedPhone;
      }
    });
    if (isLoggedIn) {
      final userKey = _getUserStorageKey();
      final savedAvatar = prefs.getString('user_avatar_$userKey') ?? prefs.getString('user_avatar');
      _userAvatarNotifier.value = savedAvatar;
      await _loadUserBookmarks();
      await _loadUserAvatarCloud();
    } else {
      await _loadUserBookmarks();
    }
  }

  String _getUserStorageKey() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null && uid.isNotEmpty) {
      return uid;
    }
    if (_phoneNumber.isNotEmpty) {
      return _phoneNumber.replaceAll(RegExp(r'[^a-zA-Z0-9_\-]'), '_');
    }
    return 'default_user';
  }

  Future<void> _loadUserBookmarks() async {
    final userKey = _getUserStorageKey();
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    _prefs = prefs;

    // Load locally saved bookmarks per user
    final savedList = prefs.getStringList('saved_subjects_$userKey') ?? prefs.getStringList('saved_subjects') ?? [];
    Set<String> loaded = savedList.toSet();

    if (mounted) {
      setState(() {
        _bookmarkedSubjects = loaded;
      });
    }

    // Sync with Firestore if authenticated user
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (doc.exists && doc.data() != null) {
          final data = doc.data()!;
          if (data.containsKey('saved_subjects') && data['saved_subjects'] is List) {
            final firestoreList = List<String>.from(data['saved_subjects']);
            final firestoreSet = firestoreList.toSet();
            await prefs.setStringList('saved_subjects_$userKey', firestoreSet.toList());
            if (mounted) {
              setState(() {
                _bookmarkedSubjects = firestoreSet;
              });
            }
          }
        }
      } catch (e) {
        debugPrint("Error loading user bookmarks from Firestore: $e");
      }
    }
  }

  Future<void> _saveUserBookmarks() async {
    final userKey = _getUserStorageKey();
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    _prefs = prefs;
    final list = _bookmarkedSubjects.toList();
    await prefs.setStringList('saved_subjects_$userKey', list);

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'saved_subjects': list,
        }, SetOptions(merge: true));
      } catch (e) {
        debugPrint("Error saving user bookmarks to Firestore: $e");
      }
    }
  }

  Future<void> _loadUserAvatarCloud() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (doc.exists && doc.data() != null) {
          final data = doc.data()!;
          if (data.containsKey('avatar_url') && data['avatar_url'] is String) {
            final cloudAvatar = data['avatar_url'] as String;
            _userAvatarNotifier.value = cloudAvatar;
            final prefs = _prefs ?? await SharedPreferences.getInstance();
            await prefs.setString('user_avatar_${user.uid}', cloudAvatar);
          }
        }
      } catch (e) {
        debugPrint("Error loading user avatar from Firestore: $e");
      }
    }
  }

  Future<void> _updateUserAvatar(String? avatar) async {
    _userAvatarNotifier.value = avatar;
    final userKey = _getUserStorageKey();
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    _prefs = prefs;

    if (avatar != null && avatar.isNotEmpty) {
      await prefs.setString('user_avatar_$userKey', avatar);
    } else {
      await prefs.remove('user_avatar_$userKey');
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'avatar_url': avatar,
        }, SetOptions(merge: true));
      } catch (e) {
        debugPrint("Error updating user avatar in Firestore: $e");
      }
    }
  }

  // ── Helper: slide push & safe pop ──────────────────────────────────────────
  void _safePop() {
    final nav = _navKey.currentState;
    if (nav != null && nav.canPop()) {
      nav.pop();
    }
  }

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
    final navigator = _navKey.currentState;
    if (navigator == null) return;

    if (index == _navIndex) {
      // Tapped the active tab: pop back to the root page of this tab
      if (index == 0) {
        navigator.popUntil((route) => route.isFirst);
      } else {
        String rootName = '/home';
        if (index == 1) rootName = '/updates';
        if (index == 2) rootName = '/saved';
        if (index == 3) rootName = '/profile';
        navigator.popUntil((route) => route.settings.name == rootName);
      }
      return;
    }

    switch (index) {
      case 0:
        // Pop back to the home page (root of the navigator stack when logged in)
        navigator.popUntil((route) => route.isFirst);
        break;
      case 1:
        if (_navIndex == 2 || _navIndex == 3) {
          navigator.pushReplacement(_slideRoute(_buildUpdates(), '/updates'));
        } else {
          _push(_buildUpdates(), '/updates');
        }
        break;
      case 2:
        if (_navIndex == 1 || _navIndex == 3) {
          navigator.pushReplacement(_slideRoute(_buildSaved(), '/saved'));
        } else {
          _push(_buildSaved(), '/saved');
        }
        break;
      case 3:
        if (_navIndex == 1 || _navIndex == 2) {
          navigator.pushReplacement(_slideRoute(_buildProfile(), '/profile'));
        } else {
          _push(_buildProfile(), '/profile');
        }
        break;
    }
  }

  // ── Screen builders ──────────────────────────────────────────────────────
  Widget _buildLogin() => LoginView(
        onEmailLoggedIn: (email, name) async {
          final prefs = _prefs ?? await SharedPreferences.getInstance();
          _prefs = prefs;
          await prefs.setBool('is_logged_in', true);
          await prefs.setString('user_name', name);
          await prefs.setString('phone_number', email);
          _userNameNotifier.value = name;
          setState(() {
            _phoneNumber = email;
            _isLoggedIn = true;
            _showBottomNav = true;
            _navIndex = 0;
          });
          await _loadUserBookmarks();
          _push(_buildHome(), '/home', clearStack: true);
          Future.delayed(const Duration(milliseconds: 600), () {
            final navContext = _navKey.currentContext;
            if (navContext != null && navContext.mounted) {
              // ignore: use_build_context_synchronously
              UpdateService.checkForUpdates(navContext, silent: true);
            }
          });
        },
        onCreateAccountTap: () {
          _push(_buildRegister(), '/register');
        },
      );

  Widget _buildRegister() => RegisterView(
        onEmailLoggedIn: (email, name) async {
          final prefs = _prefs ?? await SharedPreferences.getInstance();
          _prefs = prefs;
          await prefs.setBool('is_logged_in', true);
          await prefs.setString('user_name', name);
          await prefs.setString('phone_number', email);
          _userNameNotifier.value = name;
          setState(() {
            _phoneNumber = email;
            _isLoggedIn = true;
            _showBottomNav = true;
            _navIndex = 0;
          });
          await _loadUserBookmarks();
          _push(_buildHome(), '/home', clearStack: true);
          Future.delayed(const Duration(milliseconds: 600), () {
            final navContext = _navKey.currentContext;
            if (navContext != null && navContext.mounted) {
              // ignore: use_build_context_synchronously
              UpdateService.checkForUpdates(navContext, silent: true);
            }
          });
        },
        onBackToLoginTap: _safePop,
      );

  void _openSubject(
    String subject,
    String branch, {
    String? scheme,
    int? year,
    int? semester,
    List<String>? subjects,
  }) {
    int selectedYear = year ?? 1;
    int selectedSemester = semester ?? 1;
    String selectedScheme = scheme ?? "K Scheme";
    List<String> selectedSubjects = subjects ?? [];

    final cleanSub = subject.toLowerCase().trim();
    if (cleanSub == "basic science" || cleanSub == "applied science") {
      final isBasic = cleanSub == "basic science";
      final physicsName = isBasic ? "Basic Physics" : "Applied Physics";
      final chemistryName = isBasic ? "Basic Chemistry" : "Applied Chemistry";
      final context = _navKey.currentContext;
      if (context != null) {
        showModalBottomSheet(
          context: context,
          backgroundColor: AppColors.bgCard,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          builder: (ctx) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.borderCard,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Select $subject Module",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Choose which subject module you want to open:",
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.bgMain,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.borderCard),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        leading: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.bluePale,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.bolt_rounded, color: AppColors.blueInfo, size: 24),
                        ),
                        title: Text(
                          physicsName,
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                        subtitle: Text("Syllabus, Notes & Video Lectures", style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                        trailing: Icon(Icons.arrow_forward_ios_rounded, color: AppColors.blueInfo, size: 16),
                        onTap: () {
                          Navigator.pop(ctx);
                          _openSubject(
                            physicsName,
                            branch,
                            scheme: scheme,
                            year: year,
                            semester: semester,
                            subjects: subjects,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.bgMain,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.borderCard),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        leading: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.tealPale,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.science_rounded, color: AppColors.tealAccent, size: 24),
                        ),
                        title: Text(
                          chemistryName,
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                        subtitle: Text("Syllabus, Notes & Video Lectures", style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                        trailing: Icon(Icons.arrow_forward_ios_rounded, color: AppColors.tealAccent, size: 16),
                        onTap: () {
                          Navigator.pop(ctx);
                          _openSubject(
                            chemistryName,
                            branch,
                            scheme: scheme,
                            year: year,
                            semester: semester,
                            subjects: subjects,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
        return;
      }
    }

    if (scheme == null || year == null || semester == null || subjects == null || subjects.isEmpty) {
      final branchData = branchSemestersDb[branch];
      if (branchData != null) {
        bool found = false;
        branchData.forEach((sch, years) {
          if (found) return;
          years.forEach((y, sems) {
            if (found) return;
            sems.forEach((sem, subs) {
              if (found) return;
              if (subs.contains(subject)) {
                selectedScheme = sch;
                selectedYear = y;
                selectedSemester = sem;
                selectedSubjects = subs;
                found = true;
              }
            });
          });
        });
      }
    }

    setState(() {
      _selectedSubject = subject;
      _selectedBranch = branch;
      _selectedCourse = "Diploma";
      _selectedScheme = selectedScheme;
      _selectedYear = selectedYear;
      _selectedSemester = selectedSemester;
      _selectedSemesterSubjects = selectedSubjects;
    });
    _push(_buildMaterials(), '/materials');
  }

  Widget _buildHome() => HomeView(
    userNameNotifier: _userNameNotifier,
    userAvatarNotifier: _userAvatarNotifier,
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
    onBack: _safePop,
    onBranchSelected: (branch) {
      setState(() => _selectedBranch = branch);
      _push(_buildSchemeSelection(), '/scheme_select');
    },
  );

  Widget _buildSchemeSelection() => SchemeView(
    branchName: _selectedBranch,
    onBack: _safePop,
    onSchemeSelected: (scheme) {
      setState(() => _selectedScheme = scheme);
      _push(_buildYearSemSelection(), '/year_sem_select');
    },
  );

  Widget _buildYearSemSelection() => YearSemView(
    branchName: _selectedBranch,
    scheme: _selectedScheme,
    onBack: _safePop,
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
    onBack: _safePop,
    onSubjectSelected: (subject) {
      _openSubject(
        subject,
        _selectedBranch,
        scheme: _selectedScheme,
        year: _selectedYear,
        semester: _selectedSemester,
        subjects: _selectedSemesterSubjects,
      );
    },
  );

  Widget _buildMaterials() {
    final bookmarkKey = "$_selectedBranch|$_selectedScheme|$_selectedSemester|$_selectedSubject";
    return MaterialsView(
      subject: _selectedSubject,
      branch: _selectedBranch,
      scheme: _selectedScheme,
      semester: _selectedSemester,
      isBookmarked: _bookmarkedSubjects.contains(bookmarkKey),
      onBookmarkToggle: () async {
        setState(() {
          if (_bookmarkedSubjects.contains(bookmarkKey)) {
            _bookmarkedSubjects.remove(bookmarkKey);
          } else {
            _bookmarkedSubjects.add(bookmarkKey);
          }
        });
        await _saveUserBookmarks();
      },
      onBack: _safePop,
    );
  }

  Widget _buildProfile() => ProfileView(
        userNameNotifier: _userNameNotifier,
        userAvatarNotifier: _userAvatarNotifier,
        email: _phoneNumber,
        onBack: _safePop,
    onUpdateName: (name) async {
      _userNameNotifier.value = name;
      final prefs = _prefs ?? await SharedPreferences.getInstance();
      _prefs = prefs;
      await prefs.setString('user_name', name);
    },
    onUpdateAvatar: _updateUserAvatar,
    onAboutUsTap: () => _push(_buildAboutUs(), '/about'),
    onSuggestionTap: () => _push(_buildSuggestion(), '/suggestion'),
    onMoreAppsTap: () => _push(_buildMoreApps(), '/more_apps'),
    onSettingsTap: () => _push(_buildSettings(), '/settings'),
    onLogout: () async {
      try {
        await FirebaseAuth.instance.signOut();
      } catch (_) {}
      final prefs = _prefs ?? await SharedPreferences.getInstance();
      _prefs = prefs;
      await prefs.clear();
      setState(() {
        _isLoggedIn = false;
        _showBottomNav = false;
        _navIndex = 0;
        _bookmarkedSubjects = {};
        _userAvatarNotifier.value = null;
      });
      _push(_buildLogin(), '/login', clearStack: true);
    },
  );

  Widget _buildSettings() => SettingsView(
    isDarkMode: _isDarkMode,
    selectedLanguage: _selectedLanguage,
    isAKAssistantEnabled: _isAKAssistantEnabled,
    onThemeChanged: (isDark) {
      AppColors.isDark = isDark;
      themeNotifier.value = isDark;
      setState(() {
        _isDarkMode = isDark;
      });
      SharedPreferences.getInstance().then((prefs) {
        _prefs = prefs;
        prefs.setBool('is_dark_mode', isDark);
      });
    },
    onLanguageChanged: (lang) async {
      setState(() {
        _selectedLanguage = lang;
      });
      AppStrings.languageNotifier.value = lang;
      final prefs = _prefs ?? await SharedPreferences.getInstance();
      _prefs = prefs;
      await prefs.setString('app_language', lang);
    },
    onAKAssistantChanged: (enabled) async {
      setState(() {
        _isAKAssistantEnabled = enabled;
      });
      final prefs = _prefs ?? await SharedPreferences.getInstance();
      _prefs = prefs;
      await prefs.setBool('is_ak_assistant_enabled', enabled);
    },
    onBack: _safePop,
  );

  Widget _buildUpdates() => UpdatesView(onBack: _safePop);

  Widget _buildSaved() => SavedView(
        savedSubjects: _bookmarkedSubjects,
        onSubjectSelected: (key) {
          final parts = key.split('|');
          if (parts.length == 4) {
            final branch = parts[0];
            final scheme = parts[1];
            final semStr = parts[2];
            final subject = parts[3];

            final sem = int.tryParse(semStr) ?? 1;
            final year = (sem <= 2) ? 1 : ((sem <= 4) ? 2 : 3);

            // Fetch the subjects list for this semester to populate _selectedSemesterSubjects
            List<String> subjects = [];
            final branchData = branchSemestersDb[branch];
            if (branchData != null) {
              final schemeData = branchData[scheme];
              if (schemeData != null) {
                final yearData = schemeData[year];
                if (yearData != null) {
                  subjects = yearData[sem] ?? [];
                }
              }
            }

            _openSubject(
              subject,
              branch,
              scheme: scheme,
              year: year,
              semester: sem,
              subjects: subjects,
            );
          } else {
            // Fallback for legacy key
            final branch = _findBranchForLegacySubject(key);
            _openSubject(key, branch);
          }
        },
        onRemoveBookmark: (key) async {
          setState(() {
            _bookmarkedSubjects.remove(key);
          });
          await _saveUserBookmarks();
        },
      );

  String _findBranchForLegacySubject(String subject) {
    for (final entry in branchSubjectsDb.entries) {
      if (entry.value.contains(subject)) {
        return entry.key;
      }
    }
    return "Computer Engineering";
  }

  Widget _buildAboutUs() => AboutView(
        userNameNotifier: _userNameNotifier,
        userAvatarNotifier: _userAvatarNotifier,
        onBack: _safePop,
      );

  Widget _buildSuggestion() => FeedbackView(
        userEmail: _phoneNumber,
        userName: _userNameNotifier.value,
        onBack: _safePop,
      );

  Widget _buildMoreApps() => MoreAppsView(
        onBack: _safePop,
      );

  void _executeAKAction(AKAction action) {
    switch (action.type) {
      case AKActionType.navigateHome:
        _onNavTap(0);
        break;
      case AKActionType.navigateUpdates:
        _onNavTap(1);
        break;
      case AKActionType.navigateSaved:
        _onNavTap(2);
        break;
      case AKActionType.navigateProfile:
        _onNavTap(3);
        break;
      case AKActionType.navigateSettings:
        _push(_buildSettings(), '/settings');
        break;
      case AKActionType.navigateAbout:
        _push(_buildAboutUs(), '/about');
        break;
      case AKActionType.navigateFeedback:
        _push(_buildSuggestion(), '/suggestion');
        break;
      case AKActionType.navigateScheme:
        _push(_buildSchemeSelection(), '/scheme_select');
        break;
      case AKActionType.navigateBranch:
        _push(_buildChooseBranch(), '/choose_branch');
        break;
      case AKActionType.navigateSubjects:
        _push(_buildSubjects(), '/subjects');
        break;
      case AKActionType.navigateMaterials:
        _push(_buildMaterials(), '/materials');
        break;
      case AKActionType.toggleTheme:
        final newDark = !_isDarkMode;
        setState(() {
          _isDarkMode = newDark;
          AppColors.isDark = newDark;
        });
        themeNotifier.value = newDark;
        if (_prefs != null) {
          _prefs!.setBool('is_dark_mode', newDark);
        }
        break;
      case AKActionType.setCourse:
        if (action.parameter != null) {
          setState(() {
            _selectedCourse = action.parameter!;
          });
          _push(_buildChooseBranch(), '/choose_branch');
        }
        break;
      case AKActionType.setBranch:
        if (action.parameter != null) {
          setState(() {
            _selectedBranch = action.parameter!;
          });
          _push(_buildSchemeSelection(), '/scheme_select');
        }
        break;
      case AKActionType.setScheme:
        if (action.parameter != null) {
          setState(() {
            _selectedScheme = action.parameter!;
          });
          _push(_buildYearSemSelection(), '/year_sem_select');
        }
        break;
      case AKActionType.searchSubject:
        final currentBranchSubjects = branchSubjectsDb[_selectedBranch] ?? [];
        if (action.parameter != null && action.parameter!.trim().isNotEmpty) {
          final queryStr = action.parameter!.trim().toLowerCase();

          // Search if query matches any subject in CURRENT selected branch first!
          String? matchedSubject;
          for (final sub in currentBranchSubjects) {
            if (sub.toLowerCase().contains(queryStr)) {
              matchedSubject = sub;
              break;
            }
          }

          if (matchedSubject != null) {
            _openSubject(matchedSubject, _selectedBranch);
          } else {
            // Fallback for cross-branch search
            final foundBranch = _findBranchForLegacySubject(action.parameter!);
            _openSubject(action.parameter!, foundBranch);
          }
        } else {
          // Empty parameter: open active selected branch's first subject
          final defaultSub = currentBranchSubjects.isNotEmpty ? currentBranchSubjects.first : "Java Programming";
          _openSubject(defaultSub, _selectedBranch);
        }
        break;
      case AKActionType.none:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appContextData = {
      'userName': _userNameNotifier.value,
      'course': _selectedCourse,
      'branch': _selectedBranch,
      'scheme': _selectedScheme,
      'isDarkMode': _isDarkMode,
    };

    return ValueListenableBuilder<String>(
      valueListenable: AppStrings.languageNotifier,
      builder: (context, currentLang, child) {
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
                    child: Stack(
                      children: [
                        Navigator(
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
                        if (_isLoggedIn && _isAKAssistantEnabled)
                          AKFloatingButton(
                            appContext: appContextData,
                            onExecuteAction: _executeAKAction,
                          ),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}
