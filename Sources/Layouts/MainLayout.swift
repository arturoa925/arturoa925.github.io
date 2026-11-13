import Foundation
import Ignite

/// Bump when site.css or site.js change, so browsers fetch the new files instead of a cached copy.
let assetVersion = 3

struct MainLayout: Layout {
    var body: some Document {
        Head {
            MetaLink(href: "/fonts/Geist-Variable.woff2", rel: "preload")
                .customAttribute(name: "as", value: "font")
                .customAttribute(name: "type", value: "font/woff2")
                .customAttribute(name: "crossorigin", value: "")
            MetaLink(href: "/css/site.css?v=\(assetVersion)", rel: .stylesheet)
            MetaLink(href: "/images/favicon-32.png", rel: "alternate icon")
            MetaLink(href: "/images/apple-touch-icon.png", rel: "apple-touch-icon")
        }

        Body {
            NavBar()
            content
            SiteFooter()
            Script(file: "/js/site.js?v=\(assetVersion)")
        }
    }
}
