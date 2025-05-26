import 'package:matrimony_flutter/Authentication/email.dart';
import 'package:matrimony_flutter/Utils/importFiles.dart';
import 'package:matrimony_flutter/Update/Submit_Pages/name_profilephoto.dart';



class LaunchPage extends StatefulWidget {
  const LaunchPage({super.key});

  @override
  State<LaunchPage> createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {
  int _currentPage = 0;
  List<String> images = [
    "assets/launch1.jpg",
    "assets/launch2.jpg",
    "assets/launch3.jpg",
  ];

  List<Map<String, dynamic>> contents = [
    {
      "title": "Algorithm",
      "content":
          "Users going through a vetting process to ensure you never match with bots",
    },
    {
      "title": "Matches",
      "content":
          "We match you with people that have large array of similar interests.",
    },
    {
      "title": "Premiums",
      "content":
          "Sign Up today and enjoy the first month of premium benefits on us.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(preferredSize: Size(10, 40), child: AppBar()),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CarouselSlider(
            options: CarouselOptions(
              onPageChanged: (value, _) {
                setState(() {
                  _currentPage = value;
                });
              },
              autoPlayCurve: Curves.ease,
              autoPlayAnimationDuration: Duration(seconds: 1),
              initialPage: 0,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              enlargeFactor: 0.5,
              enlargeCenterPage: true,
              height: 400.0,
            ),

            items:
                images.map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            i,
                            fit: BoxFit.fitHeight,
                            opacity: AlwaysStoppedAnimation(0.8),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
          ),
          _buildCarouselSliderIndicatorAndContents(),
          buildButton(
            label: "Create an account",
            textColor: Colors.white,
            backgroundColor: Colors.purple,
            onPressed: () {

              Get.to(Email(isSignIn: false),transition: Transition.fade);
                
            },
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Already have an account?"),
              TextButton(
                onPressed: () {
                  Get.to(LoginPage(),transition: Transition.fade);
                },
                child: Text(
                  "Sign In",
                  style: GoogleFonts.nunitoSans(
                    color: Colors.purple,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselSliderIndicatorAndContents() {
    return Column(
      children: [
        AnimatedContainer(
          height: 60,
          alignment: Alignment.center,
          duration: Duration(milliseconds: 100),
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 100),
            transitionBuilder: (child, animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: Text(
              key: ValueKey<String>(contents[_currentPage]["title"]),
              contents[_currentPage]["title"],
              style: GoogleFonts.nunito(
                fontSize: 25,
                color: Colors.purple,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 250,
          height: 40,
          child: Text(
            contents[_currentPage]["content"],
            style: GoogleFonts.nunito(fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox( 
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < images.length; i++)
                AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  margin: EdgeInsets.all(10),
                  height: i == _currentPage ? 7 : 5,
                  width: i == _currentPage ? 10 : 5,
                  decoration: BoxDecoration(
                    color: i == _currentPage ? Colors.purple : Colors.grey,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
