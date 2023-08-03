import api from "../constants/api";
import { LOGIN_LS } from "../constants/localStorage";
import { getLocalStorage } from "../utils/localStorageHandle";

const token = getLocalStorage(LOGIN_LS)
const config = {
    headers:{
        Authorization: `Bearer ${token}`
    }
}

const postService = {
    getPost(page=1){
        return api.get('/admin/post?offset='+page)
    },
    getPostById(data){
        return api.get(`/admin/post/${data}`)
    },
    getUserLastPost(id){
        return api.get(`/admin/post/user-last-post/?userId=${id}`)  
    },
    deletePost(id){
        return api.delete('admin/post/'+id, config)
    },
    hardDeletePost(id){
        return api.delete('admin/post/hard-delete/'+id, config)
    },
    recoverPost(id){
        return api.put('admin/post/recover/'+id, config)
    },
}

export default postService