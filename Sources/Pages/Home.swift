import Foundation
import Ignite

struct Home: StaticPage {
    var title = "Software Developer"
    var description = "Software developer building native iOS apps in Swift and SwiftUI, and full-stack apps in TypeScript and React."

    @Environment(\.articles) var articles

    var body: some HTML {
        Section {
            Text("Natural in hand. Obvious to use. Built to last.")
                .font(.title1)

            Text("I'm Arturo. I build native iOS and watchOS apps in Swift and SwiftUI, and full-stack apps in TypeScript and React.")
                .class("lead")

            Section {
                Link("See my work", target: Projects())
                    .linkStyle(.button)
                    .role(.primary)

                Link("Download résumé", target: Resume.pdfPath)
                    .linkStyle(.button)
                    .role(.secondary)
                    .target(.blank)
            }
            .class("actions")
        }
        .class("hero")

        Text("Selected work")
            .class("section-title")

        Section {
            ForEach(projects) { project in
                ProjectRow(project: project)
            }
        }
        .class("row-list")

        Text("Writing")
            .class("section-title")

        Section {
            ForEach(latestPosts) { post in
                PostRow(post: post)
            }
        }
        .class("row-list")
        .margin(.bottom, .small)

        Text {
            Link("All writing", target: Writing())
                .class("more-link")
        }
        .margin(.bottom, .xLarge)
    }

    private var projects: [Article] {
        articles.typed("projects").sorted { $0.order < $1.order }
    }

    private var latestPosts: [Article] {
        Array(articles.typed("writing").sorted { $0.date > $1.date }.prefix(4))
    }
}
