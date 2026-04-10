<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cart - CampusBites</title>
    <link rel="stylesheet" href="./css/style.css">
</head>
<body>

    <%@ include file="navbar.jsp" %>

    <!-- PAGE TITLE -->
    <section class="page-title">
        <h2>Your Cart &#128722;</h2>
        <p>Review your order before placing it</p>
    </section>

    <!-- CART CONTENT -->
    <section class="cart-container">
        <div id="cart-items"></div>

        <!-- EMPTY CART -->
        <div id="empty-cart" style="display:none; text-align:center; padding:60px;">
            <div style="font-size:70px;">&#128722;</div>
            <h3 style="margin:15px 0; color:#666;">Your cart is empty!</h3>
            <a href="menu.jsp" class="btn">Browse Menu</a>
        </div>

        <!-- ORDER SUMMARY -->
        <div id="order-summary" class="order-summary">
            <h3>Order Summary</h3>
            <div class="summary-row">
                <span>Subtotal</span>
                <span id="subtotal">&#8377;0</span>
            </div>
            <div class="summary-row">
                <span>Handling Fee</span>
                <span>Rs.5</span>
            </div>
            <div class="summary-row total-row">
                <span>Total</span>
                <span id="total-price">&#8377;0</span>
            </div>
            <button onclick="placeOrder()" class="btn"
                style="width:100%; text-align:center; margin-top:15px;
                       display:block; border:none; cursor:pointer;">
                Proceed to Checkout &#127829;
            </button>
        </div>
    </section>

    <!-- FOOTER -->
    <footer>
        <p>&copy; 2024 CampusBites | College Canteen System</p>
    </footer>

    <script src="js/cart.js"></script>
    <script src="js/cart.js"></script>
<script src="js/cart.js"></script>
<script>
    function renderCart() {
        const cart = getCart();
        const cartItemsEl = document.getElementById('cart-items');
        const emptyCart = document.getElementById('empty-cart');
        const orderSummary = document.getElementById('order-summary');

        if (cart.length === 0) {
            cartItemsEl.innerHTML = '';
            emptyCart.style.display = 'block';
            orderSummary.style.display = 'none';
            return;
        }

        emptyCart.style.display = 'none';
        orderSummary.style.display = 'block';

        let html = '';
        let subtotal = 0;

        cart.forEach(function(item) {
            subtotal += item.price * item.qty;
            const itemTotal = item.price * item.qty;
            const div = document.createElement('div');
            div.className = 'cart-item';
            div.innerHTML =
                '<div class="cart-item-info">' +
                    '<h4>' + item.name + '</h4>' +
                    '<p>Rs.' + item.price + ' each</p>' +
                '</div>' +
                '<div class="cart-item-controls">' +
                    '<button onclick="changeQty(\'' + item.name + '\', -1)">-</button>' +
                    '<span>' + item.qty + '</span>' +
                    '<button onclick="changeQty(\'' + item.name + '\', 1)">+</button>' +
                '</div>' +
                '<div class="cart-item-total">' +
                    'Rs.' + itemTotal +
                    '<button class="remove-btn" onclick="removeItem(\'' + item.name + '\')"></button>' +
                '</div>';
            cartItemsEl.appendChild(div);
        });

        document.getElementById('subtotal').textContent = 'Rs.' + subtotal;
        document.getElementById('total-price').textContent = 'Rs.' + (subtotal + 5);
    }

    function changeQty(name, change) {
        const cart = getCart();
        const item = cart.find(function(i) { return i.name === name; });
        if (item) {
            item.qty += change;
            if (item.qty <= 0) cart.splice(cart.indexOf(item), 1);
        }
        saveCart(cart);
        document.getElementById('cart-items').innerHTML = '';
        renderCart();
    }

    function removeItem(name) {
        const cart = getCart().filter(function(i) { return i.name !== name; });
        saveCart(cart);
        document.getElementById('cart-items').innerHTML = '';
        renderCart();
    }

    function placeOrder() {
        const cart = getCart();
        if(cart.length === 0) {
            alert('Your cart is empty!');
            return;
        }
        const total = cart.reduce(function(sum, item) {
            return sum + item.price * item.qty;
        }, 0) + 5;

        const form = document.createElement('form');
        form.method = 'POST';
        form.action = 'payment.jsp';

        const itemsInput = document.createElement('input');
        itemsInput.type = 'hidden';
        itemsInput.name = 'items';
        itemsInput.value = JSON.stringify(cart);
        form.appendChild(itemsInput);

        const totalInput = document.createElement('input');
        totalInput.type = 'hidden';
        totalInput.name = 'total';
        totalInput.value = total;
        form.appendChild(totalInput);

        document.body.appendChild(form);
        form.submit();
    }

    document.addEventListener('DOMContentLoaded', renderCart);
</script>
</body>
</html>