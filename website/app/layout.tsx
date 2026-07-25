import { RootProvider } from "fumadocs-ui/provider";
import type { Metadata, Viewport } from "next";
import type { ReactNode } from "react";
import "./global.css";
import { Body } from "./body";
import { GeistSans } from "geist/font/sans";
import { SquircleNoScript } from "@squircle-js/react";

export const viewport: Viewport = {
    width: "device-width",
    initialScale: 1,
    viewportFit: "cover",
};

export const metadata: Metadata = {
    metadataBase: new URL("https://article-hub-studio.github.io/WindUI-Skibidi"),
    title: {
        template: "%s",
        default: "WindUI Modded Docs",
    },
    description:
        "Documentation for WindUI Modded, a Roblox Luau UI library fork with mobile-focused liquid glass elements.",
    authors: [
        {
            name: "article-hub-studio",
            url: "https://github.com/article-hub-studio",
        },
    ],
    creator: "article-hub-studio",
};

export default function Layout({ children }: { children: ReactNode }) {
    return (
        <html
            lang="en"
            className={GeistSans.className}
            suppressHydrationWarning
        >
            <Body>
                <SquircleNoScript />
                <RootProvider search={{ enabled: false }}>
                    {children}
                </RootProvider>
            </Body>
        </html>
    );
}
