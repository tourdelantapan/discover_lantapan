import 'package:app/models/dashboard/dashboard_like.dart';
import 'package:app/models/dashboard/dashboard_rating.dart';
import 'package:app/widgets/icon_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

class MostRated extends StatefulWidget {
  List<DashboardRating> ratings;
  MostRated({Key? key, required this.ratings}) : super(key: key);
  @override
  MostRatedState createState() => MostRatedState();
}

class MostRatedState extends State<MostRated> {
  late TooltipBehavior _tooltip;

  @override
  void initState() {
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          IconText(
              icon: Icons.star,
              mainAxisAlignment: MainAxisAlignment.start,
              color: Colors.black,
              fontWeight: FontWeight.bold,
              size: 17,
              label: "Most Rated"),
          const SizedBox(
            height: 10,
          ),
          SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              primaryYAxis: NumericAxis(minimum: 0, maximum: 5, interval: 1),
              onTooltipRender: (TooltipArgs args) {
                DashboardRating dashboardLikes =
                    widget.ratings[args.pointIndex!.toInt()];

                args.header = "${dashboardLikes.name} Reviews";

                args.text =
                    "Based on ${dashboardLikes.reviewsStat.reviewerCount.toString()} review/s.";
              },
              tooltipBehavior: _tooltip,
              series: <ChartSeries<DashboardRating, String>>[
                ColumnSeries<DashboardRating, String>(
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                    width: 0.5,
                    dataSource: widget.ratings,
                    xValueMapper: (DashboardRating data, _) => data.name,
                    yValueMapper: (DashboardRating data, _) =>
                        data.reviewsStat.average,
                    color: Colors.red)
              ]),
        ],
      ),
    );
  }
}
