import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leez/constants/colors.dart';

// This widget is placed below the vendor section
class SalesChart extends StatefulWidget {
  @override
  _SalesChartState createState() => _SalesChartState();
}

class _SalesChartState extends State<SalesChart> {
  bool showMonthly = true;

  // Dummy sales data
  final List<double> monthlySales = [5, 7, 3, 6, 9, 8]; // 6 months
  final List<double> yearlySales = [40, 60, 35, 70, 50, 90]; // 6 years
  final months = ['Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  final years = [2020, 2021, 2022, 2023, 2024, 2025];

  @override
  Widget build(BuildContext context) {
    List<double> currentData = showMonthly ? monthlySales : yearlySales;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Statistics",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: ChoiceChip(
                label: const Text("Monthly Sales"),
                selected: showMonthly,
                onSelected: (selected) {
                  setState(() => showMonthly = true);
                },
                backgroundColor: AppColors.primary,
                selectedColor: AppColors.secondary,
                labelStyle: TextStyle(
                  color: showMonthly ? Colors.white : Colors.black,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: ChoiceChip(
                label: const Text("Yearly Sales"),
                selected: !showMonthly,
                onSelected: (selected) {
                  setState(() => showMonthly = false);
                },
                backgroundColor: AppColors.primary,

                selectedColor: AppColors.secondary,
                labelStyle: TextStyle(
                  color: !showMonthly ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        AspectRatio(
          aspectRatio: 1.5,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        showMonthly
                            ? months[value.toInt()]
                            : years[value.toInt()].toString(),
                      );
                    },
                    reservedSize: 28,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      return (value != 9 && value != 70)
                          ? Text('${value.toInt()}k')
                          : Text("");
                    },
                    reservedSize: 40,
                  ),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false, // ❌ Hide top values
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false, // ❌ Hide right values
                  ),
                ),
              ),
              barGroups:
                  currentData.asMap().entries.map((entry) {
                    int index = entry.key;
                    double value = entry.value;
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: value,
                          width: 16,
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    );
                  }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
