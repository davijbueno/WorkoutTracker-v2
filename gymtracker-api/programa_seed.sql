-- ==========================================================================
-- PROGRAMA 16 SEMANAS V-TAPER — Seed SQL
-- Cole integralmente no Supabase SQL Editor e clique em RUN
-- ==========================================================================

DO $$
DECLARE
  v_user_id     INTEGER;
  v_athlete_id  INTEGER;
  v_gym_id      INTEGER;
  v_prog_id     INTEGER;

  v_blk_1      INTEGER;   -- bloco Resistência
  v_blk_2      INTEGER;   -- bloco Hipertrofia
  v_blk_3      INTEGER;   -- bloco Força
  v_blk_4      INTEGER;   -- bloco Deload
  v_spl_1      INTEGER;   -- split A
  v_spl_2      INTEGER;   -- split B
  v_spl_3      INTEGER;   -- split C
  v_spl_4      INTEGER;   -- split D
  v_spl_5      INTEGER;   -- split E
  v_ex_1    INTEGER;
  v_ex_2    INTEGER;
  v_ex_3    INTEGER;
  v_ex_4    INTEGER;
  v_ex_5    INTEGER;
  v_ex_6    INTEGER;
  v_ex_7    INTEGER;
  v_ex_8    INTEGER;
  v_ex_9    INTEGER;
  v_ex_10    INTEGER;
  v_ex_11    INTEGER;
  v_ex_12    INTEGER;
  v_ex_13    INTEGER;
  v_ex_14    INTEGER;
  v_ex_15    INTEGER;
  v_ex_16    INTEGER;
  v_ex_17    INTEGER;
  v_ex_18    INTEGER;
  v_ex_19    INTEGER;
  v_ex_20    INTEGER;
  v_ex_21    INTEGER;
  v_ex_22    INTEGER;
  v_ex_23    INTEGER;
  v_ex_24    INTEGER;
  v_ex_25    INTEGER;
  v_ex_26    INTEGER;
  v_ex_27    INTEGER;
  v_ex_28    INTEGER;
  v_ex_29    INTEGER;
  v_ex_30    INTEGER;
  v_ex_31    INTEGER;
  v_ex_32    INTEGER;
  v_ex_33    INTEGER;
  v_ex_34    INTEGER;
  v_ex_35    INTEGER;
  v_ex_36    INTEGER;
  v_se_id       INTEGER;   -- split_exercise id (temporário)
  v_day_num     INTEGER := 1;
  v_td_id       INTEGER;   -- training_day id (temporário)
