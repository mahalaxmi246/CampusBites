package com.campusbites;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    private static final String URL = System.getenv("DB_URL") != null 
        ? System.getenv("DB_URL") 
        : "jdbc:mysql://localhost:3306/campusbites"; // fallback for local dev
    
    private static final String USER = System.getenv("DB_USER") != null
        ? System.getenv("DB_USER")
        : "root"; // fallback for local dev
    
    private static final String PASSWORD = System.getenv("DB_PASSWORD");

    public static Connection getConnection() {
        if (PASSWORD == null) {
            System.err.println("ERROR: DB_PASSWORD environment variable not set!");
            return null;
        }
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}