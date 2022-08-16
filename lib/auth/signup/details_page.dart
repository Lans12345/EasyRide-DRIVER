import 'package:easy_ride_driver/auth/signup/signup_page.dart';
import 'package:easy_ride_driver/widgets/appbar.dart';
import 'package:easy_ride_driver/widgets/button.dart';
import 'package:easy_ride_driver/widgets/text.dart';
import 'package:flutter/material.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({Key? key}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  int _currentStep = 0;

  var prices = ['20', '15', '10', '5'];

  var vehicles = ['Taxi', 'Habal-habal', 'Jeep', 'Rela'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbarSignUp(),
      body: Center(
          child: ListView(
        children: [
          Stepper(
            currentStep: _currentStep,
            onStepTapped: (int newValue) {
              setState(() {
                _currentStep = newValue;
              });
            },
            onStepContinue: () {
              if (_currentStep != 1) {
                setState(() {
                  _currentStep += 1;
                });
              }
            },
            onStepCancel: () {
              if (_currentStep != 0) {
                setState(() {
                  _currentStep -= 1;
                });
              }
            },
            steps: [
              Step(
                title: textBold('Pricing', 16, Colors.black),
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    textBold('Prices per Booking', 16, Colors.black),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 250,
                      child: ListView.builder(
                          itemCount: vehicles.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title:
                                  textBold(vehicles[index], 16, Colors.black),
                              trailing: textReg(
                                  prices[index] + 'php', 18, Colors.green),
                            );
                          }),
                    ),
                  ],
                ),
              ),
              Step(
                title: textBold('Rules and Regulations', 16, Colors.black),
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    ListTile(
                      leading: Icon(
                        Icons.warning_rounded,
                        color: Colors.red,
                      ),
                      title: Text(
                        'Payment is once a month',
                        style: TextStyle(
                          fontFamily: 'QRegular',
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.warning_rounded,
                        color: Colors.red,
                      ),
                      title: Text(
                        'After a month, duration of payment is maximum of 7 days / 1 week',
                        style: TextStyle(
                          fontFamily: 'QRegular',
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.warning_rounded,
                        color: Colors.red,
                      ),
                      title: Text(
                        'Failed to pay on time scheduled will be automatically banned from this system',
                        style: TextStyle(
                          fontFamily: 'QRegular',
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.warning_rounded,
                        color: Colors.red,
                      ),
                      title: Text(
                        "Total Payment can be seen through Driver's Profile",
                        style: TextStyle(
                          fontFamily: 'QRegular',
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Button(
              buttonText: 'I Agree',
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const SignUp()));
              }),
        ],
      )),
    );
  }
}
