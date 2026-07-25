"use client";

import { useMemo, useState } from "react";
import { Check, Copy, Github, UploadCloud } from "lucide-react";

type ThemeDraft = {
    Name: string;
    Accent: string;
    Dialog: string;
    Text: string;
    Placeholder: string;
    Background: string;
    Button: string;
    Icon: string;
    Primary: string;
};

const defaultTheme: ThemeDraft = {
    Name: "Custom Liquid",
    Accent: "#0EA5E9",
    Dialog: "#101821",
    Text: "#FFFFFF",
    Placeholder: "#8DA2B8",
    Background: "#070B12",
    Button: "#0EA5E9",
    Icon: "#7DD3FC",
    Primary: "#38BDF8",
};

const fields: Array<[keyof ThemeDraft, string]> = [
    ["Accent", "Accent"],
    ["Dialog", "Dialog"],
    ["Text", "Text"],
    ["Placeholder", "Placeholder"],
    ["Background", "Background"],
    ["Button", "Button"],
    ["Icon", "Icon"],
    ["Primary", "Primary"],
];

function slugify(value: string) {
    return value
        .toLowerCase()
        .replace(/[^a-z0-9]+/g, "-")
        .replace(/^-+|-+$/g, "");
}

function toBase64(value: string) {
    const bytes = new TextEncoder().encode(value);
    let binary = "";
    bytes.forEach((byte) => {
        binary += String.fromCharCode(byte);
    });
    return window.btoa(binary);
}

