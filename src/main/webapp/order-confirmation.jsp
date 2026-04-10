<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.campusbites.DBConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Order Confirmed - CampusBites</title>
    <link rel="stylesheet" href="./css/style.css">
</head>
<body>

    <%@ include file="navbar.jsp" %>

    <%
        String token = request.getParameter("token");
        String orderId = request.getParameter("orderId");
        String total = request.getParameter("total");

        // Fetch real status from DB
        String realStatus = "Placed";
        if(orderId != null) {
            Connection conn = DBConnection.getConnection();
            try {
                PreparedStatement stmt = conn.prepareStatement("SELECT status FROM orders WHERE id = ?");
                stmt.setInt(1, Integer.parseInt(orderId));
                ResultSet rs = stmt.executeQuery();
                if(rs.next()) realStatus = rs.getString("status");
                conn.close();
            } catch(Exception e) { e.printStackTrace(); }
        }
    %>

    <section class="confirmation-container">
        <div class="confirmation-card">

            <div class="success-icon">✅</div>
            <h2>Order Placed Successfully!</h2>
            <p class="confirm-subtitle">Your food is being prepared 🍳</p>

            <div class="token-box">
                <p>Your Token Number</p>
                <h1 class="token-number">#<%= token %></h1>
                <p>Show this at the counter</p>
            </div>

            <!-- LIVE INDICATOR -->
            <div class="live-indicator" id="live-indicator">
                <span class="live-dot"></span> Live updates on
            </div>

            <div class="order-details">
                <div class="detail-row">
                    <span>Order ID</span>
                    <span>#<%= orderId %></span>
                </div>
                <div class="detail-row">
                    <span>Total Paid</span>
                    <span>₹<%= total %></span>
                </div>
                <div class="detail-row">
                    <span>Status</span>
                    <span class="status-badge" id="status-badge">
                        <%= realStatus.equals("Placed") ? "🟡 Placed" :
                            realStatus.equals("Preparing") ? "🟠 Preparing" : "🟢 Ready!" %>
                    </span>
                </div>
            </div>

            <div class="confirm-actions">
                <a href="menu.jsp" class="btn">Order More</a>
                <a href="order-status.jsp?orderId=<%= orderId %>"
                   class="btn-outline">Track Order</a>
            </div>

        </div>
    </section>

    <footer>
        <p>© 2026 CampusBites | College Canteen System</p>
    </footer>

    <script src="js/cart.js"></script>
    <script>
        // Clear cart
        localStorage.removeItem('campusbites_cart');
        document.getElementById('cart-count').textContent = '0';

        const orderId = '<%= orderId %>';
        let lastStatus = '<%= realStatus %>';

        function updateBadge(status) {
            const badge = document.getElementById('status-badge');
            badge.textContent = status === 'Placed' ? '🟡 Placed' :
                               status === 'Preparing' ? '🟠 Preparing' : '🟢 Ready!';

            if(status === 'Ready') {
                document.getElementById('live-indicator').innerHTML = '✅ Your order is Ready!';
                if(Notification.permission === 'granted') {
                    new Notification('CampusBites 🍕', {
                        body: 'Your order is Ready! Go collect it!'
                    });
                }
            }
        }

        // Request notification permission
        if(Notification.permission === 'default') {
            Notification.requestPermission();
        }

        // Poll every 3 seconds
        function pollStatus() {
            fetch('GetOrderStatusServlet?orderId=' + orderId)
                .then(res => res.json())
                .then(data => {
                    if(data.status !== lastStatus) {
                        lastStatus = data.status;
                        updateBadge(data.status);
                        document.getElementById('live-indicator').innerHTML =
                            '<span class="live-dot"></span> ✨ Status updated!';
                        setTimeout(() => {
                            if(data.status !== 'Ready') {
                                document.getElementById('live-indicator').innerHTML =
                                    '<span class="live-dot"></span> Live updates on';
                            }
                        }, 3000);
                    }
                    if(data.status !== 'Ready') {
                        setTimeout(pollStatus, 3000);
                    }
                })
                .catch(() => setTimeout(pollStatus, 5000));
        }

        // Set initial state
        updateBadge('<%= realStatus %>');

        // Start polling if not ready
        if('<%= realStatus %>' !== 'Ready') {
            setTimeout(pollStatus, 3000);
        }
    </script>
</body>
</html>