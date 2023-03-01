import 'package:flutter/material.dart';

class Barrier extends StatelessWidget {
  final barrierX;
  final barrierWidth;
  final barrierHeight;
  final bool bottomBarrier;

  const Barrier(
      {super.key,
      this.barrierX,
      this.barrierWidth,
      this.barrierHeight,
      required this.bottomBarrier});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment((2 * barrierX + barrierWidth) / (2 - barrierWidth),
          bottomBarrier ? 1 : -1),
      child: Container(
        color: Colors.green,
        width: MediaQuery.of(context).size.width * barrierWidth / 2,
        height: MediaQuery.of(context).size.height * 3 / 4 * barrierHeight / 2,
      ),
    );
  }
}
