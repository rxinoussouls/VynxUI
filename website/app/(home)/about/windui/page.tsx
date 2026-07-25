"use client";

import { Button } from "@/components/ui/button";
import { DynamicCodeBlock } from "fumadocs-ui/components/dynamic-codeblock";
import example from "@/lib/windui/example";

export default function WindUIPage() {
    return (
        <div className="w-full p-4 lg:p-36 md:p-26 xl:px-64 flex-col gap-24 flex">
            <section className="flex md:flex-row flex-col items-center h-auto justify-center max-md:gap-6">
                <div className="w-full md:flex-1">
                    <img
                        src={`${process.env.NEXT_PUBLIC_BASE_PATH || ""}/windui/main-banner-2.jpg`}
                        alt="Preview"
                        className="w-full rounded-2xl"
                    />
                </div>
                <div className="md:w-fit! w-full flex-col items-start space-y-5 md:p-14 p-3">
                    <div className="flex flex-col gap-1">
                        <h1 className="md:text-4xl! tracking-tight">
                            WindUI Modded Library
                        </h1>
                        <p className="opacity-70 md:text-xl! tracking-tight">
                            Luau
                        </p>
                        <p className="opacity-50 tracking-tight">
                            liquid glass fork with mobile support <br />
                            credited to the original WindUI project
                        </p>
                    </div>
                    <div className="flex flex-row items-start justify-start w-fit! gap-2">
                        <Button
                            className="bg-brand-2! rounded-full hover:brightness-120! text-white"
                            variant="default"
                            onClick={() => {
                                window.location.href = `${process.env.NEXT_PUBLIC_BASE_PATH || ""}/docs`;
                            }}
                        >
                            Documentation
                        </Button>
                        <Button
                            className="rounded-full hover:brightness-120!"
                            variant="secondary"
                            onClick={() => {
                                window.location.href =
                                    "https://github.com/article-hub-studio/WindUI-Skibidi";
                            }}
                        >
                            Github
                        </Button>
                    </div>
                </div>
            </section>
            <section className="space-y-6">
                <h1>Example</h1>
                <DynamicCodeBlock lang="luau" code={example} />
            </section>
        </div>
    );
}
