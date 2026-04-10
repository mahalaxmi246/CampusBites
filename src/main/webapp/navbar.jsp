<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    HttpSession navSession = request.getSession(false);
    boolean isLoggedIn = navSession != null && navSession.getAttribute("user_id") != null;
    String navFullname = isLoggedIn ? (String) navSession.getAttribute("fullname") : "";
%>
<header>
    <div class="logo">&#127829; CampusBites</div>
    <nav>
        <a href="index.jsp">Home</a>
        <a href="menu.jsp">Menu</a>
        <a href="cart.jsp">&#128722; Cart <span id="cart-count">0</span></a>
        <% if(isLoggedIn) { %>
            <a href="profile.jsp">&#128100; <%= navFullname %></a>
            <a href="LogoutServlet" class="logout-btn">Logout</a>
        <% } else { %>
            <a href="Login.jsp">Login</a>
            <a href="register.html">Register</a>
        <% } %>
    </nav>
</header>