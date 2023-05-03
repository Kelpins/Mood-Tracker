import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class heatmap extends StatelessWidget {
  final String email;

  heatmap(this.email);

  @override
  Widget build(BuildContext context) {
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
                  datasets: {
                    // Provide the dataset for the heatmap, mapping date & time to values
                    DateTime(2023, 5, 1): data["2023-05-01"],
                  },
                  colorsets: const {
                    // Colorsets (themes)
                    1: Colors.purple,
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
