import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:intl/intl.dart';
import 'package:moviego/Model/movie.dart';
import 'package:moviego/Services/services.dart';
import 'package:moviego/screens/moviedetails.dart';
import 'package:moviego/widgets/homepage/coming_soon_header.dart';
import 'package:moviego/widgets/coming_soon_movies.dart';
import 'package:moviego/widgets/homepage/movie_news_header.dart';
import 'package:moviego/widgets/homepage/movie_news_widget.dart';
import 'package:moviego/widgets/homepage/now_showing_header.dart';
import 'package:moviego/widgets/homepage/now_showing_movies.dart';
import 'package:moviego/widgets/homepage/promo_discount.dart';
import 'package:moviego/widgets/homepage/promo_discount_header.dart';
import 'package:moviego/widgets/homepage/service_header.dart';
import 'package:moviego/widgets/homepage/service_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.onTabChange});

  final void Function(int index) onTabChange;

  @override
  State<HomePage> createState() => HomePageState();
}

String formatDate(String date) {
  try {
    final parsedDate = DateTime.parse(date);
    return DateFormat('dd.MM.yyyy').format(parsedDate);
  } catch (e) {
    return "Invalid Date";
  }
}

String formatRuntime(int runtime) {
  int hours = runtime ~/ 60;
  int minutes = runtime % 60;
  return "${hours}h${minutes}m";
}

class HomePageState extends State<HomePage> {
  String userName = "Guest";
  late Future<List<Movie>> nowShowing = APIserver().getNowShowing();
  late Future<List<Movie>> comingSoon = APIserver().getComingSoon();

  @override
  void initState() {
    super.initState();
    _loadMovies();
    loadUserName();
  }

  void loadUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (userDoc.exists && userDoc.data() != null) {
          String fetchedName =
              (userDoc.data() as Map<String, dynamic>)['name'] ?? 'Guest';
          setState(() {
            userName = fetchedName;
          });
        } else {
          setState(() {
            userName = "Guest"; // Nếu không có tài liệu, dùng "Guest"
          });
        }
      } catch (e) {
        print('Error fetching user name from Firestore: $e');
        setState(() {
          userName = "Guest";
        });
      }
    } else {
      setState(() {
        userName = "Guest";
      });
    }
  }

  void navigateToProfile() {
    widget.onTabChange(3);
    loadUserName();
  }

  final List<Map<String, String>> movieNews = [
    {
      "image": "assets/images/Mufasa.png",
      "title":
          "Box Office: ‘Mufasa’ Wins With \${23.8}M, ‘Sonic 3’ Sits at No. 2 as Franchise Crosses \${1}B Globally"
    },
    {
      "image": "assets/images/toy_story_4_-publicity_still_13-h_2019.png",
      "title": "Tim Allen Teases a “Very, Very Clever” ‘Toy Story 5’ Script"
    },
    {
      "image": "assets/images/batman.png",
      "title":
          "‘The Batman’ Sequel Moves to 2027 as Alejandro González Iñárritu and Tom Cruise Take Its Fall 2026 Date"
    },
    {
      "image":
          "assets/images/Dune-2-The-Substance-Wild-Robot-Split-Everett-H-2025.png",
      "title": "Heat Vision’s Top 10 Movies of 2024"
    },
    {
      "image":
          "assets/images/WIN_OR_LOSE-ONLINE-USE-g170_38a_pub.pub16n.448-2-H-2024.png",
      "title":
          "Ex-Pixar Staffers Decry ‘Win or Lose’ Trans Storyline Being Scrapped: “Can’t Tell You How Much I Cried”"
    },
  ];

  void _loadMovies() {
    setState(() {
      nowShowing = APIserver().getNowShowing();
      comingSoon = APIserver().getComingSoon();
    });
  }

  Future<void> _refreshMovies() async {
    setState(() {
      nowShowing = APIserver().getNowShowing();
      comingSoon = APIserver().getComingSoon();
    });
    await Future.wait([nowShowing, comingSoon]);
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(content: Text("Danh sách phim đã được làm mới!")),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(userName, context),
      backgroundColor: const Color.fromARGB(184, 0, 0, 0),
      body: RefreshIndicator(
        onRefresh: _refreshMovies,
        color: const Color(0xFFFCC434),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: <Widget>[
              const SearchBar(),
              const SizedBox(height: 20),
              const NowShowingHeader(),
              const SizedBox(height: 15),
              NowShowingMovies(nowShowing: nowShowing),
              const ComingSoonHeader(),
              const SizedBox(height: 15),
              ComingSoonMovies(comingSoon: comingSoon),
              const SizedBox(height: 15),
              const PromoDiscountHeader(),
              const SizedBox(height: 5),
              const PromoDiscount(),
              const ServiceHeader(),
              const SizedBox(height: 5),
              const ServiceWidget(),
              const SizedBox(height: 10),
              const MovieNewsHeader(),
              const SizedBox(height: 5),
              MovieNewsWidget(movieNews: movieNews),
            ],
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar(String userName, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return AppBar(
      title: Container(
        margin: EdgeInsets.all(screenWidth * 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi, $userName',
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                color: Colors.white,
              ),
            ),
            Text(
              'MOVIEGO',
              style: TextStyle(
                fontSize: screenWidth * 0.065,
                color: Colors.yellow,
                fontFamily: "Ultra",
              ),
            ),
          ],
        ),
      ),
      actions: [
        const Icon(
          Icons.notifications_rounded,
          color: Colors.white,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: navigateToProfile,
            child: ClipOval(
              child: Image.network(
                FirebaseAuth.instance.currentUser?.photoURL ?? '',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/avatar.png',
                    fit: BoxFit.cover,
                    width: screenWidth * 0.11,
                    height: screenWidth * 0.11,
                  );
                },
                width: screenWidth * 0.11,
                height: screenWidth * 0.11,
              ),
            ),
          ),
        ),
        SizedBox(width: screenWidth * 0.025),
      ],
      elevation: 0,
      backgroundColor: const Color.fromARGB(184, 0, 0, 0),
      automaticallyImplyLeading: false,
      surfaceTintColor: Colors.black,
    );
  }
}

