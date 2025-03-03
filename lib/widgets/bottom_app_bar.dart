import 'package:flutter/material.dart';
import 'package:moviego/screens/homepage.dart';
import 'package:moviego/screens/movie.dart';
import 'package:moviego/screens/profile.dart';
import 'package:moviego/screens/ticket.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;

  const MainScreen({super.key, this.initialIndex = 0});

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  late int _currentIndex;
  late final List<Widget> _pages;
  final GlobalKey<HomePageState> _homePageKey = GlobalKey<HomePageState>();

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pages = [
      HomePage(key: _homePageKey, onTabChange: _onTabChange),
      TicketPage(),
      const MoviePage(selectedCategory: 'Now Playing'),
      ProfilePage(onTabChange: () => _onTabChange(1)),
    ];
  }

  void _onTabChange(int index) {
    setState(() {
      _currentIndex = index;
      if (index == 0) {
        _homePageKey.currentState?.loadUserName();
      }
    });
  }

  void navigateToMovies(String category) {
    setState(() {
      _currentIndex = 2;
    });

    final moviePage = _pages[2] as MoviePage;
    moviePage.changeCategory(category);
  }

  void refreshHomePageUserName() {
    _homePageKey.currentState?.loadUserName();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(top: 2),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFF262626), width: 1.5)),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.black,
          currentIndex: _currentIndex,
          unselectedItemColor: Colors.white,
          selectedItemColor: Colors.yellow,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              if (index == 0) {
                _homePageKey.currentState?.loadUserName();
              }
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/home.png',
                width: screenWidth * 0.07,
                height: screenWidth * 0.07,
                color: Colors.white,
              ),
              activeIcon: Image.asset(
                'assets/images/home.png',
                width: screenWidth * 0.07,
                height: screenWidth * 0.07,
                color: Colors.yellow,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/ticket.png',
                width: screenWidth * 0.07,
                height: screenWidth * 0.07,
                color: Colors.white,
              ),
              activeIcon: Image.asset(
                'assets/images/ticket.png',
                width: screenWidth * 0.07,
                height: screenWidth * 0.07,
                color: Colors.yellow,
              ),
              label: 'Ticket',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/video.png',
                width: screenWidth * 0.07,
                height: screenWidth * 0.07,
                color: Colors.white,
              ),
              activeIcon: Image.asset(
                'assets/images/video.png',
                width: screenWidth * 0.07,
                height: screenWidth * 0.07,
                color: Colors.yellow,
              ),
              label: 'Movies',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/user.png',
                width: screenWidth * 0.07,
                height: screenWidth * 0.07,
                color: Colors.white,
              ),
              activeIcon: Image.asset(
                'assets/images/user.png',
                width: screenWidth * 0.07,
                height: screenWidth * 0.07,
                color: Colors.yellow,
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
