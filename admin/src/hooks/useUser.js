import { useMutation, useQuery } from "@tanstack/react-query";
import userService from "../services/userService";

//paginate in useQuery https://tanstack.com/query/v4/docs/guides/paginated-queries
export const useUser = (page) =>
  useQuery(["uses", page], () => userService.getUser(page), {
    keepPreviousData: true,
  });

export const useUserDetail = (id) =>
  useQuery(["user-detail", id], () => userService.getUserById(id));

export const useRecoverUser = (id) =>
  useMutation(["user-recover", id], () => userService.recoverUser(id));

export const useDeleteUser = (id) =>
  useMutation(["user-delete", id], () => userService.deleteUser(id));

export const useHardDeleteUser = (id) =>
  useMutation(["user-hard-delete", id], () => userService.hardDeleteUser(id));

export const useAddUser = () => useMutation(userService.addUser);
