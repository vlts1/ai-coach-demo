import 'package:ai_coach_demo/punch_destination.dart';
import 'package:flutter/material.dart';

class PunchDestinationAnimation extends StatefulWidget {
  final VoidCallback onFinish;
  final Color color;
  final PunchDestination destination;
  final Duration duration;

  PunchDestinationAnimation({
    Key? key,
    required this.onFinish,
    this.color = Colors.red,
    required this.destination,
    required this.duration,
  }) : super(key: key);

  @override
  _PunchDestinationAnimationState createState() => _PunchDestinationAnimationState();
}

class _PunchDestinationAnimationState extends State<PunchDestinationAnimation> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onFinish();
        }
      });

    _fadeAnimation = Tween<double>(begin: 1, end: 0).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        // Determine position based on PunchDestination
        double top = 0.0;
        double bottom = 0.0;

        if (widget.destination == PunchDestination.Head) {
          bottom = MediaQuery.of(context).size.height / 2;
        } else if (widget.destination == PunchDestination.Body) {
          top = MediaQuery.of(context).size.height / 2;
        } else {
          // Combo - Full screen
          top = 0.0;
          bottom = 0.0;
        }

        return Positioned(
          top: top,
          bottom: bottom,
          left: 0,
          right: 0,
          child: Container(
            color: widget.color.withOpacity(_fadeAnimation.value),
            child: Center(
              child: Text(
                widget.destination.name, // Removed context.tr() for demo
                style: TextStyle(
                  color: Colors.white.withOpacity(_fadeAnimation.value),
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
