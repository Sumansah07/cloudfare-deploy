import { createRequestHandler } from "@remix-run/cloudflare";
// @ts-ignore
import * as build from "./build/server";
// @ts-ignore
import manifestJSON from "__STATIC_CONTENT_MANIFEST";

const assetManifest = JSON.parse(manifestJSON);

const handleRequest = createRequestHandler(build as any);

export default {
    async fetch(request: Request, env: any, ctx: any): Promise<Response> {
        try {
            // Serve static assets from /assets
            const url = new URL(request.url);
            if (url.pathname.startsWith("/assets/")) {
                // @ts-ignore
                return await env.ASSETS.fetch(request);
            }

            // Handle Remix requests
            return await handleRequest(request, {
                cloudflare: {
                    env,
                    cf: request.cf as any,
                    ctx: ctx as any,
                    caches: caches as any,
                },
            } as any);
        } catch (error) {
            console.error("Worker error:", error);
            return new Response("Internal Server Error: " + error, { status: 500 });
        }
    },
};
