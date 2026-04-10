<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.campusbites.DBConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Order Status - CampusBites</title>
    <link rel="stylesheet" href="./css/style.css">
</head>
<body>

    <%@ include file="navbar.jsp" %>

    <%
        String orderId = request.getParameter("orderId");
        String status = "Unknown";
        String token = "";
        String total = "";
        String createdAt = "";
        int queuePos = 0;

        if(orderId != null) {
            Connection conn = DBConnection.getConnection();
            try {
                String sql = "SELECT o.*, " +
                           "(SELECT COUNT(*) FROM orders WHERE status='Placed' AND id < ?) as queue_pos " +
                           "FROM orders o WHERE o.id = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setInt(1, Integer.parseInt(orderId));
                stmt.setInt(2, Integer.parseInt(orderId));
                ResultSet rs = stmt.executeQuery();
                if(rs.next()) {
                    status = rs.getString("status");
                    token = String.valueOf(rs.getInt("token_number"));
                    total = String.valueOf(rs.getDouble("total_amount"));
                    createdAt = rs.getTimestamp("created_at").toString();
                    queuePos = rs.getInt("queue_pos");
                }
                conn.close();
            } catch(Exception e) {
                e.printStackTrace();
            }
        }
    %>

    <section class="page-title">
        <h2>Order Status 📋</h2>
        <p>Updates automatically — no refresh needed!</p>
    </section>

    <section class="status-container">
        <div class="status-card">

            <div class="token-box">
                <p>Token Number</p>
                <h1 class="token-number">#<%= token %></h1>
                <p id="queue-text">
                    <% if(queuePos > 0) { %>
                        📊 <%= queuePos %> order(s) before you
                    <% } else { %>
                        🎉 You're next!
                    <% } %>
                </p>
            </div>

            <div class="live-indicator" id="live-indicator">
                <span class="live-dot"></span> Live updates on
            </div>
            
            <!-- WAIT TIME PREDICTOR -->
<div class="wait-time-card" id="wait-time-card">
    <div class="wait-time-header">
        <span>🤖 AI Wait Time Prediction</span>
        <span class="confidence-badge" id="confidence-badge">Calculating...</span>
    </div>
    <div class="wait-time-body">
        <div class="wait-time-number" id="wait-time-number">
            <span id="wait-minutes">--</span>
            <span class="wait-unit">mins</span>
        </div>
        <p class="wait-message" id="wait-message">Calculating your wait time...</p>
    </div>
    <div class="wait-time-footer">
        <div class="wait-detail">
            <span>Orders ahead</span>
            <strong id="orders-ahead">--</strong>
        </div>
        <div class="wait-detail">
            <span>Parallel slots</span>
            <strong>3 🍳</strong>
        </div>
        <div class="wait-detail">
            <span>Your items</span>
            <strong id="my-cook-time">--</strong>
        </div>
    </div>
