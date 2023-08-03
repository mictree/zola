import { useMutation, useQuery } from "@tanstack/react-query";
import roomService from "../services/roomService";
import userService from "../services/userService";

//paginate in useQuery https://tanstack.com/query/v4/docs/guides/paginated-queries
export const useRoom = (page) =>
  useQuery(["rooms", page], () => roomService.getRoom(page), {
    keepPreviousData: true,
  });

export const useRoomDetail = (id) =>
  useQuery(["room-detail", id], () => roomService.getRoomById(id));

export const useDeleteRoom = (id) =>
  useMutation(["delete-room", id], () => roomService.deleteRoomById(id));

  export const useRecoverRoom = (id) =>
  useMutation(["recover-room", id], () => roomService.recoverRoom(id));

// export const useAddUser = () => useMutation(userService.addUser);
