export default function Hero() {
  return (
    <section
      id="home"
      className="relative bg-gradient-to-br from-green-50 via-white to-sky-50 py-20 sm:py-28 overflow-hidden"
    >
      {/* Decorative circles */}
      <div className="absolute top-10 left-10 w-32 h-32 bg-green-100 rounded-full opacity-50 blur-2xl" />
      <div className="absolute bottom-10 right-10 w-40 h-40 bg-sky-100 rounded-full opacity-50 blur-2xl" />

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center relative">
        <h2 className="text-4xl sm:text-5xl lg:text-6xl font-bold text-gray-800 mb-4 animate-fade-in">
          Fresh Milk Delivered{" "}
          <span className="text-green-600">Daily</span>
        </h2>
        <p className="text-lg sm:text-xl text-gray-600 mb-8 max-w-2xl mx-auto">
          Pure, farm-fresh dairy products at your doorstep
        </p>
        <a
          href="#products"
          className="btn-primary inline-block text-lg"
        >
          Order Now
        </a>

        {/* Decorative milk drop SVG */}
        <div className="mt-12 flex justify-center">
          <svg
            className="w-20 h-20 text-green-200 animate-bounce"
            fill="currentColor"
            viewBox="0 0 24 24"
            aria-hidden="true"
          >
            <path d="M12 2c-5.33 4.55-8 8.48-8 11.8 0 4.98 3.8 8.2 8 8.2s8-3.22 8-8.2c0-3.32-2.67-7.25-8-11.8z" />
          </svg>
        </div>
      </div>
    </section>
  );
}
