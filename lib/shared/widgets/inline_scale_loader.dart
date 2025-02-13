import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class InlineScaleLoader extends StatelessWidget {
  const InlineScaleLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.1,
        height: MediaQuery.of(context).size.height * 0.06,
        child: const LoadingIndicator(
            indicatorType: Indicator.lineScalePulseOut,
            colors: [Colors.black],
            strokeWidth: 0.5,
            pathBackgroundColor: Colors.black),
      ),
    );
  }
}
