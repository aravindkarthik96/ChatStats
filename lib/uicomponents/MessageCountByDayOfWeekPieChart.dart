import 'package:charts_flutter/flutter.dart' as charts;
import 'package:chat_stats/database/messages/MessageCountByDay.dart';
import 'package:flutter/material.dart';

class MessageCountByDayOfWeekPieChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate = true;

  MessageCountByDayOfWeekPieChart(this.seriesList);

  /// Creates a [PieChart] with sample data and no transition.
  factory MessageCountByDayOfWeekPieChart.withSampleData(
      List<MessageCountOnDayOfWeek> dayOfWeekMessageCount) {
    return new MessageCountByDayOfWeekPieChart(
      _createSampleData(dayOfWeekMessageCount),
      // Disable animations for image tests.
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(seriesList,
        animate: animate,
        // Configure the width of the pie slices to 60px. The remaining space in
        // the chart will be left as a hole in the center.
        //
        // [ArcLabelDecorator] will automatically position the label inside the
        // arc if the label will fit. If the label will not fit, it will draw
        // outside of the arc with a leader line. Labels can always display
        // inside or outside using [LabelPosition].
        //
        // Text style for inside / outside can be controlled independently by
        // setting [insideLabelStyleSpec] and [outsideLabelStyleSpec].
        //
        // Example configuring different styles for inside/outside:
        //       new charts.ArcLabelDecorator(
        //          insideLabelStyleSpec: new charts.TextStyleSpec(...),
        //          outsideLabelStyleSpec: new charts.TextStyleSpec(...)),
        defaultRenderer: new charts.ArcRendererConfig(arcRendererDecorators: [
          new charts.ArcLabelDecorator(
              labelPosition: charts.ArcLabelPosition.auto,
              insideLabelStyleSpec:
                  charts.TextStyleSpec(color: charts.Color.black, fontSize: 14))
        ]));
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<MessageCountOnDayOfWeek, String>> _createSampleData(
      List<MessageCountOnDayOfWeek> dayOfWeekMessageCount) {
    return [
      new charts.Series<MessageCountOnDayOfWeek, String>(
        id: 'Sales',
        domainFn: (MessageCountOnDayOfWeek sales, _) => sales.dayOfWeek,
        measureFn: (MessageCountOnDayOfWeek sales, _) => sales.messageCount,
        data: dayOfWeekMessageCount,
        // Set a label accessor to control the text of the arc label.
        labelAccessorFn: (MessageCountOnDayOfWeek row, _) =>
            '${row.dayOfWeek}\n ${row.messageCount}',
      )
    ];
  }
}
