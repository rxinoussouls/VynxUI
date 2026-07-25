"use client";

import Link from "next/link";
import { DynamicCodeBlock } from "fumadocs-ui/components/dynamic-codeblock";
import {
    ArrowRight,
    BadgeCheck,
    BookOpen,
    Code2,
    Crown,
    ExternalLink,
    Gem,
    LayoutDashboard,
    MonitorSmartphone,
    Palette,
    PanelsTopLeft,
    Sparkles,
} from "lucide-react";
import loadstring from "@/lib/loadstring";
import BrandName from "../data/BrandName";

const previewImages = [
    {
        src: "/windui/previews/windui-modded-preview.png",
        title: "Full interface preview",
        detail: "Desktop, mobile and liquid glass components in one frame.",
        span: "lg:col-span-2",
    },
    {
        src: "/windui/banners/Window.png",
        title: "Window shell",
        detail: "Mac style topbar, sidebar tabs and compact content panels.",
        span: "",
    },
    {
        src: "/windui/banners/Tab.png",
        title: "Tab navigation",
        detail: "Sidebar navigation with grouped script pages and icons.",
        span: "",
    },
    {
        src: "/windui/banners/Themes.png",
        title: "Theme picker",
        detail: "Theme states, config controls and dark glass treatment.",
        span: "",
    },
    {
        src: "/windui/banners/TabSection.png",
        title: "Tab section",
        detail: "Nested tab flows without wasting vertical space.",
        span: "",
    },
    {
        src: "/windui/banners/Section.png",
        title: "Sections",
        detail: "Section headers, dense controls and clean content blocks.",
        span: "",
    },
    {
        src: "/windui/banners/HStackVStack.png",
        title: "Layout primitives",
        detail: "HStack and VStack moved into useful layout examples.",
        span: "",
    },
    {
        src: "/windui/banners/Notifications.png",
        title: "Notifications",
        detail: "Toast states and runtime feedback for script actions.",
        span: "",
    },
    {
        src: "/windui/banners/Tag.png",
        title: "Tags",
        detail: "Compact metadata tags for cards, rows and script status.",
        span: "",
    },
];

const repoPreviewImages = [
    {
        src: "/windui/repo/banner-new.webp",
        title: "Repo banner",
        detail: "Original repository banner exported as a lightweight webp.",
    },
    {
        src: "/windui/repo/banner-dark.webp",
        title: "Dark banner",
        detail: "Large dark presentation image from the repository docs folder.",
    },
    {
        src: "/windui/repo/banner-light.webp",
        title: "Light banner",
        detail: "Light mode repository banner for contrast and docs usage.",
    },
    {
        src: "/windui/repo/ui.png",
        title: "Classic UI capture",
        detail: "Legacy UI reference retained for visual comparison.",
    },
    {
        src: "/windui/repo/themes-overview.png",
        title: "Theme overview",
        detail: "Theme screenshot from the repo docs asset set.",
    },
    {
        src: "/windui/main-banner.png",
        title: "Main banner",
        detail: "Primary WindUI Modded website banner.",
    },
];

const themePreviewImages = [
    "Dark",
    "Light",
    "Amber",
    "Cotton Candy",
    "Crimson",
    "Emerald",
    "Indigo",
    "Mellowsi",
    "Midnight",
    "Monokai Pro",
    "Plant",
    "Rainbow",
    "Red",
    "Rose",
    "Sky",
    "Violet",
];

