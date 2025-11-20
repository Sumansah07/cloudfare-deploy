import type { AppLoadContext } from "@remix-run/cloudflare";
import { createRequestHandler } from "@remix-run/cloudflare";
import * as build from "../build/server";

export const onRequest: PagesFunction<Env> = async (context) => {
    const handleRequest = createRequestHandler(build as any);

    const loadContext: AppLoadContext = {
        cloudflare: {
            env: context.env,
            cf: context.request.cf as any,
            ctx: {
                waitUntil: context.waitUntil.bind(context),
                passThroughOnException: context.passThroughOnException.bind(context),
            } as any,
            caches: caches as any,
        },
    };

    return handleRequest(context.request, loadContext);
};