class SearchBar extends StatefulWidget {
  const SearchBar({super.key});

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final APIserver _apiServer = APIserver();
  List<Movie> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {}); // Cập nhật UI khi focus thay đổi
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) async {
    if (query.isNotEmpty) {
      setState(() {
        _isSearching = true;
      });
      try {
        List<Movie> results = await _apiServer.searchMovies(query);
        setState(() {
          _searchResults = results;
          _isSearching = false;
        });
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isSearching = false;
        });
      }
    } else {
      setState(() {
        _searchResults = [];
      });
    }
  }

  void _clearSearch() {
    setState(() {
      _controller.clear();
      _searchResults = [];
    });
    _focusNode.unfocus();
  }

  void _hideSearchResults() {
    setState(() {
      _searchResults = [];
    });
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _hideSearchResults,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                prefixIcon:
                    const Icon(FeatherIcons.search, color: Colors.white),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white),
                        onPressed: _clearSearch,
                      )
                    : null,
                hintText: 'Search movies...',
                hintStyle: TextStyle(color: Colors.grey[600], fontSize: 18),
                filled: true,
                fillColor: Colors.grey[900],
              ),
              onChanged: _onSearchChanged,
              onTap: () {
                // Giữ focus khi nhấn vào TextField
                _focusNode.requestFocus();
              },
            ),
          ),
          if (_searchResults.isNotEmpty)
            GestureDetector(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 14),
                constraints: const BoxConstraints(maxHeight: 300),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: _searchResults.map((movie) {
                      return ListTile(
                        leading: Image.network(
                          "https://image.tmdb.org/t/p/w200${movie.posterPath}",
                          fit: BoxFit.cover,
                        ),
                        title: Text(movie.title,
                            style: const TextStyle(color: Colors.white)),
                        subtitle: Text(
                          movie.genres.join(", "),
                          style: const TextStyle(color: Colors.grey),
                        ),
                        onTap: () {
                          _hideSearchResults(); // Ẩn kết quả khi chọn phim
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MovieDetailPage(movie: movie),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          if (_isSearching) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
