'use client';

import { useAuth } from '@/lib/contexts/auth-context';
import { Button } from '@/components/ui/button';
import Link from 'next/link';
import { ChefHat, Calendar, ShoppingCart, BookOpen } from 'lucide-react';

export default function DashboardPage() {
  const { user, profile } = useAuth();

  return (
    <div className="container mx-auto px-4 py-8 max-w-6xl">
      <div className="mb-8">
        <h1 className="text-4xl font-bold mb-2">
          Welcome back, {profile?.display_name || 'Chef'}!
        </h1>
        <p className="text-gray-600 dark:text-gray-400">
          Let's plan some delicious meals
        </p>
      </div>

      <div className="grid md:grid-cols-2 gap-6 mb-12">
        <Link href="/ingredients">
          <div className="p-8 bg-gradient-to-br from-blue-500 to-blue-600 rounded-lg shadow-lg hover:shadow-xl transition-shadow cursor-pointer">
            <ChefHat className="w-12 h-12 mb-4 text-white" />
            <h2 className="text-2xl font-bold text-white mb-2">
              Generate Meal Prep Plan
            </h2>
            <p className="text-blue-100">
              Select ingredients and generate AI-powered meal prep plans
              optimized for batch cooking
            </p>
            <Button variant="secondary" className="mt-4">
              Start Planning →
            </Button>
          </div>
        </Link>

        <Link href="/recipes">
          <div className="p-8 bg-gradient-to-br from-green-500 to-green-600 rounded-lg shadow-lg hover:shadow-xl transition-shadow cursor-pointer">
            <BookOpen className="w-12 h-12 mb-4 text-white" />
            <h2 className="text-2xl font-bold text-white mb-2">
              Saved Recipes
            </h2>
            <p className="text-green-100">
              Browse and manage your collection of saved recipes
            </p>
            <Button variant="secondary" className="mt-4">
              View Recipes →
            </Button>
          </div>
        </Link>

        <Link href="/planner">
          <div className="p-8 bg-gradient-to-br from-purple-500 to-purple-600 rounded-lg shadow-lg hover:shadow-xl transition-shadow cursor-pointer">
            <Calendar className="w-12 h-12 mb-4 text-white" />
            <h2 className="text-2xl font-bold text-white mb-2">
              Weekly Planner
            </h2>
            <p className="text-purple-100">
              Organize your meals on a weekly calendar
            </p>
            <Button variant="secondary" className="mt-4">
              View Calendar →
            </Button>
          </div>
        </Link>

        <Link href="/shopping-list">
          <div className="p-8 bg-gradient-to-br from-orange-500 to-orange-600 rounded-lg shadow-lg hover:shadow-xl transition-shadow cursor-pointer">
            <ShoppingCart className="w-12 h-12 mb-4 text-white" />
            <h2 className="text-2xl font-bold text-white mb-2">
              Shopping Lists
            </h2>
            <p className="text-orange-100">
              Generate and manage shopping lists from your meal plans
            </p>
            <Button variant="secondary" className="mt-4">
              View Lists →
            </Button>
          </div>
        </Link>
      </div>

      <div className="bg-white dark:bg-gray-800 rounded-lg p-6 shadow">
        <h3 className="text-xl font-semibold mb-4">Getting Started</h3>
        <ol className="space-y-3 text-gray-600 dark:text-gray-400">
          <li className="flex items-start">
            <span className="font-bold text-blue-600 mr-2">1.</span>
            <span>
              Click "Generate Meal Prep Plan" to select ingredients and create
              your first meal prep plan
            </span>
          </li>
          <li className="flex items-start">
            <span className="font-bold text-green-600 mr-2">2.</span>
            <span>
              Review the AI-generated recipes and save the ones you like
            </span>
          </li>
          <li className="flex items-start">
            <span className="font-bold text-purple-600 mr-2">3.</span>
            <span>
              Add recipes to your weekly planner to organize your meals
            </span>
          </li>
          <li className="flex items-start">
            <span className="font-bold text-orange-600 mr-2">4.</span>
            <span>
              Generate a shopping list from your meal plan and you're ready to
              shop!
            </span>
          </li>
        </ol>
      </div>
    </div>
  );
}
