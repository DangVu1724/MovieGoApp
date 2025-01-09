import 'package:flutter/material.dart';
import 'package:movie_app/Model/movie.dart';
import 'package:movie_app/Services/services.dart';
import 'package:movie_app/screens/homepage.dart';
import 'package:readmore/readmore.dart';

class MovieDetailPage extends StatefulWidget {
  final Movie movie;

  const MovieDetailPage({super.key, required this.movie});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Movie>(
        future: APIserver().getMovieDetail(widget.movie.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("No details available"));
          }

          final movieDetail = snapshot.data!;

          // Ảnh trên cùng
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Image.network(
                "https://image.tmdb.org/t/p/original${movieDetail.backDropPath}",
                height: 300, // Chiều cao cố định của ảnh
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 180.0, left: 16, right: 16),
                  child: Column(
                    children: [
                      Container(
                        // Nền mờ cho chữ
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color(0xFF1C1C1C),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movieDetail.title,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Text(
                                  formatRuntime(movieDetail.runtime),
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                                const Text(" | ",
                                    style: TextStyle(color: Colors.white)),
                                Text(
                                  formatDate(widget.movie.releaseDate),
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            Row(
                              children: [
                                const Text("Review",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                  size: 16,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  widget.movie.voteAverage.toStringAsFixed(1),
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '(${widget.movie.voteCount})',
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.white),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Row(
                                  children: List.generate(5, (index) {
                                    return Icon(
                                      index <
                                              (widget.movie.voteAverage / 2)
                                                  .round()
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: Colors.yellow,
                                      size: 32,
                                    );
                                  }),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                // Nút xem trailer
                                Container(
                                  padding: const EdgeInsets.all(0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: const Color(0xFFBFBFBF),
                                    ),
                                  ),
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      // Xử lý logic khi bấm nút
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) => TrailerPage(movieId: movie.id),
                                      //   ),
                                      // );
                                    },
                                    icon: const Icon(
                                      Icons.play_arrow,
                                      color: Color(0xFFBFBFBF),
                                    ),
                                    label: const Text(
                                      "Xem Trailer",
                                      style:
                                          TextStyle(color: Color(0xFFBFBFBF)),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 0,
                                        horizontal: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Chỉ sử dụng một ReadMoreText
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              const Text(
                                "Movie genre:",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFFCDCDCD)
                                ),
                              ),
                              const SizedBox(width: 5,),
                              Text(
                                movieDetail.genres.join(', '),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 7,),
                          const Text(
                            "Censorship:",
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFFCDCDCD)
                            ),
                          ),
                          const SizedBox(height: 7,),
                           Row(
                            children: [
                              const Text(
                                "Language:",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFFCDCDCD)
                                ),
                              ),
                              const SizedBox(width: 7,),
                              Text(
                                movieDetail.languages.join(', '),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 15,),
                          const Text("Storyline",
                          style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                          const SizedBox(height: 10,),
                          ReadMoreText(
                            movieDetail.overview,
                            style: const TextStyle(fontSize: 16),
                            trimLines: 4,
                            trimLength: 150,
                            colorClickableText: Colors.yellow,
                            trimMode: TrimMode.Length,
                            trimCollapsedText: 'See more',
                            trimExpandedText: ' See less',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Nút quay lại
              SafeArea(
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          );
          // Phần nội dung còn lại bên dưới ảnh
        },
      ),
    );
  }
}
