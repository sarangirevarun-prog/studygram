import 'package:flutter/material.dart';
import 'package:study_gram/theme/colors.dart';

class ResponsiveDeviceFrame extends StatelessWidget {
  final Widget child;
  final bool showBottomNav;
  final int navIndex;
  final ValueChanged<int> onNavTap;

  const ResponsiveDeviceFrame({
    super.key,
    required this.child,
    required this.showBottomNav,
    required this.navIndex,
    required this.onNavTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          // Desktop — phone bezel wrapper
          return Scaffold(
            backgroundColor: AppColors.outerCanvas,
            body: Center(
              child: Container(
                width: 412,
                height: 840,
                margin: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  color: AppColors.bgMain,
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.15),
                    width: 10,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.55),
                      blurRadius: 48,
                      offset: const Offset(0, 20),
                    ),
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      blurRadius: 80,
                      spreadRadius: 8,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Scaffold(
                    backgroundColor: AppColors.bgMain,
                    body: child,
                    bottomNavigationBar: showBottomNav ? _buildBottomNav() : null,
                  ),
                ),
              ),
            ),
          );
        } else {
          // Mobile — full screen
          return Scaffold(
            backgroundColor: AppColors.bgMain,
            body: child,
            bottomNavigationBar: showBottomNav ? _buildBottomNav() : null,
          );
        }
      },
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        border: const Border(
          top: BorderSide(color: AppColors.borderCard, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: navIndex,
        onTap: onNavTap,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textMuted,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
        items: const [
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 2),
              child: Icon(Icons.home_rounded),
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 2),
              child: Icon(Icons.person_rounded),
            ),
            label: "Profile",
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 2),
              child: Icon(Icons.info_outline_rounded),
            ),
            label: "About",
          ),
        ],
      ),
    );
  }
}
