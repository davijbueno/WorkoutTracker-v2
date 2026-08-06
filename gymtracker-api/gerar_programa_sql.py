#!/usr/bin/env python3
"""
Gera o SQL completo para criar o Programa 16 Semanas V-Taper no Supabase.
Execute: python gerar_programa_sql.py > programa_seed.sql
Depois cole o conteúdo de programa_seed.sql no Supabase SQL Editor.
"""

# ===========================================================================
# DEFINIÇÃO DOS DADOS
# ===========================================================================

USER_EMAIL = "davijbueno@outlook.com"
PROGRAM_NAME = "Programa 16 Semanas — V-Taper"

BLOCKS = [
    # (order, name, start_week, end_week, color, target_reps, target_intensity, rest_seconds)
    (1, "Resistência", 1,  4,  "blue",   "15-25", "50-65% 1RM", 45),
    (2, "Hipertrofia", 5,  10, "yellow", "8-12",  "65-80% 1RM", 75),
    (3, "Força",       11, 15, "red",    "3-6",   "80-92% 1RM", 180),
    (4, "Deload",      16, 16, "gray",   "12-15", "50-60% 1RM", 60),
]

# Splits: (order, letter, description, muscle_groups_array)
SPLITS_META = [
    (1, "A", "Peito + Tríceps",           "{Peito,Tríceps}"),
    (2, "B", "Costas Largura + Bíceps",   "{Costas,Bíceps}"),
    (3, "C", "Ombros",                     "{Ombros,Trapézio}"),
    (4, "D", "Pernas",                     "{Quadríceps,Isquiotibiais,Glúteos,Panturrilha}"),
    (5, "E", "Costas Espessura + Core",   "{Costas,Core}"),
]

# Exercícios por split.
# Cada exercício:
#   name, primary_muscle_group, equipment, exercise_type,
#   configs = [(block_order, sets, reps_str, rest_seconds), ...]
# Se um bloco não aparecer na lista de configs → exercício PULADO naquele bloco
#   (is_included = FALSE implicitamente, inserimos apenas os que aparecem)

