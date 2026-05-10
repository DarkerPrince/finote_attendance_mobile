import 'package:finote_program/Constants/ColorConstant.dart';
import 'package:finote_program/View/Attendance/AttendancePage.dart';
import 'package:finote_program/View/Profile/ProfilePage.dart';
import 'package:finote_program/View/ProgramsPage.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.userId});

  final String userId;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final List<Widget> _pages;

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _pages = [
      ProgramsPage(userId: widget.userId),
      Attendancepage(userId: widget.userId),
      const ProfilePage(),
    ];
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<Map<String, dynamic>> _navItems = [
    {
      "icon": Icons.auto_stories_rounded,
      "label": "Programs",
    },
    {
      "icon": Icons.fact_check_rounded,
      "label": "Attendance",
    },
    {
      "icon": Icons.person_rounded,
      "label": "Profile",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),

      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: _pages[_currentIndex],
      ),

      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            _navItems.length,
                (index) {
              final isSelected = _currentIndex == index;

              return GestureDetector(
                onTap: () => _onTabTapped(index),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: EdgeInsets.symmetric(
                    horizontal: isSelected ? 18 : 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xff2563EB)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(24),
                      boxShadow: isSelected ?[BoxShadow(color: primaryColor.withOpacity(0.4),spreadRadius: 2 ,blurStyle: BlurStyle.normal,blurRadius: 16)]:[]
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _navItems[index]["icon"],
                        color: isSelected
                            ? Colors.white
                            : Colors.grey.shade600,
                        size: 24,
                      ),

                      AnimatedSize(
                        duration: const Duration(milliseconds: 250),
                        child: isSelected
                            ? Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            _navItems[index]["label"],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}