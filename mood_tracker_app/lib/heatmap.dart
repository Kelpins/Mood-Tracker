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

          //return Text(data.toString());

          Map<DateTime, int> dataset = {};
          for (int i = 0; i < data.length; i++) {
            List<String> datums = data.keys.toList();

            int month = int.parse(datums[i].split("-")[0]);
            int day = int.parse(datums[i].split("-")[1]);
            int year = int.parse(datums[i].split("-")[2]);

            dataset[DateTime(year, month, day)] = data[datums[i]].round();
          }
          return Text(data.toString());

          return Container(
              margin: const EdgeInsets.all(20),
              child: HeatMap(
                  // Properties for the heatmap widget
                  defaultColor: Colors.white,
                  scrollable: true,
                  colorMode: ColorMode.opacity,
                  size: 40,
                  fontSize: 20,
                  showColorTip: false,
                  showText: true,
                  borderRadius: 10,
                  margin: const EdgeInsets.all(5),
                  datasets: dataset,
                  colorsets: const {
                    // Colorsets (themes)
                    0: Colors.yellow,
                    1: Colors.green,
                    2: Colors.blue,
                    3: Colors.purple,
                  },
                  onClick: (value) {
                    // onClick event
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(value.toString())));
                  }));
        }

        return Text("loading");
      },
    );
  }
}
