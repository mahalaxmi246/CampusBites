package com.campusbites;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullname = request.getParameter("fullname");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        Connection conn = DBConnection.getConnection();

        try {
            // Check if username already exists
            String checkSql = "SELECT * FROM users WHERE username = ? OR email = ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setString(1, username);
            checkStmt.setString(2, email);
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                // User already exists
                response.sendRedirect("register.html?error=exists");
            } else {
                // Insert new user
                String sql = "INSERT INTO users (fullname, username, email, password) VALUES (?, ?, ?, ?)";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, fullname);
                stmt.setString(2, username);
                stmt.setString(3, email);
                stmt.setString(4, password);
                stmt.executeUpdate();

                response.sendRedirect("login.html?success=registered");
            }

            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("register.html?error=server");
        }
    }
}