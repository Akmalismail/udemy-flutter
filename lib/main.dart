import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  void answerQuestion() {
    print('Answer chosen!');
  }

  @override
  Widget build(BuildContext context) {
    var questions = [
      'What\'s your favorite colour?',
      'What\'s your favorite animal?'
    ];

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('My First App'),
        ),
        body: Column(
          children: [
            Text('The question!'),
            RaisedButton(
              onPressed: answerQuestion,
              child: Text('Answer 1'),
            ),
            RaisedButton(
              onPressed: () => print('Answer 2 chosen!'),
              child: Text('Answer 2'),
            ),
            RaisedButton(
              onPressed: () {
                // ...
                print('Answer 3 chosen!');
              },
              child: Text('Answer 3'),
            ),
          ],
        ),
      ),
    );
  }
}
