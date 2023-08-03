import api from "../constants/api";
import { LOGIN_LS } from "../constants/localStorage";
import { getLocalStorage } from "../utils/localStorageHandle";

const token = getLocalStorage(LOGIN_LS)
const config = {
    headers:{
        Authorization: `Bearer ${token}`
    }
}


const userService = {
    getUser(page=1){
        return api.get(`/admin/user?offset=${page}`, config)
    },
    getUserById(data){
        return api.get(`/admin/user/${data}`, config)
    },
    addUser(data){
        return api.post('admin/user/create', data, config)
    },
    updateUser(data){
        return api.put('admin/user/update', data, config)
    },
    deleteUser(id){
        return api.delete('admin/user/'+ id, config)
    },
    hardDeleteUser(id){
        return api.delete('admin/user/hard-delete/'+ id, config)
    },
    recoverUser(id){
        return api.put('admin/user/recover/'+ id, config)
    }
}

export default userService