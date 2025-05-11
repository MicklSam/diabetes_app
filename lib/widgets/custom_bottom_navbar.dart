import 'package:flutter/material.dart';
import '../constants/colors.dart';

// Custom Bottom Navigation Bar
class CustomBottomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavbar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: AppColors.black, // 🛠️ خليت الخلفية أسود
      selectedItemColor: AppColors.white, // العنصر المختار أبيض
      unselectedItemColor: Colors.grey.shade400, // العناصر التانية رمادية فاتحة
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.monitor_heart), label: 'Health'),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chatbot'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
