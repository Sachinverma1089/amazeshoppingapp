import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../models/sales.dart';

class CategoryProductsChart extends StatelessWidget {
  final List<Sales> salesData;
  const CategoryProductsChart({
    Key? key,
    required this.salesData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (salesData.isEmpty) {
      return SizedBox();
    }
    return AspectRatio(
      aspectRatio: 1.7,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: const Color(0xff232d37),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: salesData
                    .map((data) => data.earning)
                    .reduce((a, b) => a > b ? a : b) *
                1.2,
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (group) => Colors.grey,
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              rightTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (double value, TitleMeta meta) {
                    final index = value.toInt();
                    if (index < salesData.length) {
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        child: Text(salesData[index].label),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: (double value, TitleMeta meta) {
                    return Text(value.toInt().toString());
                  },
                ),
              ),
            ),
            borderData: FlBorderData(
              show: false,
            ),
            barGroups: salesData.asMap().entries.map((entry) {
              int index = entry.key;
              Sales data = entry.value;
              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: data.earning.toDouble(),
                    color: Colors.lightBlueAccent,
                    width: 22,
                    borderRadius: BorderRadius.zero,
                  ),
                ],
                showingTooltipIndicators: [0],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
