import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CompletionChart extends StatefulWidget {
  final List<Map<String, dynamic>> chartData;
  final String timeFrame;

  const CompletionChart({
    super.key,
    required this.chartData,
    required this.timeFrame,
  });

  @override
  State<CompletionChart> createState() => _CompletionChartState();
}

class _CompletionChartState extends State<CompletionChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: AppTheme.shadowLight,
                  blurRadius: 8,
                  offset: const Offset(0, 2)),
            ]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              CustomIconWidget(
                  iconName: 'bar_chart', color: AppTheme.primaryTeal, size: 24),
              SizedBox(width: 2.w),
              Text('Completion Trends',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textHighEmphasisLight)),
            ]),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                    color: AppTheme.primaryTeal.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20)),
                child: Text(widget.timeFrame,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.primaryTeal,
                        fontWeight: FontWeight.w500))),
          ]),
          SizedBox(height: 3.h),
          SizedBox(
              height: 30.h,
              child: widget.chartData.isEmpty
                  ? _buildEmptyState()
                  : _buildChart()),
        ]));
  }

  Widget _buildEmptyState() {
    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      CustomIconWidget(
          iconName: 'show_chart', color: AppTheme.textDisabledLight, size: 48),
      SizedBox(height: 2.h),
      Text('No data available',
          style: AppTheme.lightTheme.textTheme.titleSmall
              ?.copyWith(color: AppTheme.textDisabledLight)),
      SizedBox(height: 1.h),
      Text('Start tracking habits to see your progress',
          style: AppTheme.lightTheme.textTheme.bodySmall
              ?.copyWith(color: AppTheme.textDisabledLight),
          textAlign: TextAlign.center),
    ]));
  }

  Widget _buildChart() {
    return BarChart(BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 100,
        barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
                tooltipRoundedRadius: 8,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  final data = widget.chartData[groupIndex];
                  return BarTooltipItem(
                      '${data['label']}\n${rod.toY.toInt()}% completed',
                      AppTheme.lightTheme.textTheme.bodySmall!.copyWith(
                          color: AppTheme.pureWhite,
                          fontWeight: FontWeight.w500));
                }),
            touchCallback: (FlTouchEvent event, barTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    barTouchResponse == null ||
                    barTouchResponse.spot == null) {
                  touchedIndex = -1;
                  return;
                }
                touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
              });
            }),
        titlesData: FlTitlesData(
            show: true,
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= 0 &&
                          value.toInt() < widget.chartData.length) {
                        return Padding(
                            padding: EdgeInsets.only(top: 1.h),
                            child: Text(
                                widget.chartData[value.toInt()]['label']
                                    as String,
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                        color:
                                            AppTheme.textMediumEmphasisLight)));
                      }
                      return const Text('');
                    },
                    reservedSize: 32)),
            leftTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    interval: 25,
                    getTitlesWidget: (value, meta) {
                      return Text('${value.toInt()}%',
                          style: AppTheme.lightTheme.textTheme.bodySmall
                              ?.copyWith(
                                  color: AppTheme.textMediumEmphasisLight));
                    },
                    reservedSize: 40))),
        borderData: FlBorderData(show: false),
        barGroups: widget.chartData.asMap().entries.map((entry) {
          final index = entry.key;
          final data = entry.value;
          final isTouched = index == touchedIndex;

          return BarChartGroupData(x: index, barRods: [
            BarChartRodData(
                toY: (data['percentage'] as double).clamp(0.0, 100.0),
                gradient: LinearGradient(
                    colors: isTouched
                        ? [AppTheme.primaryTeal, AppTheme.deepTeal]
                        : [
                            AppTheme.primaryTeal.withValues(alpha: 0.8),
                            AppTheme.primaryTeal.withValues(alpha: 0.6)
                          ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter),
                width: isTouched ? 22 : 18,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(6), topRight: Radius.circular(6))),
          ]);
        }).toList(),
        gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 25,
            getDrawingHorizontalLine: (value) {
              return FlLine(color: AppTheme.borderLight, strokeWidth: 1);
            })));
  }
}
