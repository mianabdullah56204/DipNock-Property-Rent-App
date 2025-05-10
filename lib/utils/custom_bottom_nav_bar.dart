import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _BottomIcon(
                icon: Icons.home,
                label: "Home",
                selected: selectedIndex == 0,
                onTap: () => onItemTapped(0),
              ),
              _BottomIcon(
                icon: Icons.message,
                label: "Messages",
                selected: selectedIndex == 1,
                onTap: () => onItemTapped(1),
              ),
              _BottomIcon(
                icon: Icons.search,
                label: "Search",
                selected: selectedIndex == 2,
                onTap: () => onItemTapped(2),
              ),
              _BottomIcon(
                icon: Icons.list,
                label: "My Ads",
                selected: selectedIndex == 3,
                onTap: () => onItemTapped(3),
              ),
              _BottomIcon(
                icon: Icons.person,
                label: "Account",
                selected: selectedIndex == 4,
                onTap: () => onItemTapped(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _BottomIcon({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? Colors.black : Colors.grey;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(
                  fontSize: 12, color: color, fontFamily: 'SourceSans3')),
        ],
      ),
    );
  }
}
