import 'dart:async';
import 'dart:math';
import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Timer _timer;
  int _milliseconds = 0;
  bool _isRunning = false;
  List<String> _laps = [];
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      if (_isRunning) {
        setState(() {
          _milliseconds += 10;
        });
      }
    });
  }

  void startStopwatch() {
    setState(() {
      _isRunning = true;
    });
  }

  void stopStopwatch() {
    setState(() {
      _isRunning = false;
    });
  }

  void resetStopwatch() {
    setState(() {
      _milliseconds = 0;
      _isRunning = false;
      _laps.clear();
    });
  }

  void recordLap() {
    setState(() {
      _laps.add(formatTime(_milliseconds));
    });
    // Scroll to the end of the list when a new lap is added
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  String formatTime(int milliseconds) {
    int hundreds = (milliseconds ~/ 10) % 100;
    int seconds = (milliseconds ~/ 1000) % 60;
    int minutes = (milliseconds ~/ 60000) % 60;
    int hours = (milliseconds ~/ 3600000);

    String hoursStr = hours.toString().padLeft(2, '0');
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');
    String hundredsStr = hundreds.toString().padLeft(2, '0');

    return "$hoursStr:$minutesStr:$secondsStr.$hundredsStr";
  }

  @override
  void dispose() {
    _timer.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 247, 251, 255),
        title: Padding(
          padding: EdgeInsets.only(bottom: 20, top: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Clock",
                style: TextStyle(
                  fontSize: 40,
                  color: Color.fromARGB(221, 0, 13, 41),
                  fontWeight: FontWeight.bold,
                ),
              ),
              ClayContainer(
                color: Color.fromARGB(255, 247, 251, 255),
                height: 50,
                width: 50,
                borderRadius: 50,
                child: Icon(
                  Icons.settings,
                  size: 30,
                  color: Colors.black45,
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 247, 251, 255),
      body: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(5),
        child: Column(
          children: [
            SizedBox(height: 20),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClayContainer(
                    color: Color.fromARGB(255, 247, 251, 255),
                    height: 300,
                    width: 300,
                    borderRadius: 300,
                    depth: 40,
                    spread: 20,
                    child: CustomPaint(
                      painter: ClockPainter(),
                    ),
                  ),
                  Text(
                    formatTime(_milliseconds),
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ClayContainer(
                  height: 50,
                  color: Color.fromARGB(255, 247, 251, 255),
                  width: 150,
                  borderRadius: 10,
                  depth: 40,
                  spread: 20,
                  child: TextButton(
                    onPressed: _isRunning ? stopStopwatch : startStopwatch,
                    child: Text(
                      _isRunning ? 'Pause' : 'Start',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                ClayContainer(
                  height: 50,
                  color: Color.fromARGB(255, 247, 251, 255),
                  width: 150,
                  borderRadius: 10,
                  depth: 40,
                  spread: 20,
                  child: TextButton(
                    onPressed: _isRunning ? recordLap : resetStopwatch,
                    child: Text(
                      _isRunning ? 'Record' : 'Reset',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _laps.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.all(5),
                    child: Padding(
                      
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: ClayContainer(
                        color: Color.fromARGB(255, 247, 251, 255),
                        borderRadius: 10,
                        depth: 20,
                        spread: 5,
                        child: ListTile(
                          title: Text('Lap ${index + 1}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                          trailing: Text(_laps[index],style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ClockPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2;

    for (int i = 0; i < 60; i++) {
      final angle = (i * 6) * (pi / 180);
      final x1 = center.dx + radius * 0.9 * cos(angle);
      final y1 = center.dy + radius * 0.9 * sin(angle);
      final x2 = center.dx + radius * 0.95 * cos(angle);
      final y2 = center.dy + radius * 0.95 * sin(angle);

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
