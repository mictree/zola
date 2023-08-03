import api from "../constants/api";
import { LOGIN_LS } from "../constants/localStorage";
import { getLocalStorage } from "../utils/localStorageHandle";

const token = getLocalStorage(LOGIN_LS)
const config = {
    headers:{
        Authorization: `Bearer ${token}`
    }
}

const roomService = {
    getRoom(page=1){
        return api.get(`/admin/room?offset=${page}`, config)
    },
    getRoomById(data){
        return api.get(`/admin/room/${data}`)
    },
    deleteRoomById(data){
        return api.delete(`/admin/room/${data}`)
    },
    hardDeleteRoomById(data){
        return api.delete(`/admin/room/hard-delete/${data}`)
    },
    recoverRoom(data){
        return api.put(`admin/room/recover/${data}`)
    }
}

export default roomService