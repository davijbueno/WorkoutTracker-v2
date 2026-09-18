import { useState } from 'react'
import { Link } from 'react-router-dom'
import { Dumbbell, ArrowLeft, MailCheck } from 'lucide-react'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Button } from '@/components/ui/button'
import { useForgotPassword } from '@/hooks/use-auth'
import { toast } from '@/hooks/use-toast'

export default function ForgotPasswordPage() {
  const [email, setEmail] = useState('')
  const [sent, setSent] = useState(false)
  const forgotPassword = useForgotPassword()

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    try {
      await forgotPassword.mutateAsync({ email })
      setSent(true)
    } catch (err: unknown) {
      const msg = (err as { response?: { data?: { error?: string } } })?.response?.data?.error ?? 'Erro ao solicitar redefinição de senha.'
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
          {sent ? (
            <CardContent className="pt-6 flex flex-col items-center text-center gap-3">
              <MailCheck className="h-10 w-10 text-primary" />
              <p className="font-medium">Verifique seu e-mail</p>
              <p className="text-sm text-muted-foreground">
                Se <strong>{email}</strong> estiver cadastrado, enviamos um link para você criar
                uma nova senha. Pode levar alguns minutos para chegar.
              </p>
              <Link to="/login" className="text-sm text-primary hover:underline mt-2">
                Voltar para o login
              </Link>
            </CardContent>
          ) : (
            <>
              <CardHeader>
                <CardTitle>Esqueceu sua senha?</CardTitle>
                <CardDescription>
                  Informe seu e-mail e enviaremos um link para criar uma nova senha.
                </CardDescription>
              </CardHeader>
              <CardContent>
                <form onSubmit={handleSubmit} className="space-y-4">
                  <div>
                    <Label htmlFor="forgot-email">E-mail</Label>
                    <Input
                      id="forgot-email"
                      type="email"
                      required
                      value={email}
                      onChange={e => setEmail(e.target.value)}
                      placeholder="seu@email.com"
                      className="mt-1"
                    />
                  </div>
                  <Button type="submit" className="w-full" disabled={forgotPassword.isPending}>
                    {forgotPassword.isPending ? 'Enviando...' : 'Enviar link de redefinição'}
                  </Button>
                  <Link
                    to="/login"
                    className="flex items-center justify-center gap-1 text-sm text-muted-foreground hover:text-foreground transition-colors"
                  >
                    <ArrowLeft className="h-3.5 w-3.5" />
                    Voltar para o login
                  </Link>
                </form>
              </CardContent>
            </>
          )}
        </Card>
      </div>
    </div>
  )
}
