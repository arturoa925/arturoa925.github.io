(function () {
    var reduceMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches;

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

    // ── 5. For anyone who opens the developer console ──
    console.log(
        "%cHey, you opened the console.%c\n\nThis site is written in Swift with Ignite.\nSource: https://github.com/arturoa925/arturoa925.github.io\nSay hi: ayalaarturo925@gmail.com",
        "font: 600 15px Geist, system-ui; color: #F05138;",
        "font: 13px Geist, system-ui; color: #4A5060;"
    );
})();

// ── Hand-trace widget: steps through subsets([1, 2]) three ways ──
(function () {
    var root = document.querySelector('[data-trace="subsets"]');
    if (!root) return;
    var nums = [1, 2];

    var modes = {
        value: {
            label: "Value copies",
            code: [
                ["call", "func explore(_ index: Int, _ path: [Int]) {"],
                ["record", "    if index == nums.count { result.append(path); return }"],
                ["choose", "    explore(index + 1, path + [nums[index]])  // choose"],
                ["skip", "    explore(index + 1, path)                  // skip"],
                ["", "}"]
            ]
        },
        shared: {
            label: "Shared + undo",
            code: [
                ["call", "func explore(_ index: Int, _ path: inout [Int]) {"],
                ["record", "    if index == nums.count { result.append(path); return }"],
                ["choose", "    path.append(nums[index])    // choose"],
                ["", "    explore(index + 1, &path)"],
                ["undo", "    path.removeLast()           // un-choose"],
                ["skip", "    explore(index + 1, &path)   // skip"],
                ["", "}"]
            ]
        },
        bug: {
            label: "Shared, no undo",
            code: [
                ["call", "func explore(_ index: Int, _ path: inout [Int]) {"],
                ["record", "    if index == nums.count { result.append(path); return }"],
                ["choose", "    path.append(nums[index])    // choose"],
                ["", "    explore(index + 1, &path)"],
                ["", "    // forgot path.removeLast()"],
                ["skip", "    explore(index + 1, &path)   // skip"],
                ["", "}"]
            ]
        }
    };

    function fmt(a) { return "[" + a.join(", ") + "]"; }

    // Run the real recursion and record a snapshot at each line worth stopping on.
    function trace(mode) {
        var steps = [], results = [], stack = [], shared = [];
        function snap(line, note) {
            steps.push({
                line: line, note: note,
                stack: stack.map(function (f) { return { index: f.index, path: f.path ? f.path.slice() : null }; }),
                shared: shared.slice(),
                results: results.map(function (r) { return r.slice(); })
            });
        }
        function exploreValue(i, path) {
            stack.push({ index: i, path: path });
            snap("call", "Call explore(" + i + ", " + fmt(path) + "). This frame gets its own copy of path.");
            if (i === nums.length) {
                results.push(path.slice());
                snap("record", "index == " + nums.length + ", so record " + fmt(path) + ".");
                stack.pop(); return;
            }
            snap("choose", "Choose " + nums[i] + ": pass a new array " + fmt(path.concat([nums[i]])) + " down. This frame's path is untouched.");
            exploreValue(i + 1, path.concat([nums[i]]));
            snap("skip", "Back in this frame, path is still " + fmt(path) + ". Skip " + nums[i] + ".");
            exploreValue(i + 1, path);
            stack.pop();
        }
        function exploreShared(i, undo) {
            stack.push({ index: i, path: null });
            snap("call", "Call explore(" + i + ", &path). Every frame points at the same array.");
            if (i === nums.length) {
                results.push(shared.slice());
                snap("record", "index == " + nums.length + ", so record " + fmt(shared) + ".");
                stack.pop(); return;
            }
            shared.push(nums[i]);
            snap("choose", "Choose " + nums[i] + ": append to the shared array, now " + fmt(shared) + ".");
            exploreShared(i + 1, undo);
            if (undo) {
                shared.pop();
                snap("undo", "removeLast() puts the shared array back to " + fmt(shared) + " before skipping.");
            } else {
                snap("skip", "No undo, so the shared array is still " + fmt(shared) + ". The skip branch inherits the leftover " + nums[i] + ".");
            }
            if (undo) snap("skip", "Skip " + nums[i] + " with the array at " + fmt(shared) + ".");
            exploreShared(i + 1, undo);
            stack.pop();
        }
        if (mode === "value") exploreValue(0, []);
        else exploreShared(0, mode === "shared");
        snap("", mode === "bug"
            ? "Done. Two answers are wrong, and nothing crashed. That's the leak tracing catches."
            : "Done. Four subsets: " + results.map(fmt).join(", ") + ".");
        return steps;
    }

    var mode = "value", steps = trace(mode), at = 0;

    root.innerHTML =
        '<div class="trace-modes" role="group" aria-label="How path is passed"></div>' +
        '<div class="trace-body">' +
            '<pre class="trace-code" aria-hidden="true"></pre>' +
            '<div class="trace-state">' +
                '<p class="trace-label">Call stack</p><div class="trace-stack"></div>' +
                '<div class="trace-shared-wrap"><p class="trace-label">Shared path</p><div class="trace-shared"></div></div>' +
                '<p class="trace-label">result</p><div class="trace-results"></div>' +
            '</div>' +
        '</div>' +
        '<p class="trace-note" aria-live="polite"></p>' +
        '<div class="trace-controls">' +
            '<button type="button" class="btn btn-secondary" data-act="back">Back</button>' +
            '<button type="button" class="btn btn-primary" data-act="step">Step</button>' +
            '<button type="button" class="btn btn-secondary" data-act="reset">Reset</button>' +
            '<span class="trace-count"></span>' +
        '</div>';

    var modeBar = root.querySelector(".trace-modes");
    Object.keys(modes).forEach(function (key) {
        var b = document.createElement("button");
        b.type = "button"; b.textContent = modes[key].label; b.dataset.mode = key;
        b.addEventListener("click", function () { mode = key; steps = trace(mode); at = 0; render(); });
        modeBar.appendChild(b);
    });

    function chip(arr) {
        return '<span class="trace-chip">' + (arr.length ? arr.map(function (n) { return "<b>" + n + "</b>"; }).join("") : "<i>empty</i>") + "</span>";
    }

    function render() {
        var s = steps[at];
        modeBar.querySelectorAll("button").forEach(function (b) {
            b.setAttribute("aria-pressed", b.dataset.mode === mode ? "true" : "false");
        });
        root.querySelector(".trace-code").innerHTML = modes[mode].code.map(function (l) {
            var text = l[1].replace(/&/g, "&amp;").replace(/</g, "&lt;");
            return '<span class="' + (l[0] && l[0] === s.line ? "on" : "") + '">' + text + "</span>";
        }).join("\n");
        root.querySelector(".trace-stack").innerHTML = s.stack.length ? s.stack.map(function (f, i) {
            var top = i === s.stack.length - 1 ? " top" : "";
            var right = f.path ? chip(f.path) : '<span class="trace-arrow">points to shared path</span>';
            return '<div class="trace-frame' + top + '"><code>explore(index: ' + f.index + ")</code>" + right + "</div>";
        }).join("") : '<div class="trace-empty">empty</div>';
        root.querySelector(".trace-shared-wrap").hidden = mode === "value";
        root.querySelector(".trace-shared").innerHTML = chip(s.shared);
        root.querySelector(".trace-results").innerHTML = s.results.length ? s.results.map(chip).join("") : '<span class="trace-empty">nothing yet</span>';
        root.querySelector(".trace-note").textContent = s.note;
        root.querySelector(".trace-count").textContent = "Step " + (at + 1) + " of " + steps.length;
        root.querySelector('[data-act="back"]').disabled = at === 0;
        root.querySelector('[data-act="step"]').disabled = at === steps.length - 1;
        root.classList.toggle("is-bug", mode === "bug" && at === steps.length - 1);
    }

    root.addEventListener("click", function (e) {
        var act = e.target.getAttribute && e.target.getAttribute("data-act");
        if (act === "step" && at < steps.length - 1) at++;
        if (act === "back" && at > 0) at--;
        if (act === "reset") at = 0;
        if (act) render();
    });
    root.addEventListener("keydown", function (e) {
        if (e.key === "ArrowRight" && at < steps.length - 1) { at++; render(); }
        if (e.key === "ArrowLeft" && at > 0) { at--; render(); }
    });
    render();
})();
