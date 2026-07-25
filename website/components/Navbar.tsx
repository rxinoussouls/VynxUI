"use client";
import React, { useState, useEffect, useRef } from "react";
import Logo from "@/components/Logo";
import { Button } from "@/components/ui/button";
import Link from "next/link";

import { ChevronRight, ExternalLink } from "lucide-react";
import BrandName from "@/app/data/BrandName";
import Spring from "@/app/data/Spring";
import TopbarButton from "./TopbarButton";
import { useRouter, usePathname } from "next/navigation";

interface NavbarProps {
    links: any[];
}

export default function Navbar({ links }: NavbarProps) {
    const pathname = usePathname();

    if (
        pathname === "/about" ||
        pathname === "/playground" ||
        pathname.startsWith("/about/") ||
        pathname.startsWith("/playground/")
    ) {
        return null;
    }

    const [isLoaded, setIsLoaded] = useState(false);
    const [isDark, setIsDark] = useState(false);
    const [isScrolled, setIsScrolled] = useState(false);
    const timeoutsRef = useRef<NodeJS.Timeout[]>([]);

    const router = useRouter();

    const [IsHoldingThemeBtn, SetIsHoldingThemeBtn] = useState(false);
    const Ref = useRef<HTMLDivElement>(null);

    const OnDown = (E: React.PointerEvent) => {
        SetIsHoldingThemeBtn(true);
        E.currentTarget.setAttribute("data-holding", "true");
        E.currentTarget.setPointerCapture(E.pointerId);
    };

    const OnUp = (E: React.PointerEvent) => {
        SetIsHoldingThemeBtn(false);
        E.currentTarget.releasePointerCapture(E.pointerId);
    };

    useEffect(() => {
        setTimeout(() => setIsLoaded(true), 20);
    }, []);

    const filteredLinks = links.filter(
        (link) => link.url !== "/getting-started",
    );

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

        const handleScroll = () => {
            setIsScrolled(window.scrollY > 10);
        };

        mq.addEventListener("change", mqHandler);
        window.addEventListener("scroll", handleScroll);

        return () => {
            timeoutsRef.current.forEach((t) => clearTimeout(t));
            mq.removeEventListener("change", mqHandler);
            window.removeEventListener("scroll", handleScroll);
        };
    }, []);

    const toggleTheme = () => {
        const newTheme = isDark ? "light" : "dark";
        document.documentElement.classList.toggle("dark", newTheme === "dark");
        localStorage.setItem("theme", newTheme);
        setIsDark(newTheme === "dark");
    };

    return (
        <nav
            className={`flex fixed top-0 w-full z-999999999999 transition-colors duration-300 items-center h-19.5 bg-gradient-to-b dark:from-black/85 from-black/15 to-black/0 `}
        >
            <div className="absolute w-full h-full top-0 left-0 pointer-events-none mask-b-from-0 backdrop-blur-2xl"></div>
            <div
                className="w-full h-14 px-4 lg:px-24 flex flex-row items-center justify-between"
                style={{
                    transform: isScrolled
                        ? "translateY(0)"
                        : "translateY(-100%)",
                    transition: `transform 1.2s ${Spring}`,
                }}
            >
                <TopbarButton
                    onClick={() => router.push("/")}
                    isScrolled={isScrolled}
                    className="aspect-auto! h-11.5 dark:bg-secondary bg-white rounded-full w-fit!"
                    scaleOnHold={1.15}
                >
                    <Link
                        href="/"
                        className="flex flex-row items-center gap-1 px-2.5 text-foreground pr-4"
                    >
                        <Logo className="h-5! text-brand" />
                        <span className="font-semibold text-[22px] tracking-tighter">
                            {BrandName}
                        </span>
                    </Link>
                </TopbarButton>
                <div
                    className={`w-fit! flex items-center gap-1 justify-end dark:bg-secondary bg-white backdrop-blur-lg px-1 h-11.5 py-1 rounded-full max-sm:hidden`}
                    style={{
                        opacity: isScrolled ? 1 : 0,
                        transform: isScrolled
                            ? "translateY(0) scale(1)"
                            : "translateY(-16px) scale(0.7)",
                        transition: `opacity 1.2s ${Spring}, transform 1.2s ${Spring}`,
                        transitionDelay: "100ms",
                    }}
                >
                    {filteredLinks.map((link, idx) => (
                        <Link
                            key={link.url}
                            href={link.url}
                            className={`transition-transform duration-900 h-full ${link.text === "Github" || link.text === "Discord" ? "max-lg:hidden" : ""}`}
                        >
                            <Button
                                className={`rounded-full h-full! px-4! text-[16px] dark:hover:brightness-125`}
                                classNameTB={`h-full!`}
                                variant="ghost"
                                size="sm"
                            >
                                {link.text === "Github" ||
                                link.text === "Discord"
                                    ? // <ExternalLink className="text-brand" />
                                      ""
                                    : ""}
                                {link.text}
                            </Button>
                        </Link>
                    ))}
                    <Link
                        href="/getting-started"
                        className={`transition-transform duration-900 h-full`}
                    >
                        <Button
                            className="rounded-full h-full px-4! text-[16px] bg-brand! hover:brightness-120 text-white"
                            classNameTB={`h-full!`}
                            variant="default"
                            size="sm"
                        >
                            Get Script
                        </Button>
                    </Link>
                </div>
                <TopbarButton
                    onClick={toggleTheme}
                    isScrolled={isScrolled}
                    scaleOnHold={1.25}
                    className="aspect-square h-11.5 text-foreground/35 hover:text-foreground dark:bg-secondary bg-white rounded-full w-fit!"
                >
                    <div
                        className={`transition-transform duration-900 p-2 flex items-center justify-center`}
                    >
                        <svg
                            className="h-5  transition"
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
                    </div>
                </TopbarButton>
            </div>
        </nav>
    );
}
