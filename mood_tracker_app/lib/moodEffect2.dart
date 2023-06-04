import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';
import 'dart:async';
import 'dart:io';

class barChart extends StatefulWidget {
  const barChart({Key? key}) : super(key: key);

  @override
  State<barChart> createState() => _barChartState();
}

class _barChartState extends State<barChart> {
  var user = FirebaseAuth.instance.currentUser!;
  var habitList = [];
  var moodDays = [];
  var barValues = [];
  var barLabels = [];
  var barMap = {};
  late List<correlationData> _chartData;

  @override
  void initState() {
    super.initState();
    _chartData = getChartData();
  }

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

    double roundDouble(double value, int places) {
      double mod = pow(10.0, places).toDouble();
      return ((value * mod).round().toDouble() / mod);
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
      try {
        final habitData = doc.data() as Map<String, dynamic>;
      } catch (e) {
        return 0;
      }
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

      // Makes it so that the standard deviations (which end up in the denominator) are never 0
      // UNHIDE IF YOU WANT TO DISPLAY ALL HABITS, EVEN THOSE W/ VALUE 0
      //habitStandardDeviation += 0.00001;
      //moodStandardDeviation += 0.00001;

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
      //},

      //onError: (e) ==> print("Error getting document: $e"),
      //);

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

            var correlationFactorFutures = <Future<num>>[];
            for (int i = 0; i < habitList.length; i++) {
              var habit = habitList[i];
              // finds the correlation between the specific habit and the user's mood
              // this will return NaN if there's not enough data!! do not worry!!
              var correlationFactorFuture =
                  calculateCorrelationFactor(habit, moodDays, userData);
              correlationFactorFutures.add(correlationFactorFuture);
            }

            return FutureBuilder<List<num>>(
              future: Future.wait(correlationFactorFutures),
              builder:
                  (BuildContext context, AsyncSnapshot<List<num>> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  barValues.clear();
                  barLabels.clear();
                  for (int i = 0; i < habitList.length; i++) {
                    var correlationFactor = snapshot.data![i].toDouble();
                    if (correlationFactor.isFinite) {
                      print("full correlation factor: $correlationFactor");
                      correlationFactor = roundDouble(correlationFactor, 2);
                      barMap[habitList[i].toString()] = correlationFactor;
                      //barLabels.add(habitList[i].toString());
                      barValues.add(correlationFactor);
                    }
                  }
                  print("barMap: $barMap");
                  print("barValues: $barValues");
                  //print("barLabels: $barLabels");

                  _chartData = getChartData();

                  // replace this return statement
                  return Scaffold(
                      body: Center(
                          child: Container(
                    child: SfCartesianChart(
                        series: <ChartSeries>[
                          BarSeries<correlationData, String>(
                              dataSource: _chartData,
                              xValueMapper:
                                  (correlationData correlationFactor, _) =>
                                      correlationFactor.habitLabel,
                              yValueMapper:
                                  (correlationData correlationFactor, _) =>
                                      correlationFactor.correlationFactor,
                              dataLabelSettings:
                                  DataLabelSettings(isVisible: true),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              color: Color.fromARGB(255, 255, 184, 189),
                              width: 0.3,
                              spacing: 0.2),
                        ],
                        primaryXAxis: CategoryAxis(),
                        primaryYAxis: NumericAxis(
                          title: AxisTitle(text: 'Effect on mood'),
                          minimum: -1,
                          maximum: 1,
                        )),
                  )));
                }

                return Column(
                  children: [
                    SizedBox(height: 200),
                    Center(
                        child:
                            const Text("Calculating correlation factors...")),
                  ],
                );
              },
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

  // data for each bar :)
  List<correlationData> getChartData() {
    final List<correlationData> chartData = [];

    barValues.sort();
    print("sorted bar values: $barValues");

    for (int i = 0; i < barValues.length; i++) {
      var label = barMap.keys
          .firstWhere((k) => barMap[k] == barValues[i], orElse: () => null);
      chartData.add(correlationData(label, barValues[i]));
    }

    return chartData;
  }
}

class correlationData {
  correlationData(this.habitLabel, this.correlationFactor);
  final String habitLabel;
  final double correlationFactor;
}
