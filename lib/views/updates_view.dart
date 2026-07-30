import 'package:flutter/material.dart';
import 'package:study_gram/services/update_service.dart';
import 'package:study_gram/theme/colors.dart';
import 'package:study_gram/theme/l10n.dart';
import 'package:study_gram/widgets/pull_refresh.dart';
import 'package:study_gram/widgets/swipe_back.dart';

class UpdatesView extends StatefulWidget {
  final VoidCallback? onBack;

  const UpdatesView({
    super.key,
    this.onBack,
  });

  @override
  State<UpdatesView> createState() => _UpdatesViewState();
}

class _UpdatesViewState extends State<UpdatesView> {
  bool _isLoading = true;
  Map<String, dynamic>? _remoteData;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadUpdateStatus();
  }

  Future<void> _loadUpdateStatus() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      final data = await UpdateService.fetchLatestVersion();
      if (mounted) {
        setState(() {
          _remoteData = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Unable to fetch update status';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final int remoteCode = _remoteData != null
        ? (_remoteData!['version_code'] is int
            ? _remoteData!['version_code']
            : int.tryParse("${_remoteData!['version_code']}") ?? UpdateService.currentAppVersionCode)
        : UpdateService.currentAppVersionCode;
    final bool isUpdateAvailable = remoteCode > UpdateService.currentAppVersionCode;
    final String remoteName = _remoteData?['latest_version']?.toString() ?? UpdateService.currentAppVersionName;
    final String releaseNotes = _remoteData?['release_notes']?.toString() ?? 
        "• Added Share App via QR Scanner for instant downloads\n• Updated contact & support via Instagram (@s.gram2026)\n• Performance optimizations and smooth UI enhancements";
    final String apkUrl = _remoteData?['apk_url']?.toString() ?? "";

    return SwipeBackWrapper(
      child: ValueListenableBuilder<String>(
        valueListenable: AppStrings.languageNotifier,
        builder: (context, currentLang, _) {
          return Scaffold(
            backgroundColor: AppColors.bgMain,
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (widget.onBack != null) {
                              widget.onBack!();
                            } else if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            }
                          },
                          icon: Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
                          padding: EdgeInsets.zero,
                          alignment: Alignment.centerLeft,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.system_update_alt_rounded, color: AppColors.primaryLight, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          AppStrings.get('updates'),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: PullRefresh(
                      onRefresh: _loadUpdateStatus,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        children: [
                          // Status Card
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.bgCard,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isUpdateAvailable ? AppColors.primary : AppColors.borderCard,
                                width: isUpdateAvailable ? 2 : 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: _isLoading
                                ? const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 24),
                                    child: Center(child: CircularProgressIndicator()),
                                  )
                                : _errorMessage.isNotEmpty
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        child: Column(
                                          children: [
                                            Icon(Icons.error_outline_rounded, color: AppColors.textSecondary, size: 36),
                                            const SizedBox(height: 8),
                                            Text(_errorMessage, style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                                            const SizedBox(height: 12),
                                            OutlinedButton(onPressed: _loadUpdateStatus, child: const Text("Retry")),
                                          ],
                                        ),
                                      )
                                    : Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: isUpdateAvailable
                                                  ? AppColors.primaryPale
                                                  : AppColors.tealPale,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              isUpdateAvailable
                                                  ? Icons.new_releases_rounded
                                                  : Icons.check_circle_rounded,
                                              color: isUpdateAvailable
                                                  ? AppColors.primaryLight
                                                  : AppColors.tealAccent,
                                              size: 28,
                                            ),
                                          ),
                                          const SizedBox(width: 14),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  isUpdateAvailable
                                                      ? "New Update Available!"
                                                      : "App is Up to Date",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.textPrimary,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  isUpdateAvailable
                                                      ? "Version v$remoteName is ready to install"
                                                      : "Installed Version: v${UpdateService.currentAppVersionName}",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: AppColors.textSecondary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      if (isUpdateAvailable && apkUrl.isNotEmpty)
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton.icon(
                                            onPressed: () => UpdateService.launchApkDownload(apkUrl),
                                            icon: const Icon(Icons.download_rounded, color: Colors.white),
                                            label: Text("Download v$remoteName Now",
                                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: AppColors.primary,
                                              padding: const EdgeInsets.symmetric(vertical: 14),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(14),
                                              ),
                                            ),
                                          ),
                                        )
                                      else
                                        SizedBox(
                                          width: double.infinity,
                                          child: OutlinedButton.icon(
                                            onPressed: _loadUpdateStatus,
                                            icon: Icon(Icons.refresh_rounded, color: AppColors.textPrimary),
                                            label: Text("Check for Updates",
                                                style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                                            style: OutlinedButton.styleFrom(
                                              side: BorderSide(color: AppColors.borderCard),
                                              padding: const EdgeInsets.symmetric(vertical: 12),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(14),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                          ),
                          const SizedBox(height: 24),
                          // Release Notes Section
                          Text(
                            "What's New in v$remoteName",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.bgCard,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.borderCard),
                            ),
                            child: Text(
                              releaseNotes,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textPrimary,
                                height: 1.6,
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
