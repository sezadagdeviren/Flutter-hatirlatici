import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sensors/sensors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Güzel Ekran',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late DateTime _currentTime;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });

    // Sallama efektini başlat
    accelerometerEvents.listen((AccelerometerEvent event) {
      if (event.y > 12.0) {
        // Y ekseninde bir sallama algılandığında
        _snoozeAlarm();
      }
    });
  }

  void _snoozeAlarm() {
    // Burada alarmı 5 dakika erteleme işlemini gerçekleştirebilirsiniz
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Alarm 5 dakika ertelendi'),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Güzel Ekran"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    color: Colors.purple[300],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${_currentTime.hour}:${_currentTime.minute}",
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Center(
              child: Hero(
                tag: 'taskTag',
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 500),
                  opacity: 1.0,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Görev 1",
                          style: TextStyle(fontSize: 24),
                        ),
                        SizedBox(height: 16),
                        GestureDetector(
                          // Sallama algılandığında _snoozeAlarm fonksiyonunu çağır
                          onVerticalDragEnd: (details) {
                            if (details.primaryVelocity! < -10) {
                              _snoozeAlarm();
                            }
                          },
                          child: Text(
                            "Sallayarak 5 Dakika Ertele",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, right: 16.0),
        child: ReminderCard(),
      ),
    );
  }
}

class ReminderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Alarm kapatıldı'),
          ),
        );
      },
      background: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 16.0),
        color: Colors.green,
        child: Icon(
          Icons.check,
          color: Colors.white,
        ),
      ),
      child: ListTile(
        title: Text('Alarm Title'),
        subtitle: Text('Alarm Description'),
      ),
    );
  }
}
