import Foundation
import Ignite

struct Writing: StaticPage {
    var title = "Writing"
    var description = "Notes on Swift, problem solving, debugging and how I build apps."

    @Environment(\.articles) var articles

    var body: some HTML {
        Section {
            Text("Writing")
                .font(.title1)

            Text("Notes on Swift, problem solving, debugging, and how I design and build apps.")
                .class("lead")
        }
        .class("page-head")

        Section {
            ForEach(articles.typed("writing").sorted { $0.date > $1.date }) { post in
                PostRow(post: post)
            }
        }
        .class("row-list")
    }
}
