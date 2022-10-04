import 'package:app/models/dashboard/dashboard_like.dart';
import 'package:app/widgets/icon_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

class MostPopular extends StatefulWidget {
  List<DashboardLikes> likes;
  MostPopular({Key? key, required this.likes}) : super(key: key);
  @override
  MostPopularState createState() => MostPopularState();
}

class MostPopularState extends State<MostPopular> {
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
              icon: Icons.favorite,
              mainAxisAlignment: MainAxisAlignment.start,
              color: Colors.black,
              fontWeight: FontWeight.bold,
              size: 17,
              label: "Most Popular (Likes)"),
          const SizedBox(
            height: 10,
          ),
          SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              primaryYAxis: NumericAxis(minimum: 0, maximum: 40, interval: 10),
              onTooltipRender: (TooltipArgs args) {
                DashboardLikes dashboardLikes =
                    widget.likes[args.pointIndex!.toInt()];

                args.header = "${dashboardLikes.name} Likes";

                args.text = dashboardLikes.favorites.count.toString();
              },
              tooltipBehavior: _tooltip,
              series: <ChartSeries<DashboardLikes, String>>[
                ColumnSeries<DashboardLikes, String>(
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                    width: 0.5,
                    dataSource: widget.likes,
                    xValueMapper: (DashboardLikes data, _) => data.name,
                    yValueMapper: (DashboardLikes data, _) =>
                        data.favorites.count,
                    color: Colors.red)
              ]),
        ],
      ),
    );
  }
}
