import React from "react";
import { Navigate } from "react-router-dom";
import { HOME_PATH, LOGIN_PATH } from "../constants/path";
import { useAuth } from "../hooks/useAuth";

export default function LoginWrapper({ children }) {
  const { user } = useAuth();
  console.log('user', user);
  if (user) return <Navigate to={HOME_PATH}></Navigate>
  else 
  return children
}
