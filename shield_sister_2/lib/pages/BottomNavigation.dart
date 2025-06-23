import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
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
    if(mounted){
      pageController.jumpToPage(page);
    }
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
          const MainManualPage(), // Search page (index 1)
          const MapDisplayPage(), // Category page (index 2)
          const ContactManagementPage(), // Contact page (index 3)
          const MainSettingPage()
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
                      onPressed: (val) async{
                        animateToPage(val);
                        await Future.delayed(Duration(milliseconds: 10));
                        setState(() {
                          _currentIndex = val;
                        });
                      },
                      imagePath: 'assets/icons/home1.png',
                      name: "Home",
                      currentIndex: _currentIndex,
                      index: 0,
                    ),
                    BottomNavBTN(
                      onPressed: (val) async{
                        animateToPage(val);
                        await Future.delayed(Duration(milliseconds: 10));
                        setState(() {
                          _currentIndex = val;
                        });
                      },
                      imagePath: 'assets/icons/manual1.png',
                      name: "Manual",
                      currentIndex: _currentIndex,
                      index: 1,
                    ),
                    BottomNavBTN(
                      onPressed: (val) async{
                        animateToPage(val);
                        await Future.delayed(Duration(milliseconds: 10));
                        setState(() {
                          _currentIndex = val;
                        });
                      },
                      imagePath: 'assets/icons/maps1.png',
                      name: "Map",
                      currentIndex: _currentIndex,
                      index: 2,
                    ),
                    BottomNavBTN(
                      onPressed: (val) async{
                        animateToPage(val);
                        await Future.delayed(Duration(milliseconds: 10));
                        setState(() {
                          _currentIndex = val;
                        });
                      },
                      imagePath: 'assets/icons/contacts1.png',
                      name: "Contacts",
                      currentIndex: _currentIndex,
                      index: 3,
                    ),
                    BottomNavBTN(
                      onPressed: (val) async{
                        animateToPage(val);
                        await Future.delayed(Duration(milliseconds: 10));
                        setState(() {
                          _currentIndex = val;
                        });
                      },
                      imagePath: 'assets/icons/profile1.png',
                      name: "Profile",
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
  final String imagePath;
  final int index;
  final int currentIndex;
  final String name;

  const BottomNavBTN({
    super.key,
    required this.imagePath,
    required this.onPressed,
    required this.index,
    required this.currentIndex,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    AppSizes().init(context);
    return InkWell(
      onTap: () => onPressed(index),
      child: Container(
        // Use a fixed height suitable for bottom nav (56dp is standard)
        height: 56, // Adjusted to standard bottom nav height
        width: AppSizes.blockSizeHorizontal * 15, // ~15% of screen width
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedOpacity(
              opacity: currentIndex == index ? 1 : 0.65,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
              child: Column(
                mainAxisSize: MainAxisSize.min, // Minimize vertical space
                children: [
                  Image.asset(
                    color: Colors.white,
                    imagePath,
                    width: 24,  // Reduced from 32 to fit better
                    height: 24,
                  ),
                  const SizedBox(height: 4), // Small gap between image and text
                  Text(
                    name,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 12, // Smaller font to fit
                    ),
                  ),
                ],
              ),
            ),
          ],
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