BEGIN

  -- 1. Buscar usuário
  SELECT id INTO v_user_id FROM users WHERE email = 'davijbueno@outlook.com';
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Usuário davijbueno@outlook.com não encontrado';
  END IF;

  -- 2. Buscar atleta
  SELECT id INTO v_athlete_id FROM athletes WHERE user_id = v_user_id LIMIT 1;
  IF v_athlete_id IS NULL THEN
    RAISE EXCEPTION 'Atleta não encontrado para o usuário';
  END IF;

  -- 3. Buscar academia (opcional)
  SELECT id INTO v_gym_id FROM gyms WHERE user_id = v_user_id AND is_active = TRUE LIMIT 1;

  -- 4. Criar exercícios (ON CONFLICT → reaproveita existente)
  INSERT INTO exercises (user_id, name, primary_muscle_group, equipment, exercise_type)
  SELECT v_user_id, 'Supino c/ Halteres (plano)', 'Peito', 'dumbbell', 'compound'
  WHERE NOT EXISTS (SELECT 1 FROM exercises WHERE user_id = v_user_id AND name = 'Supino c/ Halteres (plano)');
  SELECT id INTO v_ex_1 FROM exercises WHERE user_id = v_user_id AND name = 'Supino c/ Halteres (plano)' LIMIT 1;
  INSERT INTO exercises (user_id, name, primary_muscle_group, equipment, exercise_type)
  SELECT v_user_id, 'Supino Inclinado c/ Halteres (30°)', 'Peito', 'dumbbell', 'compound'
  WHERE NOT EXISTS (SELECT 1 FROM exercises WHERE user_id = v_user_id AND name = 'Supino Inclinado c/ Halteres (30°)');
  SELECT id INTO v_ex_2 FROM exercises WHERE user_id = v_user_id AND name = 'Supino Inclinado c/ Halteres (30°)' LIMIT 1;
  INSERT INTO exercises (user_id, name, primary_muscle_group, equipment, exercise_type)
  SELECT v_user_id, 'Crossover na Polia (declinado)', 'Peito', 'cable', 'isolation'
  WHERE NOT EXISTS (SELECT 1 FROM exercises WHERE user_id = v_user_id AND name = 'Crossover na Polia (declinado)');
  SELECT id INTO v_ex_3 FROM exercises WHERE user_id = v_user_id AND name = 'Crossover na Polia (declinado)' LIMIT 1;
  INSERT INTO exercises (user_id, name, primary_muscle_group, equipment, exercise_type)
  SELECT v_user_id, 'Peck Deck / Fly Máquina', 'Peito', 'machine', 'isolation'
  WHERE NOT EXISTS (SELECT 1 FROM exercises WHERE user_id = v_user_id AND name = 'Peck Deck / Fly Máquina');
  SELECT id INTO v_ex_4 FROM exercises WHERE user_id = v_user_id AND name = 'Peck Deck / Fly Máquina' LIMIT 1;
  INSERT INTO exercises (user_id, name, primary_muscle_group, equipment, exercise_type)
  SELECT v_user_id, 'Tríceps Corda (polia alta)', 'Tríceps', 'cable', 'isolation'
  WHERE NOT EXISTS (SELECT 1 FROM exercises WHERE user_id = v_user_id AND name = 'Tríceps Corda (polia alta)');
  SELECT id INTO v_ex_5 FROM exercises WHERE user_id = v_user_id AND name = 'Tríceps Corda (polia alta)' LIMIT 1;
  INSERT INTO exercises (user_id, name, primary_muscle_group, equipment, exercise_type)
  SELECT v_user_id, 'Tríceps Testa c/ Halteres', 'Tríceps', 'dumbbell', 'isolation'
  WHERE NOT EXISTS (SELECT 1 FROM exercises WHERE user_id = v_user_id AND name = 'Tríceps Testa c/ Halteres');
  SELECT id INTO v_ex_6 FROM exercises WHERE user_id = v_user_id AND name = 'Tríceps Testa c/ Halteres' LIMIT 1;
  INSERT INTO exercises (user_id, name, primary_muscle_group, equipment, exercise_type)
  SELECT v_user_id, 'Tríceps Coice c/ Halter', 'Tríceps', 'dumbbell', 'isolation'
  WHERE NOT EXISTS (SELECT 1 FROM exercises WHERE user_id = v_user_id AND name = 'Tríceps Coice c/ Halter');
  SELECT id INTO v_ex_7 FROM exercises WHERE user_id = v_user_id AND name = 'Tríceps Coice c/ Halter' LIMIT 1;
  INSERT INTO exercises (user_id, name, primary_muscle_group, equipment, exercise_type)
  SELECT v_user_id, 'Puxada Frontal (Lat Pulldown)', 'Costas', 'cable', 'compound'
  WHERE NOT EXISTS (SELECT 1 FROM exercises WHERE user_id = v_user_id AND name = 'Puxada Frontal (Lat Pulldown)');
  SELECT id INTO v_ex_8 FROM exercises WHERE user_id = v_user_id AND name = 'Puxada Frontal (Lat Pulldown)' LIMIT 1;
  INSERT INTO exercises (user_id, name, primary_muscle_group, equipment, exercise_type)
  SELECT v_user_id, 'Pullover c/ Halter (deitado)', 'Costas', 'dumbbell', 'compound'
  WHERE NOT EXISTS (SELECT 1 FROM exercises WHERE user_id = v_user_id AND name = 'Pullover c/ Halter (deitado)');
  SELECT id INTO v_ex_9 FROM exercises WHERE user_id = v_user_id AND name = 'Pullover c/ Halter (deitado)' LIMIT 1;
  INSERT INTO exercises (user_id, name, primary_muscle_group, equipment, exercise_type)
  SELECT v_user_id, 'Remada na Máquina (sentado)', 'Costas', 'machine', 'compound'
  WHERE NOT EXISTS (SELECT 1 FROM exercises WHERE user_id = v_user_id AND name = 'Remada na Máquina (sentado)');
  SELECT id INTO v_ex_10 FROM exercises WHERE user_id = v_user_id AND name = 'Remada na Máquina (sentado)' LIMIT 1;
  INSERT INTO exercises (user_id, name, primary_muscle_group, equipment, exercise_type)
  SELECT v_user_id, 'Remada Unilateral c/ Halter', 'Costas', 'dumbbell', 'compound'
  WHERE NOT EXISTS (SELECT 1 FROM exercises WHERE user_id = v_user_id AND name = 'Remada Unilateral c/ Halter');
  SELECT id INTO v_ex_11 FROM exercises WHERE user_id = v_user_id AND name = 'Remada Unilateral c/ Halter' LIMIT 1;
  INSERT INTO exercises (user_id, name, primary_muscle_group, equipment, exercise_type)
  SELECT v_user_id, 'Puxada Neutra Fechada', 'Costas', 'cable', 'compound'
  WHERE NOT EXISTS (SELECT 1 FROM exercises WHERE user_id = v_user_id AND name = 'Puxada Neutra Fechada');
  SELECT id INTO v_ex_12 FROM exercises WHERE user_id = v_user_id AND name = 'Puxada Neutra Fechada' LIMIT 1;
  INSERT INTO exercises (user_id, name, primary_muscle_group, equipment, exercise_type)
  SELECT v_user_id, 'Rosca Direta c/ Halteres', 'Bíceps', 'dumbbell', 'isolation'
  WHERE NOT EXISTS (SELECT 1 FROM exercises WHERE user_id = v_user_id AND name = 'Rosca Direta c/ Halteres');
  SELECT id INTO v_ex_13 FROM exercises WHERE user_id = v_user_id AND name = 'Rosca Direta c/ Halteres' LIMIT 1;
  INSERT INTO exercises (user_id, name, primary_muscle_group, equipment, exercise_type)
  SELECT v_user_id, 'Rosca Martelo', 'Bíceps', 'dumbbell', 'isolation'
  WHERE NOT EXISTS (SELECT 1 FROM exercises WHERE user_id = v_user_id AND name = 'Rosca Martelo');
  SELECT id INTO v_ex_14 FROM exercises WHERE user_id = v_user_id AND name = 'Rosca Martelo' LIMIT 1;
  INSERT INTO exercises (user_id, name, primary_muscle_group, equipment, exercise_type)
  SELECT v_user_id, 'Rosca Concentrada', 'Bíceps', 'dumbbell', 'isolation'
  WHERE NOT EXISTS (SELECT 1 FROM exercises WHERE user_id = v_user_id AND name = 'Rosca Concentrada');
  SELECT id INTO v_ex_15 FROM exercises WHERE user_id = v_user_id AND name = 'Rosca Concentrada' LIMIT 1;
  INSERT INTO exercises (user_id, name, primary_muscle_group, equipment, exercise_type)
  SELECT v_user_id, 'Desenvolvimento c/ Halteres (sentado c/ encosto)', 'Ombros', 'dumbbell', 'compound'
  WHERE NOT EXISTS (SELECT 1 FROM exercises WHERE user_id = v_user_id AND name = 'Desenvolvimento c/ Halteres (sentado c/ encosto)');
  SELECT id INTO v_ex_16 FROM exercises WHERE user_id = v_user_id AND name = 'Desenvolvimento c/ Halteres (sentado c/ encosto)' LIMIT 1;
  INSERT INTO exercises (user_id, name, primary_muscle_group, equipment, exercise_type)
  SELECT v_user_id, 'Elevação Lateral c/ Halteres', 'Ombros', 'dumbbell', 'isolation'
  WHERE NOT EXISTS (SELECT 1 FROM exercises WHERE user_id = v_user_id AND name = 'Elevação Lateral c/ Halteres');
  SELECT id INTO v_ex_17 FROM exercises WHERE user_id = v_user_id AND name = 'Elevação Lateral c/ Halteres' LIMIT 1;
  INSERT INTO exercises (user_id, name, primary_muscle_group, equipment, exercise_type)
  SELECT v_user_id, 'Elevação Lateral na Polia (unilateral)', 'Ombros', 'cable', 'isolation'
  WHERE NOT EXISTS (SELECT 1 FROM exercises WHERE user_id = v_user_id AND name = 'Elevação Lateral na Polia (unilateral)');
  SELECT id INTO v_ex_18 FROM exercises WHERE user_id = v_user_id AND name = 'Elevação Lateral na Polia (unilateral)' LIMIT 1;
  INSERT INTO exercises (user_id, name, primary_muscle_group, equipment, exercise_type)
  SELECT v_user_id, 'Desenvolvimento na Máquina', 'Ombros', 'machine', 'compound'
  WHERE NOT EXISTS (SELECT 1 FROM exercises WHERE user_id = v_user_id AND name = 'Desenvolvimento na Máquina');
  SELECT id INTO v_ex_19 FROM exercises WHERE user_id = v_user_id AND name = 'Desenvolvimento na Máquina' LIMIT 1;
  INSERT INTO exercises (user_id, name, primary_muscle_group, equipment, exercise_type)
  SELECT v_user_id, 'Elevação Frontal c/ Halteres', 'Ombros', 'dumbbell', 'isolation'
  WHERE NOT EXISTS (SELECT 1 FROM exercises WHERE user_id = v_user_id AND name = 'Elevação Frontal c/ Halteres');
  SELECT id INTO v_ex_20 FROM exercises WHERE user_id = v_user_id AND name = 'Elevação Frontal c/ Halteres' LIMIT 1;
  INSERT INTO exercises (user_id, name, primary_muscle_group, equipment, exercise_type)
  SELECT v_user_id, 'Face Pull na Polia', 'Ombros', 'cable', 'isolation'
  WHERE NOT EXISTS (SELECT 1 FROM exercises WHERE user_id = v_user_id AND name = 'Face Pull na Polia');
  SELECT id INTO v_ex_21 FROM exercises WHERE user_id = v_user_id AND name = 'Face Pull na Polia' LIMIT 1;
  INSERT INTO exercises (user_id, name, primary_muscle_group, equipment, exercise_type)
  SELECT v_user_id, 'Encolhimento c/ Halteres', 'Trapézio', 'dumbbell', 'isolation'
  WHERE NOT EXISTS (SELECT 1 FROM exercises WHERE user_id = v_user_id AND name = 'Encolhimento c/ Halteres');
  SELECT id INTO v_ex_22 FROM exercises WHERE user_id = v_user_id AND name = 'Encolhimento c/ Halteres' LIMIT 1;
  INSERT INTO exercises (user_id, name, primary_muscle_group, equipment, exercise_type)
  SELECT v_user_id, 'Leg Press 45°', 'Quadríceps', 'machine', 'compound'
  WHERE NOT EXISTS (SELECT 1 FROM exercises WHERE user_id = v_user_id AND name = 'Leg Press 45°');
  SELECT id INTO v_ex_23 FROM exercises WHERE user_id = v_user_id AND name = 'Leg Press 45°' LIMIT 1;
  INSERT INTO exercises (user_id, name, primary_muscle_group, equipment, exercise_type)
  SELECT v_user_id, 'Hack Squat na Máquina', 'Quadríceps', 'machine', 'compound'
  WHERE NOT EXISTS (SELECT 1 FROM exercises WHERE user_id = v_user_id AND name = 'Hack Squat na Máquina');
  SELECT id INTO v_ex_24 FROM exercises WHERE user_id = v_user_id AND name = 'Hack Squat na Máquina' LIMIT 1;
  INSERT INTO exercises (user_id, name, primary_muscle_group, equipment, exercise_type)
  SELECT v_user_id, 'Leg Press Unilateral', 'Quadríceps', 'machine', 'isolation'
  WHERE NOT EXISTS (SELECT 1 FROM exercises WHERE user_id = v_user_id AND name = 'Leg Press Unilateral');
  SELECT id INTO v_ex_25 FROM exercises WHERE user_id = v_user_id AND name = 'Leg Press Unilateral' LIMIT 1;
  INSERT INTO exercises (user_id, name, primary_muscle_group, equipment, exercise_type)
  SELECT v_user_id, 'Cadeira Extensora', 'Quadríceps', 'machine', 'isolation'
  WHERE NOT EXISTS (SELECT 1 FROM exercises WHERE user_id = v_user_id AND name = 'Cadeira Extensora');
  SELECT id INTO v_ex_26 FROM exercises WHERE user_id = v_user_id AND name = 'Cadeira Extensora' LIMIT 1;
  INSERT INTO exercises (user_id, name, primary_muscle_group, equipment, exercise_type)
  SELECT v_user_id, 'Mesa Flexora (Lying Curl)', 'Isquiotibiais', 'machine', 'isolation'
  WHERE NOT EXISTS (SELECT 1 FROM exercises WHERE user_id = v_user_id AND name = 'Mesa Flexora (Lying Curl)');
  SELECT id INTO v_ex_27 FROM exercises WHERE user_id = v_user_id AND name = 'Mesa Flexora (Lying Curl)' LIMIT 1;
  INSERT INTO exercises (user_id, name, primary_muscle_group, equipment, exercise_type)
  SELECT v_user_id, 'Hip Thrust c/ Barra', 'Glúteos', 'barbell', 'compound'
  WHERE NOT EXISTS (SELECT 1 FROM exercises WHERE user_id = v_user_id AND name = 'Hip Thrust c/ Barra');
  SELECT id INTO v_ex_28 FROM exercises WHERE user_id = v_user_id AND name = 'Hip Thrust c/ Barra' LIMIT 1;
  INSERT INTO exercises (user_id, name, primary_muscle_group, equipment, exercise_type)
  SELECT v_user_id, 'Panturrilha Sentado (máquina)', 'Panturrilha', 'machine', 'isolation'
  WHERE NOT EXISTS (SELECT 1 FROM exercises WHERE user_id = v_user_id AND name = 'Panturrilha Sentado (máquina)');
  SELECT id INTO v_ex_29 FROM exercises WHERE user_id = v_user_id AND name = 'Panturrilha Sentado (máquina)' LIMIT 1;
  INSERT INTO exercises (user_id, name, primary_muscle_group, equipment, exercise_type)
  SELECT v_user_id, 'Panturrilha em Pé (máquina)', 'Panturrilha', 'machine', 'isolation'
  WHERE NOT EXISTS (SELECT 1 FROM exercises WHERE user_id = v_user_id AND name = 'Panturrilha em Pé (máquina)');
  SELECT id INTO v_ex_30 FROM exercises WHERE user_id = v_user_id AND name = 'Panturrilha em Pé (máquina)' LIMIT 1;
  INSERT INTO exercises (user_id, name, primary_muscle_group, equipment, exercise_type)
  SELECT v_user_id, 'Remada c/ Halteres (peito apoiado no banco inclinado)', 'Costas', 'dumbbell', 'compound'
  WHERE NOT EXISTS (SELECT 1 FROM exercises WHERE user_id = v_user_id AND name = 'Remada c/ Halteres (peito apoiado no banco inclinado)');
  SELECT id INTO v_ex_31 FROM exercises WHERE user_id = v_user_id AND name = 'Remada c/ Halteres (peito apoiado no banco inclinado)' LIMIT 1;
  INSERT INTO exercises (user_id, name, primary_muscle_group, equipment, exercise_type)
  SELECT v_user_id, 'Remada Baixa na Polia (sentado)', 'Costas', 'cable', 'compound'
  WHERE NOT EXISTS (SELECT 1 FROM exercises WHERE user_id = v_user_id AND name = 'Remada Baixa na Polia (sentado)');
  SELECT id INTO v_ex_32 FROM exercises WHERE user_id = v_user_id AND name = 'Remada Baixa na Polia (sentado)' LIMIT 1;
  INSERT INTO exercises (user_id, name, primary_muscle_group, equipment, exercise_type)
  SELECT v_user_id, 'Remada Máquina (peito apoiado)', 'Costas', 'machine', 'compound'
  WHERE NOT EXISTS (SELECT 1 FROM exercises WHERE user_id = v_user_id AND name = 'Remada Máquina (peito apoiado)');
  SELECT id INTO v_ex_33 FROM exercises WHERE user_id = v_user_id AND name = 'Remada Máquina (peito apoiado)' LIMIT 1;
  INSERT INTO exercises (user_id, name, primary_muscle_group, equipment, exercise_type)
  SELECT v_user_id, 'Prancha Frontal', 'Core', 'bodyweight', 'isometric'
  WHERE NOT EXISTS (SELECT 1 FROM exercises WHERE user_id = v_user_id AND name = 'Prancha Frontal');
  SELECT id INTO v_ex_34 FROM exercises WHERE user_id = v_user_id AND name = 'Prancha Frontal' LIMIT 1;
  INSERT INTO exercises (user_id, name, primary_muscle_group, equipment, exercise_type)
  SELECT v_user_id, 'Abdominal Infra na Polia (Kneeling Crunch)', 'Core', 'cable', 'isolation'
  WHERE NOT EXISTS (SELECT 1 FROM exercises WHERE user_id = v_user_id AND name = 'Abdominal Infra na Polia (Kneeling Crunch)');
  SELECT id INTO v_ex_35 FROM exercises WHERE user_id = v_user_id AND name = 'Abdominal Infra na Polia (Kneeling Crunch)' LIMIT 1;
  INSERT INTO exercises (user_id, name, primary_muscle_group, equipment, exercise_type)
  SELECT v_user_id, 'Elevação de Pernas (paralela ou deitado)', 'Core', 'bodyweight', 'isolation'
  WHERE NOT EXISTS (SELECT 1 FROM exercises WHERE user_id = v_user_id AND name = 'Elevação de Pernas (paralela ou deitado)');
  SELECT id INTO v_ex_36 FROM exercises WHERE user_id = v_user_id AND name = 'Elevação de Pernas (paralela ou deitado)' LIMIT 1;

  -- 5. Criar programa
  -- Arquivar qualquer programa ativo anterior
  UPDATE training_programs SET status = 'archived' WHERE user_id = v_user_id AND status = 'active';

  INSERT INTO training_programs
    (user_id, athlete_id, gym_id, name, total_weeks, weekly_training_freq, weekly_cardio_freq, status)
  VALUES
    (v_user_id, v_athlete_id, v_gym_id, 'Programa 16 Semanas — V-Taper', 16, 5, 2, 'active')
  RETURNING id INTO v_prog_id;

  -- 6. Criar blocos
  INSERT INTO training_blocks
    (program_id, block_order, name, start_week, end_week, color, target_reps, target_intensity, default_rest_seconds)
  VALUES
    (v_prog_id, 1, 'Resistência', 1, 4, 'blue', '15-25', '50-65% 1RM', 45)
  RETURNING id INTO v_blk_1;
  INSERT INTO training_blocks
    (program_id, block_order, name, start_week, end_week, color, target_reps, target_intensity, default_rest_seconds)
  VALUES
    (v_prog_id, 2, 'Hipertrofia', 5, 10, 'yellow', '8-12', '65-80% 1RM', 75)
  RETURNING id INTO v_blk_2;
  INSERT INTO training_blocks
    (program_id, block_order, name, start_week, end_week, color, target_reps, target_intensity, default_rest_seconds)
  VALUES
    (v_prog_id, 3, 'Força', 11, 15, 'red', '3-6', '80-92% 1RM', 180)
  RETURNING id INTO v_blk_3;
  INSERT INTO training_blocks
    (program_id, block_order, name, start_week, end_week, color, target_reps, target_intensity, default_rest_seconds)
  VALUES
    (v_prog_id, 4, 'Deload', 16, 16, 'gray', '12-15', '50-60% 1RM', 60)
  RETURNING id INTO v_blk_4;

  -- 7. Criar splits
  INSERT INTO training_splits (program_id, letter, description, muscle_groups, split_order)
  VALUES (v_prog_id, 'A', 'Peito + Tríceps', '{Peito,Tríceps}', 1)
  RETURNING id INTO v_spl_1;
  INSERT INTO training_splits (program_id, letter, description, muscle_groups, split_order)
  VALUES (v_prog_id, 'B', 'Costas Largura + Bíceps', '{Costas,Bíceps}', 2)
  RETURNING id INTO v_spl_2;
  INSERT INTO training_splits (program_id, letter, description, muscle_groups, split_order)
  VALUES (v_prog_id, 'C', 'Ombros', '{Ombros,Trapézio}', 3)
  RETURNING id INTO v_spl_3;
  INSERT INTO training_splits (program_id, letter, description, muscle_groups, split_order)
  VALUES (v_prog_id, 'D', 'Pernas', '{Quadríceps,Isquiotibiais,Glúteos,Panturrilha}', 4)
  RETURNING id INTO v_spl_4;
  INSERT INTO training_splits (program_id, letter, description, muscle_groups, split_order)
  VALUES (v_prog_id, 'E', 'Costas Espessura + Core', '{Costas,Core}', 5)
  RETURNING id INTO v_spl_5;

  -- 8. Criar split_exercises e configs por bloco
  -- Split A
  INSERT INTO split_exercises (split_id, exercise_id, exercise_order)
  VALUES (v_spl_1, v_ex_1, 1)
  RETURNING id INTO v_se_id;
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_1, 3, '20', 0, 45, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_2, 4, '10', 0, 75, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_3, 5, '4', 0, 180, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_4, 2, '15', 0, 60, TRUE);
  INSERT INTO split_exercises (split_id, exercise_id, exercise_order)
  VALUES (v_spl_1, v_ex_2, 2)
  RETURNING id INTO v_se_id;
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_1, 3, '18', 0, 45, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_2, 4, '10', 0, 75, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_3, 4, '5', 0, 180, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_4, 2, '12', 0, 60, TRUE);
  INSERT INTO split_exercises (split_id, exercise_id, exercise_order)
  VALUES (v_spl_1, v_ex_3, 3)
  RETURNING id INTO v_se_id;
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_1, 3, '20', 0, 30, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_2, 3, '12', 0, 60, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_3, 3, '8', 0, 90, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_4, 2, '15', 0, 45, TRUE);
  INSERT INTO split_exercises (split_id, exercise_id, exercise_order)
  VALUES (v_spl_1, v_ex_4, 4)
  RETURNING id INTO v_se_id;
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_1, 3, '20', 0, 30, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_2, 3, '12', 0, 60, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_4, 2, '15', 0, 45, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_3, 1, '-', 0, 60, FALSE);
  INSERT INTO split_exercises (split_id, exercise_id, exercise_order)
  VALUES (v_spl_1, v_ex_5, 5)
  RETURNING id INTO v_se_id;
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_1, 3, '20', 0, 30, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_2, 4, '12', 0, 60, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_3, 4, '6', 0, 90, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_4, 2, '15', 0, 45, TRUE);
  INSERT INTO split_exercises (split_id, exercise_id, exercise_order)
  VALUES (v_spl_1, v_ex_6, 6)
  RETURNING id INTO v_se_id;
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_1, 3, '18', 0, 30, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_2, 3, '10', 0, 60, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_3, 4, '5', 0, 120, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_4, 2, '12', 0, 45, TRUE);
  INSERT INTO split_exercises (split_id, exercise_id, exercise_order)
  VALUES (v_spl_1, v_ex_7, 7)
  RETURNING id INTO v_se_id;
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_1, 3, '15', 0, 30, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_2, 3, '12', 0, 60, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_3, 1, '-', 0, 60, FALSE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_4, 1, '-', 0, 60, FALSE);

  -- Split B
  INSERT INTO split_exercises (split_id, exercise_id, exercise_order)
  VALUES (v_spl_2, v_ex_8, 1)
  RETURNING id INTO v_se_id;
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_1, 3, '20', 0, 45, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_2, 4, '10', 0, 75, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_3, 5, '4', 0, 180, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_4, 2, '15', 0, 60, TRUE);
  INSERT INTO split_exercises (split_id, exercise_id, exercise_order)
  VALUES (v_spl_2, v_ex_9, 2)
  RETURNING id INTO v_se_id;
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_1, 3, '18', 0, 45, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_2, 4, '10', 0, 75, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_3, 3, '6', 0, 120, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_4, 2, '12', 0, 60, TRUE);
  INSERT INTO split_exercises (split_id, exercise_id, exercise_order)
  VALUES (v_spl_2, v_ex_10, 3)
  RETURNING id INTO v_se_id;
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_1, 3, '20', 0, 45, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_2, 4, '10', 0, 75, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_4, 2, '15', 0, 60, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_3, 1, '-', 0, 60, FALSE);
  INSERT INTO split_exercises (split_id, exercise_id, exercise_order)
  VALUES (v_spl_2, v_ex_11, 4)
  RETURNING id INTO v_se_id;
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_1, 3, '18', 0, 45, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_2, 4, '10', 0, 75, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_3, 4, '5', 0, 150, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_4, 2, '12', 0, 60, TRUE);
  INSERT INTO split_exercises (split_id, exercise_id, exercise_order)
  VALUES (v_spl_2, v_ex_12, 5)
  RETURNING id INTO v_se_id;
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_1, 3, '18', 0, 30, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_2, 3, '12', 0, 60, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_3, 1, '-', 0, 60, FALSE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_4, 1, '-', 0, 60, FALSE);
  INSERT INTO split_exercises (split_id, exercise_id, exercise_order)
  VALUES (v_spl_2, v_ex_13, 6)
  RETURNING id INTO v_se_id;
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_1, 3, '20', 0, 30, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_2, 3, '12', 0, 60, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_3, 3, '6', 0, 90, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_4, 2, '15', 0, 45, TRUE);
  INSERT INTO split_exercises (split_id, exercise_id, exercise_order)
  VALUES (v_spl_2, v_ex_14, 7)
  RETURNING id INTO v_se_id;
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_1, 3, '18', 0, 30, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_2, 3, '10', 0, 60, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_3, 3, '5', 0, 90, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_4, 2, '12', 0, 45, TRUE);
  INSERT INTO split_exercises (split_id, exercise_id, exercise_order)
  VALUES (v_spl_2, v_ex_15, 8)
  RETURNING id INTO v_se_id;
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_1, 3, '15', 0, 30, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_2, 3, '12', 0, 60, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_3, 1, '-', 0, 60, FALSE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_4, 1, '-', 0, 60, FALSE);

  -- Split C
  INSERT INTO split_exercises (split_id, exercise_id, exercise_order)
  VALUES (v_spl_3, v_ex_16, 1)
  RETURNING id INTO v_se_id;
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_1, 3, '18', 0, 45, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_2, 4, '10', 0, 75, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_3, 5, '4', 0, 180, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_4, 2, '15', 0, 60, TRUE);
  INSERT INTO split_exercises (split_id, exercise_id, exercise_order)
  VALUES (v_spl_3, v_ex_17, 2)
  RETURNING id INTO v_se_id;
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_1, 3, '20', 0, 30, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_2, 4, '12', 0, 60, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_3, 3, '8', 0, 90, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_4, 2, '15', 0, 45, TRUE);
  INSERT INTO split_exercises (split_id, exercise_id, exercise_order)
  VALUES (v_spl_3, v_ex_18, 3)
  RETURNING id INTO v_se_id;
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_1, 3, '20', 0, 30, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_2, 4, '12', 0, 60, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_4, 2, '15', 0, 45, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_3, 1, '-', 0, 60, FALSE);
  INSERT INTO split_exercises (split_id, exercise_id, exercise_order)
  VALUES (v_spl_3, v_ex_19, 4)
  RETURNING id INTO v_se_id;
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_1, 3, '18', 0, 45, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_2, 3, '10', 0, 75, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_3, 4, '5', 0, 150, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_4, 1, '-', 0, 60, FALSE);
  INSERT INTO split_exercises (split_id, exercise_id, exercise_order)
  VALUES (v_spl_3, v_ex_20, 5)
  RETURNING id INTO v_se_id;
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_1, 3, '18', 0, 30, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_2, 3, '12', 0, 60, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_3, 1, '-', 0, 60, FALSE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_4, 1, '-', 0, 60, FALSE);
  INSERT INTO split_exercises (split_id, exercise_id, exercise_order)
  VALUES (v_spl_3, v_ex_21, 6)
  RETURNING id INTO v_se_id;
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_1, 3, '20', 0, 30, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_2, 3, '15', 0, 45, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_3, 3, '12', 0, 60, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_4, 2, '15', 0, 45, TRUE);
  INSERT INTO split_exercises (split_id, exercise_id, exercise_order)
  VALUES (v_spl_3, v_ex_22, 7)
  RETURNING id INTO v_se_id;
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_1, 3, '20', 0, 30, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_2, 3, '12', 0, 60, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_3, 3, '6', 0, 90, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_4, 1, '-', 0, 60, FALSE);

  -- Split D
  INSERT INTO split_exercises (split_id, exercise_id, exercise_order)
  VALUES (v_spl_4, v_ex_23, 1)
  RETURNING id INTO v_se_id;
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_1, 3, '20', 0, 45, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_2, 4, '10', 0, 75, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_3, 5, '4', 0, 180, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_4, 2, '15', 0, 60, TRUE);
  INSERT INTO split_exercises (split_id, exercise_id, exercise_order)
  VALUES (v_spl_4, v_ex_24, 2)
  RETURNING id INTO v_se_id;
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_1, 3, '18', 0, 45, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_2, 4, '10', 0, 75, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_3, 4, '5', 0, 180, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_4, 2, '12', 0, 60, TRUE);
  INSERT INTO split_exercises (split_id, exercise_id, exercise_order)
  VALUES (v_spl_4, v_ex_25, 3)
  RETURNING id INTO v_se_id;
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_1, 3, '15', 0, 45, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_2, 3, '10', 0, 75, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_3, 1, '-', 0, 60, FALSE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_4, 1, '-', 0, 60, FALSE);
  INSERT INTO split_exercises (split_id, exercise_id, exercise_order)
  VALUES (v_spl_4, v_ex_26, 4)
  RETURNING id INTO v_se_id;
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_1, 3, '20', 0, 30, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_2, 4, '12', 0, 60, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_3, 3, '8', 0, 90, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_4, 2, '15', 0, 45, TRUE);
  INSERT INTO split_exercises (split_id, exercise_id, exercise_order)
  VALUES (v_spl_4, v_ex_27, 5)
  RETURNING id INTO v_se_id;
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_1, 3, '20', 0, 30, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_2, 4, '12', 0, 60, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_3, 3, '8', 0, 90, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_4, 2, '15', 0, 45, TRUE);
  INSERT INTO split_exercises (split_id, exercise_id, exercise_order)
  VALUES (v_spl_4, v_ex_28, 6)
  RETURNING id INTO v_se_id;
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_1, 3, '18', 0, 45, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_2, 4, '10', 0, 75, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_3, 4, '5', 0, 150, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_4, 2, '12', 0, 60, TRUE);
  INSERT INTO split_exercises (split_id, exercise_id, exercise_order)
  VALUES (v_spl_4, v_ex_29, 7)
  RETURNING id INTO v_se_id;
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_1, 3, '20', 0, 30, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_2, 4, '15', 0, 45, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_3, 3, '10', 0, 60, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_4, 2, '15', 0, 30, TRUE);
  INSERT INTO split_exercises (split_id, exercise_id, exercise_order)
  VALUES (v_spl_4, v_ex_30, 8)
  RETURNING id INTO v_se_id;
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_1, 3, '20', 0, 30, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_2, 3, '15', 0, 45, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_3, 1, '-', 0, 60, FALSE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_4, 1, '-', 0, 60, FALSE);

  -- Split E
  INSERT INTO split_exercises (split_id, exercise_id, exercise_order)
  VALUES (v_spl_5, v_ex_31, 1)
  RETURNING id INTO v_se_id;
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_1, 3, '18', 0, 45, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_2, 4, '10', 0, 75, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_3, 5, '5', 0, 180, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_4, 2, '12', 0, 60, TRUE);
  INSERT INTO split_exercises (split_id, exercise_id, exercise_order)
  VALUES (v_spl_5, v_ex_32, 2)
  RETURNING id INTO v_se_id;
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_1, 3, '20', 0, 45, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_2, 4, '10', 0, 75, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_3, 4, '5', 0, 150, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_4, 2, '15', 0, 60, TRUE);
  INSERT INTO split_exercises (split_id, exercise_id, exercise_order)
  VALUES (v_spl_5, v_ex_33, 3)
  RETURNING id INTO v_se_id;
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_1, 3, '18', 0, 45, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_2, 4, '12', 0, 75, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_4, 2, '15', 0, 60, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_3, 1, '-', 0, 60, FALSE);
  INSERT INTO split_exercises (split_id, exercise_id, exercise_order)
  VALUES (v_spl_5, v_ex_21, 4)
  RETURNING id INTO v_se_id;
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_1, 3, '20', 0, 30, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_2, 3, '15', 0, 45, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_3, 3, '12', 0, 60, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_4, 2, '15', 0, 45, TRUE);
  INSERT INTO split_exercises (split_id, exercise_id, exercise_order)
  VALUES (v_spl_5, v_ex_34, 5)
  RETURNING id INTO v_se_id;
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_1, 3, '30s', 0, 30, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_2, 4, '40s', 0, 30, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_3, 3, '45s', 0, 45, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_4, 2, '30s', 0, 30, TRUE);
  INSERT INTO split_exercises (split_id, exercise_id, exercise_order)
  VALUES (v_spl_5, v_ex_35, 6)
  RETURNING id INTO v_se_id;
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_1, 3, '20', 0, 30, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_2, 4, '15', 0, 30, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_3, 3, '12', 0, 30, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_4, 2, '15', 0, 30, TRUE);
  INSERT INTO split_exercises (split_id, exercise_id, exercise_order)
  VALUES (v_spl_5, v_ex_36, 7)
  RETURNING id INTO v_se_id;
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_1, 3, '15', 0, 30, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_2, 4, '12', 0, 30, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_3, 3, '10', 0, 45, TRUE);
  INSERT INTO split_exercise_block_config
    (split_exercise_id, block_id, sets, reps, load_kg, rest_seconds, is_included)
  VALUES (v_se_id, v_blk_4, 2, '12', 0, 30, TRUE);

  -- 9. Gerar training_days e exercícios de cada dia
  v_day_num := 1;

  -- Bloco 1: Resistência (semanas 1-4, 4x/semana)
  -- Semana 1, Treino A
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_1, v_blk_1, 1, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_1;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '18', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_2;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_3;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_4;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_5;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '18', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_6;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '15', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_7;
  v_day_num := v_day_num + 1;
  -- Semana 1, Treino B
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_2, v_blk_1, 1, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_8;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '18', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_9;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_10;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '18', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_11;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '18', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_12;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_13;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '18', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_14;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '15', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_15;
  v_day_num := v_day_num + 1;
  -- Semana 1, Treino C
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_3, v_blk_1, 1, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '18', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_16;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_17;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_18;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '18', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_19;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '18', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_20;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_21;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_22;
  v_day_num := v_day_num + 1;
  -- Semana 1, Treino D
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_4, v_blk_1, 1, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_23;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '18', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_24;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '15', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_25;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_26;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_27;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '18', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_28;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_29;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_30;
  v_day_num := v_day_num + 1;
  -- Semana 2, Treino A
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_1, v_blk_1, 2, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_1;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '18', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_2;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_3;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_4;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_5;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '18', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_6;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '15', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_7;
  v_day_num := v_day_num + 1;
  -- Semana 2, Treino B
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_2, v_blk_1, 2, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_8;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '18', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_9;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_10;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '18', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_11;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '18', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_12;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_13;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '18', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_14;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '15', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_15;
  v_day_num := v_day_num + 1;
  -- Semana 2, Treino C
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_3, v_blk_1, 2, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '18', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_16;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_17;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_18;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '18', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_19;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '18', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_20;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_21;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_22;
  v_day_num := v_day_num + 1;
  -- Semana 2, Treino D
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_4, v_blk_1, 2, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_23;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '18', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_24;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '15', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_25;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_26;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_27;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '18', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_28;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_29;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_30;
  v_day_num := v_day_num + 1;
  -- Semana 3, Treino A
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_1, v_blk_1, 3, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_1;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '18', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_2;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_3;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_4;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_5;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '18', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_6;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '15', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_7;
  v_day_num := v_day_num + 1;
  -- Semana 3, Treino B
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_2, v_blk_1, 3, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_8;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '18', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_9;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_10;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '18', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_11;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '18', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_12;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_13;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '18', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_14;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '15', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_15;
  v_day_num := v_day_num + 1;
  -- Semana 3, Treino C
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_3, v_blk_1, 3, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '18', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_16;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_17;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_18;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '18', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_19;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '18', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_20;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_21;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_22;
  v_day_num := v_day_num + 1;
  -- Semana 3, Treino D
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_4, v_blk_1, 3, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_23;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '18', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_24;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '15', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_25;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_26;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_27;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '18', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_28;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_29;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_30;
  v_day_num := v_day_num + 1;
  -- Semana 4, Treino A
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_1, v_blk_1, 4, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_1;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '18', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_2;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_3;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_4;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_5;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '18', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_6;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '15', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_7;
  v_day_num := v_day_num + 1;
  -- Semana 4, Treino B
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_2, v_blk_1, 4, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_8;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '18', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_9;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_10;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '18', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_11;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '18', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_12;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_13;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '18', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_14;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '15', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_15;
  v_day_num := v_day_num + 1;
  -- Semana 4, Treino C
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_3, v_blk_1, 4, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '18', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_16;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_17;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_18;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '18', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_19;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '18', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_20;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_21;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_22;
  v_day_num := v_day_num + 1;
  -- Semana 4, Treino D
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_4, v_blk_1, 4, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_23;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '18', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_24;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '15', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_25;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_26;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_27;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '18', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_28;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_29;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '20', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_30;
  v_day_num := v_day_num + 1;

  -- Bloco 2: Hipertrofia (semanas 5-10, 5x/semana)
  -- Semana 5, Treino A
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_1, v_blk_2, 5, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_1;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_2;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_3;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_4;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_5;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '10', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_6;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_7;
  v_day_num := v_day_num + 1;
  -- Semana 5, Treino B
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_2, v_blk_2, 5, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_8;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_9;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_10;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_11;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_12;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_13;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '10', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_14;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_15;
  v_day_num := v_day_num + 1;
  -- Semana 5, Treino C
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_3, v_blk_2, 5, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_16;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_17;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_18;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_19;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_20;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '15', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_21;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_22;
  v_day_num := v_day_num + 1;
  -- Semana 5, Treino D
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_4, v_blk_2, 5, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_23;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_24;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_25;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_26;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_27;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_28;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '15', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_29;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '15', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_30;
  v_day_num := v_day_num + 1;
  -- Semana 5, Treino E
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_5, v_blk_2, 5, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_5 AND se.exercise_id = v_ex_31;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_5 AND se.exercise_id = v_ex_32;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '12', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_5 AND se.exercise_id = v_ex_33;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '15', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_5 AND se.exercise_id = v_ex_21;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '40s', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_5 AND se.exercise_id = v_ex_34;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '15', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_5 AND se.exercise_id = v_ex_35;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '12', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_5 AND se.exercise_id = v_ex_36;
  v_day_num := v_day_num + 1;
  -- Semana 6, Treino A
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_1, v_blk_2, 6, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_1;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_2;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_3;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_4;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_5;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '10', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_6;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_7;
  v_day_num := v_day_num + 1;
  -- Semana 6, Treino B
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_2, v_blk_2, 6, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_8;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_9;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_10;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_11;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_12;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_13;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '10', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_14;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_15;
  v_day_num := v_day_num + 1;
  -- Semana 6, Treino C
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_3, v_blk_2, 6, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_16;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_17;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_18;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_19;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_20;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '15', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_21;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_22;
  v_day_num := v_day_num + 1;
  -- Semana 6, Treino D
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_4, v_blk_2, 6, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_23;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_24;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_25;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_26;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_27;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_28;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '15', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_29;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '15', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_30;
  v_day_num := v_day_num + 1;
  -- Semana 6, Treino E
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_5, v_blk_2, 6, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_5 AND se.exercise_id = v_ex_31;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_5 AND se.exercise_id = v_ex_32;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '12', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_5 AND se.exercise_id = v_ex_33;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '15', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_5 AND se.exercise_id = v_ex_21;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '40s', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_5 AND se.exercise_id = v_ex_34;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '15', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_5 AND se.exercise_id = v_ex_35;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '12', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_5 AND se.exercise_id = v_ex_36;
  v_day_num := v_day_num + 1;
  -- Semana 7, Treino A
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_1, v_blk_2, 7, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_1;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_2;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_3;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_4;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_5;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '10', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_6;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_7;
  v_day_num := v_day_num + 1;
  -- Semana 7, Treino B
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_2, v_blk_2, 7, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_8;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_9;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_10;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_11;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_12;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_13;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '10', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_14;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_15;
  v_day_num := v_day_num + 1;
  -- Semana 7, Treino C
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_3, v_blk_2, 7, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_16;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_17;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_18;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_19;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_20;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '15', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_21;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_22;
  v_day_num := v_day_num + 1;
  -- Semana 7, Treino D
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_4, v_blk_2, 7, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_23;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_24;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_25;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_26;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_27;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_28;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '15', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_29;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '15', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_30;
  v_day_num := v_day_num + 1;
  -- Semana 7, Treino E
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_5, v_blk_2, 7, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_5 AND se.exercise_id = v_ex_31;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_5 AND se.exercise_id = v_ex_32;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '12', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_5 AND se.exercise_id = v_ex_33;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '15', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_5 AND se.exercise_id = v_ex_21;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '40s', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_5 AND se.exercise_id = v_ex_34;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '15', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_5 AND se.exercise_id = v_ex_35;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '12', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_5 AND se.exercise_id = v_ex_36;
  v_day_num := v_day_num + 1;
  -- Semana 8, Treino A
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_1, v_blk_2, 8, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_1;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_2;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_3;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_4;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_5;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '10', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_6;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_7;
  v_day_num := v_day_num + 1;
  -- Semana 8, Treino B
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_2, v_blk_2, 8, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_8;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_9;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_10;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_11;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_12;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_13;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '10', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_14;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_15;
  v_day_num := v_day_num + 1;
  -- Semana 8, Treino C
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_3, v_blk_2, 8, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_16;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_17;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_18;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_19;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_20;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '15', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_21;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_22;
  v_day_num := v_day_num + 1;
  -- Semana 8, Treino D
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_4, v_blk_2, 8, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_23;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_24;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_25;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_26;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_27;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_28;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '15', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_29;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '15', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_30;
  v_day_num := v_day_num + 1;
  -- Semana 8, Treino E
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_5, v_blk_2, 8, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_5 AND se.exercise_id = v_ex_31;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_5 AND se.exercise_id = v_ex_32;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '12', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_5 AND se.exercise_id = v_ex_33;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '15', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_5 AND se.exercise_id = v_ex_21;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '40s', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_5 AND se.exercise_id = v_ex_34;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '15', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_5 AND se.exercise_id = v_ex_35;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '12', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_5 AND se.exercise_id = v_ex_36;
  v_day_num := v_day_num + 1;
  -- Semana 9, Treino A
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_1, v_blk_2, 9, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_1;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_2;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_3;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_4;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_5;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '10', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_6;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_7;
  v_day_num := v_day_num + 1;
  -- Semana 9, Treino B
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_2, v_blk_2, 9, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_8;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_9;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_10;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_11;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_12;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_13;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '10', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_14;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_15;
  v_day_num := v_day_num + 1;
  -- Semana 9, Treino C
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_3, v_blk_2, 9, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_16;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_17;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_18;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_19;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_20;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '15', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_21;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_22;
  v_day_num := v_day_num + 1;
  -- Semana 9, Treino D
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_4, v_blk_2, 9, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_23;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_24;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_25;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_26;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_27;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_28;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '15', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_29;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '15', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_30;
  v_day_num := v_day_num + 1;
  -- Semana 9, Treino E
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_5, v_blk_2, 9, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_5 AND se.exercise_id = v_ex_31;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_5 AND se.exercise_id = v_ex_32;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '12', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_5 AND se.exercise_id = v_ex_33;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '15', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_5 AND se.exercise_id = v_ex_21;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '40s', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_5 AND se.exercise_id = v_ex_34;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '15', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_5 AND se.exercise_id = v_ex_35;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '12', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_5 AND se.exercise_id = v_ex_36;
  v_day_num := v_day_num + 1;
  -- Semana 10, Treino A
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_1, v_blk_2, 10, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_1;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_2;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_3;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_4;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_5;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '10', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_6;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_7;
  v_day_num := v_day_num + 1;
  -- Semana 10, Treino B
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_2, v_blk_2, 10, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_8;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_9;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_10;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_11;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_12;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_13;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '10', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_14;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_15;
  v_day_num := v_day_num + 1;
  -- Semana 10, Treino C
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_3, v_blk_2, 10, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_16;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_17;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_18;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_19;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_20;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '15', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_21;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_22;
  v_day_num := v_day_num + 1;
  -- Semana 10, Treino D
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_4, v_blk_2, 10, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_23;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_24;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_25;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_26;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_27;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_28;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '15', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_29;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '15', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_30;
  v_day_num := v_day_num + 1;
  -- Semana 10, Treino E
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_5, v_blk_2, 10, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_5 AND se.exercise_id = v_ex_31;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '10', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_5 AND se.exercise_id = v_ex_32;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '12', 0, 75
  FROM split_exercises se
  WHERE se.split_id = v_spl_5 AND se.exercise_id = v_ex_33;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '15', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_5 AND se.exercise_id = v_ex_21;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '40s', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_5 AND se.exercise_id = v_ex_34;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '15', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_5 AND se.exercise_id = v_ex_35;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '12', 0, 30
  FROM split_exercises se
  WHERE se.split_id = v_spl_5 AND se.exercise_id = v_ex_36;
  v_day_num := v_day_num + 1;

  -- Bloco 3: Força (semanas 11-15, 4x/semana)
  -- Semana 11, Treino A
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_1, v_blk_3, 11, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         5, '4', 0, 180
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_1;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '5', 0, 180
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_2;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '8', 0, 90
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_3;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '6', 0, 90
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_5;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '5', 0, 120
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_6;
  v_day_num := v_day_num + 1;
  -- Semana 11, Treino B
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_2, v_blk_3, 11, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         5, '4', 0, 180
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_8;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '6', 0, 120
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_9;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '5', 0, 150
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_11;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '6', 0, 90
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_13;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '5', 0, 90
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_14;
  v_day_num := v_day_num + 1;
  -- Semana 11, Treino C
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_3, v_blk_3, 11, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         5, '4', 0, 180
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_16;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '8', 0, 90
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_17;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '5', 0, 150
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_19;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_21;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '6', 0, 90
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_22;
  v_day_num := v_day_num + 1;
  -- Semana 11, Treino D
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_4, v_blk_3, 11, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         5, '4', 0, 180
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_23;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '5', 0, 180
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_24;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '8', 0, 90
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_26;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '8', 0, 90
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_27;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '5', 0, 150
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_28;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '10', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_29;
  v_day_num := v_day_num + 1;
  -- Semana 12, Treino A
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_1, v_blk_3, 12, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         5, '4', 0, 180
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_1;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '5', 0, 180
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_2;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '8', 0, 90
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_3;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '6', 0, 90
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_5;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '5', 0, 120
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_6;
  v_day_num := v_day_num + 1;
  -- Semana 12, Treino B
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_2, v_blk_3, 12, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         5, '4', 0, 180
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_8;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '6', 0, 120
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_9;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '5', 0, 150
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_11;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '6', 0, 90
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_13;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '5', 0, 90
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_14;
  v_day_num := v_day_num + 1;
  -- Semana 12, Treino C
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_3, v_blk_3, 12, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         5, '4', 0, 180
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_16;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '8', 0, 90
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_17;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '5', 0, 150
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_19;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_21;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '6', 0, 90
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_22;
  v_day_num := v_day_num + 1;
  -- Semana 12, Treino D
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_4, v_blk_3, 12, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         5, '4', 0, 180
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_23;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '5', 0, 180
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_24;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '8', 0, 90
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_26;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '8', 0, 90
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_27;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '5', 0, 150
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_28;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '10', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_29;
  v_day_num := v_day_num + 1;
  -- Semana 13, Treino A
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_1, v_blk_3, 13, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         5, '4', 0, 180
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_1;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '5', 0, 180
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_2;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '8', 0, 90
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_3;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '6', 0, 90
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_5;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '5', 0, 120
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_6;
  v_day_num := v_day_num + 1;
  -- Semana 13, Treino B
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_2, v_blk_3, 13, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         5, '4', 0, 180
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_8;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '6', 0, 120
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_9;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '5', 0, 150
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_11;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '6', 0, 90
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_13;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '5', 0, 90
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_14;
  v_day_num := v_day_num + 1;
  -- Semana 13, Treino C
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_3, v_blk_3, 13, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         5, '4', 0, 180
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_16;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '8', 0, 90
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_17;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '5', 0, 150
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_19;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_21;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '6', 0, 90
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_22;
  v_day_num := v_day_num + 1;
  -- Semana 13, Treino D
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_4, v_blk_3, 13, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         5, '4', 0, 180
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_23;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '5', 0, 180
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_24;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '8', 0, 90
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_26;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '8', 0, 90
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_27;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '5', 0, 150
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_28;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '10', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_29;
  v_day_num := v_day_num + 1;
  -- Semana 14, Treino A
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_1, v_blk_3, 14, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         5, '4', 0, 180
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_1;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '5', 0, 180
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_2;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '8', 0, 90
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_3;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '6', 0, 90
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_5;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '5', 0, 120
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_6;
  v_day_num := v_day_num + 1;
  -- Semana 14, Treino B
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_2, v_blk_3, 14, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         5, '4', 0, 180
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_8;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '6', 0, 120
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_9;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '5', 0, 150
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_11;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '6', 0, 90
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_13;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '5', 0, 90
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_14;
  v_day_num := v_day_num + 1;
  -- Semana 14, Treino C
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_3, v_blk_3, 14, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         5, '4', 0, 180
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_16;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '8', 0, 90
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_17;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '5', 0, 150
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_19;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_21;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '6', 0, 90
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_22;
  v_day_num := v_day_num + 1;
  -- Semana 14, Treino D
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_4, v_blk_3, 14, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         5, '4', 0, 180
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_23;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '5', 0, 180
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_24;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '8', 0, 90
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_26;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '8', 0, 90
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_27;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '5', 0, 150
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_28;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '10', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_29;
  v_day_num := v_day_num + 1;
  -- Semana 15, Treino A
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_1, v_blk_3, 15, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         5, '4', 0, 180
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_1;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '5', 0, 180
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_2;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '8', 0, 90
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_3;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '6', 0, 90
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_5;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '5', 0, 120
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_6;
  v_day_num := v_day_num + 1;
  -- Semana 15, Treino B
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_2, v_blk_3, 15, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         5, '4', 0, 180
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_8;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '6', 0, 120
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_9;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '5', 0, 150
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_11;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '6', 0, 90
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_13;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '5', 0, 90
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_14;
  v_day_num := v_day_num + 1;
  -- Semana 15, Treino C
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_3, v_blk_3, 15, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         5, '4', 0, 180
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_16;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '8', 0, 90
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_17;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '5', 0, 150
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_19;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_21;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '6', 0, 90
  FROM split_exercises se
  WHERE se.split_id = v_spl_3 AND se.exercise_id = v_ex_22;
  v_day_num := v_day_num + 1;
  -- Semana 15, Treino D
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_4, v_blk_3, 15, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         5, '4', 0, 180
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_23;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '5', 0, 180
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_24;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '8', 0, 90
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_26;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '8', 0, 90
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_27;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         4, '5', 0, 150
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_28;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         3, '10', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_4 AND se.exercise_id = v_ex_29;
  v_day_num := v_day_num + 1;

  -- Bloco 4: Deload (semanas 16-16, 2x/semana)
  -- Semana 16, Treino A
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_1, v_blk_4, 16, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         2, '15', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_1;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         2, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_2;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         2, '15', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_3;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         2, '15', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_4;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         2, '15', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_5;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         2, '12', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_1 AND se.exercise_id = v_ex_6;
  v_day_num := v_day_num + 1;
  -- Semana 16, Treino B
  INSERT INTO training_days (program_id, split_id, block_id, week_number, day_number, status)
  VALUES (v_prog_id, v_spl_2, v_blk_4, 16, v_day_num, 'pending')
  RETURNING id INTO v_td_id;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         2, '15', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_8;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         2, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_9;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         2, '15', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_10;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         2, '12', 0, 60
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_11;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         2, '15', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_13;
  INSERT INTO training_day_exercises
    (training_day_id, split_exercise_id, exercise_id, exercise_order,
     planned_sets, planned_reps, planned_load_kg, planned_rest_seconds)
  SELECT v_td_id, se.id, se.exercise_id, se.exercise_order,
         2, '12', 0, 45
  FROM split_exercises se
  WHERE se.split_id = v_spl_2 AND se.exercise_id = v_ex_14;
  v_day_num := v_day_num + 1;

  RAISE NOTICE 'Programa criado com sucesso! ID = %', v_prog_id;
  RAISE NOTICE 'Total de dias gerados: %', v_day_num - 1;

END $$;
