'use client';

import { Button } from './ui/button';
import Link from 'next/link';
import { useAuth } from '@/lib/contexts/auth-context';
import { ChefHat, LogOut, User, Settings } from 'lucide-react';

export const Navbar = () => {
  const { user, profile, signOut } = useAuth();

  const handleSignOut = async () => {
    await signOut();
  };

  return (
    <nav className="border-b border-gray-200 dark:border-gray-800 bg-white dark:bg-gray-900">
      <div className="container mx-auto px-4">
        <div className="flex items-center justify-between h-16">
          {/* Logo */}
          <Link
            href="/"
            className="flex items-center space-x-2 hover:opacity-80 transition"
          >
            <ChefHat className="w-8 h-8 text-blue-600" />
            <span className="text-xl font-bold">Meal Planner</span>
          </Link>

          {/* Navigation Links */}
          {user && (
            <div className="hidden md:flex items-center space-x-6">
              <Link
                href="/ingredients"
                className="text-gray-600 dark:text-gray-300 hover:text-gray-900 dark:hover:text-white transition"
              >
                Generate Meals
              </Link>
              <Link
                href="/recipes"
                className="text-gray-600 dark:text-gray-300 hover:text-gray-900 dark:hover:text-white transition"
              >
                Recipes
              </Link>
              <Link
                href="/planner"
                className="text-gray-600 dark:text-gray-300 hover:text-gray-900 dark:hover:text-white transition"
              >
                Planner
              </Link>
              <Link
                href="/shopping-list"
                className="text-gray-600 dark:text-gray-300 hover:text-gray-900 dark:hover:text-white transition"
              >
                Shopping
              </Link>
            </div>
          )}

          {/* User Menu */}
          {user && (
            <div className="flex items-center space-x-4">
              <span className="hidden md:block text-sm text-gray-600 dark:text-gray-400">
                {profile?.display_name || user.email}
              </span>
              <Link href="/settings">
                <Button variant="outline" size="sm">
                  <Settings className="w-4 h-4" />
                </Button>
              </Link>
              <Button variant="outline" size="sm" onClick={handleSignOut}>
                <LogOut className="w-4 h-4 mr-2" />
                Sign Out
              </Button>
            </div>
          )}
        </div>
      </div>
    </nav>
  );
};
