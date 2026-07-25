import AnimatedList from "@/components/AnimatedList";
import loadstring from "@/lib/loadstring";
import { DynamicCodeBlock } from "fumadocs-ui/components/dynamic-codeblock";
import Link from "next/link";

export default function GettingStartedPage() {
    return (
        <main className="flex min-h-dvh flex-1 flex-col items-center justify-center bg-[#05070b] px-4 text-white sm:px-[10%] lg:px-[20%]">
            <AnimatedList
                className="flex flex-col items-center justify-center gap-4"
                staggerDelay={150}
            >
                <p className="rounded-full border border-white/12 bg-white/8 px-3 py-1 text-sm font-medium text-white/64">
                    WindUI Modded
                </p>
                <h1 className="text-center text-3xl font-semibold tracking-tight">
                    Getting Started With Loadstring
                </h1>

                <p className="max-w-xl text-center text-sm leading-6 text-white/58">
                    Use the current article-hub-studio repo build. The API still
                    exposes the `WindUI` variable in examples, so existing
                    scripts stay familiar.
                </p>

                <div className="w-full flex flex-row items-center justify-center">
                    <div className="w-full max-w-2xl">
                        <DynamicCodeBlock lang="luau" code={loadstring} />
                    </div>
                </div>

                <div className="flex flex-col gap-2 sm:flex-row">
                    <Link
                        href="/docs/windui/elements-overview"
                        className="rounded-full bg-white px-5 py-2 text-sm font-semibold text-black"
                    >
                        Elements overview
                    </Link>
                    <Link
                        href="/docs/windui/loadstring"
                        className="rounded-full border border-white/12 bg-white/8 px-5 py-2 text-sm font-semibold text-white"
                    >
                        Loadstring docs
                    </Link>
                </div>
            </AnimatedList>
        </main>
    );
}
