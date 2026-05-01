import { useState } from "react";
import { placeOrder } from "../api";

export default function Cart({ cartItems, onRemoveItem, onUpdateQuantity, onOrderPlaced, userId }) {
  const [orderStatus, setOrderStatus] = useState(null); // null | "loading" | "success" | "error"
  const [orderResult, setOrderResult] = useState(null);

  const total = cartItems.reduce(
    (sum, item) => sum + item.price * item.quantity,
    0
  );

  if (cartItems.length === 0) {
    return (
      <section id="orders" className="py-16 bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-12">
            <h2 className="text-3xl sm:text-4xl font-bold text-gray-800 mb-3">
              Your Order
            </h2>
          </div>
          <div className="text-center py-12 bg-gray-50 rounded-2xl">
            <svg
              className="w-16 h-16 text-gray-300 mx-auto mb-4"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
              aria-hidden="true"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth={1.5}
                d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 100 4 2 2 0 000-4z"
              />
            </svg>
            <p className="text-gray-500 text-lg">Your cart is empty</p>
            <p className="text-gray-400 text-sm mt-1">
              Add some fresh dairy products!
            </p>
          </div>
        </div>
      </section>
    );
  }

  return (
    <section id="orders" className="py-16 bg-white">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-12">
          <h2 className="text-3xl sm:text-4xl font-bold text-gray-800 mb-3">
            Your Order
          </h2>
          <p className="text-gray-600">Review your items before checkout</p>
        </div>

        <div className="max-w-3xl mx-auto">
          <div className="bg-white rounded-2xl shadow-md border border-gray-100 overflow-hidden">
            {/* Table Header */}
            <div className="hidden sm:grid grid-cols-12 gap-4 px-6 py-4 bg-gray-50 text-sm font-semibold text-gray-600 uppercase">
              <div className="col-span-5">Product</div>
              <div className="col-span-2 text-center">Price</div>
              <div className="col-span-3 text-center">Quantity</div>
              <div className="col-span-2 text-right">Total</div>
            </div>

            {/* Cart Items */}
            {cartItems.map((item) => (
              <div
                key={item.id}
                className="grid grid-cols-1 sm:grid-cols-12 gap-4 px-6 py-4 border-t border-gray-100 items-center hover:bg-gray-50 transition-colors"
              >
                <div className="sm:col-span-5 flex items-center space-x-3">
                  <img
                    src={item.image}
                    alt={item.name}
                    className="w-12 h-12 rounded-lg object-cover"
                  />
                  <span className="font-medium text-gray-800">{item.name}</span>
                </div>
                <div className="sm:col-span-2 text-center text-gray-600">
                  <span className="sm:hidden text-sm text-gray-500">Price: </span>
                  ₹{item.price}/{item.unit}
                </div>
                <div className="sm:col-span-3 flex items-center justify-center space-x-2">
                  <button
                    onClick={() => onUpdateQuantity(item.id, item.quantity - 1)}
                    className="w-7 h-7 flex items-center justify-center bg-gray-100 hover:bg-gray-200 rounded-full transition-colors"
                    aria-label={`Decrease quantity of ${item.name}`}
                  >
                    <svg className="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M20 12H4" />
                    </svg>
                  </button>
                  <span className="w-8 text-center font-medium">{item.quantity}</span>
                  <button
                    onClick={() => onUpdateQuantity(item.id, item.quantity + 1)}
                    className="w-7 h-7 flex items-center justify-center bg-gray-100 hover:bg-gray-200 rounded-full transition-colors"
                    aria-label={`Increase quantity of ${item.name}`}
                  >
                    <svg className="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 4v16m8-8H4" />
                    </svg>
                  </button>
                  <button
                    onClick={() => onRemoveItem(item.id)}
                    className="ml-2 w-7 h-7 flex items-center justify-center text-red-400 hover:text-red-600 hover:bg-red-50 rounded-full transition-colors"
                    aria-label={`Remove ${item.name} from cart`}
                  >
                    <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                    </svg>
                  </button>
                </div>
                <div className="sm:col-span-2 text-right font-semibold text-gray-800">
                  <span className="sm:hidden text-sm text-gray-500">Total: </span>
                  ₹{item.price * item.quantity}
                </div>
              </div>
            ))}

            {/* Total and Checkout */}
            <div className="px-6 py-5 bg-gradient-to-r from-green-50 to-sky-50 border-t border-gray-100">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-gray-500">Total Amount</p>
                  <p className="text-2xl font-bold text-green-700">₹{total}</p>
                </div>
                <button
                  className="btn-primary text-lg disabled:opacity-50"
                  disabled={orderStatus === "loading"}
                  onClick={async () => {
                    setOrderStatus("loading");
                    try {
                      const result = await placeOrder(cartItems, userId);
                      setOrderResult(result);
                      setOrderStatus("success");
                      if (onOrderPlaced) onOrderPlaced();
                      // Reset status after 3 seconds
                      setTimeout(() => setOrderStatus(null), 3000);
                    } catch (err) {
                      console.error("Order failed:", err);
                      setOrderStatus("error");
                    }
                  }}
                >
                  {orderStatus === "loading" ? "Placing Order..." : "Place Order"}
                </button>
                {orderStatus === "success" && (
                  <p className="text-green-600 text-sm mt-2">
                    Order placed! Total: ₹{orderResult?.total}
                  </p>
                )}
                {orderStatus === "error" && (
                  <p className="text-red-600 text-sm mt-2">
                    Order failed. Is the backend running?
                  </p>
                )}
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
