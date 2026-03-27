import SwiftUI

struct DiningHallRowView: View {
    let hall: DiningHall

    var body: some View {
        HStack {
            Text(hall.name)
            Spacer()
            if hall.isCollected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
            } else {
                Image(systemName: "circle")
                    .foregroundStyle(.secondary)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(hall.name), \(hall.isCollected ? "collected" : "not collected")")
    }
}
