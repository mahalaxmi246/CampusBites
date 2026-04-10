package com.campusbites;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;

@WebServlet("/WaitTimeServlet")
public class WaitTimeServlet extends HttpServlet {

    // Cooking time for each item in minutes
    private int getCookingTime(String itemName) {
        itemName = itemName.toLowerCase();
        if (itemName.contains("tea")) return 2;
        if (itemName.contains("juice")) return 2;
        if (itemName.contains("coffee")) return 3;
        if (itemName.contains("fries")) return 5;
        if (itemName.contains("sandwich")) return 5;
        if (itemName.contains("pizza")) return 7;
        if (itemName.contains("noodles")) return 8;
        if (itemName.contains("thali")) return 10;
        if (itemName.contains("biryani")) return 12;
        return 5; // default
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String orderIdStr = request.getParameter("orderId");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            Connection conn = DBConnection.getConnection();

            // Get current order's items and position
            int orderId = Integer.parseInt(orderIdStr);

            // Get queue position - orders placed before this one
            // that are still Placed or Preparing
            String queueSql = "SELECT o.id, oi.item_name, oi.quantity " +
                             "FROM orders o " +
                             "JOIN order_items oi ON o.id = oi.order_id " +
                             "WHERE o.status IN ('Placed', 'Preparing') " +
                             "AND o.id <= ? " +
                             "ORDER BY o.id ASC";

            PreparedStatement queueStmt = conn.prepareStatement(queueSql);
            queueStmt.setInt(1, orderId);
            ResultSet queueRs = queueStmt.executeQuery();

            // Calculate total cooking workload
            int totalCookingMinutes = 0;
            int ordersAhead = 0;
            int currentOrderId = -1;
            boolean countingAhead = true;

            while(queueRs.next()) {
                int rowOrderId = queueRs.getInt("id");
                String itemName = queueRs.getString("item_name");
                int qty = queueRs.getInt("quantity");
                int cookTime = getCookingTime(itemName);

                if(rowOrderId != orderId && countingAhead) {
                    ordersAhead++;
                    totalCookingMinutes += cookTime * qty;
                }

                if(rowOrderId == orderId) {
                    countingAhead = false;
                }
            }

            // Get current order's own cooking time
            String myOrderSql = "SELECT oi.item_name, oi.quantity, o.status " +
                              "FROM order_items oi " +
                              "JOIN orders o ON oi.order_id = o.id " +
                              "WHERE oi.order_id = ?";
            PreparedStatement myStmt = conn.prepareStatement(myOrderSql);
            myStmt.setInt(1, orderId);
            ResultSet myRs = myStmt.executeQuery();

            int myOrderTime = 0;
            String currentStatus = "Placed";
            while(myRs.next()) {
                myOrderTime = Math.max(myOrderTime,
                    getCookingTime(myRs.getString("item_name")));
                currentStatus = myRs.getString("status");
            }

            // Parallel cooking slots (canteen can cook 3 orders at once)
            int parallelSlots = 3;

            // Calculate wait time
            int waitTime = 0;

            if(currentStatus.equals("Ready")) {
                waitTime = 0;
            } else if(currentStatus.equals("Preparing")) {
                // Already being cooked - just remaining time
                waitTime = myOrderTime / 2; // assume halfway done
            } else {
                // Placed - need to wait for orders ahead + own cooking
                int queueWait = (int) Math.ceil(
                    (double) totalCookingMinutes / parallelSlots);
                waitTime = queueWait + myOrderTime;
            }

            // Minimum 1 min if not ready
            if(!currentStatus.equals("Ready") && waitTime < 1) {
                waitTime = 1;
            }

            // Confidence level based on queue size
            String confidence = ordersAhead <= 2 ? "High" :
                               ordersAhead <= 5 ? "Medium" : "Low";

            // Fun message based on wait time
            String message = waitTime == 0 ? "Your order is Ready!" :
                            waitTime <= 3 ? "Almost ready! Stay close!" :
                            waitTime <= 7 ? "Won't take long!" :
                            waitTime <= 12 ? "Grab a seat, we're on it!" :
                            "Thank you for your patience!";

            conn.close();

            out.print("{" +
                "\"waitTime\":" + waitTime + "," +
                "\"ordersAhead\":" + ordersAhead + "," +
                "\"confidence\":\"" + confidence + "\"," +
                "\"message\":\"" + message + "\"," +
                "\"status\":\"" + currentStatus + "\"," +
                "\"parallelSlots\":" + parallelSlots +
            "}");

        } catch(Exception e) {
            e.printStackTrace();
            out.print("{\"waitTime\":5,\"ordersAhead\":0," +
                     "\"confidence\":\"Medium\",\"message\":\"Calculating...\"," +
                     "\"status\":\"Placed\",\"parallelSlots\":3}");
        }
    }
}