import React from "react";
import { Outlet } from "react-router-dom";
import Footer from "../components/Footer/Footer";
import Navbar from "../components/navbar/Navbar";
import ProtectedRoute from "../components/ProtectedRoute";
import Sidebar from "../components/sidebar/Sidebar";
import "./MainLayout.scss";

export default function MainLayout() {


  return (
    <ProtectedRoute>
      <div className="main">
        <Sidebar />
        <div className="container">
          <Navbar />
          <Outlet />
        </div>
      </div>
      <Footer />
    </ProtectedRoute>
  );
}
