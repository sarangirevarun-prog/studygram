import 'dart:async';
import 'package:flutter/material.dart';
import 'package:study_gram/theme/colors.dart';


class MaterialsView extends StatefulWidget {
  final String subject;
  final bool isBookmarked;
  final VoidCallback onBookmarkToggle;
  final VoidCallback onBack;

  const MaterialsView({
    super.key,
    required this.subject,
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
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
          // Custom TabBar
          TabBar(
            controller: _tabController,
            labelColor: AppColors.primaryLight,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primaryLight,
            tabs: const [
              Tab(text: "Notes"),
              Tab(text: "Videos"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildNotesTab(),
                _buildVideosTab(),
              ],
            ),
          ),
        ],
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





