import 'package:flutter/material.dart';

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(width: 30, height: 30, child: CircularProgressIndicator()),
          SizedBox(height: 20),
          Text("Daten werden geladen...")
        ],
      ),
    );
  }
}
