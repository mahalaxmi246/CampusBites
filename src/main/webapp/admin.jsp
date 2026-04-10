<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.campusbites.DBConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Panel - CampusBites</title>
    <link rel="stylesheet" href="./css/style.css">
</head>
<body>

    <!-- HEADER -->
    <%@ include file="navbar.jsp" %>

    <section class="page-title">
        <h2>Admin Dashboard 👨‍🍳</h2>
        <p>Manage all orders from here</p>
    </section>

    <section class="admin-container">

        <!-- STATS ROW -->
        <%
            Connection conn = DBConnection.getConnection();
            int totalOrders = 0;
            int placedOrders = 0;
            int preparingOrders = 0;
            int readyOrders = 0;

            try {
                Statement statStmt = conn.createStatement();

                ResultSet rs1 = statStmt.executeQuery("SELECT COUNT(*) FROM orders");
                if(rs1.next()) totalOrders = rs1.getInt(1);

                ResultSet rs2 = statStmt.executeQuery("SELECT COUNT(*) FROM orders WHERE status='Placed'");
                if(rs2.next()) placedOrders = rs2.getInt(1);

                ResultSet rs3 = statStmt.executeQuery("SELECT COUNT(*) FROM orders WHERE status='Preparing'");
                if(rs3.next()) preparingOrders = rs3.getInt(1);

                ResultSet rs4 = statStmt.executeQuery("SELECT COUNT(*) FROM orders WHERE status='Ready'");
                if(rs4.next()) readyOrders = rs4.getInt(1);

            } catch(Exception e) {
                e.printStackTrace();
            }
        %>

        <div class="admin-stats">
            <div class="stat-card">
                <h3><%= totalOrders %></h3>
                <p>Total Orders</p>
            </div>
            <div class="stat-card placed">
                <h3><%= placedOrders %></h3>
                <p>🟡 Placed</p>
            </div>
            <div class="stat-card preparing">
                <h3><%= preparingOrders %></h3>
                <p>🟠 Preparing</p>
            </div>
            <div class="stat-card ready">
                <h3><%= readyOrders %></h3>
                <p>🟢 Ready</p>
            </div>
        </div>

        <!-- ORDERS TABLE -->
        <div class="admin-table-container">
            <h3 style="margin-bottom:20px;">All Orders</h3>
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>Order ID</th>
                        <th>Token</th>
                        <th>User ID</th>
                        <th>Total</th>
                        <th>Status</th>
                        <th>Time</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try {
                            String sql = "SELECT * FROM orders ORDER BY created_at DESC";
                            PreparedStatement stmt = conn.prepareStatement(sql);
                            ResultSet rs = stmt.executeQuery();

                            while(rs.next()) {
                                String orderStatus = rs.getString("status");
                                String badgeClass = orderStatus.equals("Placed") ? "badge-placed" :
                                                   orderStatus.equals("Preparing") ? "badge-preparing" : "badge-ready";
                    %>
                    <tr>
                        <td>#<%= rs.getInt("id") %></td>
                        <td><strong>#<%= rs.getInt("token_number") %></strong></td>
                        <td><%= rs.getInt("user_id") %></td>
                        <td>₹<%= rs.getDouble("total_amount") %></td>
                        <td><span class="badge <%= badgeClass %>"><%= orderStatus %></span></td>
                        <td><%= rs.getTimestamp("created_at") %></td>
                        <td>
                            <form method="POST" action="UpdateOrderServlet" style="display:inline;">
                                <input type="hidden" name="orderId" value="<%= rs.getInt("id") %>">
                                <select name="status" class="status-select">
                                    <option <%= orderStatus.equals("Placed") ? "selected" : "" %>>Placed</option>
                                    <option <%= orderStatus.equals("Preparing") ? "selected" : "" %>>Preparing</option>
                                    <option <%= orderStatus.equals("Ready") ? "selected" : "" %>>Ready</option>
                                </select>
                                <button type="submit" class="update-btn">Update</button>
                            </form>
                        </td>
                    </tr>
                    <%
                            }
                            conn.close();
                        } catch(Exception e) {
                            e.printStackTrace();
                        }
                    %>
                </tbody>
            </table>
        </div>

    </section>

    <!-- FOOTER -->
    <footer>
        <p>© 2024 CampusBites | College Canteen System</p>
    </footer>
    <script>
    let countdown = 5;
    const refreshBadge = document.createElement('div');
    refreshBadge.style.cssText = `
        position: fixed;
        bottom: 20px;
        right: 20px;
        background: #ff6b35;
        color: white;
        padding: 10px 20px;
        border-radius: 10px;
        font-size: 14px;
        font-weight: 600;
        box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        z-index: 9999;
    `;
    refreshBadge.textContent = 'Auto refresh in 5s...';
    document.body.appendChild(refreshBadge);

    const timer = setInterval(() => {
        countdown--;
        refreshBadge.textContent = 'Auto refresh in ' + countdown + 's...';
        if(countdown <= 0) {
            clearInterval(timer);
            location.reload();
        }
    }, 1000);
</script>

</body>
</html>