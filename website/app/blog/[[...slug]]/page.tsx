import { blog } from "@/lib/source";
import {
    DocsPage,
    DocsBody,
    DocsDescription,
    DocsTitle,
} from "fumadocs-ui/page";
import { notFound, redirect } from "next/navigation";
import { createRelativeLink } from "fumadocs-ui/mdx";
import { getMDXComponents } from "@/mdx-components";

function asset(path?: string) {
    if (!path) return "";
    if (/^https?:\/\//.test(path)) return path;
    const encoded = path
        .split("/")
        .map((part, index) => (index === 0 ? part : encodeURIComponent(part)))
        .join("/");
    return `${process.env.NEXT_PUBLIC_BASE_PATH || ""}${encoded}`;
}

export default async function Page(props: {
    params: Promise<{ slug?: string[] }>;
}) {
    const params = await props.params;

    const page = blog.getPage(params.slug);

    if (!page) notFound();

    const MDXContent = page.data.body;

    return (
        <div className="flex flex-col gap-2 p-0">
            <div className="border-b border-black/10 dark:border-white/5 p-6 md:p-8 xl:px-14 xl:mx-auto max-w-280 flex flex-col gap-2 hidden">
                <h1 className="text-lg font-semibold">{page.data.title}</h1>
                <p className="text-md font-normal opacity-70">
                    {page.data.description}
                </p>
            </div>
            <img
                src={asset(page.data.thumbnail)}
                alt=""
                className="m-6 md:m-8 xl:mx-auto max-w-280 rounded-lg"
            />
            <div className="p-2">
                <DocsPage>
                    <DocsBody className="p-0 m-0 top-0">
                        <MDXContent
                            components={getMDXComponents({
                                a: createRelativeLink(blog, page),
                            })}
                        />
                    </DocsBody>
                </DocsPage>
            </div>
        </div>
    );
}

export async function generateStaticParams() {
    return blog.generateParams();
}
export async function generateMetadata(props: {
    params: Promise<{ slug?: string[] }>;
}) {
    const params = await props.params;
    if (!params.slug) return {};

    const page = blog.getPage(params.slug);
    if (!page) return {};

    return {
        title: page.data.title,
        description: page.data.description,
    };
}
