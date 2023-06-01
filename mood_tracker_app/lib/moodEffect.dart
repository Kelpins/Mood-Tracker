import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';
import 'dart:async';
import 'dart:io';
// different library
import 'package:fl_chart/fl_chart.dart';

class moodEffect extends StatefulWidget {
  const moodEffect({Key? key}) : super(key: key);

  @override
  State<moodEffect> createState() => _moodEffectState();
}

class _moodEffectState extends State<moodEffect> {
  var user = FirebaseAuth.instance.currentUser!;
  var habitList = [];
  var moodDays = [];

  @override
  Widget build(BuildContext context) {
    bool loaded = false;

    final db = FirebaseFirestore.instance;
    final email = user.email;

    CollectionReference userDatabase =
        FirebaseFirestore.instance.collection('Users');

    // I could not find a built in version for dart :(
    boolToInt(bool boolValue) {
      if (boolValue == true) {
        return 1;
      }
      return 0;
    }

    Future<num> calculateCorrelationFactor(
        String habitName, List moodDays, moodData) async {
      num correlationFactor = 0;
      var habitDays = [];
      var validDays = [];
      var habitValues = [];
      var moodValues = [];
      num habitMean = 0;
      num habitSum = 0;
      var habitDeviationValues = [];
      num habitStandardDeviation = 0;
      num moodMean = 0;
      num moodSum = 0;
      var moodDeviationValues = [];
      num moodStandardDeviation = 0;
      num deviationProductSum = 0;

      final habitDataRef =
          db.collection('Users').doc(email).collection("Habits").doc(habitName);

      //await habitDataRef.get().then(
      //(DocumentSnapshot doc) {
      final DocumentSnapshot doc = await habitDataRef.get();
      final habitData = doc.data() as Map<String, dynamic>;

      // Days where there is data for that specific habit
      habitDays = habitData.keys.toList();

      // Days where there is data for both mood and that habit
      validDays = habitDays;
      validDays.removeWhere((item) => !moodDays.contains(item));

      // Goes through the days and finds the relevant habit and mood values
      for (var i = 0; i < validDays.length; i++) {
        habitValues.add(boolToInt(habitData[validDays[i]]));
        moodValues.add(moodData[validDays[i]]);
      }

      // HABITS SECTION ----------------------------------------------------

      // Mean habit value
      for (num value in habitValues) {
        habitSum += value;
      }
      habitMean = habitSum / habitValues.length;

      // Finds the deviation score of each habit value (value - mean)
      habitDeviationValues = List.filled(habitValues.length, 0);
      for (var i = 0; i < habitValues.length; i++) {
        habitDeviationValues[i] = habitValues[i] - habitMean;
      }

      // Finds the standard deviation of the habits (sum of the square of the deviation scores)
      for (num value in habitDeviationValues) {
        habitStandardDeviation += value * value;
      }

      // MOOD SECTION ----------------------------------------------------

      // Mean mood value
      for (num value in moodValues) {
        moodSum += value;
      }
      moodMean = moodSum / moodValues.length;

      // Finds the deviation score of each mood value (value - mean)
      moodDeviationValues = List.filled(moodValues.length, 0);
      for (var i = 0; i < moodValues.length; i++) {
        moodDeviationValues[i] = moodValues[i] - moodMean;
      }

      // Finds the standard deviation of the moods (sum of the square of the deviation scores)
      for (num value in moodDeviationValues) {
        moodStandardDeviation += value * value;
      }

      // OVERALL SECTION ---------------------------------------------------

      // Sum of products of deviation scores
      for (var i = 0; i < moodDeviationValues.length; i++) {
        deviationProductSum += moodDeviationValues[i] * habitDeviationValues[i];
      }

      // Finding the correlation factor
      correlationFactor = deviationProductSum /
          sqrt(moodStandardDeviation * habitStandardDeviation);
      print("correlation factor: $correlationFactor");
      //},

      //onError: (e) ==> print("Error getting document: $e"),
      //);

      print("correlation factor when it's time to return : $correlationFactor");

      return correlationFactor;
    }

    return FutureBuilder<DocumentSnapshot>(
        future: userDatabase.doc(email).collection("Moods").doc("Mood").get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          //Error Handling conditions
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return const Text("Document does not exist");
          }

          loaded = true;

          //Data is output to the user
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> userData =
                snapshot.data!.data() as Map<String, dynamic>;

            // read database for list of habits
            habitList = userData['Habits'];
            print("Habit List: " + habitList.toString());

            // read database for list of days w/ mood data
            moodDays = userData.keys.toList();
            moodDays.remove("username");
            moodDays.remove("Habits");
            moodDays.remove("HabitMatchingToday");
            moodDays.remove("HabitDay");
            print("Days with mood data: " + moodDays.toString());

            // iterates through all the habits
            for (final habit in habitList) {
              // finds the correlation between the specific habit and the user's mood
              // this will return NaN if there's not enough data!! do not worry!!
              calculateCorrelationFactor(habit, moodDays, userData)
                  .then((correlationFactor) {
                print("CF: $correlationFactor");
              });
            }

            return Center(
              child: Container(
                  // child: SfCartesianChart(),

                  child: BarChart(
                BarChartData(
                  maxY: 1,
                  minY: -1,
                  barGroups: [
                    BarChartGroupData(x: 0, barRods: [
                      BarChartRodData(
                        toY: 0.5,
                      )
                    ]),
                    BarChartGroupData(x: 1, barRods: [
                      BarChartRodData(
                        toY: -0.8,
                      ),
                    ]),
                  ],
                  gridData: FlGridData(show: false),
                  /*titlesData: FlTitlesData(
              show: true,
            )*/ // SHOWS DATA LABLES MIGHT NEED LATER
                  borderData: FlBorderData(show: true, border: Border()),
                ),
                swapAnimationDuration: Duration(milliseconds: 150),
                swapAnimationCurve: Curves.linear,
              )),
            );
          }

          if (!loaded) {
            return Column(children: [
              SizedBox(height: 200),
              Center(child: const Text("Loading..."))
            ]);
          }

          return Scaffold();
        });
  }
}
