import { json } from '@remix-run/cloudflare';
import type { LoaderFunctionArgs, ActionFunctionArgs } from '@remix-run/cloudflare';

interface DiskInfo {
  filesystem: string;
  size: number;
  used: number;
  available: number;
  percentage: number;
  mountpoint: string;
  timestamp: string;
  error?: string;
}

const getDiskInfo = (): DiskInfo[] => {
  // Cloudflare Workers don't have access to disk info
  return [
    {
      filesystem: 'Cloudflare Worker',
      size: 0,
      used: 0,
      available: 0,
      percentage: 0,
      mountpoint: '/',
      timestamp: new Date().toISOString(),
      error: 'Disk information is not available in Cloudflare Workers environment',
    },
  ];
};

export const loader = async ({ request: _request }: LoaderFunctionArgs) => {
  return json(getDiskInfo());
};

export const action = async ({ request: _request }: ActionFunctionArgs) => {
  return json(getDiskInfo());
};
