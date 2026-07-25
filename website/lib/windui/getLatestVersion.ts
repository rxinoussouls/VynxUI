// lib/getLatestVersion.ts
export async function getLatestVersion(): Promise<string> {
    const res = await fetch(
        "https://api.github.com/repos/article-hub-studio/WindUI-Skibidi/releases/latest",
        { headers: { Accept: "application/vnd.github.v3+json" } },
    );

    if (!res.ok) throw new Error("Failed to fetch latest release");
    const data = await res.json();
    return data.tag_name;
}
