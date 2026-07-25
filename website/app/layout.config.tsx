import type { BaseLayoutProps } from "fumadocs-ui/layouts/shared";
import BrandName from "./data/BrandName";

const basePath = process.env.NEXT_PUBLIC_BASE_PATH || "";

export interface NavLink {
    text: string;
    url: string;
    active?: string;
}

export const baseOptions: BaseLayoutProps & { links: NavLink[] } = {
    nav: {
        title: (
            <div className="flex flex-row items-center gap-1">
                <img src={`${basePath}/logo.svg`} className="h-4" />
                <span className="font-semibold text-[20px] max-sm:hidden">
                    {BrandName}
                </span>
            </div>
        ),
    },
    links: [
        {
            text: "Github",
            url: "https://github.com/article-hub-studio/WindUI-Skibidi",
        },
        {
            text: "Discord",
            url: "https://discord.com/invite/ftgs-development-hub-1300692552005189632",
        },
        { text: "Documentation", url: "/docs", active: "nested-url" },
        { text: "Getting Started", url: "/getting-started" },
    ],
};
