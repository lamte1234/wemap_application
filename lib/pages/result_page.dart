import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wemap_application/data_models/running_data.dart';

class ResultPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var providerData = Provider.of<RunningData>(context);
    double distance = providerData.distance;
    int totalTime = providerData.totalTime ~/ 60;
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${providerData.caloriesConsumed().toStringAsFixed(2)}",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 60),
        ),
        Text(
          "calo",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        SizedBox(
          height: 150,
          width: 100,
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                child: Column(
                  children: [
                    Text(
                      "Distance",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      "${distance.toStringAsFixed(2)}",
                      style: TextStyle(fontSize: 30),
                    ),
                    Text(
                      "kilometers",
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: Column(
                  children: [
                    Text(
                      "Total Time",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      "$totalTime",
                      style: TextStyle(fontSize: 30),
                    ),
                    Text(
                      "minutes",
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: 100,
          width: 100,
        ),
        SizedBox(
            height: 40,
            width: 150,
            child: ElevatedButton(
                onPressed: () => Navigator.popAndPushNamed(context, "/"),
                child: Text(
                  "Continue",
                  style: TextStyle(color: Colors.white),
                ))),
        TextButton(
            onPressed: () => Navigator.popAndPushNamed(context, "/progress"),
            child: Text("History")),
      ],
    )));
  }
}
