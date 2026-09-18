import { useState } from 'react'
import { useSearchParams, Link, Navigate } from 'react-router-dom'
import { Dumbbell } from 'lucide-react'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Button } from '@/components/ui/button'
import { useResetPassword } from '@/hooks/use-auth'
import { toast } from '@/hooks/use-toast'

export default function ResetPasswordPage() {
  const [params] = useSearchParams()
  const token = params.get('token')
  const [password, setPassword] = useState('')
  const [confirm, setConfirm] = useState('')
  const resetPassword = useResetPassword()

  // Sem token na URL não tem o que redefinir — volta pro fluxo de solicitar o link.
  if (!token) return <Navigate to="/esqueci-senha" replace />

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    if (password !== confirm) {
      toast({ title: 'Erro', description: 'As senhas não coincidem.', variant: 'destructive' })
      return
    }
    if (password.length < 6) {
      toast({ title: 'Erro', description: 'A senha deve ter ao menos 6 caracteres.', variant: 'destructive' })
      return
    }
    try {
      await resetPassword.mutateAsync({ token, password })
      toast({ title: 'Senha redefinida!', description: 'Faça login com a nova senha.' })
    } catch (err: unknown) {
      const msg = (err as { response?: { data?: { error?: string } } })?.response?.data?.error ?? 'Erro ao redefinir a senha.'
      toast({ title: 'Erro', description: msg, variant: 'destructive' })
    }
  }

  return (
    <div className="min-h-screen flex items-center justify-center bg-background p-4">
      <div className="w-full max-w-sm">
        <div className="flex flex-col items-center mb-8">
          <div className="h-12 w-12 rounded-full bg-primary flex items-center justify-center mb-3">
            <Dumbbell className="h-6 w-6 text-primary-foreground" />
          </div>
          <h1 className="text-2xl font-bold">GymTracker 16W</h1>
          <p className="text-sm text-muted-foreground">Periodização por blocos</p>
        </div>

        <Card>
          <CardHeader>
            <CardTitle>Criar nova senha</CardTitle>
            <CardDescription>Escolha uma nova senha para sua conta.</CardDescription>
          </CardHeader>
          <CardContent>
            <form onSubmit={handleSubmit} className="space-y-4">
              <div>
                <Label htmlFor="reset-password">Nova senha</Label>
                <Input
                  id="reset-password"
                  type="password"
                  required
                  minLength={6}
                  value={password}
                  onChange={e => setPassword(e.target.value)}
                  placeholder="Mínimo 6 caracteres"
                  className="mt-1"
                />
              </div>
              <div>
                <Label htmlFor="reset-confirm">Confirmar nova senha</Label>
                <Input
                  id="reset-confirm"
                  type="password"
                  required
                  value={confirm}
                  onChange={e => setConfirm(e.target.value)}
                  placeholder="••••••"
                  className="mt-1"
                />
              </div>
              <Button type="submit" className="w-full" disabled={resetPassword.isPending}>
                {resetPassword.isPending ? 'Salvando...' : 'Redefinir senha'}
              </Button>
              <Link
                to="/login"
                className="block text-center text-sm text-muted-foreground hover:text-foreground transition-colors"
              >
                Voltar para o login
              </Link>
            </form>
          </CardContent>
        </Card>
      </div>
    </div>
  )
}
