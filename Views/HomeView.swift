import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var viewModel: DiningHallViewModel

    var body: some View {
        NavigationStack {
            List(viewModel.diningHalls) { hall in
                NavigationLink(value: hall.id) {
                    DiningHallRowView(hall: hall)
                }
            }
            .navigationTitle("Penn Dining Hunt")
            .navigationDestination(for: UUID.self) { hallID in
                DiningHallDetailView(hallID: hallID)
            }
        }
    }
}
