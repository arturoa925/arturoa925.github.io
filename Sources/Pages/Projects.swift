import Foundation
import Ignite

struct Projects: StaticPage {
    var title = "Projects"
    var description = "Case studies of the iOS, watchOS and full-stack apps I've designed and built."

    @Environment(\.articles) var articles

    var body: some HTML {
        Text("Projects")
            .font(.title1)

        Text("Each case study covers what the app does, how it's built, and why I made the design and code choices I did.")
            .font(.lead)
            .foregroundStyle(.secondary)
            .margin(.bottom, .large)

        Grid(articles.typed("projects").sorted { $0.order < $1.order }, alignment: .top, spacing: .large) { project in
            ProjectCard(project: project)
        }
        .columns(2)
    }
}
