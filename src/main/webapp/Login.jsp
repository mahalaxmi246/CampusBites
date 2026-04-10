<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Login - CampusBites</title>
<link rel="stylesheet" href="./css/style.css">
</head>
<body>

	<!-- HEADER -->
	<%@ include file="navbar.jsp"%>

	<!-- MESSAGES -->
	<%
	if ("registered".equals(request.getParameter("success"))) {
	%>
	<div class="alert-success">✅ Registration successful! Please
		login.</div>
	<%
	}
	%>
	<%
	if ("invalid".equals(request.getParameter("error"))) {
	%>
	<div class="alert-error">❌ Invalid username or password!</div>
	<%
	}
	%>
	<%
	if ("server".equals(request.getParameter("error"))) {
	%>
	<div class="alert-error">❌ Server error! Please try again.</div>
	<%
	}
	%>

	<!-- LOGIN FORM -->
	<section class="auth-container">
		<div class="auth-card">
			<h2>Welcome Back 👋</h2>
			<p class="auth-subtitle">Login to your CampusBites account</p>

			<div class="form-group">
				<label>Username</label> <input type="text" id="username"
					placeholder="Enter your username"> <span class="error"
					id="username-error"></span>
			</div>

			<div class="form-group">
				<label>Password</label> <input type="password" id="password"
					placeholder="Enter your password"> <span class="error"
					id="password-error"></span>
			</div>

			<button class="auth-btn" onclick="validateLogin()">Login</button>

			<p class="auth-switch">
				Don't have an account? <a href="register.html">Register here</a>
			</p>
		</div>
	</section>

	<!-- FOOTER -->
	<footer>
		<p>© 2026 CampusBites | College Canteen System</p>
	</footer>

	<script src="js/cart.js"></script>
	<script>
        function validateLogin() {
            let valid = true;
            document.querySelectorAll('.error').forEach(e => e.textContent = '');

            const username = document.getElementById('username').value.trim();
            const password = document.getElementById('password').value;

            if (username === '') {
                document.getElementById('username-error').textContent = 'Username is required!';
                valid = false;
            } else if (username.length < 5) {
                document.getElementById('username-error').textContent = 'Username must be at least 5 characters!';
                valid = false;
            }

            if (password === '') {
                document.getElementById('password-error').textContent = 'Password is required!';
                valid = false;
            } else if (password.length < 8) {
                document.getElementById('password-error').textContent = 'Password must be at least 8 characters!';
                valid = false;
            }

            if (valid) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = 'LoginServlet';
                const fields = { username, password };
                Object.entries(fields).forEach(([key, value]) => {
                    const input = document.createElement('input');
                    input.type = 'hidden';
                    input.name = key;
                    input.value = value;
                    form.appendChild(input);
                });
                document.body.appendChild(form);
                form.submit();
            }
        }
    </script>
</body>
</html>