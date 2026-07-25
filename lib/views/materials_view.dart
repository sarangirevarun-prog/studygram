import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:study_gram/theme/colors.dart';
import 'package:study_gram/theme/l10n.dart';
import 'package:study_gram/widgets/pull_refresh.dart';

class MaterialsView extends StatefulWidget {
  final String subject;
  final String branch;
  final String scheme;
  final int semester;
  final bool isBookmarked;
  final VoidCallback onBookmarkToggle;
  final VoidCallback onBack;

  const MaterialsView({
    super.key,
    required this.subject,
    required this.branch,
    required this.scheme,
    required this.semester,
    required this.isBookmarked,
    required this.onBookmarkToggle,
    required this.onBack,
  });

  @override
  State<MaterialsView> createState() => _MaterialsViewState();
}

class _MaterialsViewState extends State<MaterialsView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Map<String, double> _downloadProgress = {};
  final Map<String, bool> _isDownloaded = {};

  static const String _githubJsonUrl = 
      "https://raw.githubusercontent.com/sarangirevarun-prog/StudyGram-database/main/materials.json";

  late Future<Map<String, dynamic>?> _materialsFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _materialsFuture = _fetchSubjectData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _materialsFuture = _fetchSubjectData();
    });
    try {
      await _materialsFuture;
    } catch (_) {}
  }

  Future<Map<String, dynamic>?> _fetchSubjectData() async {
    try {
      final response = await http.get(Uri.parse(_githubJsonUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> allData = jsonDecode(response.body);
        return allData[widget.subject] as Map<String, dynamic>?;
      }
    } catch (e) {
      debugPrint("Error fetching GitHub JSON: $e");
    }
    return null;
  }

  Future<void> _launchUrl(String urlString) async {
    if (urlString.isEmpty) return;
    final uri = Uri.parse(urlString);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Could not open link: $urlString"),
            backgroundColor: AppColors.redDanger,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }

  void _simulateDownload(String noteTitle, String pdfUrl) {
    if (_isDownloaded[noteTitle] == true || _downloadProgress[noteTitle] != null) {
      if (pdfUrl.isNotEmpty) _launchUrl(pdfUrl);
      return;
    }

    setState(() {
      _downloadProgress[noteTitle] = 0.0;
    });

    Timer.periodic(const Duration(milliseconds: 150), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        double current = _downloadProgress[noteTitle] ?? 0.0;
        if (current >= 1.0) {
          timer.cancel();
          _downloadProgress.remove(noteTitle);
          _isDownloaded[noteTitle] = true;
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Successfully downloaded $noteTitle!"),
              backgroundColor: AppColors.primary,
              duration: const Duration(seconds: 1),
            ),
          );

          if (pdfUrl.isNotEmpty) _launchUrl(pdfUrl);
        } else {
          _downloadProgress[noteTitle] = current + 0.1;
        }
      });
    });
  }

  void _playVideo(String title, String videoUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: AppColors.bgMain,
          insetPadding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 220,
                decoration: const BoxDecoration(
                  color: Color(0xFF1E293B),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  image: DecorationImage(
                    image: NetworkImage("https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=500&auto=format&fit=crop"),
                    fit: BoxFit.cover,
                    opacity: 0.4,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        iconSize: 64,
                        icon: Icon(Icons.play_circle_outline_rounded, color: AppColors.primaryLight),
                        onPressed: () {
                          Navigator.pop(context);
                          _launchUrl(videoUrl);
                        },
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Tap to open video link",
                        style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Comprehensive topic details, lectures, and reference material covering ${widget.subject}.",
                      style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("Close", style: TextStyle(color: AppColors.redDanger)),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            _launchUrl(videoUrl);
                          },
                          icon: const Icon(Icons.open_in_new, size: 16, color: Colors.white),
                          label: const Text("Open Link", style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppStrings.languageNotifier,
      builder: (context, currentLang, _) {
        return FutureBuilder<Map<String, dynamic>?>(
          future: _materialsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                backgroundColor: AppColors.bgMain,
                body: Center(child: CircularProgressIndicator(color: AppColors.primaryLight)),
              );
            }

            final subjectData = snapshot.data ?? {};
            final syllabusSection = (subjectData['syllabus_section'] as Map<String, dynamic>?) ?? {};
            final notesList = (subjectData['notes'] as List<dynamic>?) ?? [];
            final videosList = (subjectData['videos'] as List<dynamic>?) ?? [];

            return Scaffold(
              backgroundColor: AppColors.bgMain,
              body: SafeArea(
                child: Column(
                  children: [
                    // App Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: widget.onBack,
                                icon: Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                widget.subject,
                                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () {
                              widget.onBookmarkToggle();
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    !widget.isBookmarked
                                        ? "${widget.subject} saved to your Saved list!"
                                        : "${widget.subject} removed from Saved list",
                                  ),
                                  backgroundColor: !widget.isBookmarked ? AppColors.primary : AppColors.textSecondary,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                            icon: Icon(
                              widget.isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                              color: widget.isBookmarked ? AppColors.primaryLight : AppColors.textPrimary,
                              size: 24,
                            ),
                          )
                        ],
                      ),
                    ),

                    // Tab Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TabBar(
                        controller: _tabController,
                        labelColor: AppColors.primaryLight,
                        unselectedLabelColor: AppColors.textSecondary,
                        indicatorColor: AppColors.primaryLight,
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        tabs: [
                          Tab(text: AppStrings.get('syllabus')),
                          Tab(text: AppStrings.get('notes')),
                          Tab(text: AppStrings.get('videos')),
                        ],
                      ),
                    ),

                    // Tab View Content
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildSyllabusTab(syllabusSection),
                          _buildNotesTab(notesList),
                          _buildVideosTab(videosList),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Dynamic Syllabus Tab UI
  Widget _buildSyllabusTab(Map<String, dynamic> syllabusData) {
    final subjectSyllabus = syllabusData['subject_syllabus'] as Map<String, dynamic>? ?? {};
    final semSyllabus = syllabusData['semester_syllabus'] as Map<String, dynamic>? ?? {};
    final labManual = syllabusData['lab_manual'] as Map<String, dynamic>? ?? {};

    return PullRefresh(
      onRefresh: _handleRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        children: [
          // Header Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryPale.withValues(alpha: AppColors.isDark ? 0.35 : 0.8),
                  AppColors.bgCard,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.borderCard),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.menu_book_rounded, color: AppColors.primaryLight, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "MSBTE ${widget.scheme}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Official curriculum search, e-content and syllabus portals",
                        style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Section 1: Subject Syllabus
          Text(
            AppStrings.get('subjectSyllabus'),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 12),
          _buildSyllabusCard(
            title: subjectSyllabus['title'] ?? "${widget.subject} Official Syllabus",
            subtitle: subjectSyllabus['subtitle'] ?? "Official MSBTE Syllabus PDF",
            url: subjectSyllabus['url'] ?? "https://services.msbte.edu.in/scheme_digi/pdfdownload/download/",
            icon: Icons.picture_as_pdf_outlined,
            iconBg: AppColors.primaryPale,
            iconColor: AppColors.primaryLight,
          ),
          const SizedBox(height: 24),

          // Section 2: Semester Syllabus
          Text(
            AppStrings.get('semesterSyllabus'),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 12),
          _buildSyllabusCard(
            title: semSyllabus['title'] ?? "Semester ${widget.semester} Complete Syllabus PDF",
            subtitle: semSyllabus['subtitle'] ?? "All Subject Syllabus PDF for Sem ${widget.semester}",
            url: semSyllabus['url'] ?? "https://econtent.msbte.ac.in/curriculum_search/",
            icon: Icons.folder_shared_outlined,
            iconBg: AppColors.bluePale,
            iconColor: AppColors.blueInfo,
          ),
          const SizedBox(height: 24),

          // Section 3: Lab Manual
          Text(
            AppStrings.get('labManual'),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 12),
          _buildSyllabusCard(
            title: labManual['title'] ?? "${widget.subject} Lab Manual",
            subtitle: labManual['subtitle'] ?? "Official Practical & Lab Manual PDF",
            url: labManual['url'] ?? "https://drive.google.com/file/d/11z8TYg9oHOaQIQGd_RLdVZG0jQyoRQY7/view?usp=drivesdk",
            icon: Icons.assignment_outlined,
            iconBg: AppColors.accentPale,
            iconColor: AppColors.accent,
          ),
        ],
      ),
    );
  }

  // Reusable Syllabus Card helper
  Widget _buildSyllabusCard({
    required String title,
    required String subtitle,
    required String url,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
  }) {
    return GestureDetector(
      onTap: () => _launchUrl(url),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderCard),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () => _launchUrl(url),
              icon: Icon(Icons.open_in_new_rounded, color: iconColor),
            ),
          ],
        ),
      ),
    );
  }

  // Notes Tab UI
  // Notes Tab UI
  Widget _buildNotesTab(List<dynamic> notesList) {
    final List<dynamic> effectiveNotes = notesList.isNotEmpty
        ? notesList
        : [
            {
              "title": "Unit 1: Fundamentals of ${widget.subject}",
              "size": "4.5 MB",
              "url": "https://raw.githubusercontent.com/sarangirevarun-prog/StudyGram-database/main/pdfs/placeholder.pdf"
            },
            {
              "title": "Unit 2: Core & Advanced ${widget.subject} Concepts",
              "size": "5.2 MB",
              "url": "https://raw.githubusercontent.com/sarangirevarun-prog/StudyGram-database/main/pdfs/placeholder.pdf"
            },
            {
              "title": "Unit 3: Theoretical Applications of ${widget.subject}",
              "size": "3.8 MB",
              "url": "https://raw.githubusercontent.com/sarangirevarun-prog/StudyGram-database/main/pdfs/placeholder.pdf"
            },
            {
              "title": "Unit 4: Specialized Case Studies in ${widget.subject}",
              "size": "4.1 MB",
              "url": "https://raw.githubusercontent.com/sarangirevarun-prog/StudyGram-database/main/pdfs/placeholder.pdf"
            },
            {
              "title": "Unit 5: Practical Lab & Reference Material",
              "size": "6.0 MB",
              "url": "https://raw.githubusercontent.com/sarangirevarun-prog/StudyGram-database/main/pdfs/placeholder.pdf"
            },
          ];

    return PullRefresh(
      onRefresh: _handleRefresh,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        itemCount: effectiveNotes.length,
        itemBuilder: (context, index) {
          final item = effectiveNotes[index];
          final title = item['title'] ?? 'Unit Note';
          final pdfUrl = item['url'] ?? '';
          final size = item['size'] ?? 'PDF File Size: 4.8 MB';
          final progress = _downloadProgress[title];
          final downloaded = _isDownloaded[title] == true;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderCard),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryPale,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.picture_as_pdf_outlined, color: AppColors.primaryLight, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 4),
                      if (progress != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: AppColors.bgMain,
                            valueColor: AlwaysStoppedAnimation(AppColors.primaryLight),
                          ),
                        )
                      else
                        Text(
                          downloaded ? "PDF Downloaded" : size,
                          style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                if (progress != null)
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(AppColors.primaryLight),
                    ),
                  )
                else
                  IconButton(
                    onPressed: () => _simulateDownload(title, pdfUrl),
                    icon: Icon(
                      downloaded ? Icons.check_circle_rounded : Icons.download_for_offline_outlined,
                      color: downloaded ? AppColors.primaryLight : AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Videos Tab UI
  Widget _buildVideosTab(List<dynamic> videosList) {
    final List<dynamic> effectiveVideos = videosList.isNotEmpty
        ? videosList
        : [
            {
              "title": "Introduction to ${widget.subject} Basics",
              "duration": "18 mins video lecture",
              "url": "https://www.youtube.com/watch?v=eIrMbAQSU34",
              "thumbnail": "https://images.unsplash.com/photo-1542831371-29b0f74f9713?w=500&auto=format&fit=crop"
            },
            {
              "title": "Deep Dive: Understanding ${widget.subject}",
              "duration": "22 mins video lecture",
              "url": "https://www.youtube.com/watch?v=eIrMbAQSU34",
              "thumbnail": "https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=500&auto=format&fit=crop"
            },
            {
              "title": "Practical Industrial Applications & Examples",
              "duration": "25 mins video lecture",
              "url": "https://www.youtube.com/watch?v=eIrMbAQSU34",
              "thumbnail": "https://images.unsplash.com/photo-1522202176988-66273c2fd55f?w=500&auto=format&fit=crop"
            },
            {
              "title": "Review: ${widget.subject} Advanced Tutorial",
              "duration": "30 mins video lecture",
              "url": "https://www.youtube.com/watch?v=eIrMbAQSU34",
              "thumbnail": "https://images.unsplash.com/photo-1532094349884-543bc11b234d?w=500&auto=format&fit=crop"
            },
          ];

    return PullRefresh(
      onRefresh: _handleRefresh,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        itemCount: effectiveVideos.length,
        itemBuilder: (context, index) {
          final video = effectiveVideos[index];
          final title = video['title'] ?? 'Video Lecture';
          final duration = video['duration'] ?? '18 mins video lecture';
          final videoUrl = video['url'] ?? '';
          final thumbnail = video['thumbnail'] ?? "https://images.unsplash.com/photo-1542831371-29b0f74f9713?w=500&auto=format&fit=crop";

          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderCard),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Video Thumbnail
                GestureDetector(
                  onTap: () => _playVideo(title, videoUrl),
                  child: Container(
                    height: 130,
                    decoration: BoxDecoration(
                      color: AppColors.bgMain,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      image: DecorationImage(
                        image: NetworkImage(thumbnail),
                        fit: BoxFit.cover,
                        opacity: 0.3,
                      ),
                    ),
                    child: Center(
                      child: CircleAvatar(
                        backgroundColor: AppColors.primaryLight,
                        child: Icon(Icons.play_arrow_rounded, color: AppColors.textPrimary),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.video_library_outlined, color: AppColors.textMuted, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            duration,
                            style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}