SPLITS_DATA = {
    1: [  # Split A — Peito + Tríceps
        {
            "name": "Supino c/ Halteres (plano)",
            "pmg": "Peito", "equip": "dumbbell", "type": "compound",
            "cfg": [(1,3,"20",45),(2,4,"10",75),(3,5,"4",180),(4,2,"15",60)],
        },
        {
            "name": "Supino Inclinado c/ Halteres (30°)",
            "pmg": "Peito", "equip": "dumbbell", "type": "compound",
            "cfg": [(1,3,"18",45),(2,4,"10",75),(3,4,"5",180),(4,2,"12",60)],
        },
        {
            "name": "Crossover na Polia (declinado)",
            "pmg": "Peito", "equip": "cable", "type": "isolation",
            "cfg": [(1,3,"20",30),(2,3,"12",60),(3,3,"8",90),(4,2,"15",45)],
        },
        {
            "name": "Peck Deck / Fly Máquina",
            "pmg": "Peito", "equip": "machine", "type": "isolation",
            "cfg": [(1,3,"20",30),(2,3,"12",60),(4,2,"15",45)],
            # B3 pulado
        },
        {
            "name": "Tríceps Corda (polia alta)",
            "pmg": "Tríceps", "equip": "cable", "type": "isolation",
            "cfg": [(1,3,"20",30),(2,4,"12",60),(3,4,"6",90),(4,2,"15",45)],
        },
        {
            "name": "Tríceps Testa c/ Halteres",
            "pmg": "Tríceps", "equip": "dumbbell", "type": "isolation",
            "cfg": [(1,3,"18",30),(2,3,"10",60),(3,4,"5",120),(4,2,"12",45)],
        },
        {
            "name": "Tríceps Coice c/ Halter",
            "pmg": "Tríceps", "equip": "dumbbell", "type": "isolation",
            "cfg": [(1,3,"15",30),(2,3,"12",60)],
            # B3 e B4 pulados
        },
    ],
    2: [  # Split B — Costas Largura + Bíceps
        {
            "name": "Puxada Frontal (Lat Pulldown)",
            "pmg": "Costas", "equip": "cable", "type": "compound",
            "cfg": [(1,3,"20",45),(2,4,"10",75),(3,5,"4",180),(4,2,"15",60)],
        },
        {
            "name": "Pullover c/ Halter (deitado)",
            "pmg": "Costas", "equip": "dumbbell", "type": "compound",
            "cfg": [(1,3,"18",45),(2,4,"10",75),(3,3,"6",120),(4,2,"12",60)],
        },
        {
            "name": "Remada na Máquina (sentado)",
            "pmg": "Costas", "equip": "machine", "type": "compound",
            "cfg": [(1,3,"20",45),(2,4,"10",75),(4,2,"15",60)],
            # B3 pulado
        },
        {
            "name": "Remada Unilateral c/ Halter",
            "pmg": "Costas", "equip": "dumbbell", "type": "compound",
            "cfg": [(1,3,"18",45),(2,4,"10",75),(3,4,"5",150),(4,2,"12",60)],
        },
        {
            "name": "Puxada Neutra Fechada",
            "pmg": "Costas", "equip": "cable", "type": "compound",
            "cfg": [(1,3,"18",30),(2,3,"12",60)],
            # B3 e B4 pulados
        },
        {
            "name": "Rosca Direta c/ Halteres",
            "pmg": "Bíceps", "equip": "dumbbell", "type": "isolation",
            "cfg": [(1,3,"20",30),(2,3,"12",60),(3,3,"6",90),(4,2,"15",45)],
        },
        {
            "name": "Rosca Martelo",
            "pmg": "Bíceps", "equip": "dumbbell", "type": "isolation",
            "cfg": [(1,3,"18",30),(2,3,"10",60),(3,3,"5",90),(4,2,"12",45)],
        },
        {
            "name": "Rosca Concentrada",
            "pmg": "Bíceps", "equip": "dumbbell", "type": "isolation",
            "cfg": [(1,3,"15",30),(2,3,"12",60)],
            # B3 e B4 pulados
        },
    ],
    3: [  # Split C — Ombros
        {
            "name": "Desenvolvimento c/ Halteres (sentado c/ encosto)",
            "pmg": "Ombros", "equip": "dumbbell", "type": "compound",
            "cfg": [(1,3,"18",45),(2,4,"10",75),(3,5,"4",180),(4,2,"15",60)],
        },
        {
            "name": "Elevação Lateral c/ Halteres",
            "pmg": "Ombros", "equip": "dumbbell", "type": "isolation",
            "cfg": [(1,3,"20",30),(2,4,"12",60),(3,3,"8",90),(4,2,"15",45)],
        },
        {
            "name": "Elevação Lateral na Polia (unilateral)",
            "pmg": "Ombros", "equip": "cable", "type": "isolation",
            "cfg": [(1,3,"20",30),(2,4,"12",60),(4,2,"15",45)],
            # B3 pulado
        },
        {
            "name": "Desenvolvimento na Máquina",
            "pmg": "Ombros", "equip": "machine", "type": "compound",
            "cfg": [(1,3,"18",45),(2,3,"10",75),(3,4,"5",150)],
            # B4 pulado
        },
        {
            "name": "Elevação Frontal c/ Halteres",
            "pmg": "Ombros", "equip": "dumbbell", "type": "isolation",
            "cfg": [(1,3,"18",30),(2,3,"12",60)],
            # B3 e B4 pulados
        },
        {
            "name": "Face Pull na Polia",
            "pmg": "Ombros", "equip": "cable", "type": "isolation",
            "cfg": [(1,3,"20",30),(2,3,"15",45),(3,3,"12",60),(4,2,"15",45)],
        },
        {
            "name": "Encolhimento c/ Halteres",
            "pmg": "Trapézio", "equip": "dumbbell", "type": "isolation",
            "cfg": [(1,3,"20",30),(2,3,"12",60),(3,3,"6",90)],
            # B4 pulado
        },
    ],
    4: [  # Split D — Pernas
        {
            "name": "Leg Press 45°",
            "pmg": "Quadríceps", "equip": "machine", "type": "compound",
            "cfg": [(1,3,"20",45),(2,4,"10",75),(3,5,"4",180),(4,2,"15",60)],
        },
        {
            "name": "Hack Squat na Máquina",
            "pmg": "Quadríceps", "equip": "machine", "type": "compound",
            "cfg": [(1,3,"18",45),(2,4,"10",75),(3,4,"5",180),(4,2,"12",60)],
        },
        {
            "name": "Leg Press Unilateral",
            "pmg": "Quadríceps", "equip": "machine", "type": "isolation",
            "cfg": [(1,3,"15",45),(2,3,"10",75)],
            # B3 e B4 pulados
        },
        {
            "name": "Cadeira Extensora",
            "pmg": "Quadríceps", "equip": "machine", "type": "isolation",
            "cfg": [(1,3,"20",30),(2,4,"12",60),(3,3,"8",90),(4,2,"15",45)],
        },
        {
            "name": "Mesa Flexora (Lying Curl)",
            "pmg": "Isquiotibiais", "equip": "machine", "type": "isolation",
            "cfg": [(1,3,"20",30),(2,4,"12",60),(3,3,"8",90),(4,2,"15",45)],
        },
        {
            "name": "Hip Thrust c/ Barra",
            "pmg": "Glúteos", "equip": "barbell", "type": "compound",
            "cfg": [(1,3,"18",45),(2,4,"10",75),(3,4,"5",150),(4,2,"12",60)],
        },
        {
            "name": "Panturrilha Sentado (máquina)",
            "pmg": "Panturrilha", "equip": "machine", "type": "isolation",
            "cfg": [(1,3,"20",30),(2,4,"15",45),(3,3,"10",60),(4,2,"15",30)],
        },
        {
            "name": "Panturrilha em Pé (máquina)",
            "pmg": "Panturrilha", "equip": "machine", "type": "isolation",
            "cfg": [(1,3,"20",30),(2,3,"15",45)],
            # B3 e B4 pulados
        },
    ],
    5: [  # Split E — Costas Espessura + Core
        {
            "name": "Remada c/ Halteres (peito apoiado no banco inclinado)",
            "pmg": "Costas", "equip": "dumbbell", "type": "compound",
            "cfg": [(1,3,"18",45),(2,4,"10",75),(3,5,"5",180),(4,2,"12",60)],
        },
        {
            "name": "Remada Baixa na Polia (sentado)",
            "pmg": "Costas", "equip": "cable", "type": "compound",
            "cfg": [(1,3,"20",45),(2,4,"10",75),(3,4,"5",150),(4,2,"15",60)],
        },
        {
            "name": "Remada Máquina (peito apoiado)",
            "pmg": "Costas", "equip": "machine", "type": "compound",
            "cfg": [(1,3,"18",45),(2,4,"12",75),(4,2,"15",60)],
            # B3 pulado
        },
        {
            "name": "Face Pull na Polia",  # mesmo exercício do Split C
            "pmg": "Ombros", "equip": "cable", "type": "isolation",
            "cfg": [(1,3,"20",30),(2,3,"15",45),(3,3,"12",60),(4,2,"15",45)],
        },
        {
            "name": "Prancha Frontal",
            "pmg": "Core", "equip": "bodyweight", "type": "isometric",
            "cfg": [(1,3,"30s",30),(2,4,"40s",30),(3,3,"45s",45),(4,2,"30s",30)],
        },
        {
            "name": "Abdominal Infra na Polia (Kneeling Crunch)",
            "pmg": "Core", "equip": "cable", "type": "isolation",
            "cfg": [(1,3,"20",30),(2,4,"15",30),(3,3,"12",30),(4,2,"15",30)],
        },
        {
            "name": "Elevação de Pernas (paralela ou deitado)",
            "pmg": "Core", "equip": "bodyweight", "type": "isolation",
            "cfg": [(1,3,"15",30),(2,4,"12",30),(3,3,"10",45),(4,2,"12",30)],
        },
    ],
}

