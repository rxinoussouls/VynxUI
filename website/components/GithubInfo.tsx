"use client";

import React, { useState, useEffect } from "react";

import { StarBold, StarOutline } from "@/app/SolarIcons";
import { GitFork, SquareArrowOutUpRight, Star } from "lucide-react";
import { LuaIcon } from "@/public/lua";
import TopbarButton from "./TopbarButton";

interface GithubRepo {
    name: string;
    description: string;
    url: string;
    stars: number;
    forks: number;
    language: string;
}

export default function GithubInfo({
    owner,
    repo,
}: {
    owner: string;
    repo: string;
}) {
    const [repoData, setRepoData] = useState<GithubRepo | null>(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState<string | null>(null);

    useEffect(() => {
        const fetchRepoData = async () => {
            try {
                const response = await fetch(
                    `https://api.github.com/repos/${owner}/${repo}`,
                );
                if (!response.ok) throw new Error("Failed to fetch repository");

                const data = await response.json();
                setRepoData({
                    name: data.name,
                    description: data.description,
                    url: data.html_url,
                    stars: data.stargazers_count,
                    forks: data.forks_count,
                    language: data.language,
                });
            } catch (err) {
                setError(
                    err instanceof Error ? err.message : "An error occurred",
                );
            } finally {
                setLoading(false);
            }
        };

        fetchRepoData();
    }, [owner, repo]);

    if (loading) return <div>Loading...</div>;
    if (error) return <div>Error: {error}</div>;
    if (!repoData) return <div>No repository data</div>;

    return (
        <TopbarButton
            className="p-2 dark:bg-white/8 bg-white border border-black/10 dark:border-0 rounded-3xl flex! flex-col justify-start items-start w-full!"
            onClick={() => window.open(repoData.url, "_blank")}
            isScrolled={true}
            scaleOnHold={1.04}
            stretchOnDrag={false}
        >
            <span className="text-xs font-normal opacity-50 p-2 flex flex-row justify-between items-center w-full">
                {repoData.url}
                <SquareArrowOutUpRight className="h-3" />
            </span>
            <h2 className="text-3xl font-bold px-2 -my-2!">{repoData.name}</h2>
            {repoData.description && (
                <p className="my-0! px-2 opacity-80 font-normal text-sm">
                    {repoData.description}
                </p>
            )}
            <div className="flex gap-2 text-sm p-1">
                <span className="flex flex-row items-center text-sm font-medium w-auto gap-1 dark:bg-white/10 bg-white border border-black/10 dark:border-0 rounded-full px-2 py-1">
                    <Star className="h-4" /> {repoData.stars} stars
                </span>
                <span className="flex flex-row items-center text-sm font-medium w-auto gap-1 dark:bg-white/10 bg-white border border-black/10 dark:border-0 rounded-full px-2 py-1">
                    <GitFork className="h-4" /> {repoData.forks} forks
                </span>
                {repoData.language && (
                    <span className="flex flex-row items-center text-sm font-medium w-auto gap-1 dark:bg-white/10 bg-white border border-black/10 dark:border-0 rounded-full px-2 py-1">
                        {repoData.language === "Lua" && (
                            <LuaIcon className="h-8" />
                        )}{" "}
                        {repoData.language}
                    </span>
                )}
            </div>
        </TopbarButton>
    );
}
