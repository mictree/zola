import React from "react";
import { Navigate } from "react-router-dom";
import { LOGIN_PATH } from "../constants/path";
import { useAuth } from "../hooks/useAuth";

export default function ProtectedRoute({ children }) {
  const { user } = useAuth();
  if (!user) return <Navigate to={LOGIN_PATH}></Navigate>
  else 
  return children
}
