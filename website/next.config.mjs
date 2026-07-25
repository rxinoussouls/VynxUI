import { createMDX } from "fumadocs-mdx/next";
import path from "node:path";
import { fileURLToPath } from "node:url";

const withMDX = createMDX();
const isGithubPages = process.env.NODE_ENV === "production";
const repo = "WindUI-Skibidi";
const basePath = isGithubPages ? `/${repo}` : "";
const __dirname = path.dirname(fileURLToPath(import.meta.url));

/** @type {import('next').NextConfig} */
const config = {
    output: "export",
    trailingSlash: true,
    basePath,
    assetPrefix: basePath ? `${basePath}/` : "",
    outputFileTracingRoot: __dirname,
    env: {
        NEXT_PUBLIC_BASE_PATH: basePath,
    },
    reactStrictMode: true,
    images: {
        unoptimized: true,
    },
};

export default withMDX(config);
