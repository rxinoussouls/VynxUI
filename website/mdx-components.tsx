import defaultComponents from "fumadocs-ui/mdx";
import { Tabs, Tab } from "fumadocs-ui/components/tabs";
import type { MDXComponents } from "mdx/types";
import { CodeBlock, Pre } from "fumadocs-ui/components/codeblock";

type StaticImageLike = {
    src?: string;
    width?: number;
    height?: number;
    blurDataURL?: string;
};

function cleanLocalPath(src: string) {
    if (/^https?:\/\//.test(src)) return src;
    return src.replace(/\/{2,}/g, "/");
}

function asset(src: string) {
    if (/^https?:\/\//.test(src)) return src;
    const encoded = src
        .split("/")
        .map((part, index) => (index === 0 ? part : encodeURIComponent(part)))
        .join("/");
    return cleanLocalPath(`${process.env.NEXT_PUBLIC_BASE_PATH || ""}${encoded}`);
}

function imageSource(src: unknown) {
    if (typeof src === "string") {
        return src.startsWith("/") ? asset(src) : src;
    }

    if (src && typeof src === "object" && "src" in src) {
        const value = (src as StaticImageLike).src;
        if (typeof value === "string") {
            return cleanLocalPath(value);
        }
    }

    return undefined;
}

export function getMDXComponents(components?: MDXComponents): MDXComponents {
    return {
        ...defaultComponents,
        pre: ({ ref: _ref, ...props }) => (
            <CodeBlock {...props}>
                <Pre>{props.children}</Pre>
            </CodeBlock>
        ),
        img: ({ src, ...props }) => {
            const source = imageSource(src);

            return <img src={source} loading="lazy" {...props} />;
        },
        Tabs,
        Tab,
        ...components,
    };
}
