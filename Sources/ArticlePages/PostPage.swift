import Foundation
import Ignite

/// Layout for posts in Content/writing.
struct PostPage: ArticlePage {
    var body: some HTML {
        Section {
            Text {
                Link("Writing", target: Writing())
                    .class("back")
            }

            Text(article.title)
                .font(.title1)

            Text("\(article.displayDate), \(article.estimatedReadingMinutes) min read")
                .class("meta")
        }
        .class("article-head")

        Section {
            Text(article.text)
        }
        .class("prose")
    }
}
