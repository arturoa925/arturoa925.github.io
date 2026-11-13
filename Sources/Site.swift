import Foundation
import Ignite

@main
struct PortfolioWebsite {
    static func main() async {
        var site = PortfolioSite()

        do {
            try await site.publish()
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct PortfolioSite: Site {
    var name = "Arturo Ayala"
    var titleSuffix = ""
    var description: String? = "Software developer building native iOS apps in Swift and SwiftUI, and full-stack apps in TypeScript and React."
    var url = URL(static: "https://arturoa925.github.io")
    var author = "Arturo Ayala"
    var timeZone: TimeZone? = TimeZone(identifier: "America/Los_Angeles")

    var builtInIconsEnabled: BootstrapOptions = .none
    var syntaxHighlighterConfiguration: SyntaxHighlighterConfiguration = .init(languages: [.swift, .javaScript, .bash])

    var lightTheme: (any Theme)? = PortfolioLightTheme()
    // Light only for now: the dark theme left the page background white in Ignite, washing out text.
    var darkTheme: (any Theme)? = nil

    var favicon: URL? = URL(static: "/images/icon.svg")

    /// The preview image LinkedIn, iMessage and others show when the site is shared.
    static let shareImage = URL(static: "https://arturoa925.github.io/images/og.png")

    var errorPage = NotFound()

    var homePage = Home()
    var layout = MainLayout()

    var staticPages: [any StaticPage] {
        Projects()
        Writing()
        Resume()
        About()
    }

    var articlePages: [any ArticlePage] {
        PostPage()
        ProjectPage()
    }
}
