async function readThemesSource() {
    try {
        const req = eval("require");
        const fs = req("fs");
        const path = req("path");
        const localPaths = [
            path.resolve(process.cwd(), "../src/themes/Init.lua"),
            path.resolve(process.cwd(), "src/themes/Init.lua"),
        ];

        for (const localPath of localPaths) {
            if (fs.existsSync(localPath)) {
                return fs.readFileSync(localPath, "utf8");
            }
        }
    } catch {
        // Continue to the hosted fallback below.
    }

    const url =
        "https://article-hub-studio.github.io/WindUI-Skibidi/src/themes/Init.lua";

    const controller = new AbortController();
    const timeout = setTimeout(() => controller.abort(), 5000);

    const res = await fetch(url, { signal: controller.signal });
    clearTimeout(timeout);

    if (!res.ok) throw new Error("Failed to fetch themes");
    return res.text();
}

export async function getThemes(): Promise<Record<string, any>> {
    try {
        const txt = await readThemesSource();

        const themeRegex =
            /([A-Za-z0-9_]+)\s*=\s*\{([^]*?)\},\s*(?=[A-Za-z0-9_]+\s*=|}\s*end|$)/g;
        const themes: Record<string, any> = {};
        let m;
        while ((m = themeRegex.exec(txt)) !== null) {
            const key = m[1];
            const body = m[2];
            const theme: Record<string, any> = {};

            const colorRegex =
                /([A-Za-z0-9_]+)\s*=\s*Color3\.fromHex\("(?<hex>#[0-9A-Fa-f]{6})"\)/g;
            let c;
            while ((c = colorRegex.exec(body)) !== null) {
                const prop = c[1];
                const hex = c.groups?.hex ?? null;
                if (hex) theme[prop] = hex.toLowerCase();
            }

            const nameMatch = body.match(/Name\s*=\s*"(.*?)"/);
            if (nameMatch) theme.Name = nameMatch[1];

            const gradRegex =
                /([A-Za-z0-9_]+)\s*=\s*WindUI:Gradient\(\s*\{([^]*?)\}\s*,\s*\{([^]*?)\}\s*\)/g;
            let g;
            while ((g = gradRegex.exec(body)) !== null) {
                const prop = g[1];
                const stopsBlock = g[2];
                const optsBlock = g[3];
                const stopRegex =
                    /\["(?<pos>\d+)"\]\s*=\s*\{\s*Color\s*=\s*Color3\.fromHex\("(?<hex>#[0-9A-Fa-f]{6})"\)[^}]*\}/g;
                const stops: Array<{ pos: string; hex: string }> = [];
                let s;
                while ((s = stopRegex.exec(stopsBlock)) !== null) {
                    stops.push({
                        pos: s[1],
                        hex: (s.groups?.hex ?? "").toLowerCase(),
                    });
                }

                const rotMatch = optsBlock.match(/Rotation\s*=\s*([0-9]+)/);
                const rotation = rotMatch ? Number(rotMatch[1]) : undefined;

                theme[prop] = { gradient: stops, rotation };
            }

            themes[key] = theme;
        }

        return themes;
    } catch (error) {
        console.warn("Failed to load WindUI themes:", error);
        return {};
    }
}
