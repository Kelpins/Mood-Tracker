import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'dart:async';
import 'dart:io';

import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';

// this version technically works but it is so incredibly ugly.
// the bars are vertical and all the labels are overlapping.
// this is awful

class AppColors {
  static const Color primary = contentColorCyan;
  static const Color menuBackground = Color(0xFF090912);
  static const Color itemsBackground = Color(0xFF1B2339);
  static const Color pageBackground = Color(0xFF282E45);
  static const Color mainTextColor1 = Colors.black;
  static const Color mainTextColor2 = Colors.white;
  static const Color mainTextColor3 = Colors.white38;
  static const Color mainGridLineColor = Colors.white10;
  static const Color borderColor = Colors.white54;
  static const Color gridLinesColor = Color(0x11FFFFFF);

  static const Color contentColorBlack = Colors.black;
  static const Color contentColorWhite = Colors.white;
  static const Color contentColorBlue = Color(0xFF2196F3);
  static const Color contentColorYellow = Color(0xFFFFC300);
  static const Color contentColorOrange = Color(0xFFFF683B);
  static const Color contentColorGreen = Color(0xFF3BFF49);
  static const Color contentColorPurple = Color(0xFF6E1BFF);
  static const Color contentColorPink = Color(0xFFFF3AF2);
  static const Color contentColorRed = Color(0xFFE80054);
  static const Color contentColorCyan = Color(0xFF50E4FF);
}

class AppUtils {
  factory AppUtils() {
    return _singleton;
  }

  AppUtils._internal();
  static final AppUtils _singleton = AppUtils._internal();

  double degreeToRadian(double degree) {
    return degree * math.pi / 180;
  }

  double radianToDegree(double radian) {
    return radian * 180 / math.pi;
  }
}

class BarChartSample5 extends StatefulWidget {
  const BarChartSample5({super.key});

  @override
  State<StatefulWidget> createState() => BarChartSample5State();
}

class BarChartSample5State extends State<BarChartSample5> {
  var user = FirebaseAuth.instance.currentUser!;
  var habitList = [];
  var moodDays = [];
  var barLabels = [];
  var barValues = [];

  static const double barWidth = 22;
  static const shadowOpacity = 0.0;
  var mainItems = <int, List<double>>{};

  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
  }

