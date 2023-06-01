import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

// different library
import 'package:fl_chart/fl_chart.dart';

class moodEffect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        // child: SfCartesianChart(),

        child: BarChart(
          BarChartData(
            maxY: 1,
            minY: -1,
            barGroups: [
              BarChartGroupData(
                x: 0,
                barRods: [
                  BarChartRodData(
                    toY: 0.5,
                  )
                ]
              ),
              BarChartGroupData(
                x: 1,
                barRods: [
                  BarChartRodData(
                    toY: -0.8,
                  ),
                ]
              )
            ],
            gridData: FlGridData(show:false),
            /*titlesData: FlTitlesData(
              show: true,
            )*/ // SHOWS DATA LABLES MIGHT NEED LATER
            borderData: FlBorderData(
              show: true, 
              border: Border(
            )),
          ),
          swapAnimationDuration: Duration(milliseconds: 150),
          swapAnimationCurve: Curves.linear,
        )
      ),
    );
  }
}
