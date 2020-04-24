hook.Add( "Initialize", "WorkshopLoad_Initialize", function()
	for k, v in pairs( engine.GetAddons() ) do
		local _file = v.wsid and v.wsid or string.gsub( tostring( v.file ), "%D", "" )
		resource.AddWorkshop( _file )
	end
end )

-- resource.AddWorkshop( "1972480351" )
-- resource.AddWorkshop( "757604550" )
-- resource.AddWorkshop( "1540221855" )
-- resource.AddWorkshop( "918084741" )
-- resource.AddWorkshop( "1125980817" )
-- resource.AddWorkshop( "848953359" )
-- resource.AddWorkshop( "775573383" )

-- resource.AddWorkshop( "1937522604" )
-- resource.AddWorkshop( "2008979452" )
-- resource.AddWorkshop( "1996410973" )
-- resource.AddWorkshop( "1996412427" )
-- resource.AddWorkshop( "1996413299" )
-- resource.AddWorkshop( "2008979053" )
-- resource.AddWorkshop( "1995845174" )
-- resource.AddWorkshop( "2009737898" )
-- resource.AddWorkshop( "1995852004" )
-- resource.AddWorkshop( "2010800291" )
-- resource.AddWorkshop( "1995848962" )
-- resource.AddWorkshop( "1995847766" )
-- resource.AddWorkshop( "1995854455" )
-- resource.AddWorkshop( "2008942375" )
-- resource.AddWorkshop( "2008945756" )
-- resource.AddWorkshop( "2008951688" )
-- resource.AddWorkshop( "2008972301" )
-- resource.AddWorkshop( "2008958188" )
-- resource.AddWorkshop( "1829795551" )
-- resource.AddWorkshop( "" )
-- resource.AddWorkshop( "1945396047" )
-- resource.AddWorkshop( "1945398191" )
-- resource.AddWorkshop( "1970411649" )
-- resource.AddWorkshop( "1945403920" )
-- resource.AddWorkshop( "1945407319" )
-- resource.AddWorkshop( "1945409490" )
-- resource.AddWorkshop( "1945470752" )
-- resource.AddWorkshop( "1945474031" )
-- resource.AddWorkshop( "1945476126" )
-- resource.AddWorkshop( "1945511747" )
-- resource.AddWorkshop( "1946324654" )
-- resource.AddWorkshop( "1952620929" )
-- resource.AddWorkshop( "1952623352" )
-- resource.AddWorkshop( "1952627055" )
-- resource.AddWorkshop( "1952629716" )
-- resource.AddWorkshop( "1955764278" )
-- resource.AddWorkshop( "1955767464" )
-- resource.AddWorkshop( "1955771135" )
-- resource.AddWorkshop( "1961564467" )
-- resource.AddWorkshop( "1961566937" )
-- resource.AddWorkshop( "1961582005" )
-- resource.AddWorkshop( "1971674670" )
-- resource.AddWorkshop( "1971677419" )
-- resource.AddWorkshop( "1972977543" )
-- resource.AddWorkshop( "1975580061" )
-- resource.AddWorkshop( "1978484671" )
-- resource.AddWorkshop( "1981037968" )

-- resource.AddWorkshop( "1983281467" )
-- resource.AddWorkshop( "1983282341" )
-- resource.AddWorkshop( "1983283593" )

-- resource.AddWorkshop( "1984482021" )

-- resource.AddWorkshop( "1392703845" )
-- resource.AddWorkshop( "1394493108" )
-- resource.AddWorkshop( "1778286321" )

-- resource.AddWorkshop( "1972167107" )
-- resource.AddWorkshop( "1982584910" )

maplist = {}

