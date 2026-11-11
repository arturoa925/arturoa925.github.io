import Foundation
import Ignite

struct Home: StaticPage {
    var title = "Software Developer"
    var description = "Software developer building native iOS apps in Swift and SwiftUI, and full-stack apps in TypeScript and React."

    @Environment(\.articles) var articles

    var body: some HTML {
        // Hero
        Section {
            Text("Build software that feels obvious in hindsight and lasts by design.")
                .font(.title1)
                .fontWeight(.bold)

            Text("I'm Arturo, a software developer building native iOS apps in Swift and SwiftUI, and full-stack apps in TypeScript and React.")
                .font(.lead)
                .foregroundStyle(.secondary)

            HStack {
                Link("View projects", target: Projects())
                    .linkStyle(.button)
                    .role(.primary)

                Link("Download résumé", target: Resume.pdfPath)
                    .linkStyle(.button)
                    .role(.secondary)
                    .target(.blank)
            }
            .margin(.top, .medium)
        }
        .padding(.bottom, .large)

        // Featured projects
        Text("Projects")
            .font(.title2)
            .margin(.top, .large)

        Grid(projects, alignment: .top, spacing: .large) { project in
            ProjectCard(project: project)
        }
        .columns(2)

        // Latest writing
        Text("Latest writing")
            .font(.title2)
            .margin(.top, .xLarge)

        ForEach(latestPosts) { post in
            PostRow(post: post)
        }

        Link("All writing →", target: Writing())
            .margin(.top, .medium)
    }

    private var projects: [Article] {
        articles.typed("projects").sorted { $0.order < $1.order }
    }

    private var latestPosts: [Article] {
        Array(articles.typed("writing").sorted { $0.date > $1.date }.prefix(3))
    }
}
