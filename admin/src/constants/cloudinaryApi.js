import axios from "axios";

const cloudinaryApi = axios.create(
    {
        baseURL: import.meta.env.CLOUDINARY_API || "https://api.cloudinary.com/v1_1/du3l8upse/upload"
    }
)

cloudinaryApi.interceptors.request.use(function (config) {
    // Do something before request is sent
    return config;
  }, function (error) {
    // Do something with request error
    return Promise.reject(error);
  });

// Add a response interceptor
cloudinaryApi.interceptors.response.use(function (response) {
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

export default cloudinaryApi