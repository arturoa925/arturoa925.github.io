(function () {
    var reduceMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches;

    // ── 1. The headline types itself out. Click it to watch it again. ──
    var headline = document.querySelector(".hero h1");
    if (headline) {
        var fullText = headline.textContent.trim();
        headline.setAttribute("aria-label", fullText);
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
                    timer = setTimeout(next, ch === " " ? 70 : 28 + Math.random() * 30);
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
        brand.innerHTML = '<span class="main"></span><span class="alt" aria-hidden="true">hola, I’m Arturo</span>';
        brand.querySelector(".main").textContent = name;
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

    // ── 5. For anyone who opens the developer console ──
    console.log(
        "%cHey, you opened the console.%c\n\nThis site is written in Swift with Ignite.\nSource: https://github.com/arturoa925/arturoa925.github.io\nSay hi: ayalaarturo925@gmail.com",
        "font: 600 15px Geist, system-ui; color: #F05138;",
        "font: 13px Geist, system-ui; color: #4A5060;"
    );
})();
