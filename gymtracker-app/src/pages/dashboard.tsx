import { useNavigate } from 'react-router-dom'
import { useQuery } from '@tanstack/react-query'
import { Dumbbell, Scale, Flame, TrendingUp, Plus, Target, CheckCircle2, XCircle, Clock } from 'lucide-react'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Badge } from '@/components/ui/badge'
import { PageHeader } from '@/components/layout/page-header'
import { CycleProgressBar } from '@/components/training/progress-bar'
import { BlockBadge } from '@/components/training/block-badge'
import { WeightChart, type WeightPoint } from '@/components/charts/weight-chart'
import { AdherenceChart } from '@/components/charts/adherence-chart'
import { useActiveProgram, useNextDay } from '@/hooks/use-training'
import { medicoesApi } from '@/api/resultados'
import { diasApi } from '@/api/treino'
import { formatDate, formatWeight, cn } from '@/lib/utils'
import { useAuthStore } from '@/stores/auth-store'
import { useAppStore } from '@/stores/app-store'

type DayRow = { status: string; week_number: number; block_name: string; block_color: string }

function kpiColor(pct: number) {
  if (pct >= 80) return 'text-green-400'
  if (pct >= 60) return 'text-yellow-400'
  return 'text-red-400'
}

export default function DashboardPage() {
  const navigate = useNavigate()
  const { user } = useAuthStore()
  const { units } = useAppStore()
  const { data: program, isLoading: loadingProg } = useActiveProgram()
  const { data: nextDay } = useNextDay()

  const { data: medicoes = [] } = useQuery({
    queryKey: ['medicoes-evolucao'],
    queryFn: () => medicoesApi.evolucao().then(r => r.data.data as (WeightPoint & { measurement_date: string })[]),
  })

  const { data: diasStats } = useQuery({
    queryKey: ['dias-stats'],
    queryFn: () =>
      diasApi.list().then(r => {
        const days = r.data.data as DayRow[]
        const completed = days.filter(d => d.status === 'completed').length
        const missed = days.filter(d => d.status === 'missed').length
        const pending = days.filter(d => d.status === 'pending').length
        const total = days.length
        const done = completed + missed
        const adherencePct = done > 0 ? Math.round((completed / done) * 100) : 0
        const currentWeek = days.find(d => d.status === 'in_progress' || d.status === 'pending')?.week_number ?? 1
        const blockInfo = days.find(d => d.status === 'in_progress' || d.status === 'pending')

        // Aderência por semana — apenas semanas com pelo menos 1 treino concluído ou falta
        const weekMap: Record<number, { completed: number; total: number }> = {}
        for (const d of days) {
          if (d.status === 'completed' || d.status === 'missed') {
            if (!weekMap[d.week_number]) weekMap[d.week_number] = { completed: 0, total: 0 }
            weekMap[d.week_number].total++
            if (d.status === 'completed') weekMap[d.week_number].completed++
          }
        }
        const weekStats = Object.entries(weekMap)
          .map(([w, v]) => ({ week_number: parseInt(w), ...v }))
          .sort((a, b) => a.week_number - b.week_number)

        return { completed, missed, pending, total, adherencePct, currentWeek, blockInfo, weekStats }
      }),
    enabled: !!program,
  })

  // Peso: primeiro e último com peso
  const weightHistory = medicoes.filter((m): m is typeof m & WeightPoint => m.weight_kg != null)
  const lastMedicao = weightHistory.at(-1) ?? null
  const firstMedicao = weightHistory.at(0) ?? null
  const weightDelta = lastMedicao && firstMedicao && firstMedicao !== lastMedicao
    ? +(lastMedicao.weight_kg - firstMedicao.weight_kg).toFixed(1)
    : null

  if (loadingProg) {
    return (
      <div className="space-y-4">
        <PageHeader title="Dashboard" />
        <div className="grid gap-4 grid-cols-2">
          {[1, 2, 3, 4].map(i => (
            <Card key={i} className="animate-pulse"><CardContent className="h-24 pt-6" /></Card>
          ))}
        </div>
      </div>
    )
  }

  if (!program) {
    return (
      <div className="space-y-4">
        <PageHeader title="Dashboard" description={`Olá, ${user?.full_name?.split(' ')[0]}!`} />
        <Card className="border-dashed">
          <CardContent className="flex flex-col items-center justify-center py-12 text-center">
            <Dumbbell className="h-12 w-12 text-muted-foreground mb-4" />
            <h3 className="font-semibold mb-2">Nenhum ciclo de treino configurado</h3>
            <p className="text-sm text-muted-foreground mb-4">
              Crie seu primeiro programa de 16 semanas para começar.
            </p>
            <Button onClick={() => navigate('/treino/manutencao')}>Criar Programa</Button>
          </CardContent>
        </Card>
      </div>
    )
  }

  const adherencePct = diasStats?.adherencePct ?? 0
  const completedCount = diasStats?.completed ?? 0
  const missedCount = diasStats?.missed ?? 0
  const pendingCount = diasStats?.pending ?? 0

  return (
    <div className="space-y-5">
      <PageHeader
        title="Dashboard"
        description={`Olá, ${user?.full_name?.split(' ')[0]}!`}
      />

      {/* ── Progresso do ciclo ── */}
      <Card>
        <CardHeader className="pb-2">
          <CardTitle className="text-sm font-medium text-muted-foreground flex items-center gap-2">
            <TrendingUp className="h-4 w-4" />
            Progresso do Ciclo — {program.name}
          </CardTitle>
        </CardHeader>
        <CardContent>
          <CycleProgressBar
            completed={completedCount}
            total={diasStats?.total ?? 0}
            weekNumber={diasStats?.currentWeek ?? 1}
            totalWeeks={program.total_weeks}
            blockName={diasStats?.blockInfo?.block_name ?? '—'}
          />
        </CardContent>
      </Card>

      {/* ── KPI Grid ── */}
      <div className="grid grid-cols-2 gap-3 md:grid-cols-4">

        {/* Próximo treino */}
        <Card className="col-span-2">
          <CardHeader className="pb-2">
            <CardTitle className="text-sm font-medium text-muted-foreground flex items-center gap-2">
              <Dumbbell className="h-4 w-4" />
              Próximo Treino
            </CardTitle>
          </CardHeader>
          <CardContent>
            {nextDay ? (
              <div className="space-y-2">
                <div>
                  <p className="font-semibold leading-tight">
                    Treino {nextDay.letter} — {nextDay.split_description}
                  </p>
                  <p className="text-xs text-muted-foreground">Dia {nextDay.day_number} · Sem. {diasStats?.currentWeek}</p>
                </div>
                {diasStats?.blockInfo && (
                  <BlockBadge color={diasStats.blockInfo.block_color} name={diasStats.blockInfo.block_name} />
                )}
                <Button size="sm" onClick={() => navigate('/treino/execucao')} className="w-full mt-1">
                  {nextDay.status === 'in_progress' ? 'Continuar Treino' : 'Iniciar Treino'}
                </Button>
              </div>
            ) : (
              <div className="text-center py-2 space-y-2">
                <Badge variant="secondary">Ciclo concluído!</Badge>
                <Button variant="outline" size="sm" className="w-full" onClick={() => navigate('/treino/fim-ciclo')}>
                  Ver resumo
                </Button>
              </div>
            )}
          </CardContent>
        </Card>

        {/* Aderência */}
        <Card>
          <CardHeader className="pb-2">
            <CardTitle className="text-sm font-medium text-muted-foreground flex items-center gap-2">
              <Target className="h-4 w-4" />
              Aderência
            </CardTitle>
          </CardHeader>
          <CardContent>
            {diasStats && (completedCount + missedCount) > 0 ? (
              <>
                <p className={cn('text-3xl font-bold', kpiColor(adherencePct))}>
                  {adherencePct}%
                </p>
                <p className="text-xs text-muted-foreground mt-1">
                  {completedCount} de {completedCount + missedCount} treinos
                </p>
              </>
            ) : (
              <p className="text-sm text-muted-foreground">Nenhum treino ainda</p>
            )}
          </CardContent>
        </Card>

        {/* Peso atual */}
        <Card>
          <CardHeader className="pb-2">
            <CardTitle className="text-sm font-medium text-muted-foreground flex items-center gap-2">
              <Scale className="h-4 w-4" />
              Peso Atual
            </CardTitle>
          </CardHeader>
          <CardContent>
            {lastMedicao ? (
              <>
                <p className="text-3xl font-bold">{formatWeight(lastMedicao.weight_kg, units)}</p>
                {weightDelta !== null && (
                  <p className={cn('text-xs mt-1 font-medium',
                    weightDelta < 0 ? 'text-green-400' : weightDelta > 0 ? 'text-orange-400' : 'text-muted-foreground'
                  )}>
                    {weightDelta > 0 ? '+' : ''}{weightDelta} kg desde o início
                  </p>
                )}
                <p className="text-xs text-muted-foreground">{formatDate(lastMedicao.measurement_date)}</p>
              </>
            ) : (
              <>
                <p className="text-sm text-muted-foreground mb-2">Sem medições</p>
                <Button size="sm" variant="outline" className="w-full text-xs h-7"
                  onClick={() => navigate('/treino/resultados/nova')}>
                  <Plus className="h-3 w-3 mr-1" />Registrar
                </Button>
              </>
            )}
          </CardContent>
        </Card>
      </div>

      {/* ── Resumo de status ── */}
      <div className="grid grid-cols-3 gap-3">
        <Card>
          <CardContent className="p-4 flex items-center gap-3">
            <CheckCircle2 className="h-8 w-8 text-green-400 shrink-0" />
            <div>
              <p className="text-2xl font-bold">{completedCount}</p>
              <p className="text-xs text-muted-foreground">Realizados</p>
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="p-4 flex items-center gap-3">
            <XCircle className="h-8 w-8 text-red-400 shrink-0" />
            <div>
              <p className="text-2xl font-bold">{missedCount}</p>
              <p className="text-xs text-muted-foreground">Faltas</p>
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="p-4 flex items-center gap-3">
            <Clock className="h-8 w-8 text-muted-foreground shrink-0" />
            <div>
              <p className="text-2xl font-bold">{pendingCount}</p>
              <p className="text-xs text-muted-foreground">Pendentes</p>
            </div>
          </CardContent>
        </Card>
      </div>

      {/* ── Gráfico: aderência por semana ── */}
      {diasStats && diasStats.weekStats.length > 0 && (
        <Card>
          <CardHeader className="pb-2">
            <CardTitle className="text-sm font-medium text-muted-foreground flex items-center gap-2">
              <Flame className="h-4 w-4" />
              Aderência por Semana
            </CardTitle>
          </CardHeader>
          <CardContent>
            <AdherenceChart data={diasStats.weekStats} />
          </CardContent>
        </Card>
      )}

      {/* ── Gráfico: evolução do peso ── */}
      {weightHistory.length >= 2 && (
        <Card>
          <CardHeader className="pb-2">
            <div className="flex items-center justify-between">
              <CardTitle className="text-sm font-medium text-muted-foreground">Evolução do Peso</CardTitle>
              <Button size="sm" variant="ghost" className="h-7 text-xs"
                onClick={() => navigate('/treino/resultados/nova')}>
                <Plus className="h-3 w-3 mr-1" />Nova medição
              </Button>
            </div>
          </CardHeader>
          <CardContent>
            <WeightChart data={weightHistory.slice(-12)} />
          </CardContent>
        </Card>
      )}

      {/* CTA nova medição se não tem histórico */}
      {lastMedicao && weightHistory.length < 2 && (
        <Card className="border-dashed">
          <CardContent className="flex items-center justify-between p-4">
            <p className="text-sm text-muted-foreground">Registre mais medições para ver o gráfico de peso.</p>
            <Button size="sm" variant="outline" onClick={() => navigate('/treino/resultados/nova')}>
              <Plus className="h-3.5 w-3.5 mr-1" />Registrar
            </Button>
          </CardContent>
        </Card>
      )}
    </div>
  )
}
