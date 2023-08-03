import axios from "axios";
import { getLocalStorage } from "../utils/localStorageHandle";
import { LOGIN_LS } from "./localStorage";

const api = axios.create(
    {
        baseURL: import.meta.env.VITE_HOST,
        withCredentials: true
    }
)

api.interceptors.request.use(function (config) {
    // Do something before request is sent
    let token = getLocalStorage(LOGIN_LS);
    if (token && token != 'undefined') {
      // token = JSON.parse(token);
      config.headers['Authorization'] = `Bearer ${token}`;
    }
    return config;
  }, function (error) {
    // Do something with request error
    return Promise.reject(error);
  });

// Add a response interceptor
api.interceptors.response.use(function (response) {
    // Any status code that lie within the range of 2xx cause this function to trigger
    // Do something with response data
    console.log('res');
    if(response.data)
        return response.data;
    return response
  }, function (error) {
    // Any status codes that falls outside the range of 2xx cause this function to trigger
    // Do something with response error
    return Promise.reject(error);
  });

export default api