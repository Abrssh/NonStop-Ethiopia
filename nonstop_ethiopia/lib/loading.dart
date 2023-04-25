import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    // var deviceWidth = deviceSize.width;
    var deviceHeight = deviceSize.height;
    return Container(
      color: Colors.grey[50],
      child: Center(
        child: SpinKitChasingDots(
          color: Colors.blue,
          size: deviceHeight * 0.08,
        ),
      ),
    );
  }
}
