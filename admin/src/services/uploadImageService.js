import cloudinaryApi from "../constants/cloudinaryApi";

const config = {
  headers: { "Content-Type": "multipart/form-data" },
};

// ref: https://stackoverflow.com/questions/47630163/axios-post-request-to-send-form-data
const uploadImageService = {
    uploadImage(data) {
        return cloudinaryApi.post("/", data, config);
    },
};

export default uploadImageService;
