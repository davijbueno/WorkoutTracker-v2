import api from './axios'

export interface LoginData { email: string; password: string }
export interface RegisterData { email: string; password: string; full_name: string }
export interface ForgotPasswordData { email: string }
export interface ResetPasswordData { token: string; password: string }

export const authApi = {
  login: (data: LoginData) => api.post('/auth/login', data),
  register: (data: RegisterData) => api.post('/auth/register', data),
  refresh: (refreshToken: string) =>
    api.post('/auth/refresh', {}, { headers: { Authorization: `Bearer ${refreshToken}` } }),
  me: () => api.get('/auth/me'),
  esqueciSenha: (data: ForgotPasswordData) => api.post('/auth/esqueci-senha', data),
  redefinirSenha: (data: ResetPasswordData) => api.post('/auth/redefinir-senha', data),
}
