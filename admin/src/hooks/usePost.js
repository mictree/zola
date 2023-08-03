import { useMutation, useQuery } from "@tanstack/react-query";
import postService from "../services/postService";

//paginate in useQuery https://tanstack.com/query/v4/docs/guides/paginated-queries
export const usePost = (page) =>
  useQuery(["posts", page], () => postService.getPost(page), {
    keepPreviousData: true,
  });

export const usePostDetail = (id) =>
  useQuery(["post-detail", id], () => postService.getPostById(id), {
    keepPreviousData: true,
  });

export const useUserLastPost = (id) =>
  useQuery(["user-last-post", id], () => postService.getUserLastPost(id), {
    keepPreviousData: true,
  });

// export const useAddBook = () => useMutation(bookService.addBook);

export const useUpdatePost = () => useMutation(postService.updatePost);
