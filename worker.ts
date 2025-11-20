import { createRequestHandler } from "@remix-run/cloudflare";
// @ts-ignore - build is generated
import * as build from "./build/server/index.js";

const handleRequest = createRequestHandler(build as any);

export default {
    async fetch(request: Request, env: any, ctx: any): Promise<Response> {
        try {
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
            return new Response("Internal Server Error", { status: 500 });
        }
    },
};
