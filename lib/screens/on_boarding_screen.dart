import 'package:flutter/material.dart';
import 'package:flutter_application_1/bottombar_nav.dart';
import 'package:flutter_application_1/entities/on_boarding_entity.dart';
import 'package:flutter_application_1/login_page.dart';
import 'package:flutter_application_1/widgets/header_widget.dart';

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final _onBoardingData = OnBoardingEntity.onBoardingData;
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _pageViewBuilderWidget(),
          _columnWidget(),
          HeaderWidget(),
        ],
      ),
    );
  }

  Widget _pageViewBuilderWidget() {
    return PageView.builder(
      itemCount: _onBoardingData.length,
      onPageChanged: (index) {
        setState(() {
          _currentPageIndex = index;
        });
      },
      itemBuilder: (ctx, index) {
        return Stack(
          fit: StackFit.passthrough,
          children: [
            index == 3
                ? Container(
                    height: double.infinity,
                    child: Image.asset(
                      _onBoardingData[index].image,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    height: double.infinity,
                    child: Image.asset(
                      _onBoardingData[index].image,
                      fit: BoxFit.cover,
                    ),
                  ),
            index == 3
                ? Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Color(0xff0C2332).withOpacity(.5),
                            Color(0xff0C2332).withOpacity(.5),
                            Color(0xff0C2332).withOpacity(.5),
                          ],
                          tileMode: TileMode.clamp,
                          begin: Alignment(0.9, 0.0),
                          end: Alignment(0.8, 0.1)),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Color(0xff0C2332).withOpacity(.5),
                            Color(0xff0C2332).withOpacity(.5),
                            Color(0xff0C2332).withOpacity(.5),
                          ],
                          tileMode: TileMode.clamp,
                          begin: Alignment(0.9, 0.0),
                          end: Alignment(0.9, 0.1)),
                    ),
                  ),
            Container(
              margin: EdgeInsets.only(top: 230, left: 40, right: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _onBoardingData[index].heading,
                    style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 255, 255)),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    _onBoardingData[index].description,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Widget _columnWidget() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (_currentPageIndex ==
              _onBoardingData.length - 1) // Check if it's the last slide
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LoginPage(),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 40, right: 15, left: 15),
                padding: EdgeInsets.symmetric(vertical: 12),
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(25),
                  ),
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                child: Text(
                  "ابدآ الان",
                  style: TextStyle(
                      color: Color.fromARGB(255, 3, 22, 189),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                      fontSize: 20),
                ),
              ),
            ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _onBoardingData.map(
                (data) {
                  //get index
                  int index = _onBoardingData.indexOf(data);
                  return Container(
                    height: 10,
                    width: 10,
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: index == _currentPageIndex
                          ? Color.fromARGB(84, 84, 116, 255)
                          : Colors.grey,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
          ),
          SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}
