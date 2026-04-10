<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.campusbites.DBConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Order History - CampusBites</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<%
    HttpSession userSession = request.getSession(false);
    if(userSession == null || userSession.getAttribute("user_id") == null) {
        response.sendRedirect("Login.jsp");
        return;
    }
    int userId = (Integer) userSession.getAttribute("user_id");
    String fullname = (String) userSession.getAttribute("fullname");
%>

    <%@ include file="navbar.jsp" %>

    <section class="page-title">
        <h2>My Orders 📋</h2>
        <p>All your past and current orders</p>
    </section>

    <section class="history-container">

    <%
        Connection conn = DBConnection.getConnection();
        try {
            String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY created_at DESC";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            boolean hasOrders = false;

            while(rs.next()) {
                hasOrders = true;
                int orderId = rs.getInt("id");
                int token = rs.getInt("token_number");
                double total = rs.getDouble("total_amount");
                String status = rs.getString("status");
                String createdAt = rs.getTimestamp("created_at").toString().substring(0, 16);

                String badgeClass = status.equals("Placed") ? "badge-placed" :
                                   status.equals("Preparing") ? "badge-preparing" : "badge-ready";
                String statusIcon = status.equals("Placed") ? "🟡" :
                                   status.equals("Preparing") ? "🟠" : "🟢";
    %>
        <div class="history-card">
            <div class="history-header">
                <div class="history-left">
                    <h3>Order #<%= orderId %></h3>
                    <p class="history-date">🕐 <%= createdAt %></p>
                </div>
                <div class="history-right">
                    <span class="badge <%= badgeClass %>"><%= statusIcon %> <%= status %></span>
                </div>
            </div>

            <div class="history-body">
                <!-- ORDER ITEMS -->
                <%
                    PreparedStatement itemStmt = conn.prepareStatement(
                        "SELECT * FROM order_items WHERE order_id = ?");
                    itemStmt.setInt(1, orderId);
                    ResultSet itemRs = itemStmt.executeQuery();
                    while(itemRs.next()) {
                %>
                <div class="history-item">
                    <span>🍽️ <%= itemRs.getString("item_name") %> x<%= itemRs.getInt("quantity") %></span>
                    <span>Rs.<%= (int)(itemRs.getDouble("price") * itemRs.getInt("quantity")) %></span>
                </div>
                <% } %>
            </div>

            <div class="history-footer">
                <div class="history-token">
                    Token <strong>#<%= token %></strong>
                </div>
                <div class="history-total">
                    Total: <strong>Rs.<%= (int)total %></strong>
                </div>
                <% if(!status.equals("Ready")) { %>
                <a href="order-status.jsp?orderId=<%= orderId %>" class="btn-outline" style="padding:8px 18px; font-size:13px;">
                    Track Order
                </a>
                <% } else { %>
                <span class="completed-badge">✅ Completed</span>
                <% } %>
            </div>
        </div>
    <%
            }

            if(!hasOrders) {
    %>
        <div class="empty-history">
            <div style="font-size:70px;">🍽️</div>
            <h3>No orders yet!</h3>
            <p>You haven't placed any orders yet.</p>
            <a href="menu.jsp" class="btn" style="margin-top:20px; display:inline-block;">
                Browse Menu
            </a>
        </div>
    <%
            }
            conn.close();
        } catch(Exception e) {
            e.printStackTrace();
        }
    %>

    </section>

    <footer>
        <p>&copy; 2026 CampusBites | College Canteen System</p>
    </footer>

    <script src="js/cart.js"></script>
</body>
</html>