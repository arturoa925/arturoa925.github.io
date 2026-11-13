import Foundation
import Ignite

/// Layout for case studies in Content/projects.
struct ProjectPage: ArticlePage {
    var body: some HTML {
        Section {
            Text {
                Link("Projects", target: Projects())
                    .class("back")
            }

            Text(article.title)
                .font(.title1)

            if let subtitle = article.subtitle {
                Text(subtitle)
                    .class("lead")
            }

            if let stack = article.stack {
                Text(stack)
                    .class("meta")
            }

            if let repo = article.metadata["repo"] as? String {
                // Full-stack projects can list a second repo for the server.
                let serverRepo = article.metadata["serverRepo"] as? String

                Section {
                    Link(serverRepo == nil ? "View the code on GitHub" : "View the app code", target: repo)
                        .linkStyle(.button)
                        .role(.secondary)
                        .target(.blank)

                    if let serverRepo {
                        Link("View the server code", target: serverRepo)
                            .linkStyle(.button)
                            .role(.secondary)
                            .target(.blank)
                    }
                }
                .class("repo-links")
            }
        }
        .class("article-head")

        Section {
            Text(article.text)
        }
        .class("prose")
    }
}
