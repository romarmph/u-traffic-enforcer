import '../../config/utils/exports.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NavIndexProvider>(
      builder: (context, navigator, child) {
        return Container(
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(width: 1, color: UColors.gray200)),
          ),
          child: BottomNavigationBar(
            currentIndex: navigator.currentIndex,
            onTap: (index) {
              navigator.changeIndex(index);
            },
            backgroundColor: UColors.white,
            selectedItemColor: UColors.blue700,
            unselectedItemColor: UColors.gray600,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: "Home",
                activeIcon: Icon(Icons.home),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined),
                label: "Settings",
                activeIcon: Icon(Icons.settings),
              ),
            ],
          ),
        );
      }
    );
  }
}