const elementGroups = [
    {
        title: "Core Controls",
        icon: LayoutDashboard,
        description: "Fast input primitives for scripts that need mobile and PC support.",
        items: [
            ["Button", "/docs/windui/button"],
            ["Toggle", "/docs/windui/toggle"],
            ["Slider", "/docs/windui/slider"],
            ["Stepper", "/docs/windui/stepper"],
            ["Input", "/docs/windui/input"],
            ["TextArea", "/docs/windui/textarea"],
            ["Dropdown", "/docs/windui/dropdown"],
        ],
    },
    {
        title: "Choice Inputs",
        icon: PanelsTopLeft,
        description: "Grouped selection patterns that keep mobile screens readable.",
        items: [
            ["Segmented Control", "/docs/windui/segmentedcontrol"],
            ["Radio Group", "/docs/windui/radiogroup"],
            ["Checkbox Group", "/docs/windui/checkboxgroup"],
            ["Chip List", "/docs/windui/chiplist"],
            ["Colorpicker", "/docs/windui/colorpicker"],
            ["Keybind", "/docs/windui/keybind"],
        ],
    },
    {
        title: "Display Cards",
        icon: BadgeCheck,
        description: "Cards for status, metrics, Discord links and dense script dashboards.",
        items: [
            ["Callout", "/docs/windui/callout"],
            ["Badge", "/docs/windui/badge"],
            ["StatusCard", "/docs/windui/statuscard"],
            ["StatCard", "/docs/windui/statcard"],
            ["KeyValue", "/docs/windui/keyvalue"],
            ["ActionList", "/docs/windui/actionlist"],
            ["DiscordCard", "/docs/windui/discordcard"],
            ["Card", "/docs/windui/card"],
        ],
    },
    {
        title: "Motion And Media",
        icon: Sparkles,
        description: "Visual elements for animated sections, previews and richer panels.",
        items: [
            ["TabBox", "/docs/windui/tabbox"],
            ["Timeline", "/docs/windui/timeline"],
            ["Accordion", "/docs/windui/accordion"],
            ["Path2D", "/docs/windui/path2d"],
            ["Image", "/docs/windui/image"],
            ["Video", "/docs/windui/video"],
            ["Viewport", "/docs/windui/viewport"],
            ["ProgressBar", "/docs/windui/progressbar"],
        ],
    },
];

const stats = [
    ["40+", "Documented pages"],
    ["20+", "Modern elements"],
    ["Mobile", "Executor friendly"],
    ["Liquid", "Glass modded UI"],
];

function encodeAssetPath(path: string) {
    return path
        .split("/")
        .map((part, index) => (index === 0 ? part : encodeURIComponent(part)))
        .join("/");
}

function asset(path: string) {
    return `${process.env.NEXT_PUBLIC_BASE_PATH || ""}${encodeAssetPath(path)}`;
}

