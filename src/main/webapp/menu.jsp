<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Menu - CampusBites</title>
    <link rel="stylesheet" href="./css/style.css">
</head>
<body>

    <%@ include file="navbar.jsp" %>

    <!-- PAGE TITLE -->
    <section class="page-title">
        <h2>Our Menu &#127869;</h2>
        <p>Fresh, hot and ready for you!</p>
    </section>

    <!-- CATEGORY FILTER -->
    <div class="category-filter">
        <button class="filter-btn active" onclick="filterMenu('all')">All</button>
        <button class="filter-btn" onclick="filterMenu('snacks')">🍟 Snacks</button>
        <button class="filter-btn" onclick="filterMenu('meals')">&#127857; Meals</button>
        <button class="filter-btn" onclick="filterMenu('drinks')">&#129380; Drinks</button>
    </div>

    <!-- MENU ITEMS -->
    <section class="menu-grid" id="menu-grid">

        <!-- SNACKS -->
        <div class="menu-card" data-category="snacks">
            <div class="menu-emoji">🍟</div>
            <h3>French Fries</h3>
            <p>Crispy golden fries with ketchup</p>
            <div class="menu-footer">
                <span class="price">&#8377;30</span>
                <button class="add-btn" onclick="addToCart('French Fries', 30)">Add +</button>
            </div>
        </div>

        <div class="menu-card" data-category="snacks">
            <div class="menu-emoji">🥪</div>
            <h3>Veg Sandwich</h3>
            <p>Fresh veggies with toasted bread</p>
            <div class="menu-footer">
                <span class="price">&#8377;40</span>
                <button class="add-btn" onclick="addToCart('Veg Sandwich', 40)">Add +</button>
            </div>
        </div>

        <div class="menu-card" data-category="snacks">
    <div class="menu-emoji">🍕</div>
    <h3>Mini Pizza</h3>
    <p>Cheesy mini pizza with tomato sauce</p>
    <div class="menu-footer">
        <span class="price">Rs.85</span>
        <button class="add-btn" onclick="addToCart('Mini Pizza', 35)">Add +</button>
    </div>
</div>

        <!-- MEALS -->
        <div class="menu-card" data-category="meals">
            <div class="menu-emoji">&#127857;</div>
            <h3>Veg Thali</h3>
            <p>Rice, dal, sabzi, roti and pickle</p>
            <div class="menu-footer">
                <span class="price">&#8377;80</span>
                <button class="add-btn" onclick="addToCart('Veg Thali', 80)">Add +</button>
            </div>
        </div>

        <div class="menu-card" data-category="meals">
            <div class="menu-emoji">&#127835;</div>
            <h3>Chicken Biryani</h3>
            <p>Aromatic basmati rice with chicken</p>
            <div class="menu-footer">
                <span class="price">&#8377;120</span>
                <button class="add-btn" onclick="addToCart('Chicken Biryani', 120)">Add +</button>
            </div>
        </div>

        <div class="menu-card" data-category="meals">
            <div class="menu-emoji">&#127836;</div>
            <h3>Veg Noodles</h3>
            <p>Stir fried noodles with vegetables</p>
            <div class="menu-footer">
                <span class="price">&#8377;60</span>
                <button class="add-btn" onclick="addToCart('Veg Noodles', 60)">Add +</button>
            </div>
        </div>

        <!-- DRINKS -->
        <div class="menu-card" data-category="drinks">
            <div class="menu-emoji">&#9749;</div>
            <h3>Tea</h3>
            <p>Hot masala chai</p>
            <div class="menu-footer">
                <span class="price">&#8377;10</span>
                <button class="add-btn" onclick="addToCart('Tea', 10)">Add +</button>
            </div>
        </div>

        <div class="menu-card" data-category="drinks">
            <div class="menu-emoji">&#129380;</div>
            <h3>Cold Coffee</h3>
            <p>Chilled coffee with milk and ice</p>
            <div class="menu-footer">
                <span class="price">&#8377;40</span>
                <button class="add-btn" onclick="addToCart('Cold Coffee', 40)">Add +</button>
            </div>
        </div>

        <div class="menu-card" data-category="drinks">
            <div class="menu-emoji">&#129347;</div>
            <h3>Juice</h3>
            <p>Fresh seasonal fruit juice</p>
            <div class="menu-footer">
                <span class="price">&#8377;30</span>
                <button class="add-btn" onclick="addToCart('Juice', 30)">Add +</button>
            </div>
        </div>

    </section>

    <!-- FOOTER -->
    <footer>
        <p>&copy; 2024 CampusBites | College Canteen System</p>
    </footer>

    <script src="js/cart.js"></script>
    <script>
        function filterMenu(category) {
            const cards = document.querySelectorAll('.menu-card');
            const buttons = document.querySelectorAll('.filter-btn');

            buttons.forEach(btn => btn.classList.remove('active'));
            event.target.classList.add('active');

            cards.forEach(card => {
                if (category === 'all' || card.dataset.category === category) {
                    card.style.display = 'block';
                } else {
                    card.style.display = 'none';
                }
            });
        }
    </script>
</body>
</html>