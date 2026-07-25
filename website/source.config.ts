import { defineDocs, defineConfig } from "fumadocs-mdx/config";
import { defineCollections } from "fumadocs-mdx/config";
import { z } from "zod";

export const docs = defineDocs({
    dir: "content/docs",
});

export default defineConfig({
    mdxOptions: {
        // MDX options
    },
});

export const blog = defineCollections({
    type: "doc",
    dir: "./content/blog",
    schema: z.object({
        title: z.string(),
        description: z.string(),
        date: z.string().optional(),
        author: z.string().optional(),
        thumbnail: z.string().optional(),
    }),
});
