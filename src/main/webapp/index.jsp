<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CampusBites - College Canteen</title>
    <link rel="stylesheet" href="./css/style.css">
</head>
<body>

    <%@ include file="navbar.jsp" %>

    <!-- HERO SECTION -->
    <section class="hero">
        <h1>Welcome to CampusBites &#127829;</h1>
        <p>Order fresh canteen food, skip the queue!</p>
        <a href="menu.jsp" class="btn">Order Now</a>
    </section>

    <!-- FEATURES SECTION -->
    <section class="features">
        <div class="feature-card">
            <h3>&#127828; Fresh Food</h3>
            <p>Hot and freshly prepared canteen meals every day.</p>
        </div>
        <div class="feature-card">
            <h3>&#9889; Quick Order</h3>
            <p>Order online and get a token number instantly.</p>
        </div>
        <div class="feature-card">
            <h3>&#128203; Track Status</h3>
            <p>Know when your food is ready for pickup.</p>
        </div>
    </section>

    <!-- FOOTER -->
    <footer>
        <p>&copy; 2024 CampusBites | College Canteen System</p>
    </footer>

    <script src="js/cart.js"></script>
</body>
</html>