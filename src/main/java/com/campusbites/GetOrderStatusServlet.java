package com.campusbites;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;


@WebServlet("/GetOrderStatusServlet")
public class GetOrderStatusServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String orderId = request.getParameter("orderId");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Cache-Control", "no-cache");

        PrintWriter out = response.getWriter();

        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT o.status, o.token_number, " +
                        "(SELECT COUNT(*) FROM orders WHERE status='Placed' AND id < ?) as queue_pos " +
                        "FROM orders o WHERE o.id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, Integer.parseInt(orderId));
            stmt.setInt(2, Integer.parseInt(orderId));
            ResultSet rs = stmt.executeQuery();

            if(rs.next()) {
                out.print("{\"status\":\"" + rs.getString("status") +
                         "\",\"token\":" + rs.getInt("token_number") +
                         ",\"queue\":" + rs.getInt("queue_pos") + "}");
            } else {
                out.print("{\"status\":\"Unknown\",\"token\":0,\"queue\":0}");
            }
            conn.close();

        } catch(Exception e) {
            e.printStackTrace();
            out.print("{\"status\":\"Error\",\"token\":0,\"queue\":0}");
        }
    }
}