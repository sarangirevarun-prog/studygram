import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

enum AKActionType {
  navigateHome,
  navigateUpdates,
  navigateSaved,
  navigateProfile,
  navigateSettings,
  navigateAbout,
  navigateFeedback,
  navigateScheme,
  navigateBranch,
  navigateSubjects,
  navigateMaterials,
  toggleTheme,
  setCourse,
  setBranch,
  setScheme,
  searchSubject,
  none,
}

class AKAction {
  final AKActionType type;
  final String? parameter;
  final String description;

  AKAction({
    required this.type,
    this.parameter,
    required this.description,
  });
}

class AKMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final AKAction? action;

  AKMessage({
    required this.text,
    required this.isUser,
    DateTime? timestamp,
    this.action,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'text': text,
        'isUser': isUser,
        'timestamp': timestamp.toIso8601String(),
      };

  factory AKMessage.fromJson(Map<String, dynamic> json) => AKMessage(
        text: json['text'] ?? '',
        isUser: json['isUser'] ?? false,
        timestamp: json['timestamp'] != null ? DateTime.tryParse(json['timestamp']) ?? DateTime.now() : DateTime.now(),
      );
}

class AKResponse {
  final String text;
  final AKAction? action;

  AKResponse({required this.text, this.action});
}

class AKAssistantService {
  static final AKAssistantService _instance = AKAssistantService._internal();
  factory AKAssistantService() => _instance;
  AKAssistantService._internal();

