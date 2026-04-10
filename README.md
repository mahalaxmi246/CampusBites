# 🍕 CampusBites - College Canteen Food Ordering System

![CampusBites](https://img.shields.io/badge/CampusBites-Food%20Ordering%20System-ff6b35?style=for-the-badge&logo=java)
![Java](https://img.shields.io/badge/Java-Servlets%20%26%20JSP-red?style=for-the-badge&logo=java)
![MySQL](https://img.shields.io/badge/MySQL-Database-blue?style=for-the-badge&logo=mysql)
![Tomcat](https://img.shields.io/badge/Apache-Tomcat%209.0-yellow?style=for-the-badge&logo=apachetomcat)

> A full-stack college canteen food ordering system where students can browse the menu, add items to cart, pay via UPI, get a token number and track their order in real-time — without standing in queue!

---

## 🌟 Features

### 👤 User Features
- ✅ Register & Login with session management
- ✅ Browse menu with category filters (Snacks, Meals, Drinks)
- ✅ Add items to cart with quantity control
- ✅ Dummy UPI / Card / Cash payment
- ✅ Real-time order status tracking (auto updates every 3 seconds!)
- ✅ Unique token number for each order
- ✅ Queue position — see how many orders are ahead of you
- ✅ Order history — view all past orders
- ✅ Profile page with total orders and spending stats
- ✅ Browser notifications when order is ready

### 👨‍🍳 Admin Features
- ✅ Admin dashboard with live order stats
- ✅ View all orders with status badges
- ✅ Update order status (Placed → Preparing → Ready)
- ✅ Auto refreshes every 5 seconds
- ✅ Total orders, placed, preparing, ready counts

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Frontend | HTML, CSS, JavaScript |
| Backend | Java Servlets, JSP |
| Database | MySQL |
| Server | Apache Tomcat 9.0 |
| IDE | Eclipse Enterprise Edition |
| Real-time | HTTP Polling (every 3s) |

---

## ⚙️ Prerequisites

Make sure you have all of these installed before running the project:

| Tool | Version | Download Link |
|---|---|---|
| Java JDK | 11 or higher | https://www.oracle.com/java/technologies/downloads/ |
| Eclipse IDE | Enterprise Edition | https://www.eclipse.org/downloads/ |
| Apache Tomcat | 9.0 | https://tomcat.apache.org/download-90.cgi |
| MySQL | 8.0 | https://dev.mysql.com/downloads/installer/ |
| MySQL Workbench | Latest | Included with MySQL installer |
| Git | Latest | https://git-scm.com/download/win |

---

## 🗄️ Step 1 — Database Setup

### 1.1 Open MySQL Workbench and run this SQL:

```sql
CREATE DATABASE campusbites;
USE campusbites;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fullname VARCHAR(100) NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE menu_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    price DECIMAL(10,2) NOT NULL,
    category VARCHAR(50),
    available BOOLEAN DEFAULT TRUE
);

CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    total_amount DECIMAL(10,2),
    status VARCHAR(50) DEFAULT 'Placed',
    token_number INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    item_name VARCHAR(100),
    price DECIMAL(10,2),
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(id)
);

INSERT INTO menu_items (name, description, price, category) VALUES
('French Fries', 'Crispy golden fries with ketchup', 30, 'snacks'),
('Veg Sandwich', 'Fresh veggies with toasted bread', 40, 'snacks'),
('Mini Pizza', 'Cheesy mini pizza with tomato sauce', 35, 'snacks'),
('Veg Thali', 'Rice, dal, sabzi, roti and pickle', 80, 'meals'),
('Chicken Biryani', 'Aromatic basmati rice with chicken', 120, 'meals'),
('Veg Noodles', 'Stir fried noodles with vegetables', 60, 'meals'),
('Tea', 'Hot masala chai', 10, 'drinks'),
('Cold Coffee', 'Chilled coffee with milk and ice', 40, 'drinks'),
('Juice', 'Fresh seasonal fruit juice', 30, 'drinks');
```

### 1.2 Update your MySQL password in the project

Open this file:
```
src/main/java/com/campusbites/DBConnection.java
```

Find this line and replace with your MySQL root password:
```java
private static final String PASSWORD = "YOUR_MYSQL_PASSWORD";
```

---

## 🚀 Step 2 — Project Setup in Eclipse

### 2.1 Clone the repository

Open Command Prompt and run:
```
git clone https://github.com/mahalaxmi246/CampusBites.git
```

### 2.2 Import into Eclipse

1. Open **Eclipse Enterprise Edition**
2. Go to **File → Import**
3. Select **General → Existing Projects into Workspace**
4. Click **Browse** and select the cloned **CampusBites** folder
5. Click **Finish**

### 2.3 Add required JAR files

Download these 2 JAR files:

**JAR 1 — MySQL Connector:**
- Go to: https://dev.mysql.com/downloads/connector/j/
- Select Platform Independent → Download ZIP
- Extract and find `mysql-connector-j-9.6.0.jar`

**JAR 2 — JSON Library:**
- Download from: https://repo1.maven.org/maven2/org/json/json/20240303/json-20240303.jar

**Add both JARs to project:**
1. Copy both JAR files
2. Paste into: `src/main/webapp/WEB-INF/lib/`
3. In Eclipse, right click each JAR
4. Select **Build Path → Add to Build Path**

---

## ⚙️ Step 3 — Configure Tomcat in Eclipse

### 3.1 Add Tomcat Server

1. Go to **Window → Preferences**
2. Expand **Server → Runtime Environments**
3. Click **Add**
4. Select **Apache Tomcat v9.0**
5. Click **Next**
6. Click **Browse** and select your Tomcat installation folder
   - Usually: `C:\Program Files\Apache Software Foundation\Tomcat 9.0`
7. Click **Finish**

### 3.2 Change Server Location (IMPORTANT!)

1. Go to **Window → Show View → Servers**
2. Double click **Tomcat v9.0**
3. Click **Stop** first if running
4. Under **Server Locations** select:
   - ✅ **Use Tomcat installation**
5. Save **(Ctrl+S)**

### 3.3 Add project to Tomcat

1. Right click **Tomcat v9.0** in Servers tab
2. Click **Add and Remove**
3. Move **CampusBites** to Configured side
4. Click **Finish**

---

## ▶️ Step 4 — Run the Project

1. Right click **Tomcat v9.0** in Servers tab
2. Click **Start**
3. Wait for "Server started" message in Console
4. Open browser and go to:

```
http://localhost:8080/CampusBites/index.jsp
```

---

## 📱 Step 5 — How to Use

### As a Student:
1. Go to `http://localhost:8080/CampusBites/index.jsp`
2. Click **Register** and create your account
3. Login with your credentials
4. Browse **Menu** and add items to cart
5. Click **Proceed to Checkout**
6. Choose payment method (UPI / Card / Cash)
7. Get your **Token Number**
8. Track your order status in real-time!
9. Collect food from counter when status shows **Ready** ✅

### As Admin:
1. Go to `http://localhost:8080/CampusBites/admin.jsp`
2. View all incoming orders in real-time
3. Update order status using the dropdown:
   - **Placed** → Order received
   - **Preparing** → Being cooked
   - **Ready** → Student notified!
4. Dashboard auto-refreshes every 5 seconds!

---

## 📁 Project Structure

```
CampusBites/
├── src/
│   └── main/
│       ├── java/
│       │   └── com/campusbites/
│       │       ├── DBConnection.java          ← Database connection
│       │       ├── RegisterServlet.java       ← User registration
│       │       ├── LoginServlet.java          ← User login
│       │       ├── LogoutServlet.java         ← User logout
│       │       ├── OrderServlet.java          ← Place order
│       │       ├── UpdateOrderServlet.java    ← Admin update status
│       │       └── GetOrderStatusServlet.java ← Real-time polling
│       └── webapp/
│           ├── css/
│           │   └── style.css         ← All styles
│           ├── js/
│           │   └── cart.js           ← Cart logic
│           ├── index.jsp             ← Home page
│           ├── menu.jsp              ← Menu page
│           ├── cart.jsp              ← Cart page
│           ├── Login.jsp             ← Login page
│           ├── register.html         ← Register page
│           ├── navbar.jsp            ← Shared navbar
│           ├── profile.jsp           ← User profile
│           ├── payment.jsp           ← Payment page
│           ├── order-confirmation.jsp← Order confirmation
│           ├── order-status.jsp      ← Real-time tracking
│           ├── order-history.jsp     ← Past orders
│           ├── admin.jsp             ← Admin dashboard
│           └── WEB-INF/
│               ├── lib/
│               │   ├── mysql-connector-j-9.6.0.jar
│               │   └── json-20240303.jar
│               └── web.xml
└── pom.xml
```

---

## 🔧 Common Issues & Fixes

### ❌ Issue 1 — HTTP 404 Not Found
```
The requested resource is not available
```
**Fix:**
1. Right click Tomcat → **Clean**
2. Right click project → **Run As → Run on Server**
3. Try URL: `http://localhost:8080/CampusBites/index.jsp`

---

### ❌ Issue 2 — Database Connection Error
```
Communications link failure
```
**Fix:**
1. Make sure MySQL service is running
2. Open **Services** → Start **MySQL80**
3. Check password in `DBConnection.java` matches your MySQL password

---

### ❌ Issue 3 — Port 8080 Already in Use
```
Address already in use: 8080
```
**Fix:**
1. Double click Tomcat in Servers tab
2. Change HTTP port from **8080** to **8081**
3. Save and restart
4. Access via: `http://localhost:8081/CampusBites/index.jsp`

---

### ❌ Issue 4 — Server Location Greyed Out
**Fix:**
1. Right click Tomcat → **Stop**
2. Right click Tomcat → **Add and Remove** → Remove CampusBites
3. Double click Tomcat → Now change Server Location
4. Re-add CampusBites → Start

---

### ❌ Issue 5 — JAR Not Found / Build Error
**Fix:**
1. Right click JAR in WEB-INF/lib
2. **Build Path → Add to Build Path**
3. Right click project → **Maven → Update Project**

---

### ❌ Issue 6 — Emojis Showing as Boxes
**Fix:**
1. **Window → Preferences → General → Workspace**
2. Set **Text file encoding** to **UTF-8**
3. Restart Tomcat

---

## 🏗️ System Design

```
┌─────────────────────────────────────────────┐
│              Student Browser                 │
│         (HTML + CSS + JavaScript)            │
└──────────────────┬──────────────────────────┘
                   │ HTTP Request
                   ▼
┌─────────────────────────────────────────────┐
│         Apache Tomcat 9.0 (Port 8080)        │
│                                             │
│  ┌─────────────┐    ┌──────────────────┐   │
│  │   Servlets  │    │    JSP Pages     │   │
│  │  (Business  │◄──►│  (Presentation)  │   │
│  │   Logic)    │    │                  │   │
│  └──────┬──────┘    └──────────────────┘   │
│         │                                   │
└─────────┼───────────────────────────────────┘
          │ JDBC
          ▼
┌─────────────────────────────────────────────┐
│              MySQL Database                  │
│  users | menu_items | orders | order_items  │
└─────────────────────────────────────────────┘

Real-time Flow:
Browser → polls GetOrderStatusServlet every 3 seconds
Admin   → dashboard auto-refreshes every 5 seconds
```

---

## 🗺️ Page Flow

```
index.jsp → menu.jsp → cart.jsp → payment.jsp → order-confirmation.jsp
                                                        ↓
                                               order-status.jsp (real-time)
                                               order-history.jsp (all orders)
                                               profile.jsp (user details)
                                               admin.jsp (manage orders)
```

---

## 👩‍💻 Developer

**Mahalaxmi Somisetty**
- GitHub: https://github.com/mahalaxmi246
- Project: CampusBites - College Canteen Food Ordering System
- College: VNRVJIET | IT - R22

---

## 📄 Academic Info

This project covers the following weekly topics from the IT-R22 syllabus:

| Week | Topic | Implemented In |
|---|---|---|
| Week 1-2 | HTML + CSS | All pages styling |
| Week 3 | JavaScript Validation | register.html, Login.jsp |
| Week 4 | Shopping Cart | cart.jsp, cart.js |
| Week 8 | Servlet for data retrieval | GetOrderStatusServlet.java |
| Week 9 | User Authentication | LoginServlet, LogoutServlet |

---

⭐ **If this helped you, give it a star on GitHub!**
