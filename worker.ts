import { createRequestHandler } from "@remix-run/cloudflare";
import * as build from "./build/server/index.js";

const handleRequest = createRequestHandler(build);

export default {
    fetch(request, env, ctx) {
        return handleRequest(request, {
            cloudflare: {
                env,
                ctx,
                caches,
            },
        });
    },
};
