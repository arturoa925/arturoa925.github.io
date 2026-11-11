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
                Link("View the code on GitHub", target: repo)
                    .linkStyle(.button)
                    .role(.secondary)
                    .target(.blank)
            }
        }
        .class("article-head")

        Section {
            Text(article.text)
        }
        .class("prose")
    }
}