export default function HomePage() {
    return (
        <main className="min-h-dvh overflow-x-clip bg-[#05070b] text-white">
            <section className="relative overflow-hidden border-b border-white/10">
                <div className="absolute inset-0 bg-[linear-gradient(rgba(255,255,255,0.06)_1px,transparent_1px),linear-gradient(90deg,rgba(255,255,255,0.06)_1px,transparent_1px)] bg-[size:80px_80px] opacity-20" />
                <div className="absolute inset-0 bg-[radial-gradient(circle_at_50%_0%,rgba(20,184,166,0.22),transparent_34%),linear-gradient(135deg,rgba(37,99,235,0.18),transparent_38%,rgba(234,179,8,0.13))]" />

                <div className="relative mx-auto grid min-h-[calc(100dvh-64px)] w-full max-w-7xl grid-cols-1 items-center gap-10 px-4 py-14 sm:px-6 lg:grid-cols-[0.92fr_1.08fr] lg:px-8">
                    <div className="flex flex-col gap-8">
                        <div className="inline-flex w-fit items-center gap-2 rounded-full border border-white/14 bg-white/8 px-3 py-1.5 text-sm font-medium text-white/78 backdrop-blur-md">
                            <Sparkles className="size-4 text-cyan-300" />
                            Roblox Luau UI library fork
                        </div>

                        <div className="flex flex-col gap-5">
                            <h1 className="max-w-3xl text-5xl font-semibold leading-[0.98] tracking-tight text-white sm:text-6xl lg:text-7xl">
                                {BrandName}
                            </h1>
                            <p className="max-w-2xl text-base leading-7 text-white/68 sm:text-lg">
                                A modded WindUI build focused on liquid glass
                                visuals, mobile support, richer elements and
                                practical docs for executor scripts.
                            </p>
                        </div>

                        <div className="flex flex-col gap-3 sm:flex-row">
                            <Link
                                href="/docs"
                                className="inline-flex h-12 items-center justify-center gap-2 rounded-full bg-white px-5 text-sm font-semibold text-black transition duration-200 hover:bg-cyan-100"
                            >
                                Open docs
                                <ArrowRight className="size-4" />
                            </Link>
                            <Link
                                href="/docs/windui/elements-overview"
                                className="inline-flex h-12 items-center justify-center gap-2 rounded-full border border-white/14 bg-white/8 px-5 text-sm font-semibold text-white transition duration-200 hover:bg-white/14"
                            >
                                Browse elements
                                <BookOpen className="size-4" />
                            </Link>
                            <Link
                                href="https://github.com/article-hub-studio/WindUI-Skibidi"
                                className="inline-flex h-12 items-center justify-center gap-2 rounded-full border border-white/14 bg-black/20 px-5 text-sm font-semibold text-white/84 transition duration-200 hover:bg-white/10"
                            >
                                GitHub
                                <ExternalLink className="size-4" />
                            </Link>
                        </div>

                        <div className="grid grid-cols-2 gap-2 sm:grid-cols-4">
                            {stats.map(([value, label]) => (
                                <div
                                    key={value}
                                    className="rounded-2xl border border-white/10 bg-white/[0.055] p-4"
                                >
                                    <p className="text-xl font-semibold text-white">
                                        {value}
                                    </p>
                                    <p className="mt-1 text-xs font-medium uppercase tracking-[0.18em] text-white/45">
                                        {label}
                                    </p>
                                </div>
                            ))}
                        </div>
                    </div>

                    <div className="relative">
                        <div className="absolute -inset-3 rounded-[34px] border border-cyan-300/16 bg-cyan-300/6" />
                        <div className="relative overflow-hidden rounded-[30px] border border-white/14 bg-black/40 shadow-2xl shadow-cyan-950/50">
                            <img
                                src={asset("/windui/previews/windui-modded-preview.png")}
                                alt="WindUI Modded interface preview"
                                className="aspect-[16/9] w-full object-cover"
                                loading="eager"
                            />
                            <div className="border-t border-white/10 bg-black/60 p-4">
                                <div className="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
                                    <div>
                                        <p className="text-sm font-semibold text-white">
                                            Liquid glass preview
                                        </p>
                                        <p className="text-sm text-white/55">
                                            Desktop layout, mobile panel, dropdowns,
                                            keybinds and premium accents.
                                        </p>
                                    </div>
                                    <div className="inline-flex w-fit items-center gap-2 rounded-full border border-amber-300/28 bg-amber-300/10 px-3 py-1.5 text-sm font-semibold text-amber-200">
                                        <Crown className="size-4" />
                                        Premium ready
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <section className="mx-auto grid w-full max-w-7xl grid-cols-1 gap-4 px-4 py-10 sm:px-6 lg:grid-cols-3 lg:px-8">
                <div className="rounded-3xl border border-white/10 bg-white/[0.055] p-6">
                    <p className="text-sm font-semibold uppercase tracking-[0.2em] text-cyan-200/80">
                        Maintainer
                    </p>
                    <h2 className="mt-3 text-2xl font-semibold tracking-tight">
                        article-hub-studio
                    </h2>
                    <p className="mt-3 text-sm leading-6 text-white/58">
                        This website and modded fork are maintained for the
                        WindUI-Skibidi repo.
                    </p>
                </div>
                <div className="rounded-3xl border border-white/10 bg-white/[0.055] p-6">
                    <p className="text-sm font-semibold uppercase tracking-[0.2em] text-amber-200/80">
                        Original credit
                    </p>
                    <h2 className="mt-3 text-2xl font-semibold tracking-tight">
                        Original WindUI
                    </h2>
                    <p className="mt-3 text-sm leading-6 text-white/58">
                        Credit to the original WindUI project and its author.
                        This fork keeps the familiar API while documenting the
                        modded feature set.
                    </p>
                </div>
                <div className="rounded-3xl border border-white/10 bg-white/[0.055] p-6">
                    <p className="text-sm font-semibold uppercase tracking-[0.2em] text-emerald-200/80">
                        Runtime
                    </p>
                    <h2 className="mt-3 text-2xl font-semibold tracking-tight">
                        Loadstring ready
                    </h2>
                    <p className="mt-3 text-sm leading-6 text-white/58">
                        Docs point to the current article-hub-studio repo and
                        release assets.
                    </p>
                </div>
            </section>

            <section className="mx-auto w-full max-w-7xl px-4 py-12 sm:px-6 lg:px-8">
                <div className="mb-8 flex flex-col gap-3 sm:flex-row sm:items-end sm:justify-between">
                    <div>
                        <p className="text-sm font-semibold uppercase tracking-[0.2em] text-white/45">
                            Preview UI
                        </p>
                        <h2 className="mt-3 text-3xl font-semibold tracking-tight sm:text-4xl">
                            Real interface references
                        </h2>
                    </div>
                    <p className="max-w-xl text-sm leading-6 text-white/58">
                        The site now shows actual UI previews, not an empty
                        placeholder. These images cover windows, themes,
                        layout primitives and tab sections.
                    </p>
                </div>

                <div className="grid grid-cols-1 gap-4 lg:grid-cols-3">
                    {previewImages.map((item) => (
                        <article
                            key={item.src}
                            className={`overflow-hidden rounded-3xl border border-white/10 bg-white/[0.055] ${item.span}`}
                        >
                            <img
                                src={asset(item.src)}
                                alt={item.title}
                                className="aspect-[16/9] w-full object-cover"
                                loading="lazy"
                            />
                            <div className="border-t border-white/10 p-5">
                                <h3 className="text-lg font-semibold">
                                    {item.title}
                                </h3>
                                <p className="mt-2 text-sm leading-6 text-white/56">
                                    {item.detail}
                                </p>
                            </div>
                        </article>
                    ))}
                </div>
            </section>

            <section className="mx-auto w-full max-w-7xl px-4 py-12 sm:px-6 lg:px-8">
                <div className="mb-8 grid grid-cols-1 gap-5 lg:grid-cols-[0.82fr_1.18fr]">
                    <div>
                        <p className="text-sm font-semibold uppercase tracking-[0.2em] text-white/45">
                            Repo Assets
                        </p>
                        <h2 className="mt-3 text-3xl font-semibold tracking-tight sm:text-4xl">
                            Preview images from the repository
                        </h2>
                    </div>
                    <p className="text-sm leading-6 text-white/58">
                        These previews are copied from the repo asset set into
                        the website public folder, so GitHub Pages serves them
                        locally instead of relying on fragile external links.
                    </p>
                </div>

                <div className="grid grid-cols-1 gap-4 md:grid-cols-2 xl:grid-cols-3">
                    {repoPreviewImages.map((item) => (
                        <article
                            key={item.src}
                            className="overflow-hidden rounded-3xl border border-white/10 bg-white/[0.055]"
                        >
                            <img
                                src={asset(item.src)}
                                alt={item.title}
                                className="aspect-[16/9] w-full object-cover"
                                loading="lazy"
                            />
                            <div className="border-t border-white/10 p-5">
                                <h3 className="text-lg font-semibold">
                                    {item.title}
                                </h3>
                                <p className="mt-2 text-sm leading-6 text-white/56">
                                    {item.detail}
                                </p>
                            </div>
                        </article>
                    ))}
                </div>
            </section>

            <section className="mx-auto w-full max-w-7xl px-4 py-12 sm:px-6 lg:px-8">
                <div className="mb-8 flex flex-col gap-3 sm:flex-row sm:items-end sm:justify-between">
                    <div>
                        <p className="text-sm font-semibold uppercase tracking-[0.2em] text-white/45">
                            Theme Preview
                        </p>
                        <h2 className="mt-3 text-3xl font-semibold tracking-tight sm:text-4xl">
                            Built-in theme screenshots
                        </h2>
                    </div>
                    <Link
                        href="/docs/windui/themes"
                        className="inline-flex h-11 w-fit items-center justify-center gap-2 rounded-full border border-white/14 bg-white/8 px-4 text-sm font-semibold text-white transition duration-200 hover:bg-white/14"
                    >
                        Theme docs
                        <ArrowRight className="size-4" />
                    </Link>
                </div>

                <div className="grid grid-cols-2 gap-3 md:grid-cols-4 xl:grid-cols-8">
                    {themePreviewImages.map((theme) => (
                        <Link
                            key={theme}
                            href="/docs/windui/themes"
                            className="group overflow-hidden rounded-2xl border border-white/10 bg-white/[0.055] transition duration-200 hover:border-cyan-300/30 hover:bg-cyan-300/8"
                        >
                            <img
                                src={asset(`/windui/themes/${theme}.png`)}
                                alt={`${theme} theme preview`}
                                className="aspect-[5/4] w-full object-cover object-top transition duration-300 group-hover:scale-[1.04]"
                                loading="lazy"
                            />
                            <div className="border-t border-white/10 px-3 py-2">
                                <p className="truncate text-xs font-semibold text-white/78">
                                    {theme}
                                </p>
                            </div>
                        </Link>
                    ))}
                </div>
            </section>

            <section className="mx-auto w-full max-w-7xl px-4 py-12 sm:px-6 lg:px-8">
                <div className="mb-8 grid grid-cols-1 gap-5 lg:grid-cols-[0.8fr_1.2fr]">
                    <div>
                        <p className="text-sm font-semibold uppercase tracking-[0.2em] text-white/45">
                            Elements
                        </p>
                        <h2 className="mt-3 text-3xl font-semibold tracking-tight sm:text-4xl">
                            Split by real workflow
                        </h2>
                    </div>
                    <p className="text-sm leading-6 text-white/58">
                        Elements are grouped by how scripts actually use them:
                        input controls, selections, display cards and richer
                        animated media. The full docs page includes every new
                        element with quick links.
                    </p>
                </div>

                <div className="grid grid-cols-1 gap-4 lg:grid-cols-2">
                    {elementGroups.map((group) => {
                        const Icon = group.icon;
                        return (
                            <article
                                key={group.title}
                                className="rounded-3xl border border-white/10 bg-[linear-gradient(135deg,rgba(255,255,255,0.07),rgba(255,255,255,0.035))] p-6"
                            >
                                <div className="flex items-start gap-4">
                                    <div className="flex size-12 shrink-0 items-center justify-center rounded-2xl border border-cyan-300/22 bg-cyan-300/10 text-cyan-200">
                                        <Icon className="size-5" />
                                    </div>
                                    <div>
                                        <h3 className="text-xl font-semibold tracking-tight">
                                            {group.title}
                                        </h3>
                                        <p className="mt-2 text-sm leading-6 text-white/56">
                                            {group.description}
                                        </p>
                                    </div>
                                </div>

                                <div className="mt-5 grid grid-cols-1 gap-2 sm:grid-cols-2">
                                    {group.items.map(([name, href]) => (
                                        <Link
                                            key={href}
                                            href={href}
                                            className="flex items-center justify-between rounded-2xl border border-white/8 bg-black/18 px-4 py-3 text-sm font-semibold text-white/82 transition duration-200 hover:border-cyan-300/30 hover:bg-cyan-300/10 hover:text-white"
                                        >
                                            {name}
                                            <ArrowRight className="size-4 text-white/40" />
                                        </Link>
                                    ))}
                                </div>
                            </article>
                        );
                    })}
                </div>
            </section>

            <section className="mx-auto grid w-full max-w-7xl grid-cols-1 gap-4 px-4 py-12 sm:px-6 lg:grid-cols-[0.92fr_1.08fr] lg:px-8">
                <div className="rounded-3xl border border-white/10 bg-white/[0.055] p-6">
                    <div className="flex items-center gap-3">
                        <div className="flex size-11 items-center justify-center rounded-2xl border border-emerald-300/20 bg-emerald-300/10 text-emerald-200">
                            <Code2 className="size-5" />
                        </div>
                        <div>
                            <h2 className="text-2xl font-semibold tracking-tight">
                                Loadstring
                            </h2>
                            <p className="text-sm text-white/55">
                                Current repo URL, ready for release builds.
                            </p>
                        </div>
                    </div>
                    <div className="mt-5">
                        <DynamicCodeBlock lang="luau" code={loadstring} />
                    </div>
                </div>

                <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
                    <Link
                        href="/docs/windui/custom-theme"
                        className="rounded-3xl border border-white/10 bg-white/[0.055] p-6 transition duration-200 hover:border-cyan-300/28 hover:bg-cyan-300/8"
                    >
                        <Palette className="size-6 text-cyan-200" />
                        <h3 className="mt-5 text-xl font-semibold tracking-tight">
                            Custom themes
                        </h3>
                        <p className="mt-2 text-sm leading-6 text-white/56">
                            Build, export and upload theme JSON with GitHub as
                            a simple database.
                        </p>
                    </Link>
                    <Link
                        href="/docs/windui/keysystem"
                        className="rounded-3xl border border-white/10 bg-white/[0.055] p-6 transition duration-200 hover:border-emerald-300/28 hover:bg-emerald-300/8"
                    >
                        <Gem className="size-6 text-emerald-200" />
                        <h3 className="mt-5 text-xl font-semibold tracking-tight">
                            Key system
                        </h3>
                        <p className="mt-2 text-sm leading-6 text-white/56">
                            Access gates, custom notes and mobile friendly
                            setup examples.
                        </p>
                    </Link>
                    <Link
                        href="/docs/windui/tabbox"
                        className="rounded-3xl border border-white/10 bg-white/[0.055] p-6 transition duration-200 hover:border-amber-300/28 hover:bg-amber-300/8"
                    >
                        <PanelsTopLeft className="size-6 text-amber-200" />
                        <h3 className="mt-5 text-xl font-semibold tracking-tight">
                            TabBox
                        </h3>
                        <p className="mt-2 text-sm leading-6 text-white/56">
                            Multi page sections with cleaner spacing and page
                            switch animation.
                        </p>
                    </Link>
                    <Link
                        href="/docs/windui/keybind"
                        className="rounded-3xl border border-white/10 bg-white/[0.055] p-6 transition duration-200 hover:border-blue-300/28 hover:bg-blue-300/8"
                    >
                        <MonitorSmartphone className="size-6 text-blue-200" />
                        <h3 className="mt-5 text-xl font-semibold tracking-tight">
                            Keybind menu
                        </h3>
                        <p className="mt-2 text-sm leading-6 text-white/56">
                            Mobile-first binding UI with compact interaction
                            patterns.
                        </p>
                    </Link>
                </div>
            </section>

            <footer className="border-t border-white/10 px-4 py-8 text-sm text-white/52 sm:px-6 lg:px-8">
                <div className="mx-auto flex w-full max-w-7xl flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
                    <p>
                        (c) {new Date().getFullYear()} article-hub-studio.
                        WindUI Modded docs.
                    </p>
                    <p>
                        Original WindUI credit retained. Fork repo:
                        article-hub-studio/WindUI-Skibidi.
                    </p>
                </div>
            </footer>
        </main>
    );
}
