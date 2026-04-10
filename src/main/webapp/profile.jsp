<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.campusbites.DBConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Profile - CampusBites</title>
    <link rel="stylesheet" href="./css/style.css">
</head>
<body>

<%
    // Auth guard - redirect if not logged in
    HttpSession userSession = request.getSession(false);
    if(userSession == null || userSession.getAttribute("user_id") == null) {
        response.sendRedirect("Login.jsp");
        return;
    }

    int userId = (Integer) userSession.getAttribute("user_id");
    String username = (String) userSession.getAttribute("username");
    String fullname = (String) userSession.getAttribute("fullname");

    // Fetch user details from DB
    String email = "";
    String createdAt = "";
    int totalOrders = 0;
    double totalSpent = 0;

    Connection conn = DBConnection.getConnection();
    try {
        // User details
        PreparedStatement stmt = conn.prepareStatement("SELECT * FROM users WHERE id = ?");
        stmt.setInt(1, userId);
        ResultSet rs = stmt.executeQuery();
        if(rs.next()) {
            email = rs.getString("email");
            createdAt = rs.getTimestamp("created_at").toString().substring(0, 10);
        }

        // Order stats
        PreparedStatement statsStmt = conn.prepareStatement(
            "SELECT COUNT(*) as total, IFNULL(SUM(total_amount), 0) as spent FROM orders WHERE user_id = ?");
        statsStmt.setInt(1, userId);
        ResultSet statsRs = statsStmt.executeQuery();
        if(statsRs.next()) {
            totalOrders = statsRs.getInt("total");
            totalSpent = statsRs.getDouble("spent");
        }
        conn.close();
    } catch(Exception e) {
        e.printStackTrace();
    }
%>

    <%@ include file="navbar.jsp" %>

    <section class="page-title">
        <h2>My Profile 👤</h2>
        <p>Welcome back, <%= fullname %>!</p>
    </section>

    <section class="profile-container">

        <!-- PROFILE CARD -->
        <div class="profile-card">
            <div class="profile-avatar">
                <%= fullname.substring(0,1).toUpperCase() %>
            </div>
            <h2><%= fullname %></h2>
            <p class="profile-username">@<%= username %></p>
            <p class="profile-joined">Member since <%= createdAt %></p>

            <!-- STATS -->
            <div class="profile-stats">
                <div class="profile-stat">
                    <h3><%= totalOrders %></h3>
                    <p>Orders</p>
                </div>
                <div class="profile-stat">
                    <h3>₹<%= String.format("%.0f", totalSpent) %></h3>
                    <p>Total Spent</p>
                </div>
            </div>
        </div>

        <!-- DETAILS CARD -->
        <div class="profile-details-card">
            <h3>Account Details</h3>

            <div class="detail-row">
                <span>Full Name</span>
                <span><%= fullname %></span>
            </div>
            <div class="detail-row">
                <span>Username</span>
                <span>@<%= username %></span>
            </div>
            <div class="detail-row">
                <span>Email</span>
                <span><%= email %></span>
            </div>
            <div class="detail-row">
                <span>Member Since</span>
                <span><%= createdAt %></span>
            </div>
            <div class="detail-row">
                <span>Total Orders</span>
                <span><%= totalOrders %> orders</span>
            </div>
            <div class="detail-row">
                <span>Total Spent</span>
                <span>₹<%= String.format("%.0f", totalSpent) %></span>
            </div>

            <div class="profile-actions">
                <a href="order-history.jsp" class="btn">📋 My Orders</a>
                <a href="LogoutServlet" class="btn-outline">🚪 Logout</a>
            </div>
        </div>

    </section>

    <footer>
        <p>© 2024 CampusBites | College Canteen System</p>
    </footer>

    <script src="js/cart.js"></script>
</body>
</html>