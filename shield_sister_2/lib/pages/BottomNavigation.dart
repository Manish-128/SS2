import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:shield_sister_2/new_pages/Contact_Management_Page.dart';
import 'package:shield_sister_2/new_pages/Main_Manual_Page.dart';
import 'package:shield_sister_2/new_pages/Map_Display_Page.dart';
import 'package:shield_sister_2/pages/SOS_Homescreen.dart';
import 'package:shield_sister_2/pages/Main_Setting_Page.dart';


class BottomNavigationPage extends StatefulWidget {
  const BottomNavigationPage({super.key});

  @override
  BottomNavigationPageState createState() => BottomNavigationPageState();
}

class BottomNavigationPageState extends State<BottomNavigationPage> {
  int _currentIndex = 0;
  final PageController pageController = PageController();

  void animateToPage(int page) {
       pageController.jumpToPage(page);
  }


  @override
  Widget build(BuildContext context) {
    AppSizes().init(context);
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        // Disable swipe functionality on PageView
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const SOSHomescreen(), // Home page (index 0)
          MainManualPage(), // Search page (index 1)
          const MapDisplayPage(), // Category page (index 2)
          ContactManagementPage(), // Contact page (index 3)
          MainSettingPage()
        ],
      ),
      bottomNavigationBar: bottomNav(),
    );
  }

  Widget bottomNav() {
    return Padding(
      padding: EdgeInsets.all(0),
      child: Material(
        color: Colors.transparent,
        elevation: 5,
        child: Container(
          height: AppSizes.blockSizeHorizontal * 18,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.black,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 0,
                bottom: 0,
                left: AppSizes.blockSizeHorizontal * 3,
                right: AppSizes.blockSizeHorizontal * 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    BottomNavBTN(
                      onPressed: (val) {
                        animateToPage(val);
                        setState(() {
                          _currentIndex = val;
                        });
                      },
                      icon: Icons.home,
                      currentIndex: _currentIndex,
                      index: 0,
                    ),
                    BottomNavBTN(
                      onPressed: (val) {
                        animateToPage(val);
                        setState(() {
                          _currentIndex = val;
                        });
                      },
                      icon: CupertinoIcons.book,
                      currentIndex: _currentIndex,
                      index: 1,
                    ),
                    BottomNavBTN(
                      onPressed: (val) {
                        animateToPage(val);
                        setState(() {
                          _currentIndex = val;
                        });
                      },
                      icon: Icons.map,
                      currentIndex: _currentIndex,
                      index: 2,
                    ),
                    BottomNavBTN(
                      onPressed: (val) {
                        animateToPage(val);
                        setState(() {
                          _currentIndex = val;
                        });
                      },
                      icon: Icons.contact_page_outlined,
                      currentIndex: _currentIndex,
                      index: 3,
                    ),
                    BottomNavBTN(
                      onPressed: (val) {
                        animateToPage(val);
                        setState(() {
                          _currentIndex = val;
                        });
                      },
                      icon: Icons.account_circle_outlined,
                      currentIndex: _currentIndex,
                      index: 4,
                    ),
                  ],
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.decelerate,
                bottom: 0,
                left: animatedPositionedLeftValue(_currentIndex),
                child: Container(
                  height: AppSizes.blockSizeHorizontal * 1.0,
                  width: AppSizes.blockSizeHorizontal * 12,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDFF3EA),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

double animatedPositionedLeftValue(int index) {
  double buttonWidth = AppSizes.blockSizeHorizontal * 18; // Same as the width of each button
  double centerAdjustment = 28 + (buttonWidth - (AppSizes.blockSizeHorizontal * 20) + 25) / 5; // Adjust to center the indicator

  // The left position is the index multiplied by the button width, minus half the difference to center it
  return index * buttonWidth + centerAdjustment;
}

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(AppSizes.blockSizeHorizontal * 3, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width - AppSizes.blockSizeHorizontal * 3, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class BottomNavBTN extends StatelessWidget {
  final Function(int) onPressed;
  final IconData icon;
  final int index;
  final int currentIndex;

  const BottomNavBTN({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.index,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    AppSizes().init(context);
    return InkWell(
      onTap: () {
        onPressed(index);
      },
      child: Center(
        child: Container(
          alignment: Alignment.center,
          height: AppSizes.blockSizeHorizontal * 13,
          width: AppSizes.blockSizeHorizontal * 18,
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Icon with different opacity based on whether it is the current index
              AnimatedOpacity(
                opacity: (currentIndex == index) ? 1 : 0.2, // Adjust opacity based on current index
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn,
                child: Icon(
                  icon,
                  color: (currentIndex == index) ? Colors.white : const Color(0xFFDFF3EA), // Change color based on current index
                  size: AppSizes.blockSizeHorizontal * 8, // Adjust size
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppSizes {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
  }
}

class SampleWidget extends StatelessWidget {
  const SampleWidget({
    Key? key,
    required this.label,
    required this.color,
  }) : super(key: key);

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
      ),
    );
  }
}
