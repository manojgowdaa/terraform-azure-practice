import { useState, useEffect } from "react";
import ProductCard from "./ProductCard";
import { fetchProducts } from "../api";
import localProducts from "../data/products";

export default function ProductSection({ onAddToCart }) {
  const [products, setProducts] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    fetchProducts()
      .then((data) => {
        // Backend doesn't have images, merge with local data for images
        const merged = data.map((p) => {
          const local = localProducts.find((lp) => lp.id === p.id);
          return { ...p, image: local?.image || "", description: local?.description || "" };
        });
        setProducts(merged);
      })
      .catch((err) => {
        console.warn("Backend unavailable, using local data:", err.message);
        setError("Using offline data");
        setProducts(localProducts);
      })
      .finally(() => setLoading(false));
  }, []);

  return (
    <section id="products" className="py-16 bg-gray-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-12">
          <h2 className="text-3xl sm:text-4xl font-bold text-gray-800 mb-3">
            Our Products
          </h2>
          <p className="text-gray-600 max-w-xl mx-auto">
            Farm-fresh dairy products sourced directly from local farmers
          </p>
          {error && (
            <p className="text-yellow-600 text-sm mt-2">{error}</p>
          )}
        </div>

        {loading ? (
          <div className="text-center py-12">
            <div className="animate-spin w-8 h-8 border-4 border-green-500 border-t-transparent rounded-full mx-auto"></div>
            <p className="text-gray-500 mt-4">Loading products...</p>
          </div>
        ) : (
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6 lg:gap-8">
            {products.map((product) => (
              <ProductCard
                key={product.id}
                product={product}
                onAddToCart={onAddToCart}
              />
            ))}
          </div>
        )}
      </div>
    </section>
  );
}
