import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:node/home/root.dart';
import 'package:node/utils/labels.dart';

class splashPage extends StatefulWidget {
  const splashPage({super.key});

  static const String route = '/';

  @override
  State<splashPage> createState() => _splashPageState();
}

class _splashPageState extends State<splashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(
        seconds: 3,
      ),
    ).whenComplete(
      () {
        Navigator.pushNamedAndRemoveUntil(
          context,
          Root.route,
          (route) => false,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF9FA8DA),
      body: Column(
        children: [
          Spacer(),
          Text(
            'NODE',
            style: TextStyle(
              color: Colors.white,
              fontSize: 80,
            ),
          ),
          Center(
            child: Lottie.asset('assets/lottie/idea.json'),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
