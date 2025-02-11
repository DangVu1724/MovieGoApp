import 'package:flutter/material.dart';

class TicketPage extends StatelessWidget {
  // final String movieTitle;
  // final String cinemaName;
  // final int totalPrice;
  // final List<String> selectedSeats;
  // final String showTime;
  // final DateTime showDate;
  // final String moviePoster;
  // final List<String> genres;

  const TicketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My ticket",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
      ),
      // bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}