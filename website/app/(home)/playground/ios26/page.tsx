"use client";
import TopbarButton from "@/components/TopbarButton";

import { ChevronLeft, House, Bird } from "lucide-react";

import { Squircle } from "@squircle-js/react";
import { useEffect, useRef } from "react";

import { LiquidGlass } from "@ybouane/liquidglass";

export default function iOS26Page() {
    const rootRef = useRef<HTMLDivElement>(null);

    useEffect(() => {
        if (!rootRef.current) return;

        let instance: Awaited<ReturnType<typeof LiquidGlass.init>>;

        (async () => {
            rootRef.current!.querySelectorAll(".lglass").forEach((el) => {
                (el as HTMLElement).dataset.config = JSON.stringify({
                    blurAmount: 0,
                    refraction: 0.7,
                    edgeHighlight: 0,
                    fresnel: 0,
                    shadowOpacity: 0,
                    brightness: 0.2,
                });
            });

            instance = await LiquidGlass.init({
                root: rootRef.current!,

                glassElements: rootRef.current!.querySelectorAll(".lglass"),
            });
        })();

        const update = () => instance?.markChanged();

        window.addEventListener("scroll", update);
        window.addEventListener("touchmove", update);
        window.addEventListener("touchstart", update);
        window.addEventListener("pointermove", update);
        window.addEventListener("pointerdown", update);

        return () => {
            window.removeEventListener("scroll", update);
            window.removeEventListener("touchmove", update);
            window.removeEventListener("touchstart", update);
            window.removeEventListener("pointermove", update);
            window.removeEventListener("pointerdown", update);
            instance?.destroy();
        };
    }, []);
    return (
        <div
            ref={rootRef}
            className="w-full flex flex-row items-center md:px-[30%] relative bg-background"
        >
            <div className="w-full bg-background" data-dynamic>
                <header className="fixed flex flex-row items-center justify-between gap-2 z-9999999 w-full! bg-linear-to-t from-black/0 via-black/15 to-black/40 left-0 top-0 md:px-[30%] h-16">
                    {/* left */}
                    <div className="flex flex-row gap-2 p-3 z-99999999"></div>
                    {/* center */}
                    <div className="absolute w-full h-full top-0 left-0 flex flex-row items-center justify-center font-medium">
                        flergitjk
                    </div>
                    {/* right */}
                    <div className="flex flex-row gap-2 p-3  z-99999999"></div>
                </header>
                <div className="span h-16"></div>
                <section
                    data-dynamic
                    className="w-full p-4 flex flex-col gap-3"
                >
                    <Squircle
                        cornerRadius={24}
                        cornerSmoothing={0.6}
                        className="bg-red-500  h-64"
                    ></Squircle>
                    <Squircle
                        cornerRadius={24}
                        cornerSmoothing={0.6}
                        className="bg-yellow-500  h-64"
                    ></Squircle>
                    <Squircle
                        cornerRadius={24}
                        cornerSmoothing={0.6}
                        className="bg-green-500  h-64"
                    ></Squircle>
                    <Squircle
                        cornerRadius={24}
                        cornerSmoothing={0.6}
                        className="bg-blue-500  h-64"
                    ></Squircle>
                    <Squircle
                        cornerRadius={24}
                        cornerSmoothing={0.6}
                        className="bg-indigo-500  h-64"
                    ></Squircle>
                    <Squircle
                        cornerRadius={24}
                        cornerSmoothing={0.6}
                        className="bg-transparent  h-64"
                    ></Squircle>
                </section>
                <nav></nav>
            </div>
            <TopbarButton
                isScrolled={true}
                className="lglass fixed top-3 left-3 md:ml-[30%] w-12! h-12!  flex flex-row items-center justify-center brightness-100! rounded-full before:rounded-full before:border before:border-white/15 before:absolute before:top-0 before:left-0 before:w-full before:h-full before:[mask-image:linear-gradient(to_left_top,rgba(0,0,0,1)_0%,rgba(0,0,0,0)_40%,rgba(0,0,0,0)_50%,rgba(0,0,0,0)_60%,rgba(0,0,0,1)_100%)] before:inset after:absolute after:left-0 after:top-0 after:w-full after:h-full after:rounded-full after:transition-colors after:duration-200 after:bg-white/12 [@media(hover:hover)]:hover:after:bg-white/22 active:after:bg-white/22 z-9999999999"
            >
                <ChevronLeft className="size-8" />
            </TopbarButton>

            <TopbarButton
                isScrolled={true}
                scaleOnHold={1.03}
                stretchOnDrag={false}
                className="lglass fixed bottom-3 -translate-x-1/2! left-1/2! w-[calc(100%-24px)]! md:w-[40%]! p-1 flex flex-row items-center justify-center brightness-100! gap-1! rounded-full before:rounded-full before:border before:border-white/15 before:absolute before:top-0 before:left-0 before:w-full before:h-full before:[mask-image:linear-gradient(to_left_top,rgba(0,0,0,1)_0%,rgba(0,0,0,0)_40%,rgba(0,0,0,0)_50%,rgba(0,0,0,0)_60%,rgba(0,0,0,1)_100%)] before:inset after:absolute after:left-0 after:top-0 after:w-full after:h-full after:rounded-full after:transition-colors after:duration-200 after:bg-white/12 [@media(hover:hover)]:hover:after:bg-white/22 active:after:bg-white/22 z-9999999999"
            >
                <div className="flex flex-col items-center justify-center p-2 bg-white/12 rounded-full text-xs font-semibold gap-1">
                    <House className="size-6" />
                    efefwe
                </div>
                <div className="flex flex-col items-center justify-center p-2 bg-white/0 opacity-70 rounded-full text-xs font-semibold gap-1">
                    <Bird className="size-6" />
                    PISUUUnb
                </div>
                <div className="flex flex-col items-center justify-center p-2 bg-white/0 opacity-70 rounded-full text-xs font-semibold gap-1">
                    <House className="size-6" />
                    efefwe
                </div>
                <div className="flex flex-col items-center justify-center p-2 bg-white/0 opacity-70 rounded-full text-xs font-semibold gap-1">
                    <House className="size-6" />
                    efefwe
                </div>
            </TopbarButton>
        </div>
    );
}
