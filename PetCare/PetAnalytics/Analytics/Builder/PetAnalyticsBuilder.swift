//
//  PetAnalyticsBuilder.swift
//  PetCare
//
//  Created by Ляйсан on 10/4/26.
//

import Foundation

final class PetAnalyticsBuilder: PetAnalyticsBuilding {
    private let calendar: Calendar
    private let dateFormatter: DateFormatter
    private let shortWeekdayFormatter: DateFormatter
    private let monthFormatter: DateFormatter
    private let shortMonthLetterFormatter: DateFormatter

    init(calendar: Calendar = .current) {
        self.calendar = calendar

        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        self.dateFormatter = dateFormatter

        let shortWeekdayFormatter = DateFormatter()
        shortWeekdayFormatter.locale = .current
        shortWeekdayFormatter.dateFormat = "E"
        self.shortWeekdayFormatter = shortWeekdayFormatter

        let monthFormatter = DateFormatter()
        monthFormatter.locale = .current
        monthFormatter.dateFormat = "MMM"
        self.monthFormatter = monthFormatter
        
        let shortMonthLetterFormatter = DateFormatter()
        shortMonthLetterFormatter.locale = .current
        shortMonthLetterFormatter.dateFormat = "MMMMM"
        self.shortMonthLetterFormatter = shortMonthLetterFormatter
    }

    func buildContent(
        petId: String,
        pet: Pet,
        petActivities: [PetActivity],
        period: PetAnalyticsPeriod
    ) -> PetAnalyticsContent {
        let sortedActivities = petActivities.sorted { $0.date > $1.date }
        let walkActivities = sortedActivities.filter { $0.type == .walk }
        let spendingActivities = sortedActivities.filter {
            $0.type == .grooming || $0.type == .vet
        }

        return PetAnalyticsContent(
            pet: pet,
            selectedPeriod: period,
            analyticsHeaderData: makeHeaderData(from: pet, period: period),
            walkChartData: makeWalkChartData(from: walkActivities, period: period),
            spendingsChartData: makeSpendingsChartData(from: spendingActivities, period: period),
            goalCompletionData: makeGoalCompletionData(from: walkActivities, petName: pet.name),
            statsData: makeStatsData(from: sortedActivities),
            historyData: makeHistoryData(from: sortedActivities)
        )
    }
}

private extension PetAnalyticsBuilder {
    struct ChartBucket {
        let title: String
        let start: Date
        let end: Date
    }
    
    func makeHeaderData(from pet: Pet, period: PetAnalyticsPeriod) -> PetAnalyticsHeaderData {
        PetAnalyticsHeaderData(
            petName: pet.name,
            petBreedAndAge: L10n.PetAnalytics.Pet.breedAndAge(pet.breed, pet.ageText),
            photoUrl: pet.photoUrl,
            selectedPeriod: period
        )
    }

    func makeWalkChartData(
        from activities: [PetActivity],
        period: PetAnalyticsPeriod
    ) -> BarChartData? {
        guard !activities.isEmpty else { return nil }

        let buckets = makeBuckets(for: period)
        var values = Array(repeating: 0.0, count: buckets.count)

        for activity in activities {
            guard let bucketIndex = bucketIndex(for: activity.date, in: buckets) else { continue }
            guard case let .walk(details) = activity.details else { continue }

            values[bucketIndex] += details.actual
        }

        let items = zip(buckets, values).map {
            BarChartItem(title: $0.title, value: $1)
        }
        return BarChartData(
            title: L10n.PetAnalytics.WalkChart.title,
            subtitle: period.chartSubtitle,
            items: items
        )
    }

    func makeSpendingsChartData(
        from activities: [PetActivity],
        period: PetAnalyticsPeriod
    ) -> BarChartData? {
        guard !activities.isEmpty else { return nil }

        let buckets = makeBuckets(for: period)
        var values = Array(repeating: 0.0, count: buckets.count)

        for activity in activities {
            guard let bucketIndex = bucketIndex(for: activity.date, in: buckets) else { continue }

            switch activity.details {
            case .grooming(let details):
                values[bucketIndex] += details.cost
            case .vet(let details):
                values[bucketIndex] += details.cost
            case .walk:
                break
            }
        }

        let items = zip(buckets, values).map {
            BarChartItem(title: $0.title, value: $1)
        }
        return BarChartData(
            title: L10n.PetAnalytics.SpendingsChart.title,
            subtitle: period.chartSubtitle,
            items: items
        )
    }

    func makeGoalCompletionData(
        from activities: [PetActivity],
        petName: String
    ) -> GoalCompletionData? {
        guard !activities.isEmpty else { return nil }

        let walkDetails = activities.compactMap { activity -> WalkDetails? in
            guard case let .walk(details) = activity.details else { return nil }
            return details
        }

        let goalsCount = walkDetails.count
        guard goalsCount > 0 else { return nil }

        let actualGoalsCompletion = walkDetails.filter { $0.actual >= $0.goal }.count
        let progress = CGFloat(actualGoalsCompletion) / CGFloat(goalsCount)
        let progressPercent = Int(progress * 100)

        return GoalCompletionData(
            goalsCount: goalsCount,
            actualGoalsCompletion: actualGoalsCompletion,
            description: L10n.PetAnalytics.GoalCompletion.description(petName.capitalized, progressPercent),
            progress: progress
        )
    }

