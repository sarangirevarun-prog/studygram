import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:study_gram/theme/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateService {
  static const int currentAppVersionCode = 5;
  static const String currentAppVersionName = "1.0.4";
  
  // GitHub Raw JSON link for auto-updates
  static const String versionJsonUrl =
      "https://raw.githubusercontent.com/sarangirevarun-prog/studygram/main/app_version.json";

  /// Fetch the remote version info from GitHub
  static Future<Map<String, dynamic>?> fetchLatestVersion() async {
    try {
      final response = await http
          .get(Uri.parse(versionJsonUrl))
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
    } catch (e) {
      debugPrint("Update check failed: $e");
    }
    return null;
  }

  /// Convert GitHub web URLs to direct raw download URLs
  static String getDirectApkUrl(String urlString) {
    if (urlString.contains('github.com') && (urlString.contains('/raw/') || urlString.contains('/blob/'))) {
      return urlString
          .replaceAll('github.com', 'raw.githubusercontent.com')
          .replaceAll('/raw/', '/')
          .replaceAll('/blob/', '/');
    }
    return urlString;
  }

  /// Launch external browser to download APK directly
  static Future<void> launchApkDownload(String urlString) async {
    if (urlString.isEmpty) return;
    final directUrl = getDirectApkUrl(urlString);
    final uri = Uri.tryParse(directUrl);
    if (uri == null) return;
    try {
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      try {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      } catch (_) {}
    }
  }

  /// Check for updates and show dialog if a newer version is found
  static Future<void> checkForUpdates(BuildContext context, {bool silent = true}) async {
    final data = await fetchLatestVersion();
    if (!context.mounted) return;
    if (data == null) {
      if (!silent) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not connect to update server. Please check your internet connection.")),
        );
      }
      return;
    }

    final int remoteCode = data['version_code'] is int
        ? data['version_code']
        : int.tryParse("${data['version_code']}") ?? currentAppVersionCode;
    final String remoteName = "${data['latest_version'] ?? '1.0.0'}";
    final String releaseNotes = "${data['release_notes'] ?? 'New improvements and bug fixes.'}";
    final String apkUrl = "${data['apk_url'] ?? ''}";
    final bool forceUpdate = data['force_update'] == true;

    if (remoteCode > currentAppVersionCode && apkUrl.isNotEmpty) {
      showDialog(
        context: context,
        barrierDismissible: !forceUpdate,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppColors.bgCard,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Icon(Icons.system_update_rounded, color: AppColors.primaryLight, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "New Update (v$remoteName)",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "A new version of Studygram is available! Here is what's new:",
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.bgMain,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderCard),
                ),
                child: Text(
                  releaseNotes,
                  style: TextStyle(fontSize: 13, color: AppColors.textPrimary, height: 1.4),
                ),
              ),
            ],
          ),
          actions: [
            if (!forceUpdate)
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text("Later", style: TextStyle(color: AppColors.textSecondary)),
              ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(ctx);
                launchApkDownload(apkUrl);
              },
              icon: const Icon(Icons.download_rounded, size: 18, color: Colors.white),
              label: const Text("Update Now", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
            ),
          ],
        ),
      );
    } else if (!silent && context.mounted) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppColors.bgCard,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Icon(Icons.check_circle_outline_rounded, color: AppColors.primaryLight, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Up to Date!",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
          content: Text(
            "You are running the latest version of Studygram (v$currentAppVersionName). No updates required!",
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text("OK", style: TextStyle(color: AppColors.primaryLight, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    }
  }
}
