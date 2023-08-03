import { LOGIN_LS } from "../constants/localStorage";
import { getLocalStorage } from "../utils/localStorageHandle";

const token = getLocalStorage(LOGIN_LS);
const authHeader = {
  headers: {
    Authorization: `Bearer ${token}`,
  },
};

export default authHeader;