    func makeStatsData(from activities: [PetActivity]) -> [PetAnalyticsStatsData] {
        let walkDetails = activities.compactMap { activity -> WalkDetails? in
            guard case let .walk(details) = activity.details else { return nil }
            return details
        }

        let totalWalks = walkDetails.count
        let totalDistance = walkDetails.reduce(0) { $0 + $1.actual }
        let averageDistance = totalWalks == 0 ? 0 : totalDistance / Double(totalWalks)

        let totalSpendings = activities.reduce(0.0) { partialResult, activity in
            switch activity.details {
            case .grooming(let details):
                return partialResult + details.cost
            case .vet(let details):
                return partialResult + details.cost
            case .walk:
                return partialResult
            }
        }

        return [
            PetAnalyticsStatsData(
                title: L10n.PetAnalytics.Stats.totalWalks,
                value: "\(totalWalks)",
                style: .walks
            ),
            PetAnalyticsStatsData(
                title: L10n.PetAnalytics.Stats.averageKm,
                value: String(format: "%.1f", averageDistance),
                style: .averageDistance
            ),
            PetAnalyticsStatsData(
                title: L10n.PetAnalytics.Stats.totalSpendings,
                value: String(format: "%.0f", totalSpendings),
                style: .spendings
            )
        ]
    }

    func makeHistoryData(from activities: [PetActivity]) -> [PetAnalyticsHistoryData] {
        let recentActivities = Array(activities.prefix(3))

        return recentActivities.map { activity in
            PetAnalyticsHistoryData(
                activityType: activity.type,
                date: dateFormatter.string(from: activity.date),
                activityDetail: makeHistoryDetail(for: activity)
            )
        }
    }

    func makeHistoryDetail(for activity: PetActivity) -> String {
        switch activity.details {
        case .walk(let details):
            return L10n.PetAnalytics.History.walkDistance(Float(details.actual))

        case .grooming(let details):
            return groomingTitle(for: details)

        case .vet(let details):
            return vetTitle(for: details)
        }
    }

    func groomingTitle(for details: GroomingDetails) -> String {
        String(describing: details.procedureType.title)
    }

    func vetTitle(for details: VetDetails) -> String {
        String(describing: details.procedureType.title)
    }
}

private extension PetAnalyticsBuilder {
    func makeBuckets(for period: PetAnalyticsPeriod) -> [ChartBucket] {
        let range = period.dateRange(calendar: calendar)

        switch period {
        case .week:
            return makeDayBuckets(from: range.start, to: range.end)

        case .month:
            return makeWeekBuckets(from: range.start, to: range.end)

        case .threeMonths:
            return makeMonthBuckets(count: 3, endingAt: range.end, formatter: monthFormatter)

        case .year:
            return makeMonthBuckets(count: 12, endingAt: range.end, formatter: shortMonthLetterFormatter)
        }
    }

    func bucketIndex(for date: Date, in buckets: [ChartBucket]) -> Int? {
        buckets.firstIndex { date >= $0.start && date < $0.end }
    }

    func makeDayBuckets(from start: Date, to end: Date) -> [ChartBucket] {
        var buckets: [ChartBucket] = []
        var current = calendar.startOfDay(for: start)

        while current < end {
            guard let next = calendar.date(byAdding: .day, value: 1, to: current) else {
                break
            }
            buckets.append(
                ChartBucket(
                    title: shortWeekdayFormatter.string(from: current).uppercased(),
                    start: current,
                    end: next
                )
            )

            current = next
        }
        return buckets
    }

    func makeWeekBuckets(from start: Date, to end: Date) -> [ChartBucket] {
        var buckets: [ChartBucket] = []
        var current = calendar.startOfDay(for: start)
        var index = 1

        while current < end {
            guard let next = calendar.date(byAdding: .day, value: 7, to: current) else {
                break
            }
            buckets.append(
                ChartBucket(
                    title: "W\(index)",
                    start: current,
                    end: min(next, end)
                )
            )

            current = next
            index += 1
        }
        return buckets
    }

    func makeMonthBuckets(count: Int, endingAt end: Date, formatter: DateFormatter) -> [ChartBucket] {
        var buckets: [ChartBucket] = []

        for offset in stride(from: count - 1, through: 0, by: -1) {
            guard
                let monthDate = calendar.date(byAdding: .month, value: -offset, to: end),
                let interval = calendar.dateInterval(of: .month, for: monthDate)
            else {
                continue
            }
            buckets.append(
                ChartBucket(
                    title: formatter.string(from: interval.start).uppercased(),
                    start: interval.start,
                    end: interval.end
                )
            )
        }
        return buckets
    }
}
