(() => {
    "use strict";

    const WORLD = {width: 20800, height: 12800};
    const state = {
        mode: "login",
        account: null,
        socket: null,
        heroId: null,
        hero: null,
        entities: new Map(),
        readySent: false,
        stars: Array.from({length: 180}, (_, i) => ({
            x: ((i * 73) % 997) / 997,
            y: ((i * 193) % 991) / 991,
            size: i % 11 === 0 ? 1.7 : .8
        }))
    };

    const $ = id => document.getElementById(id);
    const authView = $("auth-view");
    const gameView = $("game-view");
    const form = $("auth-form");
    const canvas = $("space");
    const ctx = canvas.getContext("2d");

    document.querySelectorAll(".tab").forEach(tab => {
        tab.addEventListener("click", () => setMode(tab.dataset.mode));
    });

    form.addEventListener("submit", authenticate);
    $("disconnect").addEventListener("click", disconnect);
    canvas.addEventListener("click", moveHero);
    window.addEventListener("resize", resizeCanvas);

    function setMode(mode) {
        state.mode = mode;
        document.querySelectorAll(".tab").forEach(tab => tab.classList.toggle("active", tab.dataset.mode === mode));
        $("email-field").hidden = mode !== "register";
        $("email").required = mode === "register";
        $("password").autocomplete = mode === "register" ? "new-password" : "current-password";
        $("auth-submit").textContent = mode === "register" ? "Create pilot" : "Enter sector";
        setAuthMessage("");
    }

    async function authenticate(event) {
        event.preventDefault();
        const submit = $("auth-submit");
        submit.disabled = true;
        setAuthMessage(state.mode === "register" ? "Creating pilot…" : "Authenticating…", true);

        const body = {
            username: $("username").value.trim(),
            password: $("password").value
        };
        if (state.mode === "register") body.email = $("email").value.trim();

        try {
            const response = await fetch(`/external/${state.mode}`, {
                method: "POST",
                headers: {"Content-Type": "application/json"},
                body: JSON.stringify(body)
            });
            const payload = await response.json();
            if (!response.ok || payload.status !== "OK" || !payload.data?.account) {
                throw new Error(payload.message || "Authentication failed");
            }

            state.account = payload.data.account;
            openGame();
        } catch (error) {
            setAuthMessage(error.message || "Could not reach the local server");
        } finally {
            submit.disabled = false;
        }
    }

    function openGame() {
        authView.hidden = true;
        gameView.hidden = false;
        gameView.style.display = "grid";
        $("pilot-name").textContent = state.account.name;
        $("level").textContent = state.account.levelsId || 1;
        $("credits").textContent = formatNumber(state.account.credits);
        $("uridium").textContent = formatNumber(state.account.uridium);
        resizeCanvas();
        connectGameSocket();
        requestAnimationFrame(render);
    }

    function connectGameSocket() {
        const protocol = location.protocol === "https:" ? "wss" : "ws";
        const socket = new WebSocket(`${protocol}://${location.hostname}:8083/game`);
        state.socket = socket;
        setConnection("CONNECTING", false);

        socket.addEventListener("open", () => {
            setConnection("CONNECTED", true);
            setGameMessage("Authenticating with the V4 sector…");
            socket.send(`LOGIN|${state.account.usersId}|${state.account.sessionId}|HTML5`);
        });
        socket.addEventListener("message", event => handlePacket(String(event.data)));
        socket.addEventListener("close", () => {
            setConnection("OFFLINE", false);
            setGameMessage("Game connection closed");
        });
        socket.addEventListener("error", () => setGameMessage("Could not connect to browser game port 8083"));
    }

    function handlePacket(raw) {
        const parts = raw.replaceAll("\u0000", "").trim().split("|");
        if (parts[0] === "0") parts.shift();
        const command = parts[0];

        if (command === "I" && parts.length >= 30) {
            initializeHero(parts);
        } else if (command === "C" && parts.length >= 16) {
            createShip(parts);
        } else if (command === "1" && parts.length >= 5) {
            moveEntity(parts);
        } else if (["c", "r", "D", "L"].includes(command) && parts.length >= 5) {
            createCollectable(parts);
        } else if (command === "p" && parts.length >= 7) {
            createPortal(parts);
        } else if (command === "s" && parts.length >= 8) {
            createStation(parts);
        } else if (command === "R" && parts.length === 2) {
            state.entities.delete(number(parts[1]));
        } else if (command === "HPT" && parts.length >= 3 && state.hero) {
            state.hero.health = number(parts[1]);
            state.hero.maxHealth = number(parts[2]);
            updateMeters();
        } else if (command === "SHD" && parts.length >= 3 && state.hero) {
            state.hero.shield = number(parts[1]);
            state.hero.maxShield = number(parts[2]);
            updateMeters();
        }
    }

    function initializeHero(p) {
        state.heroId = number(p[1]);
        state.hero = {
            id: state.heroId,
            kind: "hero",
            name: p[2],
            x: number(p[11]),
            y: number(p[12]),
            targetX: number(p[11]),
            targetY: number(p[12]),
            health: number(p[7]),
            maxHealth: number(p[8]),
            shield: number(p[5]),
            maxShield: number(p[6])
        };
        state.entities.set(state.heroId, state.hero);
        $("map-id").textContent = p[13];
        updateMeters();
        updateCoordinates();
        setGameMessage("Sector loaded — click the map to move");

        if (!state.readySent) {
            state.readySent = true;
            window.setTimeout(() => state.socket?.send("RDY"), 100);
        }
    }

    function createShip(p) {
        const id = number(p[1]);
        const existing = state.entities.get(id);
        const entity = existing || {id};
        Object.assign(entity, {
            kind: id === state.heroId ? "hero" : (p[14] === "1" ? "npc" : "player"),
            name: p[5] || (p[14] === "1" ? "NPC" : "Pilot"),
            x: number(p[6]),
            y: number(p[7]),
            targetX: number(p[6]),
            targetY: number(p[7])
        });
        state.entities.set(id, entity);
        if (id === state.heroId) state.hero = entity;
    }

    function moveEntity(p) {
        const entity = state.entities.get(number(p[1]));
        if (!entity) return;
        entity.startX = entity.x;
        entity.startY = entity.y;
        entity.targetX = number(p[2]);
        entity.targetY = number(p[3]);
        entity.moveStarted = performance.now();
        entity.moveDuration = Math.max(number(p[4]), 1);
    }

    function createCollectable(p) {
        const kinds = {c: "box", r: "ore", D: "beacon", L: "mine"};
        state.entities.set(number(p[1]), {
            id: number(p[1]), kind: kinds[p[0]], type: number(p[2]), x: number(p[3]), y: number(p[4])
        });
    }

    function createPortal(p) {
        state.entities.set(number(p[1]), {id: number(p[1]), kind: "portal", type: number(p[2]), x: number(p[4]), y: number(p[5])});
    }

    function createStation(p) {
        state.entities.set(number(p[1]), {id: number(p[1]), kind: "station", name: p[3], x: number(p[6]), y: number(p[7])});
    }

    function moveHero(event) {
        if (!state.hero || state.socket?.readyState !== WebSocket.OPEN) return;
        const rect = canvas.getBoundingClientRect();
        const scale = cameraScale();
        const x = clamp(Math.round(state.hero.x + (event.clientX - rect.left - rect.width / 2) / scale), 0, WORLD.width);
        const y = clamp(Math.round(state.hero.y + (event.clientY - rect.top - rect.height / 2) / scale), 0, WORLD.height);
        state.socket.send(`1|${x}|${y}|${Math.round(state.hero.x)}|${Math.round(state.hero.y)}`);
        setGameMessage(`Course set: ${x}, ${y}`);
    }

    function render(now) {
        if (gameView.hidden) return;
        const width = canvas.clientWidth;
        const height = canvas.clientHeight;
        ctx.clearRect(0, 0, width, height);
        drawBackground(width, height);

        if (state.hero) {
            updateMovements(now);
            const scale = cameraScale();
            for (const entity of state.entities.values()) drawEntity(entity, width, height, scale);
            updateCoordinates();
        }
        requestAnimationFrame(render);
    }

    function updateMovements(now) {
        for (const entity of state.entities.values()) {
            if (!entity.moveStarted) continue;
            const progress = Math.min((now - entity.moveStarted) / entity.moveDuration, 1);
            entity.x = entity.startX + (entity.targetX - entity.startX) * progress;
            entity.y = entity.startY + (entity.targetY - entity.startY) * progress;
            if (progress === 1) entity.moveStarted = 0;
        }
    }

    function drawBackground(width, height) {
        const gradient = ctx.createRadialGradient(width * .5, height * .45, 10, width * .5, height * .45, Math.max(width, height));
        gradient.addColorStop(0, "#0b2030");
        gradient.addColorStop(1, "#010409");
        ctx.fillStyle = gradient;
        ctx.fillRect(0, 0, width, height);
        for (const star of state.stars) {
            ctx.globalAlpha = .35 + star.size * .2;
            ctx.fillStyle = "#bdeeff";
            ctx.fillRect(star.x * width, star.y * height, star.size, star.size);
        }
        ctx.globalAlpha = 1;
    }

    function drawEntity(entity, width, height, scale) {
        const x = width / 2 + (entity.x - state.hero.x) * scale;
        const y = height / 2 + (entity.y - state.hero.y) * scale;
        if (x < -40 || y < -40 || x > width + 40 || y > height + 40) return;

        ctx.save();
        ctx.translate(x, y);
        if (["hero", "player", "npc"].includes(entity.kind)) {
            const color = entity.kind === "hero" ? "#62dcff" : entity.kind === "npc" ? "#ff667d" : "#e6d264";
            ctx.shadowBlur = entity.kind === "hero" ? 18 : 8;
            ctx.shadowColor = color;
            ctx.fillStyle = color;
            ctx.beginPath();
            ctx.moveTo(13, 0); ctx.lineTo(-9, -7); ctx.lineTo(-5, 0); ctx.lineTo(-9, 7); ctx.closePath(); ctx.fill();
            ctx.shadowBlur = 0;
            ctx.fillStyle = "#a8bfd0";
            ctx.font = "10px system-ui";
            ctx.textAlign = "center";
            ctx.fillText(entity.name || entity.kind, 0, -14);
        } else if (entity.kind === "portal") {
            ctx.strokeStyle = "#9b78ff"; ctx.lineWidth = 3; ctx.shadowBlur = 14; ctx.shadowColor = "#9b78ff";
            ctx.beginPath(); ctx.ellipse(0, 0, 10, 19, .5, 0, Math.PI * 2); ctx.stroke();
        } else if (entity.kind === "station") {
            ctx.fillStyle = "#f0b85b"; ctx.fillRect(-10, -10, 20, 20); ctx.strokeStyle = "#ffe2a8"; ctx.strokeRect(-14, -14, 28, 28);
        } else {
            const colors = {box: "#ffd65a", ore: "#68e8c0", beacon: "#75a9ff", mine: "#ff7a6c"};
            ctx.fillStyle = colors[entity.kind] || "#fff"; ctx.shadowBlur = 9; ctx.shadowColor = ctx.fillStyle;
            ctx.beginPath(); ctx.arc(0, 0, entity.kind === "box" ? 5 : 4, 0, Math.PI * 2); ctx.fill();
        }
        ctx.restore();
    }

    function updateMeters() {
        if (!state.hero) return;
        setMeter("health", state.hero.health, state.hero.maxHealth);
        setMeter("shield", state.hero.shield, state.hero.maxShield);
    }

    function setMeter(name, value, max) {
        $(`${name}-label`).textContent = `${formatNumber(value)} / ${formatNumber(max)}`;
        $(`${name}-bar`).style.width = `${clamp(max ? value / max * 100 : 0, 0, 100)}%`;
    }

    function updateCoordinates() {
        if (!state.hero) return;
        $("coord-x").textContent = Math.round(state.hero.x);
        $("coord-y").textContent = Math.round(state.hero.y);
    }

    function resizeCanvas() {
        const ratio = Math.min(window.devicePixelRatio || 1, 2);
        const rect = canvas.getBoundingClientRect();
        canvas.width = Math.max(1, Math.floor(rect.width * ratio));
        canvas.height = Math.max(1, Math.floor(rect.height * ratio));
        ctx.setTransform(ratio, 0, 0, ratio, 0, 0);
    }

    function cameraScale() {
        return Math.max(.035, Math.min(canvas.clientWidth / 9000, canvas.clientHeight / 5500));
    }

    function disconnect() {
        state.socket?.close();
        state.socket = null;
        state.entities.clear();
        state.hero = null;
        state.heroId = null;
        state.readySent = false;
        gameView.hidden = true;
        gameView.style.display = "none";
        authView.hidden = false;
        setConnection("OFFLINE", false);
    }

    function setConnection(label, online) {
        $("connection-label").textContent = label;
        $("connection-dot").parentElement.classList.toggle("online", online);
    }

    function setAuthMessage(message, ok = false) {
        $("auth-message").textContent = message;
        $("auth-message").classList.toggle("ok", ok);
    }

    function setGameMessage(message) { $("game-message").textContent = message; }
    function formatNumber(value) { return Number(value || 0).toLocaleString(); }
    function number(value) { return Number.parseInt(value, 10) || 0; }
    function clamp(value, min, max) { return Math.min(max, Math.max(min, value)); }
})();
