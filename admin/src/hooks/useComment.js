import { useMutation, useQuery } from "@tanstack/react-query";
import commentService from "../services/commentService";

//paginate in useQuery https://tanstack.com/query/v4/docs/guides/paginated-queries
export const useComment = (page) =>
  useQuery(["comments", page], () => commentService.getComment(page), {
    keepPreviousData: true,
  });

export const useDeleteComment = (id) =>
  useMutation(["delete-comment", id], () =>
    commentService.deleteCommentById(id)
  );

export const useRecoverComment = (id) =>
  useMutation(["recover-comment", id], () => commentService.recoverComment(id));

  
export const useHardDeleteComment = (id) =>
  useMutation(["hard-delete-comment", id], () => commentService.recoverComment(id));


// export const useAddUser = () => useMutation(userService.addUser);