# Cronograma de treino por bloco
# (block_order, weeks_range, days_per_week, split_orders_per_week)
SCHEDULE = [
    (1, range(1, 5),   4, [1,2,3,4]),      # B1: Resistencia - ABCD
    (2, range(5, 11),  5, [1,2,3,4,5]),    # B2: Hipertrofia - ABCDE
    (3, range(11, 16), 4, [1,2,3,4]),      # B3: Forca       - ABCD
    (4, range(16, 17), 2, [1,2]),          # B4: Deload      - AB
]

# ===========================================================================
# GERAÇÃO DO SQL
# ===========================================================================

def q(s):
    """Escapa aspas simples para SQL."""
    return s.replace("'", "''")

lines = []
out = lines.append

out("-- ==========================================================================")
out("-- PROGRAMA 16 SEMANAS V-TAPER — Seed SQL")
out("-- Cole integralmente no Supabase SQL Editor e clique em RUN")
out("-- ==========================================================================")
out("")
out("DO $$")
out("DECLARE")
out("  v_user_id     INTEGER;")
out("  v_athlete_id  INTEGER;")
out("  v_gym_id      INTEGER;")
out("  v_prog_id     INTEGER;")
out("")
# Block vars
for b in BLOCKS:
    out(f"  v_blk_{b[0]}      INTEGER;   -- bloco {b[1]}")
