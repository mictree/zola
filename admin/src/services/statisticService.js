import api from "../constants/api";
import { LOGIN_LS } from "../constants/localStorage";
import { getLocalStorage } from "../utils/localStorageHandle";

const token = getLocalStorage(LOGIN_LS)
const config = token
  ? {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    }
  : {};

const statisticService = {
    getInfo(){
        console.log('auth' ,config)
        return api.get('/admin/statistic/number')
    },
    
    getUserStatistic(){
        if(!config)
            return null
        return api.get('/admin/statistic/user-join-by-mouth')
    },
    getPostStatistic(){
        if(!config)
            return null
        return api.get('/admin/statistic/post-by-mouth')
    },
    getRoomChatStatistic(id){
        if(!config)
            return null
        return api.get('/admin/statistic/room-chat-by-mouth/'+id)
    },

    getAgeStatistic(){
        if(!config)
            return null
        return api.get('/admin/statistic/user-by-age')
    },

    getUserChatStatistic(id){
        if(!config)
            return null
        return api.get('/admin/statistic/user-chat-by-mouth/'+id)
    },

}

export default statisticService