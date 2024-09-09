import 'dart:async';
import 'dart:math';
import 'package:ai_coach_demo/exit_button.dart';
import 'package:ai_coach_demo/punch_destination.dart';
import 'package:ai_coach_demo/punch_destination_animation.dart';
import 'package:ai_coach_demo/real_time_mistakes.dart';
import 'package:ai_coach_demo/stance.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CombosScreen extends StatefulWidget {
  const CombosScreen({super.key});

  @override
  State<CombosScreen> createState() => _CombosScreenState();
}

class _CombosScreenState extends State<CombosScreen> with SingleTickerProviderStateMixin {
  bool _showCountdown = true; // False by default
  late AnimationController _controller;
  late Animation<double> _animation;
  RealTimeMistakes? realTimeMistake;

  final breakBetweenPunches = [
    Duration(milliseconds: 850),
    Duration(milliseconds: 950),
    Duration(milliseconds: 1000),
    Duration(milliseconds: 1050),
  ];

  Timer? _timer;
  PunchDestination _punch = PunchDestination.Head;
  bool _showPunch = false;
  bool _isAnimating = false;

  List<PunchDestination> _punchWeights = [
    PunchDestination.Head,
    PunchDestination.Head,
    PunchDestination.Head,
    PunchDestination.None,
    PunchDestination.None,
    PunchDestination.Combo,
    PunchDestination.Combo,
  ]; // Weighted punches for likelihood

  static const animationDuration = 1200;
  late var breakBetween = breakBetweenPunches[
    Random().nextInt(breakBetweenPunches.length)
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    _controller = AnimationController(
      duration: Duration(milliseconds: animationDuration),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1, end: 0).animate(_controller);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _timer?.cancel();
    super.dispose();
  }

  void _startBlinking() {
    _timer = Timer.periodic(Duration(milliseconds: animationDuration + breakBetween.inMilliseconds), (timer) {
      if (!_isAnimating) {
        setState(() {
          _isAnimating = true;
          PunchDestination selectedPunch = _punchWeights[Random().nextInt(_punchWeights.length)];
          _showPunch = true;

          if (_punch == PunchDestination.Combo) {
            // Give extra time after the combos
            _punch = PunchDestination.None;
          } else {
            _punch = selectedPunch;
          }

          Future.delayed(Duration(milliseconds: animationDuration), () {
            setState(() {
              _showPunch = false;
              _isAnimating = false;
            });
          });
        });
      }
    });
  }

  void _onCountdownFinished() {
    _controller.forward().then((_) {
      setState(() {
        _showCountdown = false;
      });
      // Start mistake detection here
      _startBlinking();
    });
  }

  bool isInit = false;

  @override
  Widget build(BuildContext context) {
    final stance = Stance.ortho;
    final practicedLessons = ["Body Shots"];
    final userInPosition = true;

    if (!isInit) {
      // If user learned how to throw body shots, include them
      if (practicedLessons.contains("Body Shots")) {
        _punchWeights.add(PunchDestination.Body);
        _punchWeights.add(PunchDestination.Body);
      }
    }

    if (userInPosition) {
      if (!_showCountdown) {
        setState(() { _showCountdown = true; });
      }
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        drawerEnableOpenDragGesture: false,
        endDrawerEnableOpenDragGesture: false,
        body: Stack(
          fit: StackFit.expand,
          children: [
            if (_showPunch && _punch != PunchDestination.None)
              PunchDestinationAnimation(
                onFinish: () {}, 
                color: _punch == PunchDestination.Combo ? Colors.red : Colors.green,
                destination: _punch, duration: Duration(milliseconds: animationDuration),
              ),
            // if (_showCountdown)
            //   FadeTransition(
            //     opacity: _animation,
            //     child: CountdownAnimation(onFinish: _onCountdownFinished),
            //   ),
            if (realTimeMistake == RealTimeMistakes.chinUp)
              Positioned(
                child: Text("Widget explaining to hide your chin"),
                top: MediaQuery.of(context).padding.top + 64,
                right: 0,
              )
            else if (realTimeMistake == RealTimeMistakes.handsDown)
              Positioned(
                child: Text("Widget explaining to raise your hands"),
                top: MediaQuery.of(context).padding.top + 64,
                right: 0,
              ),
            if (!userInPosition) 
              Center(child: Text("Get in position")),

            ExitButton(),
            Positioned(top: 32, right: 20, child: Text("03:00")),
          ],
        ),
      ),
    );
  }
}