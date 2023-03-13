import 'package:flutter/material.dart';

class StatPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("placeholder ٩(｡•́‿•̀｡)۶"),
          Text("will (maybe) become a correlation map for habits"),
          Image.asset('images/correlationMap.png', width: 270),
        ],
      ),
    );
  }
}
