package com.campusbites;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;

@WebServlet("/UpdateOrderServlet")
public class UpdateOrderServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String orderId = request.getParameter("orderId");
        String status = request.getParameter("status");

        Connection conn = DBConnection.getConnection();

        try {
            String sql = "UPDATE orders SET status = ? WHERE id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, status);
            stmt.setInt(2, Integer.parseInt(orderId));
            stmt.executeUpdate();
            conn.close();

            response.sendRedirect("admin.jsp");

        } catch(Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin.jsp?error=update");
        }
    }
}