import { useState } from "react";

export default function Header({ cartCount, onCartClick, user, onLogout }) {
  const [menuOpen, setMenuOpen] = useState(false);

  return (
    <header className="bg-white shadow-sm sticky top-0 z-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between items-center h-16">
          {/* Logo */}
          <div className="flex items-center space-x-2">
            <svg
              className="w-8 h-8 text-green-500"
              fill="currentColor"
              viewBox="0 0 24 24"
              aria-hidden="true"
            >
              <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z" />
            </svg>
            <h1 className="text-xl font-bold text-green-700">Namma Dairy</h1>
          </div>

          {/* Desktop Nav */}
          <nav className="hidden md:flex space-x-8" aria-label="Main navigation">
            <a
              href="#home"
              className="text-gray-700 hover:text-green-600 font-medium transition-colors"
            >
              Home
            </a>
            <a
              href="#products"
              className="text-gray-700 hover:text-green-600 font-medium transition-colors"
            >
              Products
            </a>
            <a
              href="#orders"
              className="text-gray-700 hover:text-green-600 font-medium transition-colors"
            >
              Orders
            </a>
            <a
              href="#contact"
              className="text-gray-700 hover:text-green-600 font-medium transition-colors"
            >
              Contact
            </a>
          </nav>

          {/* Cart Icon + User */}
          <div className="flex items-center space-x-4">
            {user && (
              <div className="hidden sm:flex items-center space-x-2">
                <span className="text-sm text-gray-600">Hi, <strong>{user.name}</strong></span>
                {user.role === "admin" && (
                  <span className="text-xs bg-yellow-100 text-yellow-800 px-2 py-0.5 rounded-full font-medium">Admin</span>
                )}
                <button
                  onClick={onLogout}
                  className="text-xs text-red-500 hover:text-red-700 font-medium"
                >
                  Logout
                </button>
              </div>
            )}
            <button
              onClick={onCartClick}
              className="relative p-2 text-gray-700 hover:text-green-600 transition-colors"
              aria-label={`Cart with ${cartCount} items`}
            >
              <svg
                className="w-6 h-6"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
                aria-hidden="true"
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  strokeWidth={2}
                  d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 100 4 2 2 0 000-4z"
                />
              </svg>
              {cartCount > 0 && (
                <span className="absolute -top-1 -right-1 bg-green-500 text-white text-xs font-bold rounded-full w-5 h-5 flex items-center justify-center animate-pulse">
                  {cartCount}
                </span>
              )}
            </button>

            {/* Mobile menu button */}
            <button
              className="md:hidden p-2 text-gray-700"
              onClick={() => setMenuOpen(!menuOpen)}
              aria-label="Toggle menu"
              aria-expanded={menuOpen}
            >
              <svg
                className="w-6 h-6"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
                aria-hidden="true"
              >
                {menuOpen ? (
                  <path
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    strokeWidth={2}
                    d="M6 18L18 6M6 6l12 12"
                  />
                ) : (
                  <path
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    strokeWidth={2}
                    d="M4 6h16M4 12h16M4 18h16"
                  />
                )}
              </svg>
            </button>
          </div>
        </div>

        {/* Mobile Nav */}
        {menuOpen && (
          <nav className="md:hidden pb-4 space-y-2" aria-label="Mobile navigation">
            <a
              href="#home"
              className="block py-2 text-gray-700 hover:text-green-600 font-medium"
              onClick={() => setMenuOpen(false)}
            >
              Home
            </a>
            <a
              href="#products"
              className="block py-2 text-gray-700 hover:text-green-600 font-medium"
              onClick={() => setMenuOpen(false)}
            >
              Products
            </a>
            <a
              href="#orders"
              className="block py-2 text-gray-700 hover:text-green-600 font-medium"
              onClick={() => setMenuOpen(false)}
            >
              Orders
            </a>
            <a
              href="#contact"
              className="block py-2 text-gray-700 hover:text-green-600 font-medium"
              onClick={() => setMenuOpen(false)}
            >
              Contact
            </a>
          </nav>
        )}
      </div>
    </header>
  );
}
