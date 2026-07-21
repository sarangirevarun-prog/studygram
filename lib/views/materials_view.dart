import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:study_gram/theme/colors.dart';


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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String urlString) async {
    final uri = Uri.parse(urlString);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Could not open: $urlString"),
            backgroundColor: AppColors.redDanger,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }

  String _getBranchCode(String branchName) {
    final lower = branchName.toLowerCase();
    if (lower.contains("computer")) return "CO";
    if (lower.contains("information")) return "IF";
    if (lower.contains("civil")) return "CE";
    if (lower.contains("mechanical")) return "ME";
    if (lower.contains("electrical")) return "EE";
    if (lower.contains("electronics")) return "EJ";
    if (lower.contains("chemical")) return "CH";
    if (branchName.length >= 2) {
      return branchName.substring(0, 2).toUpperCase();
    }
    return "SY";
  }

  void _simulateDownload(String noteTitle) {
    if (_isDownloaded[noteTitle] == true || _downloadProgress[noteTitle] != null) return;

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
        } else {
          _downloadProgress[noteTitle] = current + 0.1;
        }
      });
    });
  }

  void _playVideo(String title) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: AppColors.bgMain,
          insetPadding: EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 220,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  image: const DecorationImage(
                    image: NetworkImage("https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=500&auto=format&fit=crop"),
                    fit: BoxFit.cover,
                    opacity: 0.4,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.play_circle_outline_rounded, size: 64, color: AppColors.primaryLight),
                      SizedBox(height: 10),
                      Text(
                        "Streaming Lecture HD...",
                        style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Comprehensive topic details, reference papers, and lectures covering core modules of ${widget.subject}.",
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("Close Player", style: TextStyle(color: AppColors.redDanger)),
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
    return SafeArea(
      child: Column(
        children: [
          // App bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: widget.onBack,
                      icon: Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                    SizedBox(width: 12),
                    Text(
                      widget.subject,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: widget.onBookmarkToggle,
                  icon: Icon(
                    widget.isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                    color: widget.isBookmarked ? AppColors.primaryLight : AppColors.textPrimary,
                    size: 24,
                  ),
                )
              ],
            ),
          ),
          // Custom TabBar with label and indicator padding adjustments
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.primaryLight,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primaryLight,
              indicatorSize: TabBarIndicatorSize.tab,
              labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              tabs: const [
                Tab(text: "Syllabus"),
                Tab(text: "Notes"),
                Tab(text: "Videos"),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSyllabusTab(),
                _buildNotesTab(),
                _buildVideosTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSyllabusTab() {
    final branchCode = _getBranchCode(widget.branch);
    final schemeChar = widget.scheme.isNotEmpty ? widget.scheme[0].toUpperCase() : 'K';
    final semesterDoc = "$branchCode${widget.semester}$schemeChar"; // e.g. CO5K

    final subjectSyllabusTitle = "${widget.subject} Syllabus PDF (Official)";
    final progress = _downloadProgress[subjectSyllabusTitle];
    final downloaded = _isDownloaded[subjectSyllabusTitle] == true;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Header Section Banner
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
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Official curriculum search, e-content and syllabus portals",
                      style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Section Title: Subject-specific Document
        Text(
          "Subject Syllabus",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 12),

        // Subject Syllabus Document Card
        Container(
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
                      "${widget.subject} Official Syllabus",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
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
                        downloaded ? "PDF Downloaded" : "PDF File Size: 1.4 MB",
                        style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (progress != null)
                SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(AppColors.primaryLight)),
                )
              else
                IconButton(
                  onPressed: () => _simulateDownload(subjectSyllabusTitle),
                  icon: Icon(
                    downloaded ? Icons.check_circle_rounded : Icons.download_for_offline_outlined,
                    color: downloaded ? AppColors.primaryLight : AppColors.textSecondary,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Section Title: Semester-wide complete Syllabus
        Text(
          "Semester Syllabus",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 12),

        // Semester Syllabus Card
        Container(
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
                  color: AppColors.bluePale,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.folder_shared_outlined, color: AppColors.blueInfo, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$semesterDoc Syllabus PDF",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "All Subject Syllabus PDF for Sem ${widget.semester}",
                      style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => _launchUrl("https://msbte.org.in/portal/curriculum-search/"),
                icon: Icon(Icons.open_in_new_rounded, color: AppColors.blueInfo),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Section Title: Reference Links
        Text(
          "MSBTE Reference Portals",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 12),

        _buildPortalTile(
          title: "Official MSBTE Curriculum Search",
          subtitle: "MSBTE Curriculum Search (Official)",
          url: "https://msbte.org.in/portal/curriculum-search/",
          iconColor: AppColors.accent,
          icon: Icons.search_rounded,
        ),
        _buildPortalTile(
          title: "${widget.scheme} (Official MSBTE)",
          subtitle: "MSBTE ${widget.scheme} e-Content & Syllabus",
          url: "https://econtent.msbte.ac.in/",
          iconColor: AppColors.primary,
          icon: Icons.language_rounded,
        ),
        _buildPortalTile(
          title: "MSBTE Curriculum Search (Official)",
          subtitle: "Direct portal links & scheme resources",
          url: "https://econtent.msbte.ac.in/curriculum_search/",
          iconColor: AppColors.tealAccent,
          icon: Icons.find_in_page_rounded,
        ),
      ],
    );
  }

  Widget _buildPortalTile({
    required String title,
    required String subtitle,
    required String url,
    required Color iconColor,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderCard),
      ),
      child: ListTile(
        onTap: () => _launchUrl(url),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
        trailing: Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textMuted, size: 12),
      ),
    );
  }

  Widget _buildNotesTab() {
    final list = [
      "Unit 1: Fundamentals of ${widget.subject}",
      "Unit 2: Core & Advanced ${widget.subject} Concepts",
      "Unit 3: Theoretical Applications of ${widget.subject}",
      "Unit 4: Specialized Case Studies in ${widget.subject}",
      "Unit 5: Practical Lab & Reference Material",
    ];

    return ListView.builder(
      padding: EdgeInsets.all(20),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final title = list[index];
        final progress = _downloadProgress[title];
        final downloaded = _isDownloaded[title] == true;

        return Container(
          margin: EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderCard),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryPale,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.picture_as_pdf_outlined, color: AppColors.primaryLight, size: 20),
              ),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
                    ),
                    SizedBox(height: 4),
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
                        downloaded ? "PDF Downloaded" : "PDF File Size: 4.8 MB",
                        style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                      ),
                  ],
                ),
              ),
              SizedBox(width: 8),
              if (progress != null)
                SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(AppColors.primaryLight)),
                )
              else
                IconButton(
                  onPressed: () => _simulateDownload(title),
                  icon: Icon(
                    downloaded ? Icons.check_circle_rounded : Icons.download_for_offline_outlined,
                    color: downloaded ? AppColors.primaryLight : AppColors.textSecondary,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVideosTab() {
    final list = [
      "Introduction to ${widget.subject} Basics",
      "Deep Dive: Understanding ${widget.subject}",
      "Practical Industrial Applications & Examples",
      "Review: ${widget.subject} Advanced Tutorial",
    ];

    return ListView.builder(
      padding: EdgeInsets.all(20),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final title = list[index];

        return Container(
          margin: EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderCard),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Video Mock Thumbnail cover
              GestureDetector(
                onTap: () => _playVideo(title),
                child: Container(
                  height: 130,
                  decoration: BoxDecoration(
                    color: AppColors.bgMain,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    image: const DecorationImage(
                      image: NetworkImage("https://images.unsplash.com/photo-1542831371-29b0f74f9713?w=500&auto=format&fit=crop"),
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
                padding: EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.video_library_outlined, color: AppColors.textMuted, size: 12),
                        SizedBox(width: 4),
                        Text("18 mins video lecture", style: TextStyle(color: AppColors.textMuted, fontSize: 10)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}





