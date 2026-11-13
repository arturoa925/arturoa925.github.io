import Foundation
import Ignite

struct NotFound: ErrorPage {
    var title = "Page not found | Arturo Ayala"
    var description = "This page doesn't exist."

    var body: some HTML {
        Section {
            Text("This page doesn't exist.")
                .font(.title1)

            Text("The link may be out of date. Everything on the site is one click from the home page.")
                .class("lead")

            Link("Go to the home page", target: "/")
                .linkStyle(.button)
                .role(.primary)
        }
        .class("page-head")
        .margin(.bottom, .xLarge)
    }
}
