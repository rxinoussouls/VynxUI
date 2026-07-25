import { docs, blog as blogCollection } from "@/.source";
import { loader } from "fumadocs-core/source";
import { createMDXSource } from "fumadocs-mdx";

export const source = loader({
    baseUrl: "/docs",
    source: docs.toFumadocsSource(),
});

export const blog = loader({
    baseUrl: "/blog",
    source: createMDXSource(blogCollection),
});