-- maplist["rp_lusankya_metahub_v1"] = "1613799094"
maplist["rp_finalizer_v2"] = "960603659"
maplist["rp_victoria_sup_v2"] = "2053947674"
maplist["gm_blackmesa_trainyard"] = "1958007290"
maplist["gm_continental"] = "1793494402"
maplist["rp_cscdesert_edit"] = "1157981507"
maplist["rp_mk_city17_v2"] = "1360961435"
maplist["gm_underground_v"] = "1568719631"
maplist["rp_coronavirus_sup_v1"] = "2026452882"
maplist["rp_neverlosehopehospital_rdx"] = "1287736675"
maplist["rp_anaxes"] = "1829795551"
maplist["event_umbarahillbase_haz"] = "1586549506"
maplist["event_umbararidge_haz"] = "1586549506"
maplist["gm_ost"] = "1770383934"
maplist["ares_data"] = "1552486162"
maplist["gm_ares_data"] = "1983417525"
maplist["gm_ares_research"] = "1983428567"
maplist["ares_mines"] = "1447200614"
maplist["rp_cdx_eadu_v2"] = "954662118"
maplist["ww_lux_realism"] = "1965748580"
maplist["felucia_5"] = "1715656251"
maplist["rp_imperialbaseslx_v1d"] = "1978135915"
maplist["gm_buttes_sandyspace"] = "1993566568"
maplist["rp_highwayimprobable"] = "940902151"
maplist["rp_lusankya_sup_v3"] = "2008979452"
maplist["gm_csgohalocrater"] = "1504038671"
maplist["rp_valhalla_vidmo"] = "1997201677"
maplist["gm_boreas"] = "1572373847"
maplist["rp_hanamura"] = "1392013140"
maplist["event_cdx_dathbase"] = "969977945"
maplist["event_cdx_dathcanyon"] = "969977945"
maplist["rp_venator_providence_battle"] = "804649089"
maplist["rp_deathstar"] = "1598263759"
maplist["gm_drystate2"] = "1870721307"
maplist["rp_deadcairo"] = "1090044630"
maplist["gm_boreas"] = "1572373847"
maplist["rp_alpine_v1c"] = "1699581202"
maplist["machinebase"] = "1873205348"
maplist["rp_city17_build210"] = "150899249"
maplist["rp_naboo_city_v2_1"] = "225115060"
maplist["rp_hanamura_v2"] = "1972480351"
maplist["gm_alpinemesa"] = "872526437"
maplist["fs_hoth"] = "660464983"
maplist["rp_cdx_eadu_v2"] = "954662118"
maplist["gm_goldencity"] = "1403089746"
maplist["gm_disten"] = "705480409"
maplist["gm_disten_night"] = "705480409"
maplist["cityruins2"] = "266180263"
maplist["rp_city17_metahub_v1"] = "1598399569"
maplist["rp_alpha_prison_v1"] = "972898852" 
maplist["rp_woodland_warzone"] = "1612000229"
maplist["polis_massa"] = "1600759431"
maplist["rp_lusankya_metahub_v1"] = "1613799094"
maplist["rp_umbara"] = "1556357225"
maplist["rp_bridge_complex"] = "736630838"
maplist["zm_lv426"] = "203161475"
maplist["rp_nova_prospekt_caretion_v1b"] = "1208305908"
maplist["rp_passchendaele_redone"] = "1355450027"
maplist["rp_mk_city17_v2"] = "1360961435"
maplist["ryloth_redemption"] = "1536246183"
maplist["gm_site19"] = "290599102"
maplist["gm_site19_v43"] = "869668390"
maplist["rp_kamino_extensive"] = "774517123"
maplist["rp_venator_extensive"] = "1257128301"
maplist["rp_elite_imperiale_kaserne_v4"] = "729623832"
maplist["gm_emp_glycencity"] = "613057685"
maplist["gm_mountainpass_night"] = "1172791798"
maplist["gm_mountainpass_day"] = "1172791798"
maplist["rp_desert_strike"] = "1095749195"
maplist["rp_stalker_scg_v3"] = "1164159266"
maplist["rp_stingard"] = "572552309"
maplist["gm_bigcity_sh"] = "732957261"
maplist["gm_emp_cyclopean"] = "613051969"
maplist["gm_emp_glycenplains"] = "752547425"
maplist["rp_coruscant_underworld"] = "1122367733"
maplist["rhen_var"] = "1412913974"
maplist["renegade_husk3"] = "1231782808"
maplist["rp_mos_mesric_v2"] = "614696420"
maplist["rp_wasteland"] = "554556189"
maplist["rp_kashyyyk_jungle_b2"] = "169044808"
maplist["event_christophsis_tgc"] = "804567216"
maplist["gm_fork"] = "326332456"
maplist["nt_skyline"] = "1917977364"
maplist["gm_jakku_v5"] = "730302729"
maplist["rp_betaworkshl2"] = "1121801379"
maplist["gm_dddustbowl2night"] = "108101584"
maplist["rp_rishimoon_crimson"] = "890036049"
maplist["rp_tatooine_dunesea_v1"] = "216974337"
maplist["hfg_swrp_geonosis"] = "598786140"
maplist["gm_dunesea"] = "931605065"
maplist["rp_swrp_base"] = "1254815365"
maplist["geonosis"] = "603530182"
maplist["endor"] = "568835546"
maplist["gms_coastal_outlands"] = "146610619"
maplist["mustafar"] = "577727672"
maplist["rp_naboo_city_v2"] = "225115060"
maplist["mygeeto"] = "1405080787"
maplist["rp_swrpchaos"] = "669274980"
maplist["gm_lunarbase"] = "337825623"
maplist["gm_diprip_dam"] = "613028047"
maplist["bf_arid"] = "759148543"
maplist["gm_museum"] = "1720494689"
maplist["gm_range_d6"] = "494065198"
maplist["gm_bigbridge"] = "826512013"
maplist["gm_range_f4_night"] = "613435963"
maplist["mor_facility_cv1"] = "562589737"
maplist["gm_valley"] = "104483504"
maplist["rp_vanqor_v1"] = "665543153"
maplist["naboo"] = "576353911"
maplist["gm_baik_tatooine"] = "563731859"
maplist["gm_jakku_wreck_v1"] = "884960019"
maplist["rp_cscdesert_v2-1_night_newsb"] = "129917725"
maplist["gm_bay"] = "104484764"
maplist["rp_city14_night"] = "684478842"
maplist["rp_city8"] = "132913036"
maplist["rp_city8_canals"] = "132911524"
maplist["gm_dddustbowl2"] = "108093685"
maplist["gm_emp_snowstorm"] = "752555229"
maplist["rp_cscdesert_v2-1_propfix"] = "175065893"
maplist["rp_noclyria_crimson"] = "851819730"
maplist["gm_emp_bush"] = "613041835"
maplist["gm_diprip_city"] = "613009152"
maplist["rp_nova_prospekt_v8a"] = "450795921"
maplist["gm_prospekt_coast"] = "1459372458"
maplist["rp_coolsnow_lvp"] = "805216039"
maplist["helms_deep"] = "371124298"
maplist["gm_aftermath_night_v1_0"] = "428781078"
maplist["gm_aftermath_day_v1_0"] = "428781078"
maplist["gm_vyten"] = "1449731878"
maplist["gm_atomic"] = "105984257"
maplist["cityruins"] = "151539013"
maplist["gm_bigisland"] = "169600867"
maplist["gm_uldum2"] = "148992024"
maplist["gm_hoth"] = "896338025"
maplist["rp_yuka_kr"] = "810043326"
maplist["starwars_aube_sanglantee"] = "779209314"
maplist["gm_geonosis_plains_b2"] = "109800824"
maplist["rp_city8_district9"] = "132916875"
maplist["gm_marsh"] = "878761545"
maplist["gm_fork_night"] = "545157484"
maplist["gm_emp_midbridge"] = "613062694"
maplist["gm_emp_mvalley2"] = "613063827"
maplist["gm_bigcity_winter"] = "622351524"
maplist["gm_mountainlake2"] = "349856780"
maplist["gm_redrock"] = "350869194"
maplist["gm_arid_mesa"] = "144936535"
maplist["gm_diprip_refinery"] = "613030275"
maplist["gm_emp_duststorm"] = "613053117"
maplist["gm_brownout_v1"] = "184145633"
maplist["event_fortified"] = "738569030"
maplist["rp_jedivssith"] = "598771268"
maplist["rp_starwarsfrenchmatters_sith"] = "1228888658"
maplist["rp_nar_shaddaa_v2"] = "485317056"
maplist["gm_arid_valley_v2_night"] = "510347812"
maplist["gm_emp_streetsoffire"] = "613069064"
maplist["gm_emp_slaughtered"] = "613067448"
maplist["gm_emp_chain"] = "613046581"
maplist["gm_emp_coast"] = "613048219"
maplist["gm_emp_canyon"] = "613043504"
maplist["gm_diprip_village"] = "613037740"
maplist["rp_star_wars"] = "907215395"
maplist["rp_phenomenal_galaxy_v3"] = "759401502"
maplist["rp_venator_gr"] = "841892277"
maplist["gm_emp_crossroads"] = "613050025"
maplist["event_outpost-b1"] = "758372393"
maplist["kashyyyk"] = "594141404"
maplist["gm_diprip_supermarket"] = "613074437"
maplist["gm_buttes_night"] = "105985987"
maplist["valley"] = "142782327"
maplist["gm_mountain_v1"] = "112264602"
maplist["gm_wastes"] = "278005342"
maplist["rp_sheep_v3"] = "1158496801"
maplist["rp_ryloth"] = "1270291592"
maplist["renegade_mygeeto2"] = "1238811679"
maplist["renegade_cishangar"] = "1169376538"
maplist["renegade_mustafarbay"] = "1243212098"
maplist["rp_city17_build210"] = "150899249"
maplist["gm_emp_forest"] = "752303212"
maplist["gm_emp_downfall"] = "752044799"
maplist["gm_emp_escort"] = "613054910"
maplist["gm_emp_isle"] = "613059763"
maplist["gm_emp_mesa"] = "752552314"
maplist["gm_emp_urbanchaos"] = "613071062"
maplist["gm_balkans"] = "1307357127"
maplist["gm_balkans_snow"] = "1412360702"
maplist["gm_guadalcanal"] = "1112591806"
maplist["rp_research_crimson"] = "1172493467"
maplist["rp_dark_valley_v25"] = "1283780262"
maplist["gm_medievalsiege"] = "1245300884"
maplist["gm_floatingworlds_3"] = "122421739"
maplist["gm_rhine"] = "1289646999"
maplist["gm_sandstruct_night"] = "1345004468"
maplist["gm_terminal_10"] = "1253509370"
maplist["rp_monsilva_crimson"] = "1346612100"
maplist["rp_pripyat_hl2"] = "507561128"
maplist["gm_excess_island_night"] = "156992404"
maplist["gm_usborder"] = "897081595"
maplist["rp_rishimoon"] = "1963513140"
maplist["ww_lux_realism_night"] = "1967855559"
maplist["gm_emp_flat"] = "752298944"
maplist["gm_warmap_v5"] = "105630061"
--add more maps here


local map = game.GetMap() -- Get's the current map name
local workshopid = maplist[map] 
-- Finds the workshop ID for the current map name from the table above

if( workshopid != nil )then
	--If the map is in the table above, add it through workshop
	-- print( "[WORKSHOP] Setting up maps. " ..map.. " workshop ID: " ..workshopid )
	resource.AddWorkshop( workshopid )
else
	--If not, ) then hope the server has FastDL or the client has the map
	-- print( "[WORKSHOP] Not available for current map. Using FastDL instead hopefully..." )
end
