//
//  ProgressChart.swift
//  Workout
//
//  Created by Sarah Clark on 2/22/25.
//

import Charts
import SwiftUI

/// A reusable progress chart for a single metric over a ``TimePeriod``.
///
/// Replaces the three near-identical weight/reps/duration chart views: it renders a line or bar
/// series, an optional dashed goal line, and a time-period-aware X axis, with all the data and date
/// math supplied by the view model.
struct ProgressChart: View {

    /// How the data series is drawn.
    enum Style {
        case line
        case bar
    }

    let title: String
    let points: [ChartPoint]
    let goal: Double?
    let period: TimePeriod
    let axisDates: [Date]
    let style: Style
    let tint: Color
    let goalUnit: String
    let emptyMessage: String
    let emptySystemImage: String

    var body: some View {
        if points.contains(where: { $0.value != 0 }) {
            VStack(alignment: .leading, spacing: 10) {
                Text(title)
                    .font(.headline)
                    .padding(.horizontal)

                chart
                    .frame(height: 200)
                    .chartYScale(domain: 0...upperBound)
                    .chartXAxis { xAxis }
                    .chartYAxis {
                        AxisMarks { _ in
                            AxisGridLine()
                            AxisTick()
                            AxisValueLabel()
                        }
                    }
                    .padding()
            }
        } else {
            ContentUnavailableView(
                emptyMessage,
                systemImage: emptySystemImage,
                description: Text("Try another time period.")
            )
        }
    }

    // MARK: - Chart

    private var chart: some View {
        Chart {
            ForEach(points) { point in
                switch style {
                case .line:
                    LineMark(x: .value("Date", point.date), y: .value(title, point.value))
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(tint)

                    PointMark(x: .value("Date", point.date), y: .value(title, point.value))
                        .symbol(Circle().strokeBorder(lineWidth: 2))
                        .symbolSize(CGSize(width: 10, height: 10))
                        .foregroundStyle(tint)
                case .bar:
                    BarMark(x: .value("Date", point.date), y: .value(title, point.value))
                        .foregroundStyle(tint)
                }
            }

            if let goal, goal > 0 {
                RuleMark(y: .value("Goal", goal))
                    .foregroundStyle(.teal)
                    .lineStyle(StrokeStyle(lineWidth: 2, dash: [5, 5]))
                    .annotation(position: .top, alignment: .trailing) {
                        Text("Goal: \(Int(goal)) \(goalUnit)")
                            .font(.caption)
                            .foregroundStyle(.teal)
                            .padding(2)
                            .background(Color.teal.opacity(0.1))
                            .cornerRadius(4)
                    }
            }
        }
    }

    private var xAxis: some AxisContent {
        AxisMarks(values: axisDates) { value in
            AxisGridLine()
            AxisTick()
            AxisValueLabel {
                if let date = value.as(Date.self) {
                    Text(axisLabel(for: date))
                }
            }
        }
    }

    // MARK: - Helpers

    /// The Y-axis upper bound: ten above whichever is larger, the goal or the highest data point.
    private var upperBound: Double {
        let dataMax = points.map(\.value).max() ?? 0
        return max(goal ?? 0, dataMax) + 10
    }

    private func axisLabel(for date: Date) -> String {
        switch period {
        case .week:
            return date.formatted(.dateTime.weekday(.abbreviated))
        case .month:
            return date.formatted(.dateTime.day())
        case .sixMonths:
            return date.formatted(.dateTime.month(.abbreviated))
        case .year:
            return String(date.formatted(.dateTime.month(.abbreviated)).prefix(1))
        }
    }
}
