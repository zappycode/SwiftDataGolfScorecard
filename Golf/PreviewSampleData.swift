import SwiftData
import SwiftUI

/**
 Preview sample data.
 */
actor PreviewSampleData {
    @MainActor
    static var container: ModelContainer = {
        let schema = Schema([Game.self, Player.self, Hole.self, Score.self])
        let configuration = ModelConfiguration(inMemory: true)
        let container = try! ModelContainer(for: schema, configurations: [configuration])
//        let sampleData: [any PersistentModel] = [
//            Trip.preview, BucketListItem.preview, LivingAccommodation.preview
//        ]
//        sampleData.forEach {
//            container.mainContext.insert($0)
//        }
        return container
    }()
}

