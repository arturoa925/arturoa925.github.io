import Foundation
import Ignite

/// Layout for case studies in Content/projects.
struct ProjectPage: ArticlePage {
    var body: some HTML {
        Section {
            Link("← All projects", target: Projects())
                .font(.small)

            Text(article.title)
                .font(.title1)
                .margin(.top, .medium)

            if let subtitle = article.subtitle {
                Text(subtitle)
                    .font(.lead)
                    .foregroundStyle(.secondary)
            }

            HStack {
                if let stack = article.stack {
                    Text(stack)
                        .font(.small)
                        .foregroundStyle(.secondary)
                }
            }

            if let repo = article.metadata["repo"] as? String {
                Link("View the code on GitHub", target: repo)
                    .linkStyle(.button)
                    .role(.primary)
                    .target(.blank)
                    .margin(.vertical, .medium)
            }

            Text(article.text)
        }
        .frame(maxWidth: 820)
    }
}
