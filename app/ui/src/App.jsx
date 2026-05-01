import { useState } from "react";
import Header from "./components/Header";
import Hero from "./components/Hero";
import ProductSection from "./components/ProductSection";
import Cart from "./components/Cart";
import OrderHistory from "./components/OrderHistory";
import AuthForm from "./components/AuthForm";
import Footer from "./components/Footer";

export default function App() {
  const [user, setUser] = useState(null);
  const [cartItems, setCartItems] = useState([]);
  const [orderRefresh, setOrderRefresh] = useState(0);

  // If not logged in, show login/register screen
  if (!user) {
    return <AuthForm onLogin={(userData) => setUser(userData)} />;
  }

  const handleAddToCart = (product) => {
    setCartItems((prev) => {
      const existing = prev.find((item) => item.id === product.id);
      if (existing) {
        return prev.map((item) =>
          item.id === product.id
            ? { ...item, quantity: item.quantity + product.quantity }
            : item
        );
      }
      return [...prev, { ...product }];
    });
  };

  const handleRemoveItem = (id) => {
    setCartItems((prev) => prev.filter((item) => item.id !== id));
  };

  const handleUpdateQuantity = (id, newQuantity) => {
    if (newQuantity < 1) {
      handleRemoveItem(id);
      return;
    }
    if (newQuantity > 20) return;
    setCartItems((prev) =>
      prev.map((item) =>
        item.id === id ? { ...item, quantity: newQuantity } : item
      )
    );
  };

  const cartCount = cartItems.reduce((sum, item) => sum + item.quantity, 0);

  const scrollToOrders = () => {
    document.getElementById("orders")?.scrollIntoView({ behavior: "smooth" });
  };

  return (
    <div className="min-h-screen flex flex-col bg-white">
      <Header cartCount={cartCount} onCartClick={scrollToOrders} user={user} onLogout={() => setUser(null)} />
      <main className="flex-grow">
        <Hero />
        <ProductSection onAddToCart={handleAddToCart} />
        <Cart
          cartItems={cartItems}
          onRemoveItem={handleRemoveItem}
          onUpdateQuantity={handleUpdateQuantity}
          userId={user.user_id}
          onOrderPlaced={() => {
            setCartItems([]);
            setOrderRefresh((n) => n + 1);
          }}
        />
        <OrderHistory refreshTrigger={orderRefresh} userId={user.user_id} isAdmin={user.role === "admin"} />
      </main>
      <Footer />
    </div>
  );
}
