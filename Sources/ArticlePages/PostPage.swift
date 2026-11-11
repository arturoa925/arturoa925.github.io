import Foundation
import Ignite

/// Layout for posts in Content/writing.
struct PostPage: ArticlePage {
    var body: some HTML {
        Section {
            Link("← All writing", target: Writing())
                .font(.small)

            Text(article.title)
                .font(.title1)
                .margin(.top, .medium)

            Text {
                article.displayDate
                " · \(article.estimatedReadingMinutes) min read"
                if let tags = article.tags, tags.isEmpty == false {
                    " · " + tags.joined(separator: ", ")
                }
            }
            .font(.small)
            .foregroundStyle(.secondary)
            .margin(.bottom, .large)

            Text(article.text)
        }
        .frame(maxWidth: 760)
    }
}
