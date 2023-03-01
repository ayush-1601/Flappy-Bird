import 'dart:async';
import 'package:flappy_bird/barriers.dart';
import 'package:flappy_bird/brid.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static double birdY = 0;
  double birdWidth = 0.1;
  double birdHeight = 0.1;
  double initialPos = birdY;
  double height = 0;
  double time = 0;
  double gravity = -2.5;
  double velocity = 1.5;
  bool gameStarted = false;
  int highest_score = 0;
  int current_score = 0;

  static List<double> barrierX = [2, 2 + 1.5];
  static double barrierWidth = 0.5;
  List<List<double>> barrierHeight = [
    [0.6, 0.4],
    [0.4, 0.6]
  ];

  void startGame() {
    gameStarted = true;
    Timer.periodic(Duration(milliseconds: 12), (timer) {
      height = gravity * time * time + velocity * time; // (at^2/2 + ut)
      setState(() {
        birdY = initialPos - height;
      });

      if (birdIsDead()) {
        timer.cancel();
        gameStarted = false;
        _showDialog();
      }

      moveMap();

      print(birdY);

      time += 0.01;
    });
  }

  void moveMap() {
    for (int i = 0; i < barrierX.length; i++) {
      setState(() {
        barrierX[i] -= 0.005;
      });

      if (barrierX[i] < -1.5) {
        barrierX[i] += 3;
      }
    }
  }

  void jump() {
    setState(() {
      time = 0;
      initialPos = birdY;
    });
  }

  bool birdIsDead() {
    if (birdY < -1 || birdY > 1) {
      return true;
    }

    for (int i = 0; i < barrierX.length; i++) {
      if (barrierX[i] <= birdWidth &&
          barrierX[i] + barrierWidth >= -birdWidth &&
          (birdY <= -1 + barrierHeight[i][0] ||
              birdY + birdHeight >= 1 - barrierHeight[i][1])) {
        return true;
      }
    }
    score();

    return false;
  }

  void score() {
    current_score++;
    current_score > highest_score
        ? highest_score = current_score
        : highest_score = highest_score;
    setState(() {
      scoreBoard(current_score, highest_score);
    });
  }

  void resetGame() {
    Navigator.pop(context);
    setState(() {
      birdY = 0;
      gameStarted = false;
      time = 0;
      initialPos = birdY;
      birdHeight = 0.1;
      birdWidth = 0.1;
      barrierX = [2, 2 + 1.5];
      barrierWidth = 0.5;
      barrierHeight = [
        [0.6, 0.4],
        [0.4, 0.6]
      ];
      current_score = 0;
    });
  }

  void _showDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.brown,
            title: Center(
              child: Text(
                "GAME OVER",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: resetGame,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    color: Color.fromARGB(255, 187, 146, 131),
                    child: Text(
                      "PLAY AGAIN",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: gameStarted ? jump : startGame,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
                flex: 3,
                child: Container(
                  color: Colors.blue,
                  child: Center(
                    child: Stack(children: [
                      Bird(
                        birdY: birdY,
                        birdHeight: birdHeight,
                        birdWidth: birdWidth,
                      ),
                      Barrier(
                        bottomBarrier: false,
                        barrierX: barrierX[0],
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[0][0],
                      ),
                      Barrier(
                        bottomBarrier: true,
                        barrierX: barrierX[0],
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[0][1],
                      ),
                      Barrier(
                        bottomBarrier: false,
                        barrierX: barrierX[1],
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[1][0],
                      ),
                      Barrier(
                        bottomBarrier: true,
                        barrierX: barrierX[1],
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[1][1],
                      ),
                      Container(
                        alignment: Alignment(0, -0.3),
                        child: Text(
                          gameStarted ? '' : "TAP TO PLAY",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              letterSpacing: 5),
                        ),
                      )
                    ]),
                  ),
                )),
            Expanded(
                child: Container(
                    color: Colors.brown,
                    child: scoreBoard(current_score, highest_score)))
          ],
        ),
      ),
    );
  }

  Widget scoreBoard(int currentScore, int highestScore) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "SCORE",
              style: TextStyle(color: Colors.white, fontSize: 28),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              currentScore.toString(),
              style: TextStyle(color: Colors.white, fontSize: 30),
            )
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "BEST",
              style: TextStyle(color: Colors.white, fontSize: 28),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              highestScore.toString(),
              style: TextStyle(color: Colors.white, fontSize: 30),
            )
          ],
        )
      ],
    );
  }
}
