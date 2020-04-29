import 'package:flutter/material.dart';
import 'package:quizzler/quiz_logic.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

QuizLogic quizLogic = QuizLogic();

void main() => runApp(Quizzler());

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Icon> scoreKeeper = [];

  Icon createCheckIcon() => Icon(Icons.check, color: Colors.green);
  Icon createCloseIcon() => Icon(Icons.close, color: Colors.red);
  void checkAnswer(bool answer) {
    Icon icon = answer == quizLogic.questionAnswer()
        ? createCheckIcon()
        : createCloseIcon();
    setState(() {
      scoreKeeper.add(icon);
      quizLogic.nextQuestion();

      if (quizLogic.isFinished()) {
        Alert(
          context: context,
          type: AlertType.error,
          title: "",
          desc: "You have finished the quiz",
          closeFunction: () {},
          buttons: [
            DialogButton(
              child: Text(
                "Restart",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  scoreKeeper = [];
                  quizLogic.reset();
                });
              },
              width: 120,
            )
          ],
        ).show();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                quizLogic.questionText(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              textColor: Colors.white,
              color: Colors.green,
              child: Text(
                !quizLogic.isFinished() ? 'True' : '',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: !quizLogic.isFinished()
                  ? () {
                      //The user picked true.
                      checkAnswer(true);
                    }
                  : null,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              color: Colors.red,
              child: Text(
                !quizLogic.isFinished() ? 'False' : '',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: !quizLogic.isFinished()
                  ? () {
                      //The user picked false.
                      checkAnswer(false);
                    }
                  : null,
            ),
          ),
        ),
        Row(
          children: scoreKeeper,
        ),
      ],
    );
  }
}

/*
question1: 'You can lead a cow down stairs but not up stairs.', false,
question2: 'Approximately one quarter of human bones are in the feet.', true,
question3: 'A slug\'s blood is green.', true,
*/
