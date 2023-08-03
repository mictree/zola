import { createContext, useContext, useEffect, useState } from "react";
import authService from "../services/authService";
import { getLocalStorage, setLocalStorage } from "../utils/localStorageHandle";

const Context = createContext({});

const _user = getLocalStorage("user");

export const AuthProvider = ({ children }) => {
  const [user, setUser] = useState(_user);
  useEffect(() => {
    authService.getInfo().then(res=>{
      setUser(res.data)
      setLocalStorage("user", res.data);
    })
    .catch((err) => {
      setUser("")
      localStorage.clear()
    }
    )
  
  }, []);


  const logOut = () => {
    setUser();
    localStorage.clear();
  };
  return (
    <Context.Provider value={{ user, setUser, logOut }}>
      {children}
    </Context.Provider>
  );
};

export const useAuth = () => useContext(Context);
