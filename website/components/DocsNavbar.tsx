"use client";
import React, { useState, useEffect, useRef, useMemo } from "react";
import Logo from "@/components/Logo";
import Link from "next/link";
import { usePathname, useRouter } from "next/navigation";
import {
    Popover,
    PopoverContent,
    PopoverTrigger,
} from "@/components/ui/popover";
import { Check, ChevronsUpDown } from "lucide-react";
import { Button } from "./ui/button";
import { source } from "@/lib/source";

export default function DocsNavbar() {
    const [isOpen, setIsOpen] = useState(false);
    const [isDark, setIsDark] = useState(false);
    const [openPopover, setOpenPopover] = useState(false);
    const timeoutsRef = useRef<NodeJS.Timeout[]>([]);
    const pathname = usePathname();
    const router = useRouter();
    const tree = source.pageTree;

    const basePath = process.env.NEXT_PUBLIC_BASE_PATH || "";

    const NavTitle = pathname.startsWith("/blog")
        ? "Blog"
        : pathname.startsWith("/docs")
          ? "Documentation"
          : "Documentation";

    const projects = useMemo(() => {
        const result: Array<{
            key: string;
            title: string;
            url: string;
            node: any;
        }> = [];

        for (const node of tree.children || []) {
            if (node.type === "folder") {
                const firstPage = node.children?.find(
                    (c: any) => c.type === "page",
                );
                const url =
                    (firstPage && firstPage.type === "page" && firstPage.url) ||
                    `${basePath}/docs/${typeof node.name === "string" ? node.name.toLowerCase() : ""}`;

                result.push({
                    key: url,
                    title: String(node.name || ""),
                    url: url,
                    node: node,
                });
            }
        }

        return result;
    }, [tree]);

    const current =
        projects.find(
            (p) => pathname === p.url || pathname.startsWith(p.url + "/"),
        ) ?? projects[0];

    const toggleMenu = () => {
        setIsOpen(!isOpen);
    };

    const handleProjectSelect = (projectUrl: string) => {
        router.push(projectUrl);
        setOpenPopover(false);
        setIsOpen(false);
    };

    useEffect(() => {
        return () => {
            timeoutsRef.current.forEach((t) => clearTimeout(t));
        };
    }, []);

    useEffect(() => {
        const getSaved = () => localStorage.getItem("theme");
        const prefersDark = () =>
            window.matchMedia &&
            window.matchMedia("(prefers-color-scheme: dark)").matches;

        const shouldBeDark =
            getSaved() === "dark" || (getSaved() === null && prefersDark());
        document.documentElement.classList.toggle("dark", shouldBeDark);
        setIsDark(shouldBeDark);

        const mq = window.matchMedia("(prefers-color-scheme: dark)");
        const mqHandler = (e: MediaQueryListEvent) => {
            if (getSaved() !== null) return;
            document.documentElement.classList.toggle("dark", e.matches);
            setIsDark(e.matches);
        };

        mq.addEventListener("change", mqHandler);

        return () => {
            timeoutsRef.current.forEach((t) => clearTimeout(t));
            mq.removeEventListener("change", mqHandler);
        };
    }, []);

    const toggleTheme = () => {
        const newTheme = isDark ? "light" : "dark";
        document.documentElement.classList.toggle("dark", newTheme === "dark");
        localStorage.setItem("theme", newTheme);
        setIsDark(newTheme === "dark");
    };

    const renderMobileItems = () => {
        if (!current?.node || !current.node.children) return null;

        let itemIndex = 0;
        return current.node.children.map((child: any, idx: number) => {
            if (child.type === "separator") {
                return (
                    <div
                        key={`separator-${idx}`}
                        className={`text-lg text-black/40 dark:text-white/40 mt-4 mb-2 first:mt-0 opacity-0 font-medium ${
                            isOpen ? "show-item" : ""
                        }`}
                        style={{
                            animationDelay: isOpen
                                ? `${(itemIndex++ + 1) * 40}ms`
                                : "0ms",
                        }}
                    >
                        {child.name}
                    </div>
                );
            }

            if (child.type === "page") {
                return (
                    <Link
                        key={child.url}
                        href={child.url}
                        onClick={() => setIsOpen(false)}
                        className={`dark:text-white text-black hover:text-black/90 dark:hover:text-white/90 text-2xl font-semibold opacity-0 ${
                            isOpen ? "show-item" : ""
                        } ${
                            pathname === child.url
                                ? "text-black dark:text-white font-medium"
                                : "text-black/67 dark:text-white/60 font-normal hover:text-black/80 dark:hover:text-white/80"
                        }`}
                        style={{
                            animationDelay: isOpen
                                ? `${(itemIndex++ + 1) * 40}ms`
                                : "0ms",
                        }}
                    >
                        {child.name}
                    </Link>
                );
            }

            return null;
        });
    };

    return (
        <>
            <nav className="flex items-center justify-between px-4 h-14 dark:bg-popover bg-neutral-100 fixed top-0 w-full z-999">
                <div className="flex flex-row items-center gap-1">
                    <Link
                        href={`/`}
                        className="flex flex-row items-center gap-1 opacity-90 hover:opacity-100"
                    >
                        <Logo className="h-5! text-brand" />
                        <span className="font-semibold text-[22px]">
                            {NavTitle}
                        </span>
                    </Link>
                </div>
                <div className="flex flex-row gap-3.5 items-center">
                    <button onClick={toggleTheme} className="">
                        <svg
                            className="h-5 opacity-35 hover:opacity-100 transition cursor-pointer"
                            viewBox="0 0 24 24"
                            fill="none"
                            xmlns="http://www.w3.org/2000/svg"
                        >
                            <path
                                className={isDark ? "" : "hidden"}
                                d="M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z"
                                stroke="currentColor"
                                strokeWidth="2.3"
                                strokeLinecap="round"
                                strokeLinejoin="round"
                            />
                            <path
                                className={isDark ? "hidden" : ""}
                                d="M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z"
                                stroke="currentColor"
                                strokeWidth="2.3"
                                strokeLinecap="round"
                                strokeLinejoin="round"
                            />
                        </svg>
                    </button>
                    <button onClick={toggleMenu} className="md:hidden">
                        <svg
                            className="h-7 opacity-35 dark:text-white text-black"
                            viewBox="0 0 24 24"
                            fill="none"
                            xmlns="http://www.w3.org/2000/svg"
                        >
                            <rect
                                className="transition-transform origin-center duration-300"
                                x="4.5"
                                y="8"
                                width="15"
                                height="1"
                                rx="0.5"
                                stroke="currentColor"
                                fill="currentColor"
                                style={{
                                    transform: isOpen
                                        ? "translate(-2.5px, 2.5px) rotate(45deg)"
                                        : "translateY(0) rotate(0)",
                                }}
                            />
                            <rect
                                className="transition-transform origin-center duration-300"
                                x="4.5"
                                y="15"
                                width="15"
                                height="1"
                                rx="0.5"
                                stroke="currentColor"
                                fill="currentColor"
                                style={{
                                    transform: isOpen
                                        ? "translate(-2.5px, -2.5px) rotate(-45deg)"
                                        : "translateY(0) rotate(0)",
                                }}
                            />
                        </svg>
                    </button>
                </div>
            </nav>

            <div
                className={`md:hidden fixed top-14 left-0 w-full dark:bg-popover bg-neutral-100 flex flex-col z-40 overflow-hidden transition-all duration-200 ease-out ${
                    isOpen ? "h-[calc(100vh-3.5rem)]" : "h-0"
                }`}
            >
                <div className="flex flex-col h-full">
                    <div
                        className={` px-3 pt-2 pb-2 opacity-0 ${
                            isOpen ? "show-item" : ""
                        }`}
                        style={{ animationDelay: "0ms" }}
                    >
                        <Popover
                            open={openPopover}
                            onOpenChange={setOpenPopover}
                        >
                            <PopoverTrigger className="w-full! hidden">
                                <Button
                                    variant="secondary"
                                    className="justify-between rounded-xl! px-6 py-2 h-auto w-full!"
                                    classNameTB="w-full!"
                                >
                                    <div className="truncate flex flex-col items-start gap-0">
                                        <span>{current?.title}</span>
                                    </div>
                                    <ChevronsUpDown className="opacity-50" />
                                </Button>
                            </PopoverTrigger>

                            <PopoverContent
                                align="start"
                                sideOffset={4}
                                className="w-[var(--radix-popover-trigger-width)] p-1 rounded-2xl dark:bg-secondary/90 backdrop-blur-xl border dark:border-0 border-black/10 shadow-none"
                            >
                                <div className="flex flex-col gap-1">
                                    {projects.map((project) => (
                                        <button
                                            key={project.key}
                                            className={`w-full text-left px-2.5 py-2.5 hover:bg-black/5 dark:hover:bg-white/5 transition-colors text-[16px] rounded-[12px] flex flex-row items-center justify-between ${
                                                current?.url === project.url
                                                    ? "dark:bg-white/5 bg-black/5"
                                                    : ""
                                            }`}
                                            onClick={() =>
                                                handleProjectSelect(project.url)
                                            }
                                        >
                                            <div className="truncate flex flex-col items-start gap-0 font-medium">
                                                <span>{project.title}</span>
                                            </div>
                                            <Check
                                                className={`h-4 w-4 ${current?.url === project.url ? "opacity-100" : "opacity-0"}`}
                                            />
                                        </button>
                                    ))}
                                </div>
                            </PopoverContent>
                        </Popover>
                    </div>

                    <div className="flex-1 overflow-y-auto px-12 flex flex-col justify-start gap-2 py-4">
                        {renderMobileItems()}
                    </div>
                </div>
            </div>
        </>
    );
}
