import { useState, useEffect } from "react";
import { fetchUserOrders, fetchOrders } from "../api";

export default function OrderHistory({ refreshTrigger, userId, isAdmin }) {
  const [orders, setOrders] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    setLoading(true);
    // Admin sees ALL orders, regular user sees only their own
    const fetcher = isAdmin ? fetchOrders() : fetchUserOrders(userId);
    fetcher
      .then(setOrders)
      .catch((err) => console.warn("Could not load orders:", err.message))
      .finally(() => setLoading(false));
  }, [refreshTrigger, userId, isAdmin]);

  if (loading) {
    return (
      <section className="py-12 bg-white">
        <div className="max-w-4xl mx-auto px-4 text-center">
          <div className="animate-spin w-6 h-6 border-4 border-green-500 border-t-transparent rounded-full mx-auto"></div>
        </div>
      </section>
    );
  }

  if (orders.length === 0) return null;

  return (
    <section id="order-history" className="py-12 bg-white">
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
        <h2 className="text-2xl font-bold text-gray-800 mb-6">
          {isAdmin ? "All Orders (Admin View)" : "My Orders"}
        </h2>

        <div className="space-y-4">
          {orders.map((order) => (
            <div
              key={order.order_id}
              className="border border-gray-200 rounded-lg p-4 hover:shadow-md transition-shadow"
            >
              <div className="flex justify-between items-center mb-2">
                <span className="font-semibold text-gray-700">
                  Order #{order.order_id}
                </span>
                <span className="text-sm text-gray-500">
                  {new Date(order.created_at).toLocaleString()}
                </span>
              </div>

              <div className="text-sm text-gray-600 space-y-1">
                {order.items.map((item, i) => (
                  <div key={i} className="flex justify-between">
                    <span>
                      {item.product} × {item.quantity}
                    </span>
                    <span>₹{item.line_total}</span>
                  </div>
                ))}
              </div>

              <div className="mt-2 pt-2 border-t border-gray-100 flex justify-end">
                <span className="font-bold text-green-700">
                  Total: ₹{order.total}
                </span>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
