import type { AppLoadContext, EntryContext } from '@remix-run/cloudflare';
import { RemixServer } from '@remix-run/react';
import { isbot } from 'isbot';
import { renderToReadableStream } from 'react-dom/server.browser';
import { renderHeadToString } from 'remix-island';
import { Head } from './root';
import { themeStore } from '~/lib/stores/theme';

export default async function handleRequest(
  request: Request,
  responseStatusCode: number,
  responseHeaders: Headers,
  remixContext: EntryContext,
  _loadContext: AppLoadContext,
) {
  // await initializeModelList({});

  const body = await renderToReadableStream(<RemixServer context={remixContext} url={request.url} />, {
    signal: request.signal,
    onError(error: unknown) {
      console.error(error);
      responseStatusCode = 500;
    },
  });

  if (isbot(request.headers.get('user-agent') || '')) {
    await body.allReady;
  }

  responseHeaders.set('Content-Type', 'text/html');

  const transformStream = new TransformStream({
    transform(chunk, controller) {
      controller.enqueue(chunk);
    },
  });

  const readable = body.pipeThrough(transformStream);

  const head = renderHeadToString({ request, remixContext, Head });
  const htmlStart = `<!DOCTYPE html><html lang="en" data-theme="${themeStore.value}"><head>${head}</head><body><div id="root" class="w-full h-full">`;
  const htmlEnd = `</div></body></html>`;

  const stream = new ReadableStream({
    start(controller) {
      controller.enqueue(new TextEncoder().encode(htmlStart));

      const reader = readable.getReader();

      function read() {
        reader.read().then(({ done, value }) => {
          if (done) {
            controller.enqueue(new TextEncoder().encode(htmlEnd));
            controller.close();
            return;
          }
          controller.enqueue(value);
          read();
        }).catch(error => {
          controller.error(error);
        });
      }

      read();
    }
  });

  return new Response(stream, {
    headers: responseHeaders,
    status: responseStatusCode,
  });
}
