import 'package:flutter/material.dart';
import './ball.dart';
import './bat.dart';
import 'dart:math';

/* Enum is a special class that you can use to
represent a fixed number of constant values. */
enum Direction { up, down, left, right }

class Pong extends StatefulWidget {
  @override
  _PongState createState() => _PongState();
}

/* Mixin is a class that contains methods that
can be used by other classes without having to be
the parent class of those other classes. Using the
'with' clause, we are including the class, not
inheriting from it. */
/* SingleTickerProviderStateMixin provides one
Ticker. A Ticker is a class that sends a signal at
an almost regular interval, which in Flutter is
about 60 times per second. */
class _PongState extends State<Pong>
    with SingleTickerProviderStateMixin {

  double width;
  double height;
  double posX = 0;
  double posY = 0;
  double batWidth = 0;
  double batHeight = 0;
  double batPosition = 0;
  Direction vDir = Direction.down;
  Direction hDir = Direction.right;
  double increment = 5;
  double randX = 1;
  double randY = 1;
  int score = 0;

  /* Animation is not bound to any widget on the screen.
  It has listeners to check the state of the animation
  during each frame change. */
  Animation<double> animation;
  /* AnimationController can start an animation, give
  it a duration and repeat it when needed. it can
  control more than one animation. In this case, it
  is only controlling one. */
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    posX = 0;
    posY = 0;
    controller = AnimationController(
      /* Duration will be 3 seconds as we want the ball
      to take 3 seconds to get from position A to
      position B. */
      duration: const Duration(seconds: 10000),
      vsync: this,
    );
    /* Tween is short for 'in between'. For example, if
    you are animating the left position of a widget from
    0 to 200, your Tween will represent the values at
    1, 2, 3 ... up to 200. */
    animation = Tween<double>(begin: 0, end: 100).animate(controller);
    // addListener() will be called whenever the animation changes
    animation.addListener(() {
      /* Increment the horizontal and vertical positions at each iteration
      of the animation. */
      safeSetState(() {
        /* If the horizontal direction is Direction.right, we need to
        increment the horizontal position, else decrement it. */
        (hDir == Direction.right)
            ? posX += ((increment * randX) .round())
            : posX -= ((increment * randX) .round());
        /* If the vertical direction is Direction.down, we need to
        increment it and decrement it when the direction is down. */
        (vDir == Direction.down)
            ? posY += ((increment * randX) .round())
            : posY -= ((increment * randX) .round());
      });
      checkBorders();
    });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    /* LayoutBuilder measures the space available in the 
    context, including the parent constraints. */
    return LayoutBuilder(
        /* BoxConstraints contains 4 useful properties: minWidth,
        minHeight, maxWidth, maxHeight. They are useful whenever
        you need to know the constraints of the parent of a widget. */
        builder: (BuildContext context, BoxConstraints constraints) 
        {
          height = constraints.maxHeight;
          width = constraints.maxWidth;
          // width will be 20% of the screen
          batWidth = width / 5;
          // height will be 5% of the available space
          batHeight = height / 20;
          // A Stack positions its children relative to the edges of its box.
          /* As both the ball and bat will need to move, we'll be able to 
          change their position by changing their distance from the borders
          of the Stack. */
          return Stack(
            children: <Widget> [
              Positioned(
                top: 0,
                right: 24,
                child: Text('Score: ' + score.toString()),
              ),
              // Positioned controls where a child of a stack is positioned.
              Positioned(
                  child: Ball(),
                  // top of the available space
                  /* Changing the top and left parameters of the ball.
                  They take the animation value. */
                  top: posY,
                  bottom: posX,
              ),
              Positioned(
                  // bottom of the available space
                  bottom: 0,
                  left: batPosition,
                  /* GestureDetector responds to gestures of the user.
                  You can respond to several user gestures. The most
                  common ones include onTap, onDoubleTap and onLongPress. */
                  child: GestureDetector(
                    onHorizontalDragUpdate: (DragUpdateDetails update)
                    => moveBat(update),
                    child: Bat(batWidth, batHeight))
                  ),
            ],
          );
        }
    );
  }

  void checkBorders() {
    double diameter = 50;

    if(posX <=0 && hDir == Direction.left) {
      hDir = Direction.right;
      randX = randomNumber();
    }
    if(posX >= width - diameter && hDir == Direction.right) {
      hDir = Direction.left;
      randX = randomNumber();
    }
    if(posY >= height - diameter - batHeight && vDir == Direction.down) {
      /* Check whether the bat is in the correct position to make
      the ball bounce back up, or if the game needs to stop. */
      if(posX >= (batPosition - diameter) && posX <= (batPosition + batWidth + diameter)) {
        vDir = Direction.up;
        randY = randomNumber();
        safeSetState(() {
          score++;
        });
      }
      else {
        controller.stop();
        showMessage(context);
      }
    }
    if(posY <= 0 && vDir == Direction.up) {
      vDir = Direction.down;
      randY = randomNumber();
    }
  }

  /* DragUpdateDetails has a delta property that contains the distance moved
  during the drag operation.*/
  void moveBat(DragUpdateDetails update) {
    safeSetState(() {
      // dx is the horizontal data
      batPosition += update.delta.dx;
    });
  }

  // dispose() will release the resources used by the animation
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  /* Method checks whether the controller object is still mounted and active.
  A state object is mounted before calling initState() and until dispose()
  is called. Calling setState() when mounted is not true will raise an error. */
  void safeSetState (Function function) {
    if (mounted && controller.isAnimating) {
      setState(() {
        function();
      });
    }
  }

  double randomNumber() {
    // random number between 0.5 and 1.5
    var ran = new Random();
    // nextInt will return a random number
    // In this case, between 0 and 100
    int myNum = ran.nextInt(101);
    return (50 + myNum) / 100;
  }

  void showMessage(BuildContext context) {
    /* showDialog() displays a dialog window above the screen.  */
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Game Over'),
            content: Text('Would you like to play again?'),
            actions: <Widget>[
              FlatButton (
                onPressed: () {
                  setState(() {
                    posX = 0;
                    posY = 0;
                    score = 0;
                  });
                  // pop() will remove dialog from the screen
                  Navigator.of(context).pop();
                  // controller.repeat will play animation again
                  controller.repeat();
                },
              ),
              FlatButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                  dispose();
                },
              ),
            ],
          );
        });
  }
}


