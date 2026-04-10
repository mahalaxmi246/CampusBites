package com.campusbites;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import org.json.*;

@WebServlet("/OrderServlet")
public class OrderServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("user_id");

        if (userId == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        String itemsJson = request.getParameter("items");
        String totalStr = request.getParameter("total");
        double total = Double.parseDouble(totalStr);

        Connection conn = DBConnection.getConnection();

        try {
            // Generate unique token using database sequence
            String tokenSql = "SELECT IFNULL(MAX(token_number), 0) + 1 FROM orders WHERE DATE(created_at) = CURDATE()";
            Statement tokenStmt = conn.createStatement();
            ResultSet tokenRs = tokenStmt.executeQuery(tokenSql);
            int token = 1;
            if(tokenRs.next()) {
                token = tokenRs.getInt(1);
            }

            // Insert order with status Placed
            String orderSql = "INSERT INTO orders (user_id, total_amount, status, token_number) VALUES (?, ?, 'Placed', ?)";
            PreparedStatement orderStmt = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS);
            orderStmt.setInt(1, userId);
            orderStmt.setDouble(2, total);
            orderStmt.setInt(3, token);
            orderStmt.executeUpdate();

            ResultSet generatedKeys = orderStmt.getGeneratedKeys();
            int orderId = 0;
            if (generatedKeys.next()) {
                orderId = generatedKeys.getInt(1);
            }

            // Insert order items
            JSONArray items = new JSONArray(itemsJson);
            String itemSql = "INSERT INTO order_items (order_id, item_name, price, quantity) VALUES (?, ?, ?, ?)";
            PreparedStatement itemStmt = conn.prepareStatement(itemSql);

            for (int i = 0; i < items.length(); i++) {
                JSONObject item = items.getJSONObject(i);
                itemStmt.setInt(1, orderId);
                itemStmt.setString(2, item.getString("name"));
                itemStmt.setDouble(3, item.getDouble("price"));
                itemStmt.setInt(4, item.getInt("qty"));
                itemStmt.executeUpdate();
            }

            conn.close();
            response.sendRedirect("order-confirmation.jsp?token=" + token + "&orderId=" + orderId + "&total=" + total);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("cart.html?error=order");
        }
    }
}