</div>

            <div class="status-steps" id="status-steps">
                <div class="step" id="step-placed">
                    <div class="step-icon">📋</div>
                    <div class="step-info">
                        <h4>Order Placed</h4>
                        <p>We received your order</p>
                    </div>
                </div>
                <div class="step-line" id="line-1"></div>
                <div class="step" id="step-preparing">
                    <div class="step-icon">🍳</div>
                    <div class="step-info">
                        <h4>Preparing</h4>
                        <p>Your food is being cooked</p>
                    </div>
                </div>
                <div class="step-line" id="line-2"></div>
                <div class="step" id="step-ready">
                    <div class="step-icon">✅</div>
                    <div class="step-info">
                        <h4>Ready for Pickup</h4>
                        <p>Collect from the counter</p>
                    </div>
                </div>
            </div>

            <div class="order-details" style="margin-top:25px;">
                <div class="detail-row">
                    <span>Order ID</span>
                    <span>#<%= orderId %></span>
                </div>
                <div class="detail-row">
                    <span>Total</span>
                    <span>₹<%= total %></span>
                </div>
                <div class="detail-row">
                    <span>Ordered At</span>
                    <span><%= createdAt %></span>
                </div>
                <div class="detail-row">
                    <span>Current Status</span>
                    <span class="status-badge" id="current-status-badge">
                        <%= status.equals("Placed") ? "🟡 Placed" :
                            status.equals("Preparing") ? "🟠 Preparing" : "🟢 Ready!" %>
                    </span>
                </div>
            </div>

            <a href="menu.jsp" class="btn" style="margin-top:20px; display:inline-block;">
                Order More
            </a>

        </div>
    </section>

    <footer>
        <p>© 2026 CampusBites | College Canteen System</p>
    </footer>

    <script src="js/cart.js"></script>
    <script>
        const orderId = '<%= orderId %>';
        let lastStatus = '<%= status %>';

        function updateSteps(status, queue) {
            // Reset
            document.querySelectorAll('.step').forEach(s => s.classList.remove('done'));
            document.querySelectorAll('.step-line').forEach(l => l.classList.remove('done'));

            if(status === 'Placed' || status === 'Preparing' || status === 'Ready') {
                document.getElementById('step-placed').classList.add('done');
            }
            if(status === 'Preparing' || status === 'Ready') {
                document.getElementById('line-1').classList.add('done');
                document.getElementById('step-preparing').classList.add('done');
            }
            if(status === 'Ready') {
                document.getElementById('line-2').classList.add('done');
                document.getElementById('step-ready').classList.add('done');
            }

            // Update badge
            const badge = document.getElementById('current-status-badge');
            badge.textContent = status === 'Placed' ? '🟡 Placed' :
                               status === 'Preparing' ? '🟠 Preparing' : '🟢 Ready!';

            // Update queue text
            const queueText = document.getElementById('queue-text');
            if(status === 'Ready') {
                queueText.textContent = '🎉 Your order is ready! Go collect it!';
                triggerNotification();
            } else if(queue > 0) {
                queueText.textContent = '📊 ' + queue + ' order(s) before you';
            } else {
                queueText.textContent = '🎉 You\'re next!';
            }
        }

        function triggerNotification() {
            if(Notification.permission === 'granted') {
                new Notification('CampusBites 🍕', {
                    body: 'Your order is Ready! Go collect it at the counter!'
                });
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
                    // If status changed show flash
                    if(data.status !== lastStatus) {
                        lastStatus = data.status;
                        const indicator = document.getElementById('live-indicator');
                        indicator.innerHTML = '<span class="live-dot"></span> ✨ Status updated!';
                        setTimeout(() => {
                            indicator.innerHTML = '<span class="live-dot"></span> Live updates on';
                        }, 3000);
                    }

                    updateSteps(data.status, data.queue);

                    // Stop polling if ready
                    if(data.status === 'Ready') {
                        document.getElementById('live-indicator').innerHTML = '✅ Order completed!';
                    } else {
                        setTimeout(pollStatus, 3000);
                    }
                })
                .catch(() => {
                    // Retry on error
                    setTimeout(pollStatus, 5000);
                });
        }
        
     // Poll wait time every 10 seconds
        function pollWaitTime() {
            fetch('WaitTimeServlet?orderId=' + orderId)
                .then(res => res.json())
                .then(data => {
                    const card = document.getElementById('wait-time-card');

                    if(data.status === 'Ready') {
                        document.getElementById('wait-minutes').textContent = '0';
                        document.getElementById('wait-message').textContent = 'Your order is Ready!';
                        document.getElementById('confidence-badge').textContent = '✅ Done';
                        document.getElementById('confidence-badge').style.background = '#d4edda';
                        document.getElementById('confidence-badge').style.color = '#155724';
                        document.getElementById('orders-ahead').textContent = '0';
                        return;
                    }

                    document.getElementById('wait-minutes').textContent = data.waitTime;
                    document.getElementById('wait-message').textContent = data.message;
                    document.getElementById('orders-ahead').textContent = data.ordersAhead;

                    const badge = document.getElementById('confidence-badge');
                    badge.textContent = data.confidence + ' confidence';
                    badge.style.background = data.confidence === 'High' ? '#d4edda' :
                                            data.confidence === 'Medium' ? '#fff3cd' : '#f8d7da';
                    badge.style.color = data.confidence === 'High' ? '#155724' :
                                       data.confidence === 'Medium' ? '#856404' : '#721c24';

                    document.getElementById('my-cook-time').textContent = data.waitTime + ' mins';

                    if(data.status !== 'Ready') {
                        setTimeout(pollWaitTime, 10000);
                    }
                })
                .catch(() => setTimeout(pollWaitTime, 15000));
        }

        // Start wait time polling
        if('<%= status %>' !== 'Ready') {
            pollWaitTime();
        }

        // Set initial UI state
        updateSteps('<%= status %>', <%= queuePos %>);

        // Start polling after 3 seconds
        if('<%= status %>' !== 'Ready') {
            setTimeout(pollStatus, 3000);
        }
    </script>
</body>
</html>