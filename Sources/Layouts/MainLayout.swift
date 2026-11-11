import Foundation
import Ignite

struct MainLayout: Layout {
    var body: some Document {
        Head {
            MetaLink(href: "/css/site.css", rel: .stylesheet)
        }

        Body {
            NavBar()
            content
            SiteFooter()
            Script(file: "/js/site.js")
        }
    }
}
