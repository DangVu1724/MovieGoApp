import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:movie_app/Model/movie.dart';
import 'package:movie_app/Services/services.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
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
  return "${hours}h ${minutes}m";
}

class _HomePageState extends State<HomePage> {
  final String userName = "Son Tung MTP";
  late Future<List<Movie>> nowShowing = APIserver().getNowShowing();
  late Future<List<Movie>> comingSoon = APIserver().getComingSoon();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(userName),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            const SearchBar(),
            const SizedBox(height: 20),
            const NowShowingHeader(),
            const SizedBox(
              height: 15,
            ),
            NowShowingMovies(nowShowing: nowShowing),
            const ComingSoonHeader(),
            const SizedBox(height: 15),
            ComingSoonMovies(comingSoon: comingSoon),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(String userName) {
    return AppBar(
      title: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi, $userName',
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
            const Text(
              'MovieGo',
              style: TextStyle(
                  fontSize: 26, color: Colors.yellow, fontFamily: "Ultra"),
            ),
          ],
        ),
      ),
      actions: [
        const Icon(
          Icons.notifications_rounded,
          color: Colors.white,
        ),
        const SizedBox(width: 20),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: ClipOval(
            child: Image.asset(
              'assets/images/mtp.jpg',
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 10),
      ],
      elevation: 0,
      backgroundColor: const Color.fromARGB(255, 39, 37, 37),
      automaticallyImplyLeading: false,
    );
  }
}

class ComingSoonMovies extends StatelessWidget {
  const ComingSoonMovies({
    super.key,
    required this.comingSoon,
  });

  final Future<List<Movie>> comingSoon;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: comingSoon, // Lấy danh sách phim sắp chiếu
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Error: ${snapshot.error}"),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text("No movies available"),
          );
        }
    
        final movies = snapshot.data!;
    
        return SizedBox(
          height: 380, // Chiều cao cố định cho danh sách
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 8),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return FutureBuilder<Movie>(
                future: APIserver()
                    .getMovieDetail(movie.id), // Gọi chi tiết bộ phim
                builder: (context, movieDetailSnapshot) {
                  if (movieDetailSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (movieDetailSnapshot.hasError) {
                    return Center(
                      child:
                          Text("Error: ${movieDetailSnapshot.error}"),
                    );
                  } else if (!movieDetailSnapshot.hasData) {
                    return const Center(
                      child: Text("No movie details available"),
                    );
                  }
    
                  return Container(
                    width: 165, // Độ rộng cho mỗi item
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 230,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(
                                "https://image.tmdb.org/t/p/original${movie.posterPath}",
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 7),
                        // Tên phim
                        Text(
                          movie.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          children: [
                            const FaIcon(FontAwesomeIcons.video,size: 12,),
                            const SizedBox(width: 3),
                            Expanded(
                              child: Text(
                                movie.genres.join(", "),
                                style: const TextStyle(
                                  fontSize: 12,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.calendar_month_outlined,
                                size: 14),
                            const SizedBox(width: 3),
                            Text(
                              formatDate(movie.releaseDate),
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        // Hiển thị runtime dưới tên phim
                        
                      ],
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

class ComingSoonHeader extends StatelessWidget {
  const ComingSoonHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 20, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Coming soon",
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: () {
              // code to navigate to another screen
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "See all",
                  style: TextStyle(fontSize: 16, color: Colors.yellow),
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(Icons.arrow_forward_ios, color: Colors.yellow, size: 16)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NowShowingMovies extends StatelessWidget {
  const NowShowingMovies({
    super.key,
    required this.nowShowing,
  });

  final Future<List<Movie>> nowShowing;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: nowShowing,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Error: ${snapshot.error}"),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text("No movies available"),
          );
        }
        final movies = snapshot.data!;

        return CarouselSlider.builder(
          itemCount: movies.length,
          itemBuilder: (context, index, movieIndex) {
            final movie = movies[index];

            return FutureBuilder<Movie>(
              future: APIserver().getMovieDetail(movie.id),
              builder: (context, movieDetailSnapshot) {
                if (movieDetailSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (movieDetailSnapshot.hasError) {
                  return Center(
                    child: Text("Error: ${movieDetailSnapshot.error}"),
                  );
                } else if (!movieDetailSnapshot.hasData) {
                  return const Center(
                    child: Text("No movie details available"),
                  );
                }

                final movieDetail = movieDetailSnapshot.data!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hình ảnh trong Carousel
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: NetworkImage(
                              "https://image.tmdb.org/t/p/original${movie.posterPath}",
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    // Tiêu đề của phim
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: Center(
                        child: Text(
                          movie.title,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),

                    // Hiển thị runtime dưới tiêu đề phim
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.access_time,
                          color: Colors.white,
                          size: 12,
                        ),
                        const SizedBox(width: 1,),
                        Text(
                          formatRuntime(movieDetail.runtime),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        const Text(
                          "•", // Dấu chấm tròn
                          style: TextStyle(
                            fontSize: 18, // Thay đổi kích thước dấu chấm
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        Text(
                          movie.genres.join(', '),
                          style: const TextStyle(fontSize: 12),
                        )
                      ],
                    ),

                    // Đánh giá phim
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.star, color: Colors.yellow),
                          Text(
                            movie.voteAverage.toStringAsFixed(1),
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          Text('(${movie.voteCount})',
                              style: const TextStyle(fontSize: 10)),
                        ],
                      ),
                    )
                  ],
                );
              },
            );
          },
          options: CarouselOptions(
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            enlargeCenterPage: true,
            aspectRatio: 0.8,
            scrollPhysics: const BouncingScrollPhysics(),
            enableInfiniteScroll: true,
          ),
        );
      },
    );
  }
}

class NowShowingHeader extends StatelessWidget {
  const NowShowingHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 20, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Now playing",
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: () {
              // code to navigate to another screen
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "See all",
                  style: TextStyle(fontSize: 16, color: Colors.yellow),
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(Icons.arrow_forward_ios, color: Colors.yellow, size: 16)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none),
            prefixIcon: const Icon(
              FeatherIcons.search,
              color: Colors.white,
            ),
            hintText: 'Search',
            hintStyle: TextStyle(
              color: Colors.grey[600],
              fontSize: 18,
              fontStyle: FontStyle.normal,
            ),
            contentPadding: const EdgeInsets.all(12),
            filled: true,
            fillColor: Colors.grey[900],
          ),
        ));
  }
}
