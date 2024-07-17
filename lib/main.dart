import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(
        body: Chart(),
      ),
    );
  }
}

class Chart extends StatefulWidget {
  const Chart({super.key});

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  final List<ChartSampleData> chartData = List.generate(
    100,
    (index) => ChartSampleData(
      x: 'E${index + 1}',
      y: Random().nextDouble() * 100,
    ),
  );

  late final double min;
  late final double max;
  late final RangeController rangeController;

  @override
  void initState() {
    super.initState();
    const int numOfElementsToShow = 10;
    min = -0.5;
    max = chartData.length - 1 + 0.5;
    rangeController = RangeController(
      start: min,
      end: min + numOfElementsToShow,
    );
  }

  @override
  void dispose() {
    chartData.clear();
    rangeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SfCartesianChart chart = SfCartesianChart(
      zoomPanBehavior: ZoomPanBehavior(
        enablePanning: true,
        zoomMode: ZoomMode.x,
        enableSelectionZooming: true,
        enableDoubleTapZooming: true,
        enableMouseWheelZooming: true,
      ),
      primaryXAxis: CategoryAxis(
        isVisible: false,
        minimum: min,
        maximum: max,
        initialVisibleMinimum: rangeController.start,
        initialVisibleMaximum: rangeController.end,
        rangeController: rangeController,
      ),
      primaryYAxis: const NumericAxis(),
      series: [
        ColumnSeries<ChartSampleData, String>(
          dataSource: chartData,
          animationDuration: 0,
          xValueMapper: (ChartSampleData sales, int index) => sales.x,
          yValueMapper: (ChartSampleData sales, int index) => sales.y,
        ),
      ],
    );

    return Column(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: chart,
          ),
        ),
        Container(
          margin:
              const EdgeInsets.only(left: 50, right: 10, top: 10, bottom: 20),
          child: SfRangeSelectorTheme(
            data: SfRangeSelectorThemeData(
              thumbRadius: 0,
              overlayRadius: 0,
              inactiveTrackHeight: 0,
              activeTrackHeight: 0,
              inactiveRegionColor: Colors.black12.withOpacity(0.3),
              activeRegionColor: Colors.black.withOpacity(0.7),
            ),
            child: SfRangeSelector(
              min: min,
              max: max,
              controller: rangeController,
              initialValues: SfRangeValues(
                rangeController.start,
                rangeController.end,
              ),
              interval: 1,
              dragMode: SliderDragMode.betweenThumbs,
              child: SizedBox(
                height: 5,
                child: SfCartesianChart(
                  margin: const EdgeInsets.all(0),
                  primaryXAxis: const CategoryAxis(isVisible: false),
                  primaryYAxis: const NumericAxis(isVisible: false),
                  series: [
                    ColumnSeries<ChartSampleData, String>(
                      dataSource: chartData,
                      color: Colors.transparent,
                      xValueMapper: (ChartSampleData sales, int index) =>
                          sales.x,
                      yValueMapper: (ChartSampleData sales, int index) =>
                          sales.y,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ChartSampleData {
  const ChartSampleData({required this.x, required this.y, required});
  final String x;
  final double y;
}
