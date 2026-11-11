import Foundation
import Ignite

struct MainLayout: Layout {
    var body: some Document {
        Head {
            MetaLink(href: "/css/site.css", rel: .stylesheet)
            MetaLink(href: "/images/favicon-32.png", rel: "alternate icon")
            MetaLink(href: "/images/apple-touch-icon.png", rel: "apple-touch-icon")
        }

        Body {
            NavBar()
            content
            SiteFooter()
            Script(file: "/js/site.js")
        }
    }
}
