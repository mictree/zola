import { useMutation } from "@tanstack/react-query"
import authService from "../services/authService"

export const useLogin = () => {
    return useMutation((data) => authService.login(data))
}