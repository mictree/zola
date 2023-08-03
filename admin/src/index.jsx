import React from "react";
import ReactDOM from "react-dom";
import App from "./App";
import { DarkModeContextProvider } from "./context/darkModeContext";
import { ReactQueryDevtools } from '@tanstack/react-query-devtools'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import './index.css'
import { AuthProvider } from "./hooks/useAuth";

const queryClient = new QueryClient();
ReactDOM.render(
  <React.StrictMode>
    <AuthProvider>
    <DarkModeContextProvider>
    <QueryClientProvider client={queryClient}>
      {/* The rest of your application */}
      <QueryClientProvider client={queryClient}>
      <App />
      <ReactQueryDevtools initialIsOpen={false} />
    </QueryClientProvider>
      </QueryClientProvider>
    </DarkModeContextProvider>
    </AuthProvider>
  </React.StrictMode>,
  document.getElementById("root")
);
