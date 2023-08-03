import api from "../constants/api";
import { LOGIN_LS } from "../constants/localStorage";
import { getLocalStorage } from "../utils/localStorageHandle";

const token = getLocalStorage(LOGIN_LS);

const config = token
  ? {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    }
  : {};

const authService = {
  login(data) {
    return api.post("/admin/auth/login", data);
  },

  getInfo() {
    if(!config)
      return null
    return api.get("/admin/auth/get-info");
  },

  getAccessToken(){
    return api.get("/admin/auth/reset-token");
  },

  changePassword(data) {
    return api.post("/admin/auth/change-password");
  },
};

export default authService;
