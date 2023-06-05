import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:intl/intl.dart';

class heatmap extends StatelessWidget {
  final String email;

  heatmap(this.email);

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();

    String today = DateFormat('MM-dd-yyyy').format(now);
    CollectionReference moods = FirebaseFirestore.instance.collection('Users');

    return FutureBuilder<DocumentSnapshot>(
      //Fetching data from the documentId specified of the student
      future: moods.doc(email).collection("Moods").doc("Mood").get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        //Error Handling conditions
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        //Data is output to the user
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          // removes everything else in the document so only the moods are left
          data.remove("username");
          data.remove("Habits");
          data.remove("HabitMatchingToday");
          data.remove("HabitDay");

          Map<DateTime, int> dataset = {};
          for (int i = 0; i < data.length; i++) {
            List<String> datums = data.keys.toList();

            // dates are stored as strings, converted to DateTime here
            int month = int.parse(datums[i].split("-")[0]);
            int day = int.parse(datums[i].split("-")[1]);
            int year = int.parse(datums[i].split("-")[2]);

            dataset[DateTime(year, month, day)] = data[datums[i]].round();
          }

          // frontend
          return Column(
            children: [
              Container(
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 230, 230),
                  borderRadius: BorderRadius.circular(15),
                ),
                height: 50,
                width: 375,
                child: Center(
                  child: Text(
                    'Mood Heatmap',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // heatmap
              Container(
                  margin: const EdgeInsets.all(20),
                  child: HeatMapCalendar(
                    // Properties for the heatmap widget
                    defaultColor: Colors.white,
                    //scrollable: true,
                    colorMode: ColorMode.color,
                    size: 35,
                    fontSize: 15,
                    monthFontSize: 20,
                    flexible: true,
                    showColorTip: false,
                    //showText: true,
                    borderRadius: 10,
                    margin: const EdgeInsets.all(6),
                    datasets: dataset,
                    colorsets: {
                      // Colorsets (themes)
                      0: Color.fromARGB(255, 234, 131, 121),
                      1: Color.fromARGB(255, 240, 150, 130),
                      2: Color.fromARGB(255, 238, 189, 141),
                      3: Color.fromARGB(255, 236, 208, 153),
                      4: Color.fromARGB(255, 185, 200, 144),
                      5: Color.fromARGB(255, 160, 190, 140),
                      6: Color.fromARGB(255, 154, 200, 136),
                    },
                  )),
            ],
          );
        }

        return Text("Loading...");
      },
    );
  }
}
