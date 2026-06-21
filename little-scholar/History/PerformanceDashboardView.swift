import SwiftUI

struct PerformanceDashboardView: View {
    let profiles: [ChildProfile]
    let results: [ExamResult]

    @State private var selectedProfileID: UUID?

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                sectionCard(title: "Progress", icon: "chart.bar.fill") {
                    if profiles.isEmpty {
                        EmptyStateView(icon: "person.2.slash", title: "No kids yet", message: "Create kid profiles to view performance history.")
                    } else {
                        VStack(spacing: 14) {
                            Picker("Kid", selection: $selectedProfileID) {
                                Text("All Kids").tag(Optional<UUID>.none)
                                ForEach(profiles) { profile in
                                    Text(profile.name).tag(Optional(profile.profileID))
                                }
                            }
                            .pickerStyle(.menu)

                            HistorySummary(results: filteredResults)
                        }
                    }
                }

                ExamHistoryView(results: filteredResults)
            }
            .padding(.vertical)
        }
    }

    private var filteredResults: [ExamResult] {
        guard let selectedProfileID else { return results }
        return results.filter { $0.childProfileID == selectedProfileID }
    }
}

struct HistorySummary: View {
    let results: [ExamResult]

    private var average: Int {
        guard !results.isEmpty else { return 0 }
        let total = results.map(\.percentage).reduce(0, +)
        return Int((Double(total) / Double(results.count)).rounded())
    }

    var body: some View {
        HStack(spacing: 12) {
            SummaryTile(title: "Practice", value: "\(results.count)", color: ScholarTheme.primary)
            SummaryTile(title: "Average", value: "\(average)%", color: ScholarTheme.success)
            SummaryTile(title: "Best", value: "\(results.map(\.percentage).max() ?? 0)%", color: ScholarTheme.warning)
        }
    }
}

struct SummaryTile: View {
    let title: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: 6) {
            Text(value)
                .font(.title2.bold())
                .foregroundStyle(color)
            Text(title)
                .font(.caption.bold())
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(color.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}
