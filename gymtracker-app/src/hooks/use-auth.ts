import { useMutation, useQueryClient } from '@tanstack/react-query'
import { useNavigate } from 'react-router-dom'
import { authApi } from '@/api/auth'
import { useAuthStore } from '@/stores/auth-store'

export function useLogin() {
  const { setTokens } = useAuthStore()
  const navigate = useNavigate()
  const qc = useQueryClient()

  return useMutation({
    mutationFn: (data: { email: string; password: string }) => authApi.login(data),
    onSuccess: (res) => {
      const { access_token, refresh_token, user } = res.data
      setTokens(access_token, refresh_token, user)
      qc.clear()
      navigate('/')
    },
  })
}

export function useRegister() {
  const navigate = useNavigate()

  return useMutation({
    mutationFn: (data: { email: string; password: string; full_name: string }) =>
      authApi.register(data),
    onSuccess: () => {
      navigate('/login?registered=1')
    },
  })
}

export function useForgotPassword() {
  return useMutation({
    mutationFn: (data: { email: string }) => authApi.esqueciSenha(data),
  })
}

export function useResetPassword() {
  const navigate = useNavigate()

  return useMutation({
    mutationFn: (data: { token: string; password: string }) => authApi.redefinirSenha(data),
    onSuccess: () => {
      navigate('/login')
    },
  })
}

export function useLogout() {
  const { logout } = useAuthStore()
  const navigate = useNavigate()
  const qc = useQueryClient()

  return () => {
    logout()
    qc.clear()
    navigate('/login')
  }
}
