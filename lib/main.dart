import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  AnimationController _ctrlRight;
  AnimationController _ctrlLeft;
  Animation<double> animRight;
  Animation<double> animLeft;
  Animation<double> animMiddle;

  double get w => MediaQuery.of(context).size.width;
  double get h => MediaQuery.of(context).size.height;

  int after = 0;
  int swipe = 0;
  bool leftWorking = true;
  double radius = 100000.0;
  int counter = 0;
  Color blue = Color(0xff0044CF);
  Color lightPink = Color(0xffFDBFDC);
  Color bgColor;
  Color rightCircle;
  Color leftCircle;
  Color middleCircle;

  @override
  void initState() {
    super.initState();
    _ctrlRight =
        AnimationController(vsync: this, duration: Duration(milliseconds: 720));

    _ctrlLeft =
        AnimationController(vsync: this, duration: Duration(milliseconds: 720))
          ..addStatusListener((status) {});

    bgColor = Color(0xff0044CF); //? Blue
    rightCircle = Color(0xffFDBFDC); //? LightPink
    leftCircle = Color(0xff0044CF); //? Blue
    middleCircle = Colors.white; //? White
  }

  @override
  void dispose() {
    _ctrlRight.dispose();
    _ctrlLeft.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    animRight = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _ctrlRight, curve: Curves.easeInQuart));

    animLeft = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _ctrlLeft, curve: Curves.easeOutQuart),
    );
    animMiddle = Tween<double>(begin: 1.0, end: 0.0)
        .animate(CurvedAnimation(parent: _ctrlRight, curve: Curves.linear));

    return Scaffold(
      body: Container(
        width: w,
        height: h,
        color: bgColor,
        child: Stack(
          children: <Widget>[
            //! Right layout

            Positioned(
              top: 0,
              right: 0,
              child: AnimatedContainer(
                duration: Duration(milliseconds: leftWorking ? 720 : 0),
                width: w / 2 + 40 - (after == 1 ? 80 : 0),
                height: h,
                color: Colors.transparent,
                child: Stack(
                  children: <Widget>[
                    AnimatedBuilder(
                      animation: animRight,
                      builder: (context, child) {
                        return Positioned(
                          top: h - (radius * animRight.value) / 2 - 120,
                          left: 0,
                          child: Container(
                            width: 80 + (radius * animRight.value),
                            height: 80 + (radius * animRight.value),
                            decoration: BoxDecoration(
                              color: rightCircle,
                              borderRadius: BorderRadius.circular(
                                (40 +
                                    (radius * animRight.value) /
                                        2 *
                                        (1 - animRight.value)),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            //! Left layout

            Positioned(
              top: 0,
              left: 0,
              child: AnimatedContainer(
                duration: Duration(milliseconds: leftWorking ? 720 : 0),
                width: w / 2 - 40 + (after == 1 ? 80 : 0),
                height: h,
                color: Colors.transparent,
                child: Stack(
                  children: <Widget>[
                    AnimatedBuilder(
                      animation: animLeft,
                      builder: (context, child) {
                        return Positioned(
                          top: h - (radius * animLeft.value) / 2 - 120,
                          right: 0,
                          child: Container(
                            width: 80 + (radius * animLeft.value),
                            height: 80 + (radius * animLeft.value),
                            child: Center(
                              child: Stack(
                                children: <Widget>[
                                  AnimatedContainer(
                                    duration: Duration(
                                        milliseconds: leftWorking ? 860 : 0),
                                    curve: Interval(0.2, 1.0,
                                        curve: Curves.linear),
                                    width: after == 1 ? 80 : 0,
                                    height: after == 1 ? 80 : 0,
                                    decoration: BoxDecoration(
                                      color: middleCircle,
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: leftCircle,
                              borderRadius: BorderRadius.circular(
                                  (40 + (radius * animLeft.value) / 2) *
                                      (1 - animLeft.value)),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            //! Middle button
            Positioned(
              top: h - 120,
              left: w / 2 - 40,
              child: Container(
                width: 80,
                height: 80,
                child: AnimatedBuilder(
                  animation: animMiddle,
                  builder: (context, child) {
                    return Center(
                      child: IconButton(
                        icon: Icon(
                          counter != 2 ? Icons.arrow_forward_ios : Icons.stop,
                          color: Colors.grey,
                          size: (counter != 2 ? 20 : 30) * animMiddle.value,
                        ),
                        onPressed: () {
                          print(counter);
                          if (counter != 2) {
                            setState(() {
                              _ctrlRight.forward();

                              swipe != 3 ? swipe++ : swipe = 0;
                            });

                            Future.delayed(Duration(milliseconds: 0), () {
                              setState(() {
                                _ctrlLeft.forward();
                              });
                            });

                            Future.delayed(Duration(milliseconds: 420), () {
                              if (counter == 0) {
                                setState(() {
                                  bgColor = Color(0xffFDBFDC); //? Light pink
                                });
                              } else if (counter == 1) {
                                setState(() {
                                  bgColor = Colors.white; //? White
                                });
                              } else {
                                setState(() {
                                  bgColor = Color(0xff0044CF); //? Blue
                                });
                              }
                            });

                            Future.delayed(Duration(milliseconds: 500), () {
                              setState(() {
                                after = 1;
                              });
                            });

                            Future.delayed(Duration(milliseconds: 1440), () {
                              setState(() {
                                if (counter == 0) {
                                  leftCircle = lightPink;
                                  middleCircle = blue;
                                  rightCircle = Colors.white;
                                } else if (counter == 1) {
                                  leftCircle = Colors.white;
                                  middleCircle = lightPink;
                                  rightCircle = blue;
                                } else {
                                  leftCircle = blue;
                                  middleCircle = Colors.white;
                                  rightCircle = lightPink;
                                }

                                leftWorking = false;
                                after = 0;
                                _ctrlRight.reset();
                                _ctrlLeft.reset();
                              });
                            }).whenComplete(() {
                              Future.delayed(Duration(milliseconds: 720), () {
                                setState(() {
                                  leftWorking = true;
                                  counter != 2 ? counter++ : counter = 0;
                                });
                                print(counter);
                              });
                            });
                          }
                        },
                      ),
                    );
                  },
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Container(
              width: w,
              height: h * 0.75,
              child: SafeArea(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Stories",
                            style: TextStyle(
                              color: swipe != 2 ? Colors.white : Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            swipe == 2 ? "Done" : "Skip",
                            style: TextStyle(
                              color: swipe != 2 ? Colors.white : Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: w,
                      height: w,
                      child: Stack(
                        children: List.generate(boards.length, (index) {
                          return AnimatedPositioned(
                            duration: Duration(milliseconds: 1700),
                            curve: swipe == index
                                ? Interval(0.80, 1.0)
                                : Interval(0.0, 0.25),
                            top: 0,
                            left: -w * (swipe - index),
                            child: BoardWidget(
                              lastIdx: swipe == 2,
                              boardModel: boards[index],
                            ),
                          );
                        }),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BoardModel {
  final String img;
  final String motto;
  final int idx;

  BoardModel(this.img, this.motto, this.idx);
}

List<BoardModel> boards = [
  BoardModel("assets/images/giphy1.webp", "Local news\nstories", 0),
  BoardModel("assets/images/giphy2.webp", "Choose your\ninterests", 1),
  BoardModel("assets/images/giphy3.webp", "Darg and\ndrop to move", 2),
];

class BoardWidget extends StatelessWidget {
  final BoardModel boardModel;
  final bool lastIdx;
  const BoardWidget({Key key, this.boardModel, this.lastIdx}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Container(
      width: w,
      height: w,
      child: Column(
        children: <Widget>[
          Spacer(),
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(boardModel.img),
              ),
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          Spacer(),
          Text(
            boardModel.motto,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: lastIdx ? Colors.black : Colors.white,
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