export default function CustomThemeStudio() {
    const [theme, setTheme] = useState<ThemeDraft>(defaultTheme);
    const [owner, setOwner] = useState("article-hub-studio");
    const [repo, setRepo] = useState("WindUI-Skibidi");
    const [branch, setBranch] = useState("main");
    const [path, setPath] = useState("themes/custom/custom-liquid.json");
    const [token, setToken] = useState("");
    const [status, setStatus] = useState("");
    const [busy, setBusy] = useState(false);

    const json = useMemo(() => JSON.stringify(theme, null, 4), [theme]);

    function updateTheme(key: keyof ThemeDraft, value: string) {
        setTheme((current) => {
            const next = { ...current, [key]: value };
            if (key === "Name") {
                setPath(`themes/custom/${slugify(value) || "custom-theme"}.json`);
            }
            return next;
        });
    }

    async function copyJson() {
        await navigator.clipboard.writeText(json);
        setStatus("Theme JSON copied.");
    }

    async function uploadTheme() {
        if (!token.trim()) {
            setStatus("Add a GitHub token with contents write access first.");
            return;
        }

        setBusy(true);
        setStatus("Checking GitHub path...");

        try {
            const headers = {
                Authorization: `Bearer ${token.trim()}`,
                Accept: "application/vnd.github+json",
                "X-GitHub-Api-Version": "2022-11-28",
            };
            const fileUrl = `https://api.github.com/repos/${owner}/${repo}/contents/${path}`;
            const existing = await fetch(`${fileUrl}?ref=${branch}`, { headers });
            let sha: string | undefined;

            if (existing.ok) {
                const data = await existing.json();
                sha = data.sha;
            } else if (existing.status !== 404) {
                throw new Error(`GitHub lookup failed: ${existing.status}`);
            }

            setStatus("Uploading theme JSON...");

            const upload = await fetch(fileUrl, {
                method: "PUT",
                headers,
                body: JSON.stringify({
                    message: `Add ${theme.Name} WindUI theme`,
                    content: toBase64(json),
                    branch,
                    sha,
                }),
            });

            if (!upload.ok) {
                const text = await upload.text();
                throw new Error(text || `GitHub upload failed: ${upload.status}`);
            }

            setStatus("Uploaded to GitHub Contents API.");
        } catch (error) {
            setStatus(error instanceof Error ? error.message : "Upload failed.");
        } finally {
            setBusy(false);
        }
    }

    return (
        <div className="not-prose my-6 overflow-hidden rounded-[28px] border border-white/10 bg-[#071018] text-white shadow-2xl shadow-cyan-950/30">
            <div className="grid gap-0 lg:grid-cols-[0.9fr_1.1fr]">
                <section className="border-b border-white/10 p-5 lg:border-b-0 lg:border-r">
                    <div className="flex items-center gap-3">
                        <div className="flex size-11 items-center justify-center rounded-2xl bg-cyan-400/15 text-cyan-200">
                            <UploadCloud className="size-5" />
                        </div>
                        <div>
                            <h3 className="text-lg font-semibold">
                                Custom Theme Studio
                            </h3>
                            <p className="text-sm text-white/55">
                                Build a theme JSON and upload it to GitHub.
                            </p>
                        </div>
                    </div>

                    <label className="mt-5 block text-sm font-semibold text-white/70">
                        Theme name
                    </label>
                    <input
                        value={theme.Name}
                        onChange={(event) => updateTheme("Name", event.target.value)}
                        className="mt-2 h-11 w-full rounded-2xl border border-white/10 bg-white/8 px-3 text-sm outline-none transition focus:border-cyan-300/60"
                    />

                    <div className="mt-5 grid grid-cols-2 gap-3">
                        {fields.map(([key, label]) => (
                            <label key={key} className="space-y-2">
                                <span className="text-xs font-semibold uppercase tracking-[0.16em] text-white/42">
                                    {label}
                                </span>
                                <div className="flex h-11 items-center gap-2 rounded-2xl border border-white/10 bg-white/8 px-2">
                                    <input
                                        type="color"
                                        value={theme[key]}
                                        onChange={(event) =>
                                            updateTheme(key, event.target.value)
                                        }
                                        className="size-7 rounded-lg border-0 bg-transparent p-0"
                                    />
                                    <input
                                        value={theme[key]}
                                        onChange={(event) =>
                                            updateTheme(key, event.target.value)
                                        }
                                        className="min-w-0 flex-1 bg-transparent text-sm outline-none"
                                    />
                                </div>
                            </label>
                        ))}
                    </div>
                </section>

                <section className="p-5">
                    <div className="rounded-[24px] border border-white/10 bg-white/[0.055] p-4">
                        <div className="flex items-center justify-between gap-3">
                            <div>
                                <p className="text-sm font-semibold">
                                    GitHub database target
                                </p>
                                <p className="text-xs text-white/45">
                                    Token stays in this browser session.
                                </p>
                            </div>
                            <Github className="size-5 text-white/55" />
                        </div>

                        <div className="mt-4 grid gap-3 sm:grid-cols-2">
                            <input
                                value={owner}
                                onChange={(event) => setOwner(event.target.value)}
                                placeholder="owner"
                                className="h-10 rounded-2xl border border-white/10 bg-black/20 px-3 text-sm outline-none"
                            />
                            <input
                                value={repo}
                                onChange={(event) => setRepo(event.target.value)}
                                placeholder="repo"
                                className="h-10 rounded-2xl border border-white/10 bg-black/20 px-3 text-sm outline-none"
                            />
                            <input
                                value={branch}
                                onChange={(event) => setBranch(event.target.value)}
                                placeholder="branch"
                                className="h-10 rounded-2xl border border-white/10 bg-black/20 px-3 text-sm outline-none"
                            />
                            <input
                                value={path}
                                onChange={(event) => setPath(event.target.value)}
                                placeholder="themes/custom/theme.json"
                                className="h-10 rounded-2xl border border-white/10 bg-black/20 px-3 text-sm outline-none"
                            />
                        </div>

                        <input
                            value={token}
                            onChange={(event) => setToken(event.target.value)}
                            type="password"
                            placeholder="GitHub fine-grained token"
                            className="mt-3 h-10 w-full rounded-2xl border border-white/10 bg-black/20 px-3 text-sm outline-none"
                        />

                        <div className="mt-4 flex flex-col gap-2 sm:flex-row">
                            <button
                                type="button"
                                onClick={copyJson}
                                className="inline-flex h-10 flex-1 items-center justify-center gap-2 rounded-2xl bg-white/10 text-sm font-semibold transition hover:bg-white/15"
                            >
                                <Copy className="size-4" />
                                Copy JSON
                            </button>
                            <button
                                type="button"
                                onClick={uploadTheme}
                                disabled={busy}
                                className="inline-flex h-10 flex-1 items-center justify-center gap-2 rounded-2xl bg-cyan-300 text-sm font-semibold text-black transition hover:bg-cyan-200 disabled:opacity-55"
                            >
                                {busy ? (
                                    <UploadCloud className="size-4 animate-pulse" />
                                ) : (
                                    <Check className="size-4" />
                                )}
                                Upload
                            </button>
                        </div>
                    </div>

                    <pre className="mt-4 max-h-[360px] overflow-auto rounded-[24px] border border-white/10 bg-black/35 p-4 text-xs leading-5 text-cyan-50/80">
                        {json}
                    </pre>

                    {status && (
                        <p className="mt-3 rounded-2xl border border-white/10 bg-white/[0.055] px-3 py-2 text-sm text-white/70">
                            {status}
                        </p>
                    )}
                </section>
            </div>
        </div>
    );
}
