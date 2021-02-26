import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:library_base/res/colors.dart';
import 'package:library_base/res/styles.dart';
import 'package:library_base/widget/easyrefresh/first_refresh_top.dart';
import 'package:library_base/widget/easyrefresh/loading_empty_top.dart';
import 'package:library_base/utils/date_util.dart';
import 'package:library_base/utils/num_util.dart';
import 'package:module_home/model/quote.dart';


class TimeSharingChart24h extends StatefulWidget {

  final List<Quote> quoteList;

  const TimeSharingChart24h({
    Key key,
    this.quoteList,
  }): super(key: key);

  @override
  _TimeSharingChart24hState createState() => _TimeSharingChart24hState();
}

class _TimeSharingChart24hState extends State<TimeSharingChart24h> {

  @override
  Widget build(BuildContext context) {
    bool _inited = widget.quoteList != null;
    int length = widget.quoteList != null ? widget.quoteList.length : 0;

    return Container(
      padding: EdgeInsets.only(top: 10),
      width: double.infinity,
      child: !_inited ? FirstRefreshTop() : length == 0 ? LoadingEmptyTop(top: 20) : LineChart(
        mainData(),
        swapAnimationDuration:const Duration(milliseconds: 0),
      ),
    );
  }

  LineChartData mainData() {

    int length = widget.quoteList != null ? widget.quoteList.length : 0;

    double minX = 0, maxX = 24, minY = 0, maxY = 0;
    List<FlSpot> spotList = new List();
    for (int i=length-1; i>=0; i--) {
      FlSpot spot = FlSpot(length - i.toDouble() - 1, widget.quoteList[i].quote);
      spotList.add(spot);

      minY = minY == 0 ? widget.quoteList[i].quote : min(widget.quoteList[i].quote, minY);
      maxY = max(widget.quoteList[i].quote, maxY);
    }

    //minY = minY.floorToDouble();
    //maxY = maxY.ceilToDouble();

    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      borderData:  FlBorderData(show: true, border: Border.symmetric(horizontal: BorderSide(color: const Color(0xffC6D9FF), width: 0.5))),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: max(1, NumUtil.divideDec(maxY - minY, 3).ceilToDouble()),
        getDrawingHorizontalLine: (value) {
          return FlLine(
            dashArray: [3, 3],
            color: const Color(0xffC6D9FF),
            strokeWidth: 0.5,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => TextStyles.textGray500_w400_12,
          getTitles: (value) {
            if (value.toInt() == 0) {
              return '    ' + value.toInt().toString() + ':00';
            } else if (value.toInt() == maxX) {
              return value.toInt().toString() + ':00    ';
            } else if (NumUtil.remainder(value.toInt(), NumUtil.divideDec(maxX - minX, 4).ceilToDouble()).toInt() == 0 && value.toInt() != 0 && value.toInt() != maxX) {
              return value.toInt().toString() + ':00';
            }
            return null;
          },
          interval: 1,
          margin: 8,
        ),
        leftTitles: SideTitles(showTitles: false),
        rightTitles: SideTitles(
          showTitles: true,
          interval: max(1, NumUtil.divideDec(maxY - minY, 3).toDouble() - 1),
          //interval: max(1, NumUtil.divideDec(maxY - minY, 3).floorToDouble()),
          getTextStyles: (value) => TextStyles.textGray500_w400_12,
          getTitles: (value) {
            return value.toStringAsFixed(2);
          },
          reservedSize: 48,
          margin: 10,
        ),
      ),
      minX: minX,
      maxX: maxX,
      minY: minY,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: spotList,
          isCurved: false,
          colors: [Colours.app_main],
          barWidth: 1,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradientFrom: Offset(0, 0),
            gradientTo: Offset(0, 1),
            colors: [Colours.app_main.withOpacity(0.2), Colours.app_main.withOpacity(0.0)],
            gradientColorStops: [0.2, 1.0],
          ),
        ),
      ],
    );
  }

}
