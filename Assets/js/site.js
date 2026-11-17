(function () {
    var reduceMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches;

    // ── 0. Text phases in as it loads and as you scroll to it ──
    // Each block comes into focus while rising slightly into place.
    if (!reduceMotion && "IntersectionObserver" in window) {
        var targets = document.querySelectorAll(
            ".hero h1, .hero .lead, .hero .actions, .page-head > *, .article-head > *, .section-title, " +
            ".row-list > .entry, .prose > *, .about-section, .portrait, .shots figure"
        );
        document.documentElement.setAttribute("data-reveal", "");
        var batch = [], flushTimer = null;
        function flush() {
            batch.forEach(function (el, i) {
                el.style.transitionDelay = Math.min(i * 70, 420) + "ms";
                el.classList.add("revealed");
            });
            batch = [];
        }
        var revealer = new IntersectionObserver(function (items) {
            items.forEach(function (item) {
                if (!item.isIntersecting) return;
                revealer.unobserve(item.target);
                batch.push(item.target);
            });
            clearTimeout(flushTimer);
            flushTimer = setTimeout(flush, 16);
        }, { rootMargin: "0px 0px -8% 0px", threshold: 0.01 });
        targets.forEach(function (el) { el.classList.add("reveal"); revealer.observe(el); });
        // Clear the delay once shown so hover effects stay instant.
        document.addEventListener("transitionend", function (e) {
            if (e.target.classList && e.target.classList.contains("revealed")) e.target.style.transitionDelay = "";
        });
    }

    // ── 1. The headline types itself out. Click it to watch it again. ──
    var headline = document.querySelector(".hero h1");
    if (headline) {
        var spoken = headline.textContent.trim();
        headline.setAttribute("aria-label", spoken);
        // One short sentence per line.
        var fullText = spoken.replace(/\. /g, ".\n");
        // An invisible copy of the full line holds the space, so the page
        // doesn't jump while the visible layer types over it.
        headline.innerHTML = '<span class="ghost" aria-hidden="true"></span>' +
            '<span class="type-layer" aria-hidden="true"><span class="typed"></span><span class="caret"></span></span>';
        headline.querySelector(".ghost").textContent = fullText;
        headline.classList.add("has-typing");
        var typed = headline.querySelector(".typed");

        var timer = null;
        function type() {
            clearTimeout(timer);
            if (reduceMotion) { typed.textContent = fullText; return; }
            var i = 0;
            headline.classList.add("is-typing");
            (function next() {
                typed.textContent = fullText.slice(0, i);
                if (i++ < fullText.length) {
                    // a touch of human rhythm: pause a little longer after spaces
                    var ch = fullText.charAt(i - 1);
                    var delay = ch === "\n" ? 380 : ch === " " ? 70 : 32 + Math.random() * 34;
                    timer = setTimeout(next, delay);
                } else {
                    headline.classList.remove("is-typing");
                }
            })();
        }
        type();
        headline.addEventListener("click", type);
        headline.title = "Click to retype";
    }

    // ── 2. The name in the nav says hola on hover ──
    var brand = document.querySelector(".site-nav .brand");
    if (brand) {
        var name = brand.textContent;
        brand.innerHTML = '<span class="main"></span><span class="alt" aria-hidden="true">hola, soy Arturo</span>';
        brand.querySelector(".main").textContent = name;

        // Phones have no hover, so on touch screens the name says hola once,
        // right after the headline finishes typing.
        if (window.matchMedia("(hover: none)").matches && !reduceMotion) {
            setTimeout(function () {
                brand.classList.add("say-hola");
                setTimeout(function () { brand.classList.remove("say-hola"); }, 2200);
            }, 3200);
        }
    }

    // ── 3. Email links copy the address as well as opening the mail app ──
    document.querySelectorAll('a[href^="mailto:"]').forEach(function (link) {
        link.addEventListener("click", function () {
            var address = link.getAttribute("href").replace("mailto:", "");
            if (!navigator.clipboard) return;
            navigator.clipboard.writeText(address).then(function () {
                var original = link.textContent;
                link.textContent = "Email copied";
                link.setAttribute("aria-live", "polite");
                setTimeout(function () { link.textContent = original; }, 1800);
            }).catch(function () {});
        });
    });

    // ── 4. Code blocks get a copy button ──
    document.querySelectorAll("pre").forEach(function (block) {
        if (!navigator.clipboard) return;
        var button = document.createElement("button");
        button.type = "button";
        button.className = "copy-code";
        button.textContent = "Copy";
        button.addEventListener("click", function () {
            var code = block.querySelector("code") || block;
            navigator.clipboard.writeText(code.innerText).then(function () {
                button.textContent = "Copied";
                setTimeout(function () { button.textContent = "Copy"; }, 1500);
            }).catch(function () {});
        });
        block.appendChild(button);
    });

    // ── 6. The writing log: each entry's dot lights up as it scrolls in ──
    var entries = document.querySelectorAll(".log .entry");
    if (entries.length) {
        if (reduceMotion || !("IntersectionObserver" in window)) {
            entries.forEach(function (e) { e.classList.add("seen"); });
        } else {
            var watcher = new IntersectionObserver(function (items) {
                items.forEach(function (item) {
                    if (item.isIntersecting) { item.target.classList.add("seen"); watcher.unobserve(item.target); }
                });
            }, { rootMargin: "0px 0px -15% 0px" });
            entries.forEach(function (e) { watcher.observe(e); });
        }
    }

    // ── 7. A thin progress line while reading a post ──
    var prose = document.querySelector(".article-head ~ .prose");
    if (prose) {
        var line = document.createElement("div");
        line.className = "read-progress";
        line.setAttribute("aria-hidden", "true");
        document.body.appendChild(line);
        var ticking = false;
        function update() {
            var start = prose.offsetTop, end = start + prose.offsetHeight - window.innerHeight;
            var p = Math.min(1, Math.max(0, (window.scrollY - start) / Math.max(1, end - start)));
            line.style.transform = "scaleX(" + p + ")";
            ticking = false;
        }
        window.addEventListener("scroll", function () { if (!ticking) { ticking = true; requestAnimationFrame(update); } }, { passive: true });
        update();
    }

    // ── 5. For anyone who opens the developer console ──
    console.log(
        "%cHey, you opened the console.%c\n\nThis site is written in Swift with Ignite.\nSource: https://github.com/arturoa925/arturoa925.github.io\nSay hi: ayalaarturo925@gmail.com",
        "font: 600 15px Geist, system-ui; color: #F05138;",
        "font: 13px Geist, system-ui; color: #4A5060;"
    );
})();

