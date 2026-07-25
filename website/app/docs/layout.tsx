"use client";

import { ReactNode } from "react";
import { DocsLayout } from "fumadocs-ui/layouts/docs";
import { baseOptions } from "@/app/layout.config";
import DocsNavbarWrapper from "@/components/DocsNavbarWrapper";
import DocsSidebar from "@/components/DocsSidebar";
import { source } from "@/lib/source";

interface LayoutProps {
    children: ReactNode;
}

export default function Layout({ children }: LayoutProps) {
    return (
        <DocsLayout
            {...baseOptions}
            tree={source.pageTree}
            nav={{
                component: <DocsNavbarWrapper />,
            }}
        >
            <div className="flex flex-col flex-1">
                <DocsSidebar />
                <main className="flex-1 flex p-2 pt-0 mt-14 md:ml-60 dark:bg-neutral-900 bg-neutral-100">
                    <div className="rounded-lg w-full bg-background border border-black/10 dark:border-0 overflow-hidden">
                        {children}
                    </div>
                </main>
            </div>
        </DocsLayout>
    );
}