# Split vars
for s in SPLITS_META:
    out(f"  v_spl_{s[0]}      INTEGER;   -- split {s[1]}")
# Exercise vars (unique names)
seen_exercises = {}
all_exercises = []
ex_var_map = {}  # name → var_name
for split_order, exlist in SPLITS_DATA.items():
    for i, ex in enumerate(exlist):
        name = ex["name"]
        if name not in seen_exercises:
            var = f"v_ex_{len(seen_exercises)+1}"
            seen_exercises[name] = var
            all_exercises.append((var, ex))
        ex_var_map[(split_order, i)] = seen_exercises[name]

for name, (var, ex) in zip(seen_exercises.keys(), [(v, e) for v, e in [(seen_exercises[n], {'name':n}) for n in seen_exercises]]):
    pass
for var_name in seen_exercises.values():
    out(f"  {var_name}    INTEGER;")

out("  v_se_id       INTEGER;   -- split_exercise id (temporário)")
out("  v_day_num     INTEGER := 1;")
out("  v_td_id       INTEGER;   -- training_day id (temporário)")
out("BEGIN")
out("")

# ── Buscar user_id ─────────────────────────────────────────────────────────
out(f"  -- 1. Buscar usuário")
out(f"  SELECT id INTO v_user_id FROM users WHERE email = '{q(USER_EMAIL)}';")
out(f"  IF v_user_id IS NULL THEN")
out(f"    RAISE EXCEPTION 'Usuário {q(USER_EMAIL)} não encontrado';")
out(f"  END IF;")
out("")

# ── Buscar athlete_id ──────────────────────────────────────────────────────
out("  -- 2. Buscar atleta")
out("  SELECT id INTO v_athlete_id FROM athletes WHERE user_id = v_user_id LIMIT 1;")
out("  IF v_athlete_id IS NULL THEN")
out("    RAISE EXCEPTION 'Atleta não encontrado para o usuário';")
out("  END IF;")
out("")

# ── Buscar gym_id ──────────────────────────────────────────────────────────
out("  -- 3. Buscar academia (opcional)")
out("  SELECT id INTO v_gym_id FROM gyms WHERE user_id = v_user_id AND is_active = TRUE LIMIT 1;")
out("")

# ── Criar exercícios ───────────────────────────────────────────────────────
out("  -- 4. Criar exercícios (ON CONFLICT → reaproveita existente)")
for name, var in seen_exercises.items():
    # encontrar dados do exercício
    ex_data = None
    for split_order, exlist in SPLITS_DATA.items():
        for ex in exlist:
            if ex["name"] == name:
                ex_data = ex
                break
        if ex_data:
            break

    out(f"  INSERT INTO exercises (user_id, name, primary_muscle_group, equipment, exercise_type)")
    out(f"  SELECT v_user_id, '{q(name)}', '{q(ex_data['pmg'])}', '{ex_data['equip']}', '{ex_data['type']}'")
    out(f"  WHERE NOT EXISTS (SELECT 1 FROM exercises WHERE user_id = v_user_id AND name = '{q(name)}');")
    out(f"  SELECT id INTO {var} FROM exercises WHERE user_id = v_user_id AND name = '{q(name)}' LIMIT 1;")
out("")

# ── Criar programa ─────────────────────────────────────────────────────────
out("  -- 5. Criar programa")
out(f"  -- Arquivar qualquer programa ativo anterior")
out(f"  UPDATE training_programs SET status = 'archived' WHERE user_id = v_user_id AND status = 'active';")
out("")
out(f"  INSERT INTO training_programs")
out(f"    (user_id, athlete_id, gym_id, name, total_weeks, weekly_training_freq, weekly_cardio_freq, status)")
out(f"  VALUES")
out(f"    (v_user_id, v_athlete_id, v_gym_id, '{q(PROGRAM_NAME)}', 16, 5, 2, 'active')")
out(f"  RETURNING id INTO v_prog_id;")
out("")

