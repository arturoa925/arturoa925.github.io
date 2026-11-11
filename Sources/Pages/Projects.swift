import Foundation
import Ignite

struct Projects: StaticPage {
    var title = "Projects | Arturo Ayala"
    var description = "Case studies of the iOS, watchOS and full-stack apps I've designed and built."
    var image: URL? = PortfolioSite.shareImage

    @Environment(\.articles) var articles

    var body: some HTML {
        Section {
            Text("Projects")
                .font(.title1)

            Text("What each app does, how it's built, and why I made the design and code choices I did.")
                .class("lead")
        }
        .class("page-head")

        Section {
            ForEach(articles.typed("projects").sorted { $0.order < $1.order }) { project in
                ProjectRow(project: project)
            }
        }
        .class("row-list")
    }
}
