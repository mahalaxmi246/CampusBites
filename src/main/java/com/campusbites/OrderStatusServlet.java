package com.campusbites;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;

@WebServlet("/OrderStatusServlet")
public class OrderStatusServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String orderId = request.getParameter("orderId");

        // SSE Headers
        response.setContentType("text/event-stream");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Cache-Control", "no-cache");
        response.setHeader("Connection", "keep-alive");
        response.setHeader("Access-Control-Allow-Origin", "*");

        PrintWriter writer = response.getWriter();

        String lastStatus = "";
        int retries = 0;
        int maxRetries = 60; // Keep connection for 60 checks (5 mins)

        while (retries < maxRetries) {
            try {
                Connection conn = DBConnection.getConnection();
                String sql = "SELECT status, token_number, " +
                           "(SELECT COUNT(*) FROM orders WHERE status='Placed' " +
                           "AND id < ?) as queue_position " +
                           "FROM orders WHERE id = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setInt(1, Integer.parseInt(orderId));
                stmt.setInt(2, Integer.parseInt(orderId));
                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
                    String status = rs.getString("status");
                    int token = rs.getInt("token_number");
                    int queuePos = rs.getInt("queue_position");

                    // Only send if status changed
                    if (!status.equals(lastStatus)) {
                        writer.write("data: {\"status\":\"" + status +
                                   "\",\"token\":" + token +
                                   ",\"queue\":" + queuePos + "}\n\n");
                        writer.flush();
                        lastStatus = status;
                    }

                    // If ready, stop sending
                    if (status.equals("Ready")) {
                        writer.write("data: {\"status\":\"Ready\",\"token\":" +
                                   token + ",\"queue\":0,\"done\":true}\n\n");
                        writer.flush();
                        conn.close();
                        break;
                    }
                }

                conn.close();
                Thread.sleep(5000); // Check every 5 seconds
                retries++;

            } catch (Exception e) {
                e.printStackTrace();
                break;
            }
        }

        writer.close();
    }
}