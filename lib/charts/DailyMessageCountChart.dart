import 'package:charts_flutter/flutter.dart' as charts;
import 'package:chat_stats/database/MessageCountOnDay.dart';
import 'package:flutter/material.dart';

class TimeSeriesBar extends StatelessWidget {
  final List<charts.Series<MessageCountOnDay, DateTime>> seriesList;
  final bool animate = true;

  TimeSeriesBar(this.seriesList);

  factory TimeSeriesBar.withSampleData(List<MessageCountOnDay> data) {
    print(data.length);
    return new TimeSeriesBar(_createWithData(data));
  }

  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      seriesList,
      animate: true,
      // Set the default renderer to a bar renderer.
      // This can also be one of the custom renderers of the time series chart.
      defaultRenderer: new charts.BarRendererConfig<DateTime>(),
      // It is recommended that default interactions be turned off if using bar
      // renderer, because the line point highlighter is the default for time
      // series chart.
      defaultInteractions: false,
      // If default interactions were removed, optionally add select nearest
      // and the domain highlighter that are typical for bar charts.
      behaviors: [
        new charts.SelectNearest(
            selectionModelType: charts.SelectionModelType.info
        ),
        new charts.DomainHighlighter(),
        new charts.PanAndZoomBehavior(),
      ],
    );
  }

  static List<charts.Series<MessageCountOnDay, DateTime>> _createWithData(
      List<MessageCountOnDay> data) {
    return [
      new charts.Series<MessageCountOnDay, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (MessageCountOnDay sales, _) => sales.messageDate,
        measureFn: (MessageCountOnDay sales, _) => sales.messageCount,
        data: data,
      )
    ];
  }
}
