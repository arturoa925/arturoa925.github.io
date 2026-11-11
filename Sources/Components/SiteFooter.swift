import Foundation
import Ignite

struct SiteFooter: HTML {
    var body: some HTML {
        Section {
            Text("Arturo Ayala. Built in Swift with Ignite.")

            Text {
                Link("GitHub", target: "https://github.com/arturoa925")
                    .target(.blank)
                    .relationship(.noOpener, .noReferrer)
                Link("LinkedIn", target: "https://www.linkedin.com/in/arturo-ayala-775493187")
                    .target(.blank)
                    .relationship(.noOpener, .noReferrer)
                Link("Email", target: "mailto:ayalaarturo925@gmail.com")
            }
            .class("links")
        }
        .class("site-footer")
    }
}
