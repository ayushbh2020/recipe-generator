'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import Link from 'next/link';
import { createClient } from '@/lib/supabase/client';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { toast } from 'sonner';

export default function SignupPage() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [displayName, setDisplayName] = useState('');
  const [loading, setLoading] = useState(false);
  const router = useRouter();
  const supabase = createClient();

  const handleSignup = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);

    try {
      const { data, error } = await supabase.auth.signUp({
        email,
        password,
        options: {
          data: {
            display_name: displayName,
          },
        },
      });

      if (error) {
        toast.error(error.message);
      } else {
        toast.success('Account created! Please check your email to verify.');
        router.push('/login');
      }
    } catch (error) {
      toast.error('An unexpected error occurred');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="bg-white dark:bg-gray-800 p-8 rounded-lg shadow-lg">
      <div className="mb-8 text-center">
        <h1 className="text-3xl font-bold mb-2">Meal Planner</h1>
        <p className="text-gray-600 dark:text-gray-400">Create your account</p>
      </div>

      <form onSubmit={handleSignup} className="space-y-6">
        <div>
          <label
            htmlFor="displayName"
            className="block text-sm font-medium mb-2"
          >
            Display Name
          </label>
          <Input
            id="displayName"
            type="text"
            placeholder="John Doe"
            value={displayName}
            onChange={(e) => setDisplayName(e.target.value)}
            required
            disabled={loading}
          />
        </div>

        <div>
          <label htmlFor="email" className="block text-sm font-medium mb-2">
            Email
          </label>
          <Input
            id="email"
            type="email"
            placeholder="you@example.com"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            required
            disabled={loading}
          />
        </div>

        <div>
          <label htmlFor="password" className="block text-sm font-medium mb-2">
            Password
          </label>
          <Input
            id="password"
            type="password"
            placeholder="••••••••"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            required
            minLength={6}
            disabled={loading}
          />
          <p className="mt-1 text-xs text-gray-500">
            Must be at least 6 characters
          </p>
        </div>

        <Button type="submit" className="w-full" disabled={loading}>
          {loading ? 'Creating account...' : 'Sign up'}
        </Button>
      </form>

      <div className="mt-6 text-center text-sm">
        <span className="text-gray-600 dark:text-gray-400">
          Already have an account?{' '}
        </span>
        <Link
          href="/login"
          className="text-blue-600 hover:text-blue-500 font-medium"
        >
          Sign in
        </Link>
      </div>
    </div>
  );
}