# ── Criar blocos ───────────────────────────────────────────────────────────
out("  -- 6. Criar blocos")
for b in BLOCKS:
    order, name, sw, ew, color, tr, ti, rest = b
    out(f"  INSERT INTO training_blocks")
    out(f"    (program_id, block_order, name, start_week, end_week, color, target_reps, target_intensity, default_rest_seconds)")
    out(f"  VALUES")
    out(f"    (v_prog_id, {order}, '{q(name)}', {sw}, {ew}, '{color}', '{q(tr)}', '{q(ti)}', {rest})")
    out(f"  RETURNING id INTO v_blk_{order};")
out("")

# ── Criar splits ───────────────────────────────────────────────────────────
out("  -- 7. Criar splits")
for s in SPLITS_META:
    order, letter, desc, mg = s
    out(f"  INSERT INTO training_splits (program_id, letter, description, muscle_groups, split_order)")
    out(f"  VALUES (v_prog_id, '{letter}', '{q(desc)}', '{mg}', {order})")
    out(f"  RETURNING id INTO v_spl_{order};")
out("")

# ── Criar split_exercises e block_configs ──────────────────────────────────
out("  -- 8. Criar split_exercises e configs por bloco")
for split_order, exlist in SPLITS_DATA.items():
    out(f"  -- Split {SPLITS_META[split_order-1][1]}")
    for ex_order, ex in enumerate(exlist, start=1):
        var = seen_exercises[ex["name"]]
        out(f"  INSERT INTO split_exercises (split_id, exercise_id, exercise_order)")
        out(f"  VALUES (v_spl_{split_order}, {var}, {ex_order})")
        out(f"  RETURNING id INTO v_se_id;")
        # block configs presentes
        block_orders_in_cfg = {cfg[0] for cfg in ex["cfg"]}
        for cfg in ex["cfg"]:
            blk_order, sets, reps, rest = cfg
            out(f"  INSERT INTO split_exercise_block_config")
            out(f"    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)")
            out(f"  VALUES (v_se_id, v_blk_{blk_order}, {sets}, '{q(reps)}', 0, {rest}, TRUE);")
        # blocos que NÃO estão → inserir is_included=FALSE
        for b in BLOCKS:
            if b[0] not in block_orders_in_cfg:
                out(f"  INSERT INTO split_exercise_block_config")
                out(f"    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)")
                out(f"  VALUES (v_se_id, v_blk_{b[0]}, 1, '-', 0, 60, FALSE);")
    out("")

# ── Gerar training_days e training_day_exercises ───────────────────────────
out("  -- 9. Gerar training_days e exercícios de cada dia")
out("  v_day_num := 1;")
out("")

for blk_order, weeks, freq, split_orders in SCHEDULE:
    blk = BLOCKS[blk_order - 1]
    out(f"  -- Bloco {blk_order}: {blk[1]} (semanas {blk[2]}-{blk[3]}, {freq}x/semana)")
    for week in weeks:
        for day_in_week, spl_order in enumerate(split_orders, start=1):
            letter = SPLITS_META[spl_order - 1][1]
            out(f"  -- Semana {week}, Treino {letter}")
            out(f"  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)")
            out(f"  VALUES (v_prog_id, v_spl_{spl_order}, v_blk_{blk_order}, {week}, v_day_num, 'pending')")
            out(f"  RETURNING id INTO v_td_id;")
            # Exercícios deste split e bloco
            exlist = SPLITS_DATA[spl_order]
            for ex_order, ex in enumerate(exlist, start=1):
                # Verificar se tem config para este bloco
                cfg_for_block = next((c for c in ex["cfg"] if c[0] == blk_order), None)
                if cfg_for_block is None:
                    continue  # exercício pulado neste bloco
                _, sets, reps, rest = cfg_for_block
                var = seen_exercises[ex["name"]]
                # precisamos do split_exercise_id — vamos usar subquery
                out(f"  INSERT INTO training_day_exercises")
                out(f"    (training_day_id, split_exercise_id, exercise_id, exercise_order,")
                out(f"     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)")
                out(f"  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,")
                out(f"         {sets}, '{q(reps)}', 0, {rest}")
                out(f"  FROM split_exercises se")
                out(f"  WHERE se.split_id = v_spl_{spl_order} AND se.exercise_id = {var};")
            out(f"  v_day_num := v_day_num + 1;")
    out("")

out("  RAISE NOTICE 'Programa criado com sucesso! ID = %', v_prog_id;")
out("  RAISE NOTICE 'Total de dias gerados: %', v_day_num - 1;")
out("")
out("END $$;")

import sys
sys.stdout.reconfigure(encoding='utf-8')
print("\n".join(lines))
