// ===== CART STORAGE =====
function getCart() {
    try {
        const cart = localStorage.getItem('campusbites_cart');
        return cart ? JSON.parse(cart) : [];
    } catch(e) {
        return [];
    }
}

function saveCart(cart) {
    localStorage.setItem('campusbites_cart', JSON.stringify(cart));
    updateCartCount();
}

// ===== ADD TO CART =====
function addToCart(name, price) {
    const cart = getCart();
    const existing = cart.find(item => item.name === name);
    if (existing) {
        existing.qty += 1;
    } else {
        cart.push({ name: name, price: price, qty: 1 });
    }
    saveCart(cart);
    showToast(name + ' added to cart!');
}

// ===== UPDATE CART COUNT =====
function updateCartCount() {
    const cart = getCart();
    const total = cart.reduce((sum, item) => sum + item.qty, 0);
    const countEl = document.getElementById('cart-count');
    if (countEl) countEl.textContent = total;
}

// ===== TOAST =====
function showToast(message) {
    let toast = document.getElementById('toast');
    if (!toast) {
        toast = document.createElement('div');
        toast.id = 'toast';
        toast.style.cssText = `
            position: fixed;
            bottom: 30px;
            right: 30px;
            background: #333;
            color: white;
            padding: 14px 25px;
            border-radius: 10px;
            font-size: 15px;
            z-index: 9999;
            opacity: 0;
            transition: opacity 0.3s;
        `;
        document.body.appendChild(toast);
    }
    toast.textContent = message;
    toast.style.opacity = '1';
    setTimeout(() => toast.style.opacity = '0', 2500);
}

document.addEventListener('DOMContentLoaded', updateCartCount);