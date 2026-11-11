import Foundation
import Ignite

/// A plain text nav: name on the left, four short links on the right.
/// Short enough to stay on one line on a phone, so there's no hamburger menu.
struct NavBar: HTML {
    var body: some HTML {
        Section {
            Text {
                Link("Arturo Ayala", target: "/")
                    .class("brand")
            }

            Text {
                Link("Projects", target: Projects())
                Link("Writing", target: Writing())
                Link("Résumé", target: Resume())
                Link("About", target: About())
            }
            .class("links")
        }
        .class("site-nav")
    }
}
