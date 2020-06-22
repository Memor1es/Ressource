Config = {}
Config.ImmediatelyCancel = false -- Plays Exit animation if FALSE | Skips animation if TRUE
Config.RadioKey = 246  --- Default setting is Y
Config.HoverHolsterKey = 20  --- Default setting is INPUT_MULTIPLAYER_INFO

Config.Anims = {
    {name = 'umbrella', data = {type = 'anim', ad = "amb@world_human_drinking@coffee@male@base", anim = "base", prop = 'p_amb_brolly_01', proptwo = 0, boneone = 57005, bonetwo = nil, body = 49, x = 0.15, y = 0.005, z = -0.02, xa = 80.0, yb = -20.0, zc = 175.0}},
    {name = 'phonecall', data = {type = 'anim', ad = "cellphone@", anim = "cellphone_call_listen_base", prop = 'prop_player_phone_01', proptwo = 0, boneone = 57005, bonetwo = nil, body = 49, x = 0.15, y = 0.02, z = -0.01, xa = 105.0, yb = -20.0, zc = 90.0}},
    {name = 'notes', data = {type = 'anim', ad = "missheistdockssetup1clipboard@base", anim = "base", prop = 'prop_notepad_01', proptwo = "prop_pencil_01", boneone = 18905, bonetwo = 58866, body = 49, x = 0.10, y = 0.02, z = 0.05, xa = 30.0, yb = 0.0, zc = 0.0, twox = 0.12, twoy = 0.0, twoz = 0.001, twoxa = -150.0, twoyb = 0.0, twozc = 0.0}},
    {name = 'cigar', data = {type = 'prop', ad = '', anim = '', prop = 'prop_cigar_02', proptwo = 0, boneone = 47419, bonetwo = nil, body = 49, x = 0.015, y = -0.0001, z = 0.003, xa = 55.0, yb = 0.0, zc = -85.0}},
    {name = 'cigar2', data = {type = 'prop', ad = '', anim = '', prop = 'prop_cigar_01', proptwo = 0, boneone = 47419, bonetwo = nil, body = 49, x = 0.015, y = -0.0001, z = 0.003, xa = 55.0, yb = 0.0, zc = -85.0}},
    {name = 'cig', data = {type = 'prop', ad = '', anim = '', prop = 'prop_amb_ciggy_01', proptwo = 0, boneone = 47419, bonetwo = nil, body = 49, x = 0.015, y = -0.009, z = 0.003, xa = 55.0, yb = 0.0, zc = 110.0}},
    {name = 'holdcigar', data = {type = 'prop', ad = '', anim = '', prop = 'prop_cigar_03', proptwo = 0, boneone = 26611, bonetwo = nil, body = 49, x = 0.045, y = -0.05, z = -0.010, xa = -75.0, yb = 0.0, zc = 65.0}},
    {name = 'holdcig', data = {type = 'prop', ad = '', anim = '', prop = 'prop_amb_ciggy_01', proptwo = 0, boneone = 26611, bonetwo = nil, body = 49, x = 0.035, y = -0.01, z = -0.010, xa = 100.0, yb = -45.0, zc = -75.0}},
    {name = 'holdjoint', data = {type = 'prop', ad = '', anim = '', prop = 'p_cs_joint_02', proptwo = 0, boneone = 26611, bonetwo = nil, body = 49, x = 0.035, y = -0.01, z = -0.010, xa = 100.0, yb = -45.0, zc = -100.0}},
    {name = 'box', data = {type = 'anim', ad = "anim@heists@box_carry@", anim = "idle", prop = 'hei_prop_heist_box', proptwo = 0, boneone = 60309, bonetwo = nil, body = 49, x = 0.025, y = 0.08, z = 0.255, xa = -145.0, yb = 290.0, zc = 0.0}},
    {name = 'salute', data = {type = 'anim', ad = "anim@mp_player_intuppersalute", anim = "idle_a", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'finger', data = {type = 'anim', ad = "anim@mp_player_intselfiethe_bird", anim = "idle_a", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'finger2', data = {type = 'anim', ad = "anim@mp_player_intupperfinger", anim = "idle_a", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'facepalm', data = {type = 'anim', ad = "anim@mp_player_intupperface_palm", anim = "idle_a", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'foldarms2', data = {type = 'anim', ad = "missfbi_s4mop", anim = "guard_idle_a", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'foldarms', data = {type = 'anim', ad = "oddjobs@assassinate@construction@", anim = "unarmed_fold_arms", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'brief', data = {type = 'brief', ad = "", anim = "", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'brief2', data = {type = 'brief', ad = "", anim = "", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'damn', data = {type = 'anim', ad = "gestures@m@standing@casual", anim = "gesture_damn", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'fail', data = {type = 'anim', ad = "random@car_thief@agitated@idle_a", anim = "agitated_idle_a", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'gang1', data = {type = 'anim', ad = "mp_player_int_uppergang_sign_a", anim = "mp_player_int_gang_sign_a", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'gang2', data = {type = 'anim', ad = "mp_player_int_uppergang_sign_b", anim = "mp_player_int_gang_sign_b", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'no', data = {type = 'anim', ad = "mp_player_int_upper_nod", anim = "mp_player_int_nod_no", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'pickbutt', data = {type = 'anim', ad = "mp_player_int_upperarse_pick", anim = "mp_player_int_arse_pick", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'grabcrotch', data = {type = 'anim', ad = "mp_player_int_uppergrab_crotch", anim = "mp_player_int_grab_crotch", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'peace', data = {type = 'anim', ad = "mp_player_int_upperpeace_sign", anim = "mp_player_int_peace_sign", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'dead', data = {type = 'anim', ad = "misslamar1dead_body", anim = "dead_idle", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 33, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'holster', data = {type = 'anim', ad = "move_m@intimidation@cop@unarmed", anim = "idle", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'aim', data = {type = 'anim', ad = "move_weapon@pistol@copa", anim = "idle", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'aim2', data = {type = 'anim', ad = "move_weapon@pistol@cope", anim = "idle", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'guard', data = {type = 'anim', ad = "rcmepsilonism8", anim = "base_carrier", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'slowclap', data = {type = 'anim', ad = "anim@mp_player_intcelebrationmale@slow_clap", anim = "slow_clap", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'cheer', data = {type = 'anim', ad = "amb@world_human_cheering@male_a", anim = "base", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'bum', data = {type = 'anim', ad = "amb@lo_res_idles@", anim = "world_human_bum_slumped_left_lo_res_base", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 33, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'leanwall', data = {type = 'anim', ad = "amb@lo_res_idles@", anim = "world_human_lean_male_foot_up_lo_res_base", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 33, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'copcrowd', data = {type = 'anim', ad = "amb@code_human_police_crowd_control@idle_a", anim = "idle_a", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'copcrowd2', data = {type = 'anim', ad = "amb@code_human_police_crowd_control@idle_b", anim = "idle_d", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'copidle', data = {type = 'scenario', ad = "", anim = "", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 33, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'shotbar', data = {type = 'anim', ad = "anim@amb@nightclub@mini@drinking@drinking_shots@ped_a@drunk", anim = "drink", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'drunkbaridle', data = {type = 'anim', ad = "anim@amb@nightclub@mini@drinking@drinking_shots@ped_a@drunk", anim = "idle", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 33, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'djidle', data = {type = 'anim', ad = "anim@amb@nightclub@djs@dixon@", anim = "dixn_idle_cntr_b_dix", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 33, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'djidle2', data = {type = 'anim', ad = "anim@amb@nightclub@djs@dixon@", anim = "dixn_idle_cntr_e_dix", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 33, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'fdance1', data = {type = 'anim', ad = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", anim = "high_center", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 33, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'fdance2', data = {type = 'anim', ad = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", anim = "high_center_down", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 33, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'mdance1', data = {type = 'anim', ad = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@", anim = "high_right_down", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 33, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'mdance2', data = {type = 'anim', ad = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@", anim = "low_left", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 33, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
}

--If you want to add more animations:

--anim | includes Animations + Prop
--prop | prop only
--scenario | I just use this to call 1 scenario, you can easily set it up to do any scenario

--Template:
--{name = '', data = {type = 'anim', ad = "", anim = "", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},