import './globals.css';
import { GeistSans } from 'geist/font/sans';
import { Toaster } from 'sonner';
import { cn } from '@/lib/utils';
import { AuthProvider } from '@/lib/contexts/auth-context';

export const metadata = {
  title: 'Meal Planner - AI-Powered Meal Prep',
  description:
    'Plan your weekly meals with AI-generated recipes optimized for batch cooking and meal prep.',
  openGraph: {
    images: [
      {
        url: '/og?title=Meal Planner',
      },
    ],
  },
  twitter: {
    card: 'summary_large_image',
    images: [
      {
        url: '/og?title=Meal Planner',
      },
    ],
  },
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <head></head>
      <body className={cn(GeistSans.className, 'antialiased dark')}>
        <Toaster position="top-center" richColors />
        <AuthProvider>{children}</AuthProvider>
      </body>
    </html>
  );
}
