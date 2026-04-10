<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Payment - CampusBites</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<%
    HttpSession userSession = request.getSession(false);
    if(userSession == null || userSession.getAttribute("user_id") == null) {
        response.sendRedirect("Login.jsp");
        return;
    }
    String total = request.getParameter("total");
    String items = request.getParameter("items");
    if(total == null) total = "0";
%>

    <%@ include file="navbar.jsp" %>

    <section class="page-title">
        <h2>Complete Payment 💳</h2>
        <p>Choose your preferred payment method</p>
    </section>

    <section class="payment-container">

        <!-- ORDER TOTAL CARD -->
        <div class="payment-total-card">
            <h3>Order Total</h3>
            <div class="big-total">Rs.<%= total %></div>
            <p>Including Rs.5 handling fee</p>
        </div>

        <!-- PAYMENT METHODS -->
        <div class="payment-card">

            <!-- TABS -->
            <div class="payment-tabs">
                <button class="payment-tab active" onclick="showTab('upi')">
                    📱 UPI
                </button>
                <button class="payment-tab" onclick="showTab('card')">
                    💳 Card
                </button>
                <button class="payment-tab" onclick="showTab('cash')">
                    💵 Cash
                </button>
            </div>

            <!-- UPI TAB -->
            <div id="tab-upi" class="tab-content active">
                <div class="upi-options">
                    <button class="upi-app-btn active" onclick="selectUPI(this, 'gpay')">
                        <span>G</span> GPay
                    </button>
                    <button class="upi-app-btn" onclick="selectUPI(this, 'phonepe')">
                        <span style="color:purple;">P</span> PhonePe
                    </button>
                    <button class="upi-app-btn" onclick="selectUPI(this, 'paytm')">
                        <span style="color:blue;">P</span> Paytm
                    </button>
                </div>

                <!-- FAKE QR CODE -->
                <div class="qr-container">
                    <div class="qr-box">
                        <div class="qr-inner">
                            <!-- Fake QR Pattern -->
                            <div class="qr-grid">
                                <div class="qr-block dark"></div>
                                <div class="qr-block dark"></div>
                                <div class="qr-block dark"></div>
                                <div class="qr-block light"></div>
                                <div class="qr-block dark"></div>
                                <div class="qr-block dark"></div>
                                <div class="qr-block dark"></div>
                                <div class="qr-block dark"></div>
                                <div class="qr-block light"></div>
                                <div class="qr-block dark"></div>
                                <div class="qr-block light"></div>
                                <div class="qr-block dark"></div>
                                <div class="qr-block light"></div>
                                <div class="qr-block dark"></div>
                                <div class="qr-block light"></div>
                                <div class="qr-block dark"></div>
                                <div class="qr-block light"></div>
                                <div class="qr-block dark"></div>
                                <div class="qr-block dark"></div>
                                <div class="qr-block light"></div>
                                <div class="qr-block dark"></div>
                                <div class="qr-block dark"></div>
                                <div class="qr-block dark"></div>
                                <div class="qr-block light"></div>
                                <div class="qr-block dark"></div>
                                <div class="qr-block light"></div>
                                <div class="qr-block dark"></div>
                                <div class="qr-block dark"></div>
                                <div class="qr-block light"></div>
                                <div class="qr-block dark"></div>
                                <div class="qr-block dark"></div>
                                <div class="qr-block dark"></div>
                                <div class="qr-block dark"></div>
                                <div class="qr-block light"></div>
                                <div class="qr-block dark"></div>
                                <div class="qr-block light"></div>
                                <div class="qr-block dark"></div>
                                <div class="qr-block light"></div>
                                <div class="qr-block dark"></div>
                                <div class="qr-block dark"></div>
                                <div class="qr-block light"></div>
                                <div class="qr-block dark"></div>
                                <div class="qr-block dark"></div>
                                <div class="qr-block light"></div>
                                <div class="qr-block dark"></div>
                                <div class="qr-block dark"></div>
                                <div class="qr-block dark"></div>
                                <div class="qr-block dark"></div>
                                <div class="qr-block light"></div>
                            </div>
                            <div class="qr-logo">🍕</div>
                        </div>
                    </div>
                    <p class="qr-label">Scan with any UPI app</p>
                    <p class="upi-id">UPI ID: campusbites@upi</p>
                </div>

                <div class="upi-input-group">
                    <p style="text-align:center; color:#888; margin-bottom:15px;">— OR enter UPI ID —</p>
                    <input type="text" id="upi-id-input" placeholder="Enter your UPI ID (e.g. name@upi)" class="upi-input">
                    <button class="auth-btn" onclick="payWithUPI()" style="margin-top:15px;">
                        Pay Rs.<%= total %>
                    </button>
                </div>
            </div>

            <!-- CARD TAB -->
            <div id="tab-card" class="tab-content">
                <div class="form-group">
                    <label>Card Number</label>
                    <input type="text" placeholder="1234 5678 9012 3456"
                           maxlength="19" oninput="formatCard(this)" class="upi-input">
                </div>
                <div style="display:flex; gap:15px;">
                    <div class="form-group" style="flex:1;">
                        <label>Expiry Date</label>
                        <input type="text" placeholder="MM/YY" maxlength="5" class="upi-input">
                    </div>
                    <div class="form-group" style="flex:1;">
                        <label>CVV</label>
                        <input type="password" placeholder="•••" maxlength="3" class="upi-input">
                    </div>
                </div>
                <div class="form-group">
                    <label>Name on Card</label>
                    <input type="text" placeholder="Your full name" class="upi-input">
                </div>
                <button class="auth-btn" onclick="payWithCard()">
                    Pay Rs.<%= total %> Securely
                </button>
            </div>

            <!-- CASH TAB -->
            <div id="tab-cash" class="tab-content">
                <div class="cash-info">
                    <div style="font-size:60px; margin-bottom:20px;">💵</div>
                    <h3>Pay at Counter</h3>
                    <p>Your order will be placed and you can pay Rs.<%= total %> cash at the canteen counter when collecting your food.</p>
                    <div class="cash-note">
                        <strong>Note:</strong> Show your token number at the counter!
                    </div>
                    <button class="auth-btn" style="margin-top:25px;" onclick="payWithCash()">
                        Place Order &amp; Pay at Counter
                    </button>
                </div>
            </div>

        </div>
    </section>

    <!-- PAYMENT SUCCESS MODAL -->
    <div id="payment-modal" class="modal-overlay" style="display:none;">
        <div class="modal-box">
            <div class="modal-icon">✅</div>
            <h2>Payment Successful!</h2>
            <p>Rs.<%= total %> paid successfully</p>
            <p id="modal-method"></p>
            <div class="modal-loader">
                <div class="loader-bar"></div>
            </div>
            <p style="color:#888; font-size:13px;">Placing your order...</p>
        </div>
    </div>

    <footer>
        <p>&copy; 2026 CampusBites | College Canteen System</p>
    </footer>

    <script src="js/cart.js"></script>
    <script>
        const itemsData = '<%= items != null ? items.replace("'", "\\'") : "" %>';
        const totalAmount = '<%= total %>';

        function showTab(tab) {
            document.querySelectorAll('.tab-content').forEach(t => t.classList.remove('active'));
            document.querySelectorAll('.payment-tab').forEach(t => t.classList.remove('active'));
            document.getElementById('tab-' + tab).classList.add('active');
            event.target.classList.add('active');
        }

        function selectUPI(btn, app) {
            document.querySelectorAll('.upi-app-btn').forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
        }

        function formatCard(input) {
            let val = input.value.replace(/\D/g, '').substring(0, 16);
            input.value = val.replace(/(.{4})/g, '$1 ').trim();
        }

        function showSuccessModal(method) {
            document.getElementById('modal-method').textContent = 'via ' + method;
            document.getElementById('payment-modal').style.display = 'flex';

            // Submit order after 2 seconds
            setTimeout(function() {
                submitOrder();
            }, 2000);
        }

        function payWithUPI() {
            const upiId = document.getElementById('upi-id-input').value.trim();
            if(upiId === '') {
                alert('Please enter your UPI ID or scan the QR code!');
                return;
            }
            if(!upiId.includes('@')) {
                alert('Invalid UPI ID! Format: name@upi');
                return;
            }
            showSuccessModal('UPI (' + upiId + ')');
        }

        function payWithCard() {
            showSuccessModal('Credit/Debit Card');
        }

        function payWithCash() {
            showSuccessModal('Cash at Counter');
        }

        function submitOrder() {
            const cart = getCart();
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = 'OrderServlet';

            const itemsInput = document.createElement('input');
            itemsInput.type = 'hidden';
            itemsInput.name = 'items';
            itemsInput.value = JSON.stringify(cart);
            form.appendChild(itemsInput);

            const totalInput = document.createElement('input');
            totalInput.type = 'hidden';
            totalInput.name = 'total';
            totalInput.value = totalAmount;
            form.appendChild(totalInput);

            document.body.appendChild(form);
            form.submit();
        }
    </script>
</body>
</html>