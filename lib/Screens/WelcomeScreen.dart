import 'package:chatapp/Screens/Login_signup.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/constants.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final controller = PageController();
  bool isLastPage = false;
  int cur_page = 0;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: PageView(
        controller: controller,
        onPageChanged: (index) {
          setState(() {
            isLastPage = (index == 2);
            cur_page = index;
          });
        },
        children: const [
          ScrollPage('assets/images/Instant chat.png',
              'Instant messaging app', Colors.white),
          ScrollPage('assets/images/secure.png',
              'Your chat are secure with firebase', Colors.black),
          ScrollPage('assets/images/Reliable.png',
              'Reliable and trustful app', Colors.white),
        ],
      ),
      bottomSheet: isLastPage
          ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const LS(false)));
                },
                child: const Text(
                  'Get Started',
                  style: TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    elevation: 10,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25))),
              ),
            ])
          : Container(
              color: cur_page % 2 == 0 ? Colors.white : Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      controller.previousPage(
                          duration: const Duration(microseconds: 500),
                          curve: Curves.easeInOut);
                    },
                    child: const Text(
                      'Previous',
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        elevation: 10,
                        padding:
                            const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25))),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      controller.nextPage(
                          duration: const Duration(microseconds: 500),
                          curve: Curves.easeInOut);
                    },
                    child: const Text(
                      'Next',
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        elevation: 10,
                        padding:
                            const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25))),
                  ),
                ],
              )),
    ));
  }
}

class ScrollPage extends StatelessWidget {
  final String imageUrl;
  final String desc;
  final Color bgc;
  const ScrollPage(this.imageUrl, this.desc, this.bgc, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgc,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(flex: 6, child: Image.asset(imageUrl)),
          Expanded(
            flex: 1,
            child: Center(
                child: Text(
              desc,
              style: KtextStyle1.copyWith(
                  color: bgc == Colors.black ? Colors.white : Colors.black,fontSize: 20),
            )),
          ),
          Expanded(
            flex: 1,
            child: Container(),
          )
        ],
      ),
    );
  }
}
