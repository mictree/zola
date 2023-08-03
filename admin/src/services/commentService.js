import api from "../constants/api";

const commentService = {
    getComment(page=1){
        return api.get('/admin/comment?offset='+page)
    },

    deleteCommentById(data){
        return api.delete(`/admin/comment/${data}`)
    },
    hardDeleteCommentById(data){
        return api.delete(`/admin/comment/hard-delete/${data}`)
    },
    recoverComment(data){
        return api.put(`admin/comment/recover/${data}`)
    }
}

export default commentService