  static const String _apiKeyPrefKey = 'ak_gemini_api_key';
  static const String _chatHistoryPrefKey = 'ak_saved_chat_history_v1';
  String? _geminiApiKey;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _geminiApiKey = prefs.getString(_apiKeyPrefKey);
  }

  Future<String?> getApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    _geminiApiKey = prefs.getString(_apiKeyPrefKey);
    return _geminiApiKey;
  }

  Future<void> setApiKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    _geminiApiKey = key.trim();
    if (_geminiApiKey!.isEmpty) {
      await prefs.remove(_apiKeyPrefKey);
      _geminiApiKey = null;
    } else {
      await prefs.setString(_apiKeyPrefKey, _geminiApiKey!);
    }
  }

  /// Save last 3 chat turns (last 6 messages max)
  Future<void> saveChatHistory(List<AKMessage> messages) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final validMsgs = messages.where((m) => m.text != "How can I help you?").toList();
      final recent = validMsgs.length > 6 ? validMsgs.sublist(validMsgs.length - 6) : validMsgs;
      final encoded = jsonEncode(recent.map((m) => m.toJson()).toList());
      await prefs.setString(_chatHistoryPrefKey, encoded);
    } catch (e) {
      debugPrint("Error saving chat history: $e");
    }
  }

  /// Load last 3 saved chat turns
  Future<List<AKMessage>> loadChatHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rawJson = prefs.getString(_chatHistoryPrefKey);
      if (rawJson != null && rawJson.isNotEmpty) {
        final List list = jsonDecode(rawJson);
        return list.map((e) => AKMessage.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      debugPrint("Error loading chat history: $e");
    }
    return [];
  }

  /// Clear saved chat history
  Future<void> clearChatHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_chatHistoryPrefKey);
    } catch (e) {
      debugPrint("Error clearing chat history: $e");
    }
  }

  /// Process input query from Voice or Text with last 3 chat context
  Future<AKResponse> processQuery(String input, Map<String, dynamic> appContext, [List<AKMessage>? history]) async {
    final query = input.trim();
    if (query.isEmpty) {
      return AKResponse(text: "Hello! I am AK, your Studygram AI Assistant. How can I help you today?");
    }

    final lower = query.toLowerCase();

    // 1. Check for In-App Navigation & Control Commands
    final actionResponse = _detectAppCommand(lower, query, appContext);
    if (actionResponse != null) {
      return actionResponse;
    }

    // 2. Use Gemini API if Key is provided
    if (_geminiApiKey != null && _geminiApiKey!.isNotEmpty) {
      try {
        final geminiText = await _callGeminiApi(query, appContext, history);
        if (geminiText != null && geminiText.isNotEmpty) {
          return AKResponse(text: geminiText);
        }
      } catch (e) {
        debugPrint("Gemini API call error: $e");
      }
    }

    // 3. Smart Built-in Fallback Engine (Offline & Default)
    final smartResponse = _generateSmartResponse(lower, query, appContext);
    return AKResponse(text: smartResponse);
  }

  AKResponse? _detectAppCommand(String lower, String originalQuery, Map<String, dynamic> context) {
    final branch = context['branch'] ?? 'Computer Engineering';

    // Theme switching
    if (lower.contains("dark mode") || lower.contains("night mode") || lower.contains("light mode") || lower.contains("toggle theme") || lower.contains("change theme")) {
      return AKResponse(
        text: "Sure! Switching app theme for you now 🌙",
        action: AKAction(type: AKActionType.toggleTheme, description: "Toggled theme"),
      );
    }

    // Navigation - Profile
    if (lower.contains("profile") || lower.contains("my account") || lower.contains("my details") || lower.contains("open profile")) {
      return AKResponse(
        text: "Opening your Profile view...",
        action: AKAction(type: AKActionType.navigateProfile, description: "Navigated to Profile"),
      );
    }

    // Navigation - Saved
    if (lower.contains("saved") || lower.contains("bookmarks") || lower.contains("bookmarked") || lower.contains("my saved subjects")) {
      return AKResponse(
        text: "Opening your Saved Subjects list...",
        action: AKAction(type: AKActionType.navigateSaved, description: "Navigated to Saved Subjects"),
      );
    }

    // Navigation - Updates
    if (lower.contains("updates") || lower.contains("news") || lower.contains("announcements") || lower.contains("latest updates")) {
      return AKResponse(
        text: "Opening Latest Updates page...",
        action: AKAction(type: AKActionType.navigateUpdates, description: "Navigated to Updates"),
      );
    }

    // Navigation - Settings
    if (lower.contains("settings") || lower.contains("preferences") || lower.contains("open settings")) {
      return AKResponse(
        text: "Opening App Settings...",
        action: AKAction(type: AKActionType.navigateSettings, description: "Navigated to Settings"),
      );
    }

    // Navigation - About Us
    if (lower.contains("about") || lower.contains("who made studygram") || lower.contains("app info")) {
      return AKResponse(
        text: "Opening About Studygram...",
        action: AKAction(type: AKActionType.navigateAbout, description: "Navigated to About Us"),
      );
    }

    // Navigation - Feedback
    if (lower.contains("feedback") || lower.contains("report bug") || lower.contains("send feedback") || lower.contains("contact us")) {
      return AKResponse(
        text: "Opening Feedback screen...",
        action: AKAction(type: AKActionType.navigateFeedback, description: "Navigated to Feedback"),
      );
    }

    // Navigation - Home
    if (lower.contains("go home") || lower.contains("open home") || lower.contains("main screen") || lower.contains("home page")) {
      return AKResponse(
        text: "Taking you back to Home screen...",
        action: AKAction(type: AKActionType.navigateHome, description: "Navigated to Home"),
      );
    }

    // Navigation - Scheme selection
    if (lower.contains("scheme") || lower.contains("k scheme") || lower.contains("i scheme") || lower.contains("g scheme")) {
      String? targetScheme;
      if (lower.contains("k scheme") || lower.contains("k-scheme")) targetScheme = "K Scheme";
      if (lower.contains("i scheme") || lower.contains("i-scheme")) targetScheme = "I Scheme";
      if (lower.contains("g scheme") || lower.contains("g-scheme")) targetScheme = "G Scheme";

      if (targetScheme != null) {
        return AKResponse(
          text: "Selecting $targetScheme for your curriculum!",
          action: AKAction(type: AKActionType.setScheme, parameter: targetScheme, description: "Selected $targetScheme"),
        );
      } else {
        return AKResponse(
          text: "Opening Scheme Selection page...",
          action: AKAction(type: AKActionType.navigateScheme, description: "Navigated to Scheme View"),
        );
      }
    }

    // Navigation - Branch selection
    if (lower.contains("computer") || lower.contains("civil") || lower.contains("mechanical") || lower.contains("electrical") || lower.contains("entc") || lower.contains("electronics")) {
      String? branch;
      if (lower.contains("computer")) {
        branch = "Computer Engineering";
      } else if (lower.contains("civil")) {
        branch = "Civil Engineering";
      } else if (lower.contains("mechanical")) {
        branch = "Mechanical Engineering";
      } else if (lower.contains("electrical")) {
        branch = "Electrical Engineering";
      } else if (lower.contains("entc") || lower.contains("electronics")) {
        branch = "ENTC";
      }

      if (branch != null) {
        return AKResponse(
          text: "Selecting $branch branch for you...",
          action: AKAction(type: AKActionType.setBranch, parameter: branch, description: "Selected $branch"),
        );
      }
    }

    // Course selection (Diploma / Degree)
    if (lower.contains("diploma") || lower.contains("degree") || lower.contains("b.tech") || lower.contains("btech")) {
      String course = lower.contains("degree") || lower.contains("b.tech") || lower.contains("btech") ? "Degree" : "Diploma";
      return AKResponse(
        text: "Switching course to $course...",
        action: AKAction(type: AKActionType.setCourse, parameter: course, description: "Selected $course"),
      );
    }

    // Navigation - Open Notes, Video Lectures, Syllabus, Materials & Sections
    if (lower.contains("notes") ||
        lower.contains("video") ||
        lower.contains("lecture") ||
        lower.contains("material") ||
        lower.contains("syllabus") ||
        lower.contains("paper") ||
        lower.contains("section") ||
        lower.contains("subject") ||
        lower.contains("java") ||
        lower.contains("python") ||
        lower.contains("math") ||
        lower.contains("c++") ||
        lower.contains("c programming")) {

      // Generic open notes/videos/section command without a specific subject name
      final isGenericOpen = (lower == "open notes" ||
          lower == "notes" ||
          lower == "open video" ||
          lower == "open videos" ||
          lower == "video lectures" ||
          lower == "open video lectures" ||
          lower == "show videos" ||
          lower == "open section" ||
          lower == "open materials" ||
          lower == "study materials" ||
          lower == "show notes");

      if (isGenericOpen) {
        return AKResponse(
          text: "Opening Notes & Video Lectures section for you...",
          action: AKAction(type: AKActionType.navigateMaterials, description: "Opened Notes & Video Lectures"),
        );
      }

      // Subject-specific notes or video request
      String queryClean = originalQuery
          .replaceAll(RegExp(r'(open|show|find|search|notes|and|video|videos|lecture|lectures|section|sections|for|materials|syllabus|get|subjects|paper|papers)', caseSensitive: false), '')
          .trim();

      if (queryClean.isEmpty) {
        return AKResponse(
          text: "Opening Notes & Video Lectures for $branch...",
          action: AKAction(type: AKActionType.searchSubject, parameter: "", description: "Opened $branch Notes & Videos"),
        );
      }

      return AKResponse(
        text: "Opening Notes & Video Lectures for '$queryClean' ($branch)...",
        action: AKAction(type: AKActionType.searchSubject, parameter: queryClean, description: "Opened $queryClean Notes & Videos"),
      );
    }

    return null;
  }

  Future<String?> _callGeminiApi(String userPrompt, Map<String, dynamic> context, [List<AKMessage>? history]) async {
    final keyToUse = (_geminiApiKey != null && _geminiApiKey!.isNotEmpty)
        ? _geminiApiKey!
        : ""; // Use stored key if available

    if (keyToUse.isEmpty) return null;

    final url = Uri.parse("https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$keyToUse");

    final systemContext = """
You are AK, an intelligent AI Virtual Assistant in the 'Studygram' mobile learning app.
App Overview:
- Name: Studygram Education App
- Target Users: Engineering & Diploma Students (MSBTE, AICTE, Tech Degree/Diploma).
- Current Context: Course: ${context['course'] ?? 'Diploma'}, Branch: ${context['branch'] ?? 'Computer Engineering'}, Scheme: ${context['scheme'] ?? 'K Scheme'}.

Instructions:
- Provide direct, concise, accurate, and ultra-fast answers.
- Use clean Markdown formatting.
- Do not mention internal device names or system debug specs.
""";

    final List<Map<String, dynamic>> contents = [
      {
        "role": "user",
        "parts": [
          {"text": systemContext}
        ]
      }
    ];

    if (history != null && history.isNotEmpty) {
      final validMsgs = history.where((m) => m.text != "How can I help you?").toList();
      final recent = validMsgs.length > 6 ? validMsgs.sublist(validMsgs.length - 6) : validMsgs;
      for (final msg in recent) {
        contents.add({
          "role": msg.isUser ? "user" : "model",
          "parts": [
            {"text": msg.text}
          ]
        });
      }
    }

    contents.add({
      "role": "user",
      "parts": [
        {"text": "User Query: $userPrompt"}
      ]
    });

    final body = jsonEncode({
      "contents": contents,
      "generationConfig": {
        "temperature": 0.7,
        "maxOutputTokens": 500,
      }
    });

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      ).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final text = json['candidates']?[0]?['content']?['parts']?[0]?['text'] as String?;
        return text;
      }
    } catch (e) {
      debugPrint("Gemini API call exception: $e");
    }
    return null;
  }

  String _generateSmartResponse(String lower, String originalQuery, Map<String, dynamic> context) {
    final branch = context['branch'] ?? 'Computer Engineering';
    final scheme = context['scheme'] ?? 'K Scheme';

    if (lower.contains("hi") || lower.contains("hello") || lower.contains("hey") || lower.contains("who are you")) {
      return "Hello!  I am **AK**, your AI Study & Voice Assistant. Ask me any study question, code explanation, math problem, or give me a command to navigate the app!";
    }

    if (lower.contains("what can you do") || lower.contains("help") || lower.contains("features") || lower.contains("commands")) {
      return """
I can help you with:

✨ **In-App Control Commands:**
• *"Go to Profile"* / *"Open Saved Subjects"*
• *"Open Settings"* / *"Latest Updates"*
• *"Toggle Dark Mode"* / *"Switch to K-Scheme"*
• *"Select Computer Engineering"*

📚 **Educational & Technical Help:**
• Explain any programming concept (Java, C, Python, Data Structures, DBMS, OS, Web Dev).
• Provide MSBTE Diploma & Engineering syllabus overviews.
• Solve engineering & math fundamentals (Derivatives, Integrals, Matrices, Algebra).
• Answer general science, technical, and study questions!
""";
    }

    // Programming & Computer Science
    if (lower.contains("data structure") || lower.contains("ds") || lower.contains("array") || lower.contains("linked list") || lower.contains("stack") || lower.contains("queue") || lower.contains("tree")) {
      return """
📊 **Data Structures Key Concepts**:
• **Linear Structures**:
  - **Array**: Fixed-size contiguous memory index.
  - **Linked List**: Dynamic nodes connected via pointers.
  - **Stack**: LIFO (Last In First Out) — operations: `push()`, `pop()`.
  - **Queue**: FIFO (First In First Out) — operations: `enqueue()`, `dequeue()`.
• **Non-Linear Structures**:
  - **Tree & Binary Search Tree (BST)**: Hierarchical node structures with root and child nodes.
  - **Graph**: Vertices and edges representing networks.

Say *"Search Data Structure notes"* to view study materials!
""";
    }

    if (lower.contains("database") || lower.contains("dbms") || lower.contains("sql")) {
      return """
🗄️ **Database Management System (DBMS) & SQL**:
• **Core Concepts**: ACID Properties (Atomicity, Consistency, Isolation, Durability).
• **Key Commands**:
  - `SELECT * FROM table WHERE condition;`
  - `INSERT INTO table VALUES (...);`
  - `UPDATE table SET col = val WHERE condition;`
  - `DELETE FROM table WHERE condition;`
• **Normalization**: 1NF, 2NF, 3NF, BCNF to remove data redundancy.

Say *"Search Database notes"* to view DBMS notes!
""";
    }

    if (lower.contains("operating system") || lower.contains("os") || lower.contains("process") || lower.contains("thread")) {
      return """
💻 **Operating System (OS) Fundamentals**:
• **Key Functions**: Process Management, Memory Management, File System, Deadlock Handling.
• **Process vs Thread**: A process is an executing program instance with isolated memory; a thread is a lightweight execution unit sharing process memory.
• **Deadlock Conditions**: Mutual Exclusion, Hold & Wait, No Preemption, Circular Wait.
""";
    }

    if (lower.contains("c programming") || lower.contains("c language") || lower.contains("pointer")) {
      return """
⚡ **C Programming & Pointers**:
• **Pointers**: Variables storing memory addresses (`int *ptr = &var;`).
• **Memory Allocation**: `malloc()`, `calloc()`, `realloc()`, `free()`.
• **Structures**: `struct Student { char name[50]; int roll; };`
""";
    }

    if (lower.contains("java") || lower.contains("object oriented") || lower.contains("oop")) {
      return """
💻 **Java & Object Oriented Programming (OOP)**:
• **4 Core Pillars**:
  1. **Encapsulation**: Hiding internal implementation using private fields and getters/setters.
  2. **Inheritance**: Subclass acquiring properties of superclass (`class B extends A`).
  3. **Polymorphism**: Method Overloading (compile-time) & Method Overriding (runtime).
  4. **Abstraction**: Hiding complexity via Abstract Classes and Interfaces.

Say *"Search Java notes"* to open Java study materials!
""";
    }

    if (lower.contains("python")) {
      return """
🐍 **Python Programming Essentials**:
• **Data Structures**: Lists `[]`, Tuples `()`, Dictionaries `{}`.
• **File I/O**: `with open("file.txt", "r") as f: content = f.read()`
• **Libraries**: NumPy, Pandas, Matplotlib, Flask, Django.
""";
    }

    // Mathematics & Engineering Science
    if (lower.contains("math") || lower.contains("calculus") || lower.contains("derivative") || lower.contains("integration") || lower.contains("matrix")) {
      return """
📐 **Engineering Mathematics Formulas**:
• **Derivatives**:
  - `d/dx(x^n) = n * x^(n-1)`
  - `d/dx(sin x) = cos x`, `d/dx(cos x) = -sin x`
• **Integrals**:
  - `∫ x^n dx = (x^(n+1))/(n+1) + C`
  - `∫ (1/x) dx = ln|x| + C`
• **Matrix Algebra**: Determinants, Inverse `A^(-1) = adj(A)/|A|`, Eigenvalues & Eigenvectors.
""";
    }

    // Electronics & Electrical
    if (lower.contains("circuit") || lower.contains("ohm") || lower.contains("voltage") || lower.contains("current") || lower.contains("electronics")) {
      return """
⚡ **Electrical & Electronics Basics**:
• **Ohm's Law**: `V = I * R` (Voltage = Current × Resistance).
• **Kirchhoff's Laws**:
  - **KCL**: Total current entering a junction equals total current leaving (`Σ I = 0`).
  - **KVL**: Sum of all voltages in a closed loop equals zero (`Σ V = 0`).
""";
    }

    if (lower.contains("k scheme") || lower.contains("k-scheme") || lower.contains("i scheme") || lower.contains("i-scheme")) {
      return """
📘 **MSBTE Curriculum Overview**:
The **K-Scheme** is the updated curriculum introduced by MSBTE for Diploma courses focusing on outcome-based education (OBE), practical laboratory experience, micro-projects, and modern skill building.

Current selected branch: **$branch ($scheme)**.
""";
    }

    if (lower.contains("exam") || lower.contains("study tip") || lower.contains("pass") || lower.contains("marks")) {
      return """
🎯 **Top Exam Preparation Tips for MSBTE / Engineering**:
1. **Solve Past 3 Years Papers**: 60%+ questions follow recurring concepts.
2. **Focus on Weightage**: Prioritize chapters with highest marks allocation first.
3. **Neat Diagrams**: Draw clear block diagrams and flowcharts in board exams!
4. **Time Management**: Allocate marks × 1.8 minutes per question.
""";
    }

    // Casual phrases & greetings
    if (lower == "by" || lower == "bye" || lower.contains("goodbye") || lower.contains("see you")) {
      return "Goodbye! Have a great time studying on Studygram! 👋";
    }

    if (lower.contains("thank") || lower == "thx") {
      return "You're welcome! Happy learning on Studygram! 📘✨";
    }

    if (lower == "ok" || lower == "okay" || lower == "sure" || lower == "cool" || lower == "got it") {
      return "Got it! Let me know if you need any study notes or app commands. 👍";
    }

    if (lower.contains("good morning")) {
      return "Good morning! Ready for some productive learning today? ☀️";
    }

    if (lower.contains("good night")) {
      return "Good night! Rest well and see you tomorrow! 🌙";
    }

    // Default clean AI response
    return """
I'm here to help with your branch **$branch ($scheme)**! 💡

• Ask me any programming or engineering question (Java, Python, C, Data Structures, DBMS, Math).
• Give me a command (*"Open Notes"*, *"Open Video Lectures"*, *"Go to Profile"*, *"Toggle Dark Mode"*).
""";
  }
}