/*
  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(color: Colors.black, fontSize: 10);
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Mon';
        break;
      case 1:
        text = 'Tue';
        break;
      case 2:
        text = 'Wed';
        break;
      case 3:
        text = 'Thu';
        break;
      case 4:
        text = 'Fri';
        break;
      case 5:
        text = 'Sat';
        break;
      case 6:
        text = 'Sun';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }
  */

  Widget topTitles(double value, TitleMeta meta) {
    const style = TextStyle(color: Colors.black, fontSize: 10);
    String text;
    text = barLabels[value.toInt()];
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(color: Colors.black, fontSize: 10);
    String text;
    if (value == 0) {
      text = '0';
    } else {
      text = '${(value.toDouble() * 100).toInt()}%';
    }
    return SideTitleWidget(
      angle: 0,
      axisSide: meta.axisSide,
      space: 0,
      child: Text(
        text,
        style: style,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget rightTitles(double value, TitleMeta meta) {
    const style = TextStyle(color: Colors.black, fontSize: 10);
    String text;
    if (value == 0) {
      text = '0';
    } else {
      text = '${(value.toDouble() * 100).toInt()}%';
    }
    return SideTitleWidget(
      angle: 0,
      axisSide: meta.axisSide,
      space: 0,
      child: Text(
        text,
        style: style,
        textAlign: TextAlign.center,
      ),
    );
  }

  BarChartGroupData generateGroup(
    int x,
    double value1,
  ) {
    final isTop = value1 > 0;
    final sum = value1;
    final isTouched = touchedIndex == x;
    return BarChartGroupData(
      x: x,
      groupVertically: true,
      showingTooltipIndicators: isTouched ? [0] : [],
      barRods: [
        BarChartRodData(
          toY: sum,
          width: barWidth,
          borderRadius: isTop
              ? const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                )
              : const BorderRadius.only(
                  bottomLeft: Radius.circular(6),
                  bottomRight: Radius.circular(6),
                ),
          rodStackItems: [
            BarChartRodStackItem(
              0,
              value1,
              AppColors.contentColorGreen,
              BorderSide(
                color: Colors.black,
                width: isTouched ? 2 : 0,
              ),
            ),
          ],
        ),
        BarChartRodData(
          toY: -sum,
          width: barWidth,
          color: Colors.transparent,
          borderRadius: isTop
              ? const BorderRadius.only(
                  bottomLeft: Radius.circular(6),
                  bottomRight: Radius.circular(6),
                )
              : const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
          rodStackItems: [
            BarChartRodStackItem(
              0,
              -value1,
              AppColors.contentColorGreen
                  .withOpacity(isTouched ? shadowOpacity * 2 : shadowOpacity),
              const BorderSide(color: Colors.transparent),
            ),
          ],
        ),
      ],
    );
  }

  bool isShadowBar(int rodIndex) => rodIndex == 1;

  @override
  Widget build(BuildContext context) {
    // Iris's code starts here -----------------------------------
    bool loaded = false;

    final db = FirebaseFirestore.instance;
    final email = user.email;

    for (int i = 0; i < barValues.length; i++) {
      mainItems.addAll({
        i: [barValues[i]]
      });
    }

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
          math.sqrt(moodStandardDeviation * habitStandardDeviation);
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
                  barLabels.clear();
                  barValues.clear();
                  for (int i = 0; i < habitList.length; i++) {
                    var correlationFactor = snapshot.data![i];
                    barLabels.add(habitList[i].toString());
                    barValues.add(correlationFactor.toDouble());
                    mainItems[i] = [correlationFactor.toDouble()];
                    print("CF: $correlationFactor");
                  }
                  print("values!!!: $barValues");

                  return AspectRatio(
                    aspectRatio: 0.8,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.center,
                          maxY: 1,
                          minY: -1,
                          groupsSpace: 12,
                          barTouchData: BarTouchData(
                            handleBuiltInTouches: false,
                            touchCallback:
                                (FlTouchEvent event, barTouchResponse) {
                              if (!event.isInterestedForInteractions ||
                                  barTouchResponse == null ||
                                  barTouchResponse.spot == null) {
                                setState(() {
                                  touchedIndex = -1;
                                });
                                return;
                              }
                              final rodIndex =
                                  barTouchResponse.spot!.touchedRodDataIndex;
                              if (isShadowBar(rodIndex)) {
                                setState(() {
                                  touchedIndex = -1;
                                });
                                return;
                              }
                              setState(() {
                                touchedIndex =
                                    barTouchResponse.spot!.touchedBarGroupIndex;
                              });
                            },
                          ),
                          titlesData: FlTitlesData(
                            show: true,
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 32,
                                getTitlesWidget: topTitles,
                              ),
                            ),
                            /*
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 32,
                                getTitlesWidget: bottomTitles,
                              ),
                            ),
                            */
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: leftTitles,
                                interval: 5,
                                reservedSize: 42,
                              ),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: rightTitles,
                                interval: 5,
                                reservedSize: 42,
                              ),
                            ),
                          ),
                          gridData: FlGridData(
                            show: true,
                            checkToShowHorizontalLine: (value) =>
                                value % 5 == 0,
                            getDrawingHorizontalLine: (value) {
                              if (value == 0) {
                                return FlLine(
                                  color: AppColors.borderColor.withOpacity(0.1),
                                  strokeWidth: 3,
                                );
                              }
                              return FlLine(
                                color: AppColors.borderColor.withOpacity(0.05),
                                strokeWidth: 0.8,
                              );
                            },
                          ),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          barGroups: mainItems.entries
                              .map(
                                (e) => generateGroup(
                                  e.key,
                                  e.value[0],
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  );
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
}