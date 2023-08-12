import 'package:calculator_app/Constant/Colors.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  //veriables
  double firstNumber = 0.0;
  double secondNumber = 0.0;
  var input = "";
  var output = "";
  var operation = "";
  var hideInput = false;
  var outputSize = 34.0;

  onButtonClick(value) {
    if (input.length >= 10 && value != "AC" && value != "<" && value != "=") {
      // If input length is already 10 or more, don't add more characters.
      // You can show a snackbar or any other alert to indicate the limit has been reached.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Maximum input length is 10.'),
        ),
      );
      return;
    }

    if (value == "AC") {
      input = '';
      output = '';
    } else if (value == '<') {
      if (input.isNotEmpty) {
        input = input.substring(0, input.length - 1);
      }
    } else if (value == "=") {
      if (input.isNotEmpty) {
        var userInput = input;
        userInput = input.replaceAll("x", "*");
        Parser p = Parser();
        Expression expression = p.parse(userInput);
        ContextModel cm = ContextModel();
        var finalValue = expression.evaluate(EvaluationType.REAL, cm);
        output = finalValue.toString();
        if (output.endsWith(".0")) {
          output = output.substring(0, output.length - 2);
        }
        // Limit output length to 10 characters
        if (output.length > 15) {
          output = output.substring(0, 15);
        }
        input = output;
        hideInput = true;
        outputSize = 52;
      }
    } else {
      input = input + value;
      hideInput = false;
      outputSize = 34;
    }

    setState(() {});
  }

  void _showDeveloperContactsPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text("Developer Contacts")),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage("assets/images/developer.png"),
              ),
              SizedBox(height: 10),
              Text("Developed by Zain Ishtiaq"),
              Text("zainishtiaq.7866@gmail.com"),
              Text("+923028163676"),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  String _getString() {
    final currentTime = TimeOfDay.now();
    if (currentTime.hour >= 0 && currentTime.hour < 12) {
      return "Good Morning";
    } else if (currentTime.hour >= 12 && currentTime.hour < 18) {
      return "Good Afternoon";
    } else {
      return "Good Evening";
    }
  }

  String _getStringImage() {
    final currentTime = TimeOfDay.now();
    if (currentTime.hour >= 0 && currentTime.hour < 12) {
      return "assets/images/morning.png";
    } else if (currentTime.hour >= 12 && currentTime.hour < 18) {
      return "assets/images/afternoon.png"; // Change this line to use "afternoon.png"
    } else {
      return "assets/images/night.png";
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundImage = _getStringImage();
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 50, left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        "Hi, ${_getString()} ",
                        style: TextStyle(
                            fontSize: 20,
                            color: textColor,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Image.asset(
                        backgroundImage,
                        width: 20,
                        height: 20,
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      _showDeveloperContactsPopup(
                          context); // Call the function to show developer details in a pop-up
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage:
                          AssetImage("assets/images/developer.png"),
                    ),
                  ),
                ],
              ),
            ),

            //input output area
            Expanded(
                child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    hideInput ? '' : input,
                    style: TextStyle(fontSize: 48, color: Colors.white),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    output,
                    style: TextStyle(
                        fontSize: outputSize,
                        color: Colors.white.withOpacity(0.7)),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            )),
            //buttton area
            Row(
              children: [
                button(
                  text: "AC",
                  buttomBgColor: Colors.orange,
                ),
                button(text: "<", buttomBgColor: Colors.orange),
                button(text: "%", buttomBgColor: Colors.orange),
                button(text: "/", buttomBgColor: Colors.orange),
              ],
            ),
            Row(
              children: [
                button(text: "7"),
                button(text: "8"),
                button(text: "9"),
                button(text: "x", buttomBgColor: Colors.orange),
              ],
            ),
            Row(
              children: [
                button(text: "4"),
                button(text: "5"),
                button(
                  text: "6",
                ),
                button(text: "-", buttomBgColor: Colors.orange),
              ],
            ),
            Row(
              children: [
                button(text: "1"),
                button(text: "2"),
                button(
                  text: "3",
                ),
                button(text: "+", buttomBgColor: Colors.orange),
              ],
            ),
            Row(
              children: [
                button(text: "0", flex: 2),
                button(text: "."),
                button(text: "=", buttomBgColor: Colors.orange),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget button(
      {text,
      tColor = Colors.white,
      buttomBgColor = Colors.blueGrey,
      flex = 1}) {
    return Expanded(
        flex: flex,
        child: Container(
          margin: const EdgeInsets.all(5),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                primary: buttomBgColor,
                padding: EdgeInsets.all(22)),
            onPressed: () => onButtonClick(text),
            child: Text(
              text,
              style: TextStyle(
                  fontSize: 18, color: tColor, fontWeight: FontWeight.bold),
            ),
          ),
        ));
  }
}
