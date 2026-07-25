"use client";

import { usePathname } from "next/navigation";
import Link from "next/link";
import { useEffect, useMemo, useState } from "react";
import {
    Popover,
    PopoverContent,
    PopoverTrigger,
} from "@/components/ui/popover";
import { Check, ChevronsUpDown } from "lucide-react";
import { Button } from "@/components/ui/button";
import { useRouter } from "next/navigation";
import { source } from "@/lib/source";

export default function DocsSidebar() {
    const pathname = usePathname();
    const router = useRouter();
    const [openPopover, setOpenPopover] = useState(false);

    const tree = source.pageTree;

    const basePath = process.env.NEXT_PUBLIC_BASE_PATH || "";

    const projects = useMemo(() => {
        const result: Array<{
            key: string;
            title: string;
            description?: string;
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

    const handleProjectSelect = (projectUrl: string) => {
        router.push(projectUrl);
        setOpenPopover(false);
    };

    const renderItems = (node: any) => {
        if (!node || !node.children) return null;

        return node.children.map((child: any, idx: number) => {
            if (child.type === "separator") {
                return (
                    <div
                        key={`separator-${idx}`}
                        className="text-xs font-medium text-black/40 dark:text-white/40 tracking-wide mt-4 mb-2 first:mt-0"
                    >
                        {child.name}
                    </div>
                );
            }

            if (child.type === "page") {
                const isActive = pathname === child.url;

                return (
                    <Link
                        key={child.url}
                        href={child.url}
                        className={`transition dark:text-white text-black hover:text-black/90 dark:hover:text-white/90 text-[15px] font-semibold  ${
                            isActive
                                ? "text-black dark:text-white font-medium"
                                : "text-black/50 dark:text-white/60 font-normal hover:text-black/80 dark:hover:text-white/80"
                        }`}
                    >
                        {child.name}
                    </Link>
                );
            }

            return null;
        });
    };

    return (
        <aside className="hidden md:flex md:pt-14 flex-col w-60 bg-neutral-100 dark:bg-neutral-900 p-2 pt-0 pr-0 gap-4 fixed h-dvh">
            {/*<Popover open={openPopover} onOpenChange={setOpenPopover}>
                <PopoverTrigger className="w-full hidden">
                    <Button
                        variant="secondary"
                        className="justify-between w-full rounded-[12px] px-6 py-2.5 h-auto"
                    >
                        <div className="truncate flex flex-col items-start gap-0">
                            <span className="font-medium">
                                {current?.title}
                            </span>
                            {current?.description && (
                                <span className="opacity-70 text-sm font-normal">
                                    {current.description}
                                </span>
                            )}
                        </div>
                        <ChevronsUpDown className="h-4 w-4 opacity-50" />
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
                                onClick={() => handleProjectSelect(project.url)}
                            >
                                <div className="truncate flex flex-col items-start gap-0 font-medium">
                                    <span>{project.title}</span>
                                    {project.description && (
                                        <span className="opacity-70 text-sm font-normal">
                                            {project.description}
                                        </span>
                                    )}
                                </div>
                                <Check
                                    className={`h-4 w-4 ${
                                        current?.url === project.url
                                            ? "opacity-100"
                                            : "opacity-0"
                                    }`}
                                />
                            </button>
                        ))}
                    </div>
                </PopoverContent>
            </Popover>*/}

            {/* pages */}
            <div className="flex flex-col gap-1.5 px-3 overflow-y-auto flex-1 min-h-0 pb-2 font-normal!">
                {renderItems(current?.node)}
            </div>
        </aside>
    );
}
