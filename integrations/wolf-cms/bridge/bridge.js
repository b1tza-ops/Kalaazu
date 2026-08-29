(() => {
    "use strict";

    const KALAAZU_URL = "http://127.0.0.1:8081";

    document.addEventListener("submit", event => {
        const form = event.target;
        if (!(form instanceof HTMLFormElement) || !["login", "register"].includes(form.id)) return;

        event.preventDefault();
        event.stopImmediatePropagation();
        authenticate(form).catch(error => notify(error.message || "Could not reach Kalaazu"));
    }, true);

    async function authenticate(form) {
        const mode = form.id;
        const fields = Object.fromEntries(new FormData(form));

        if (mode === "register" && fields.password !== fields.password_confirm) {
            throw new Error("Those passwords do not match.");
        }

        const button = form.querySelector("button");
        if (button) button.disabled = true;

        try {
            const request = {
                username: String(fields.username || "").trim(),
                password: String(fields.password || "")
            };
            if (mode === "register") request.email = String(fields.email || "").trim();

            const response = await fetch(`${KALAAZU_URL}/external/${mode}`, {
                method: "POST",
                headers: {"Content-Type": "application/json"},
                body: JSON.stringify(request)
            });
            const payload = await response.json();
            if (!response.ok || payload.status !== "OK" || !payload.data?.account) {
                throw new Error(payload.message || "Authentication failed");
            }

            const sessionResponse = await fetch("/bridge/session.php", {
                method: "POST",
                headers: {"Content-Type": "application/json"},
                body: JSON.stringify({account: payload.data.account})
            });
            const session = await sessionResponse.json();
            if (!sessionResponse.ok || session.status !== "OK") {
                throw new Error(session.message || "Could not create the CMS session");
            }

            window.location.assign("/home");
        } finally {
            if (button) button.disabled = false;
        }
    }

    function notify(message) {
        if (window.M?.toast) {
            window.M.toast({html: `<span>${escapeHtml(message)}</span>`});
        } else {
            window.alert(message);
        }
    }

    function escapeHtml(value) {
        const node = document.createElement("span");
        node.textContent = String(value);
        return node.innerHTML;
    }
})();
