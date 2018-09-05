Lparameters PLC_Form, PLC_Ukey, PLL_OnLine, PLN_Operation && 1 - Adiciona; 2 - Edita; 3 - Deleta.
VGO_Acc.VOL_Contabiliza = .T.


Local VLC_CodigoES,VLC_CodES, VLL_Z10_Nfe
nPLN_Operation = PLN_Operation
Dimension VOA_Parameter[10]

*---------------------------------------------------------------------------------------
*-	AccInt_WExcel.FXP: Programa que contabiliza lançamentos provenientes de Excel
*-	Arquivos correlacionados a esse específico:
*-		- CGO_Wexcel_0I.Prg: Classe que trata os dados do excel antes de contabilizar.
*-		- Wexcel_0I.scx	 : Tela com as instancias iniciais.
*-		- Triggers.prg	 : Possui a configuração de acesso e posição da tela.
*---------------------------------------------------------------------------------------
if !VGO_GEN.VOL_SERVICEMODE &&Adicionado para não ser chamado quando for executado por serviço.
	Do AccInt_WExcel.FXP With PLC_Form, PLC_Ukey, PLL_OnLine, PLN_Operation
Endif
*---------------------------------------------------------------------------------------

*- Tratamento para as telas que não estão configuradas na classe de integração(Tela que não ficam disponiveis na árvore da tela de integração off-line)
If Empty(VGO_Acc.VOC_PrimaryFile) And !Empty(Nvl(PLC_Form,""))
	With VGO_Acc
		.VOC_Par = Left(PLC_Form, 3)
		.VOC_PrimaryFile = .VOC_Par
	Endwith
Endif

*-PRIME 1796 - INICIO
If PLN_Operation = 2 && Ponto de Edição
	If !Empty(Nvl(PLC_Ukey, ""))
        DeletaContabilizacao()
		IF ! VGO_Acc.vol_error
			FOL_MakeIntegrationHomeMade(.T.)
		Endif
	Endif
	If !VGO_Acc.VOL_ERROR
		PLN_Operation = 1
	Endif
ENDIF
*-PRIME 1796 - FIM

*- Add. objeto para recalculo do rateio no objeto de integração contábil
If !(Type("VGO_Acc.ool_recalculaterateio") == 'O')
	VGO_Acc.AddObject("ool_recalculaterateio","cgo_recalculaterateio_l")
Endif

Do Case
	Case PLN_Operation = 1
	
		VGO_Acc.VOC_EntryB06Ukey = "" && SCRUM-15529 quando uma Integração não era gerada a rotina se perdia.	
	
		Do Case
				*- Ponto executado antes de começar a integrar os documentos.
			Case PLC_Form == "BEGIN"
				UtilizaPreContabilizacao("BEGIN")

			Case PLC_Form == "B25"
				UtilizaPreContabilizacao("B25")

				*- Ponto executado depois da integração de todos os documentos.
			Case PLC_Form == "END"
				UtilizaPreContabilizacao("END")

			Case PLC_Form == "J10"

				*- SSA-79 - INICIO
					SET PROCEDURE TO accint_services.PRG ADDITIVE
				*- SSA-79 - Fim

				Go Top In J11T
				VLC_CodigoES = FLC_CodigoES(J11T.t04_ukey)
				VLC_CodES = Trim(Upper(VLC_CodigoES))
				Do Case
					
					&& inserido por Rui Santos em 06/02/2017 - Incident INC0455806  
					Case VLC_CodES $ "S10.98ES//S10.98SP"
						DO nfs-s10.98ES.fxp
						
					&& inserido por PR em 30/08/2017 - Incident INC0479951
					Case VLC_CodES == "S10.98W6"
						DO NFS-S10.98W6.fxp
						
					Case VLC_CodES $ "S11.02ES"
						DO nfs-S11.02ES.prg
					
					&& inserido por Rui Santos em 27/01/2017 - Incident INC0455806  
					Case VLC_CodES $ "S51.01ES"
						DO nfs-s51.01ES.fxp
					
					&& inserido por Rui Santos em 26/01/2017 - Incident INC0455810 
					Case VLC_CodES $ "S51.01W8"
						DO nfs-s51.01W8.fxp
						
					Case VLC_CodES $ "S01.09W6//S90.02W6//S01.10W6//S01.19SP//S02.06W6//S01.99W6//S01.20W6//S01.98W6//"
						Do nfs-s01.01.FXP
												
					Case VLC_CodES $ "S01.95ES"
						Do nfs-s01.95ES.FXP
						
					Case VLC_CodES $ "S01.13ES"
						Do nfs-S01.13ES.FXP && incluida no chamado Incident INC0435148 - Rui Santos

					Case VLC_CodES $ "S01.01ES//S01.19ES//S01.02ES//S01.21ES//S01.94ES//S02.04ES//S50.01ES//S50.02ES//S50.19ES//S50.21ES//S50.22ES//S60.01ES//"
						Do nfs-s01.01ES.FXP
						*- Foi feita uma nota contabilização para contemplar o novo ICMS
						
					*-Case VLC_CodES $ "S01.05W6//S01.05W8//S01.05SP//S01.05ES//S01.06ES"
					Case VLC_CodES $ "S01.05W6//S01.05W8//S01.05SP//" && Removido ces S01.05ES//S01.06ES ref. chamado: INC0493656 - 27-12-2017
						Do nfs-icmsnew.FXP
						
					Case VLC_CodES == "S01.05ES" && inserido ref. chamado: INC0493656 - 27-12-2017
                    	Do nfs-s01.05ES.FXP                                  

					Case VLC_CodES == "S01.06ES" && inserido ref. chamado: INC0493656 - 27-12-2017
                    	Do nfs-s01.06ES.FXP
						
						&& incluido para atender o chamado INC0223022
					Case VLC_CodES $ "S01.06W8"
						Do nfs-s01.06w8.FXP
						&& incluido para atender o chamado INC0223022
						
					Case VLC_CodES $ "S50.21W8"
						Do nfs-s01.01es_2.FXP

					Case VLC_CodES $ "S01.11W6//S01.03W8//S60.07W8//"
						Do nfs-s01.03.FXP

					Case VLC_CodES $ "S01.03ES//S01.04ES//S01.07ES"
						Do nfs-s01.03ES.FXP

					Case VLC_CodES $ "S01.12ES//S01.20ES//S01.22ES//S01.22W6//S01.23W8//"
						Do nfs-s01.12.prg

					Case VLC_CodES $ "S01.18ES//"
						Do nfs-s01.18ES.prg

					Case VLC_CodES $ "S01.23ES//"
						Do nfs-s01.23ES.prg

						&& adicionado ref. jira: scrum-8637
					Case VLC_CodES $ "S01.12W8"
						Do nfs-s01.12W8.FXP

					Case VLC_CodES $ "S01.97ES//S01.97W8//"
						Do nfs-s01.97ES.FXP

					Case VLC_CodES $ "S01.97W6"
						Do nfs-s01.97W6.FXP

					&& prime: 1521 - inicio
					Case VLC_CodES $ "S52.03ES//" 
						Do nfs-s52.03ES.FXP

					Case VLC_CodES $ "S02.07ES//" 
						Do nfs-s02.07ES.FXP						
					&& prime: 1521 - fim

						&& Alteracao ref. ajuste nf wbes 083082
					Case VLC_CodES $ "S02.03ES//"
						Do nfs-s02.03ES.FXP

						&& ADICIONADO FECHAMENTO 02-2015
					Case VLC_CodES $ "S02.03W8//"
						Do nfs-s02.03W8.FXP

					Case VLC_CodES $ "S06.01SP//S06.01W9//"
						Do nfs-s06.01sp.FXP

					Case VLC_CodES $ "S03.01ES//S03.12ES//S53.01ES//S03.04W8//"
						Do nfs-s03.01ES.FXP

					Case VLC_CodES $ "S05.02W6"
						Do nfs-s05.02ES.FXP

					*- PRIME 2036 - inicio	
					Case VLC_CodES == "S05.02ES"
						Do nfs-s05.02ES_.FXP
					*- PRIME 2036 - fim

					Case VLC_CodES $ "S03.11W6"
						Do nfs-s03.08.FXP

					Case VLC_CodES $ "S03.08ES//S03.05ES//S03.14ES//S53.08ES//"
						Do nfs-s03.08ES.FXP

					Case VLC_CodES $ "S53.08W8//"
						Do nfs-S53.08W8.FXP

					Case VLC_CodES $ "S05.01ES//S05.01W6//S05.01W8//"
						Do nfs-s05.01ES.FXP

					Case VLC_CodES $ "S05.05ES//S05.05SP//"
						*-	IHL-9680 - INICIO
						Do nfs-S05.05ES.FXP
						*-	IHL-9680 - FIM

					Case VLC_CodES $ "S05.03ES"
						Do nfs-s05.03ES.FXP

					Case VLC_CodES $ "S10.01SP//"
						Do nfs-s10.01sp.FXP

					Case VLC_CodES $ "S10.01W6//S10.11W6//S10.07W6//"
						Do nfs-s10.01W6.FXP

						&& Removido a ces sp10.12sp
					Case VLC_CodES $ "S10.09W6//S10.12W6//S10.13SP//"
						Do nfs-s10.02.FXP

						&& ACRESCENTADO REF. JIRA: SCRUM-8019
					Case VLC_CodES $ "S10.12SP//S10.07SP"
						Do nfs-s10.12.FXP

					Case VLC_CodES $ "S10.02SP//S10.09SP//S10.02W6//S10.05W6" 
						Do nfs-s10.02sp.FXP
						
					Case VLC_CodES $ "S10.05SP" 
						Do nfs-s10.05sp.FXP

*!*					Adicionado por Eric Cardim através do chamado INC0412157
					Case VLC_CodES $ "S10.05F1" 
						Do nfs-s10.05F1.FXP

					Case VLC_CodES $ "S10.03W6//S10.04W6//S10.06ES"
						Do nfs-s10.03.FXP

					Case VLC_CodES $ "S10.03SP"
						Do nfs-s10.03sp.FXP

					Case VLC_CodES $ "S10.04SP"
						Do nfs-s10.04sp.FXP

*!*					Adicionado por Eric Cardim através do chamado INC0412157
					Case VLC_CodES $ "S10.04F1"
						Do nfs-s10.04f1.FXP

					Case VLC_CodES $ "S10.11SP"
						Do nfs-s10.11sp.FXP

					Case VLC_CodES $ "S10.16W6//"
						Do nfs-s10.15.FXP

						&& adicionado ref. jira:scrum-8610
					Case VLC_CodES $ "S10.16SP//S10.17SP//"
						Do nfs-s10.16sp.FXP

					Case VLC_CodES $ "S11.01SP//"
						Do nfs-S11.01.FXP

					Case VLC_CodES $ "S11.02W1//"
						Do nfs-S11.02.FXP

					Case VLC_CodES $ "S50.01SP//S50.02SP//S60.01SP//S60.02SP//S60.03SP//S50.01W8//S90.02W8//S50.02W8//S60.01W8//S01.21SP//S60.02W8//S60.03W8//S60.04W8//S50.19W8//S01.91SP//S01.91W8//S50.04W8//S01.22W8//S60.99W8//S50.24W8//"
						Do nfs-s50.01.FXP

						&& add ref SCRUM-11742 em 04-11-2014
					Case VLC_CodES $ "S01.99W8"
						Do nfs-s50.01_SCRUM-11742.FXP

					Case VLC_CodES $ "S52.03W8"
						Do nfs-s52.03.FXP

						&& adicionado ref. jira:scrum-7007 em 07-03-2014
					Case VLC_CodES $ "S03.08W8"
						Do nfs-s03.08W8.FXP

						&& adicionado ref. jira:scrum-9803 em 04-08-2014
					Case VLC_CodES $ "S11.02W8"
						Do nfs-S11.02W8.FXP

						&& adicionado ref. jira:scrum-10018 em 27-08-2014
					Case VLC_CodES $ "S06.02ES"
						Do nfs-s06.02ES.FXP

						&& adicionado ref. jira:scrum-10744 em 24-09-2013
					Case VLC_CodES $ "S03.11ES"
						Do nfs-s03.11ES.FXP

						&& adicionado ref. jira:scrum-14347 em 02-03-2015
					Case VLC_CodES $ "S03.17ES"
						Do nfs-s03.17ES.FXP

						&& adicionado ref. jira:scrum-14177
					Case VLC_CodES $ "S01.18SP//"
						Do nfs-s01.18sp.FXP

						&& adicionado ref. jira:scrum-14347 em 03-03-2015
					Case VLC_CodES $ "S03.17W6"
						Do nfs-s03.17W6.FXP

					Case VLC_CodES $ "S01.95W8"
						Do nfs-s01.95W8.FXP

						&& Adicionado ref. chamado service now:
					Case VLC_CodES $ "S03.05W8"
						Do nfs-s03.05W8.FXP

						&& Adicionado ref. chamado service now: INC0262578
					Case VLC_CodES $ "S06.02W8"
						Do nfs-s06.02W8.FXP

					Case VLC_CodES $ "S02.09W8"
						Do nfs-s02.09W8.FXP

						&& Adicionado ref. chamado service now: INC0263643
					Case VLC_CodES $ "S03.14W8"
						Do nfe-s03.14W8.FXP

						&& Inserido ref. service now: INC0284050
					Case VLC_CodES $ "S10.31ES//"
						Do nfs-s10.31ES.FXP

						&& Inserido ref. service now: INC0288278
					Case VLC_CodES $ "S10.30ES//"
						Do nfs-s10.30ES.FXP

						&& Inserido ref. service now: INC0288281
					Case VLC_CodES $ "S01.18W6//"
						Do nfs-s01.18W6.FXP

						&& Inserido ref. service now: INC0294388
					Case VLC_CodES $ "S05.03W6//"
						Do nfs-s05.03W6.FXP

						&& Inserido ref. service now: INC0316953
					Case VLC_CodES == "S90.08ES"
						Do nfs-s90.08ES.prg

						&& Inserido ref. service now: INC0321037	- ELCruz
					Case VLC_CodES == "S90.08SP"
						Do nfs-s90.08sp.prg

						&& Inserido ref. service now: INC0339191	- pr
					Case VLC_CodES == "S10.32ES"
						Do nfs-s10.32ES.FXP
						
						&& Inserido ref. service now: INC0492088	- pr - 12/12/2017
					Case VLC_CodES == "S10.07ES"
						Do nfs-s10.07ES.FXP						
						
						&& Inserido por Rui Anderson em caracter de emergencia- Luciana ficou de abrir o chamado - 25/11/2016
					Case VLC_CodES == "S10.32SP"
						Do nfs-s10.32SP.FXP

						&& Inserido ref. service now: INC0476307	- pr
					Case VLC_CodES == "S10.13W6"
						Do nfs-s10.13W6.FXP

						&& Inserido ref. service now: INC0339514	- pr
					Case VLC_CodES == "S10.33ES"
						Do nfs-s10.33ES.FXP

						&& Inserido ref. service now: INC0336242	- pr
					Case VLC_CodES == "S52.04ES"
						Do nfs-s52.04ES.FXP

						&& Inserido ref. service now: INC0350925	- pr
					Case VLC_CodES == "S01.98ES"
						Do nfs-s01.98ES.FXP
					
					&& Inserido ref. service now: Incidente INC0366048	- RUI 05-04-2016
					case VLC_CodES $ "S06.03ES"
						do nfs-s06.03es.FXP

					case VLC_CodES $ "S06.03W6"
						do nfs-s06.03w6.FXP
												
					&& Inserido ref. service now: INC0408814	- pr
					&& Alterado o nome ref. service now: INC0412161	- Eric Cardim								
					Case VLC_CodES $ "S10.07F1"
						Do nfs-S10.07F1.FXP

					&& Inserido ref. service now: INC0408814	- pr
					&& Alterado o nome ref. service now: INC0412161	- Eric Cardim
					Case VLC_CodES $ "S10.08F1"
						Do nfs-S10.08F1.FXP

					&& Inserido ref. service now: INC0374785	- pr
					&& Alterado o nome ref. service now: INC0412161	- Eric Cardim
					Case VLC_CodES $ "S10.09F1"
						Do nfs-S10.09F1.FXP
						
					&& Inserido ref. service now: INC0375980	- pr
					Case VLC_CodES $ "S50.05W8"
						Do nfs-S50.05W8.FXP
						
					&& Inserido ref. service now: INC0376280	- pr
					Case VLC_CodES $ "S02.08ES"
						Do nfs-S02.08ES.FXP
						
					&& Inserido ref. service now: INC0394021	- pr
					case VLC_CodES == "S05.10ES"
						do nfs-S05.10ES.fxp
						
					&& Inserido ref. service now: INC0394021	- pr
					case VLC_CodES == "S05.10W6"
						do nfs-S05.10W6.fxp
						
					&& Inserido ref. service now: INC0394021	- pr
					case VLC_CodES == "S05.11ES"
						do nfs-S05.11ES.fxp
						
					&& Inserido ref. service now: INC0394021	- pr
					case VLC_CodES == "S05.11W6"
						do nfs-S05.11W6.fxp				

					&& Inserido ref. service now: INC0395047	- pr
					case VLC_CodES == "S60.93W8"
						do nfs-S60.93W8.fxp
						
					&& Inserido ref. service now: INC0408813	- pr
					case VLC_CodES == "S10.99ES"
						do nfs-S10.99ES.fxp										
												
					&& Inserido ref. service now: INC0416794	- pr
					case VLC_CodES == "S12.01W6"
						do nfs-S12.01W6.fxp				

					&& Inserido ref. service now: INC0416794	- pr
					case VLC_CodES == "S12.02W6"
						do nfs-S12.02W6.fxp
						
					&& Inserido ref. service now: INC0416794	- pr
					case VLC_CodES == "S12.03W6"
						do nfs-S12.03W6.fxp
						
					&& Inserido ref. service now: INC0418961	- pr
					case VLC_CodES == "S54.01W8"
						do nfs-S54.01W8.fxp														
											
					&& Inserido ref. service now: INC0424291	- pr
					case VLC_CodES == "S01.18F1"
						do nfs-S01.18F1.fxp
					&& inserido ref. service now: INC0479990    - PR - 29-08-2017
					Case VLC_CodES == "S03.30ES" 
						Do nfs-s03.30ES.FXP
					&& inserido ref. service now: INC0481748    - PR - 13-09-2017
					Case VLC_CodES == "S03.19W8" 
						Do nfs-s03.19W8.FXP						
					*- prime - 1707 - Inicio
					Case VLC_CodES == "S10.05ES" 
						Do nfs-S10.05ES.FXP											
					*- prime - 1707 - Fim						

					*- prime - 1719 - Inicio
					Case VLC_CodES == "S05.02W8" 
						Do nfs-S05.02W8.FXP											
					*- prime - 1719 - Fim						

					*- PRIME - 2104 - FIM					
					Case VLC_CodES == "S01.05WV"
						Do nfs-S01.05WV.FXP
					Case VLC_CodES == "S50.19WV"
						Do nfs-S50.19WV.FXP
					*- PRIME - 2104 - FIM				

					*- prime - 2155 - Inicio
					Case VLC_CodES == "S06.04SP"
						Do nfs-S06.04SP.FXP
					Case VLC_CodES == "S06.04W1"
						Do nfs-S06.04W1.FXP
					*- prime - 2155 - Fim								
											
				Endcase

				******************************************************
				*- Fechamento de período por Conta Contábil - Prime 930
				******************************************************
				If !VGO_Acc.VOL_ERROR
					With VGO_Dat
					  .FOL_SetParameter(1, VGO_Acc.VOC_EntryB06Ukey)
					  .VOA_Index[1] = "b11_ukey"
					  .FOL_Editcursor("B07_FRM", "B07_LAN", "B07TT", "Z", 1, 1)
					ENDWITH
					SELECT B07TT
					GO TOP
					SCAN WHILE !VGO_Acc.VOL_ERROR
						VGO_Acc.VOL_ERROR = FOL_verificaUtilizacaoConta(Alltrim(Nvl(B07TT.b11_ukey,"")))
					EndScan
				ENDIF
				VGO_Gen.FOL_CloseTable("B11CC")
				******************************************************
				*- Fechamento de período por Conta Contábil - Fim
				******************************************************



				If Used("J15TT")
					If !Empty(Alltrim(Nvl(J15TT.UKEY,"")))
						* do f11_002_on.FXP
					Endif
				ENDIF
				
				If !VGO_Acc.VOL_ERROR && SCRUM-15651
					&& PRIME-510 - Douglas (à pedido do Rafael Pereira) - Início
					go top in J11T && Todos os itens terão o mesmo local
					*-db.execsql("SELECT D07_001_C FROM STAR_DATA@D07 (NOLOCK) WHERE UKEY = ?J11T.D07_UKEY","D07_T")
					
					*- Rodar somente para os locais "0602" e "0603"
					*-if inlist(substr(D07_T.d07_001_c,1,4),"0602","0603")
						*- Se diferente de "ESTORNO DE PROCESSO MICROSOFT" e data maior que 01/05/17
						
*!*							if J10.t89_ukey <> '20160825OG6CKQ1079MI' and ttoc(J10.j10_003_d) >= '01/05/2017'
*!*								DO FOL_ContabilizaCusto.prg WITH "J11"
*!*							ENDIF
						
						*-VLC_Modelo = VGO_Gen.FOC_QuickSQL("T89_001_C", "T89", "UKEY", "'" + J10.t89_ukey + "'")
						*-if !(ALLTRIM(VLC_Modelo) == "EST")  and ttoc(J10.j10_003_d) >= '01/05/2017'
						  *- DO FOL_ContabilizaCusto.prg WITH "J11"
						*-endif
					*-endif
					  ******************************************************
				      *- Adaptação Contabilização do Custo para HW - Prime 931
				      ******************************************************
				      
				      *- prime 1746 - inicio

					  *- IF (Fol_verificaContabilizaCusto(Alltrim(Nvl(J11T.t04_ukey,"")))=1) AND ttoc(J10.j10_003_d) >= '01/08/2017' 
					  *- 	DO FOL_ContabilizaCusto.prg WITH "J11"
					  *- ENDIF
					  
					  VLN_CONTABILIZACUSTO = Fol_verificaContabilizaCusto(Alltrim(Nvl(J11T.t04_ukey,"")))
					  VLD_DATAEMISSAONF    = J10.j10_003_d

					  IF VLN_CONTABILIZACUSTO = 1 AND VLD_DATAEMISSAONF >= CTOD("01/08/2017")
					     DO FOL_ContabilizaCusto.prg WITH "J11"
					  ENDIF
				      
				      *- prime 1746 - fim
				      ******************************************************
				      *- Adaptação Contabilização do Custo para HW - Fim
				      ******************************************************


					
					*-VGO_Gen.FOL_CloseTable("D07_T")
					&& PRIME-510 - Douglas (à pedido do Rafael Pereira) - Fim
				endif
								
				&&SCRUM - 14458
				*- Busco todas as comissões da NF
				With VGO_GEN
					.FOL_SetParameter(1, 'J10')
					.FOL_SetParameter(2, J10.UKEY)
					.FOL_SetParameter(3, '002')
					.FOL_Editcursor("F11_IPAR", "F11_IPAR", "F11", "Z", 0, 3)
					If 	Empty(Nvl(F11.UKEY,''))
						*-SCRUM-15529
						if !VGO_Acc.VOL_Error 
							FOL_AtualizaNITLanc(PLC_Form)
						endif				
					Endif
				Endwith

				Select F11
				GO top
				Scan
										
					vlc_sql = "select j15_500_n from dbo.j15 (nolock) where ukey = '"+Nvl(F11.J15_ukey,'')+"'"
					vgo_gen.fol_sqlexec(vlc_sql, "TMP_j15")
					
					IF used("TMP_j15") AND EOF("TMP_j15")
						USE IN ("TMP_j15")
						loop
					ENDIF
					
					IF used("TMP_j15") AND !EOF("TMP_j15")
					
						VLC_TIPO = TMP_j15.j15_500_n 
					
						
						If VLC_TIPO > 0
						
							vlc_a21_ukey = ""
							
							IF VLC_TIPO = 1
								vlc_a21_ukey = VGO_GEN.FOC_QuickSql("ukey","A21","A21_001_C","15.96")
							ENDIF
							
							IF VLC_TIPO = 2
								vlc_a21_ukey = VGO_GEN.FOC_QuickSql("ukey","A21","A21_001_C","15.97")
							endif
							*- Comissão de MKT Fabricante
							Do f11_002J.fxp WITH vlc_a21_ukey 
						Else
							*- Comissão da revenda
							Do f11_002J1.fxp WITH F11.A21_ukey
						ENDIF
						
						USE IN ("TMP_j15")
					endif
				ENDSCAN
				
				VGO_GEN.FOL_CLOSETABLE("F11")
				*- Busco todos adiantamentos da NF
				With VGO_GEN
					.FOL_SetParameter(1, 'J10')
					.FOL_SetParameter(2, J10.UKEY)
					.FOL_SetParameter(3, '003')
					.FOL_Editcursor("F11_IPAR", "F11_IPAR_TMP", "F11", "Z", 0, 3)
				Endwith
                IF USED("F11") AND !EOF("F11")
					Select F11
					Set Order To
					Scan
						VLC_TIPO = VGO_GEN.FOC_QuickSql("A21_001_C","A21","UKEY","'" + Nvl(F11.a21_ukey,'') + "'")
						If Alltrim(VLC_TIPO) $ '16.01//16.02'
							Do f11_003vo.prg
						Endif
					Endscan
				ENDIF	
				VGO_GEN.FOL_CLOSETABLE("F11")

				SELECT J11T 
				GO Top

				&&SCRUM - 14458
				*-- SCRUM-14543 - inicio
				If !VGO_Acc.VOL_ERROR
					VGO_Acc.VOL_ERROR = FOL_VerificaContalidade(Alltrim(Nvl(J11T.t04_ukey,"")),Substr(PLC_Form,1,3), J10.UKEY,PLC_Form, VLC_CodES)
				Endif
				*-- SCRUM-14543 - fim
				
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************
				IF !VGO_Acc.VOL_Error
					VGO_Acc.VOL_Error = FOL_VerificaMoedaIntegracao(VGO_Acc.VOC_EntryB06Ukey)
				ENDIF
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************

				*- PRIME-1485 - Início
				do contabiliza_voucher.prg
				*- PRIME-1485 - Fim				
				
				*-Compra
			Case PLC_Form == "E10"			
				
				Go Top In E11T
				VLC_CodigoES = FLC_CodigoES(E11T.t04_ukey)
				VLC_CodES = Trim(VLC_CodigoES)
				Do Case

					Case VLC_CodES == "E53.09ES"  && Inserido ref. service now: INC0492724 - Peterson Ricardo - 22/12/2017
						DO nfe-e53.09ES.FXP

					Case VLC_CodES == "E01.59ES"  && Inserido ref. service now: INC0489617 - Peterson Ricardo - 21/11/2017
						DO nfe-e01.59ES.FXP
						
					Case VLC_CodES == "E01.08ES"  && Inserido ref. service now: INC0489617 - Peterson Ricardo - 21/11/2017
						DO nfe-E01.08ES.FXP

					Case VLC_CodES == "E01.58ES"  && Inserido ref. service now: INC0489617 - Peterson Ricardo - 21/11/2017
						DO nfe-e01.58ES.FXP
						
					Case VLC_CodES == "E01.60ES"  && Inserido ref. service now: INC0489617 - Peterson Ricardo - 21/11/2017
						DO nfe-E01.60ES.FXP

					Case VLC_CodES == "E01.07ES"  && Inserido ref. service now: INC0489617 - Peterson Ricardo - 21/11/2017
						DO nfe-e01.07ES.FXP

					Case VLC_CodES $ "e01.57F1"  && Inserido ref. service now: Incident INC0454665 - Rui Anderson Santos - 31/01/2017
						DO nfe-e01.57F1.FXP
						
					Case VLC_CodES $ "E90.05ES"  && Inserido ref. service now: INC0437050 - Rui Anderson Santos - 26/10/2016
						DO nfe-E90.05ES.FXP
						
*!*						Removido ref. chamado: INC0483714
*!*						Case VLC_CodES $ "E09.02ES"  && Inserido ref. service now: INC0482675 - Peterson Ricardo - 20/09/2017
*!*							DO nfe-E09.02ES.FXP
*!*						Case VLC_CodES $ "E09.02SP"  && Inserido ref. service now: INC0483244 - Peterson Ricardo - 27/09/2017
*!*							DO nfe-E09.02SP.FXP												
						
					Case VLC_CodES $ "E90.04W6"  && Inserido ref. service now: INC0275109 - Modificado para ca no chamado Incident INC0451350
						Do nfe-e90.04W6.FXP
				
					Case VLC_CodES $ "E01.01W1//E01.01//"
						Do nfe-e01.01.FXP
					
					CASE VLC_CodES = "E01.01W6"
						DO nfe-e01.01W6.FXP
					Case VLC_CodES $ "E01.02//E01.02W6//"
						Do nfe-e01.02.FXP
					Case VLC_CodES = "E02.01W1"
						Do nfe-e02.01w1.FXP
						*- Transferência do Rio para Es
					Case VLC_CodES $ "E11.02RJ//E11.03RJ//E11.02W6//E04.03W6//E03.16W6//E03.16SP//E03.13ES//E03.13SP//E03.13W6//E03.13W8//E03.16W8//"
						Do nfe-e11.02rj.FXP
					Case VLC_CodES $ "E11.02SP//E03.05SP//E11.02W8"
						Do nfe-e11.02sp.FXP
						*- Transferência do Es para Rio
					Case VLC_CodES $ "E11.02ES" && Alterado via INC0281579
						Do nfe-e11.02ES.FXP
					Case VLC_CodES $ "E05.03ES//E03.05ES//E04.03ES//E11.03W1//E05.03W1//E05.13ES" && Removido a ces e11.03es ref. scrum-7591
						Do nfe-e05.03ES.FXP
					Case VLC_CodES $ "E01.06//E01.05//"
						Do nfe-e01.06.FXP
					Case VLC_CodES $ "E01.03//E01.04"
						Do nfe-e01.03.FXP
					Case VLC_CodES $ "E04.01//E04.01W1//"
						Do nfe-e04.01.FXP
					Case VLC_CodES $ "E04.01W9" && Inserido ref. INC0423482
						Do nfe-e04.01W9.FXP
					Case VLC_CodES == "E04.03"
						Do nfe-e04.03.FXP
					Case VLC_CodES $ "E04.04//E04.02//"
						Do nfe-e04.04.FXP
					Case VLC_CodES $ "E04.04ES//" && SCRUM-9784
						Do nfe-e04.04ES.FXP
					Case VLC_CodES == "E04.06"
						Do nfe-e04.04ES.FXP
					Case VLC_CodES == "E04.06SP"					
						Do nfe-e04.06SP.FXP
					Case VLC_CodES == "E04.05"
						Do nfe-e04.05.FXP
					Case VLC_CodES $ "E90.03//"
						Do nfe-e90.03.FXP
					Case VLC_CodES $ "E90.04//E90.04W1//"
						Do nfe-e90.04.FXP
					Case VLC_CodES == "E90.05//E90.05W1"
						Do nfe-e90.05.FXP
					Case VLC_CodES == "E90.30ES" &&SCRUM-10913 Rui santos - 29/09/2014
						Do e90.30ES.FXP
					Case VLC_CodES == "E01.22"
						Do nfe-e01.22.FXP
					Case VLC_CodES $ "E01.05SP//E01.02ES//E01.92ES//E50.01SP//E01.05W8//E50.01W8//E90.01ES"
						Do nfe-e01.22ES.FXP
					CASE VLC_CodES = "E01.22ES"
						Do nfe-e01.22ES_1.FXP
					
					Case VLC_CodES $ "E01.50ES//E01.50W6//E01.50SP//E01.50RJ//E01.50W1//E01.50//E01.50W8//"
						Do nfe-e01.50.FXP
					Case VLC_CodES $ "E01.52RJ//E01.52SP//E01.52ES//E01.53RJ//E01.53SP//E01.53ES//E01.54RJ//E01.54SP//" .Or. ;
							VLC_CodES $ "E01.54ES//E01.55RJ//E01.55SP//E01.56RJ//E01.56SP//E01.56ES//E01.51RJ//E01.53TR" .Or. ;
							VLC_CodES $ "E01.51SP//E01.51W1//E01.51ES//E01.99RJ//E01.99SP//E01.99ES//E01.53W1//E01.56W1//" .Or. ;
							VLC_CodES $ "E01.51W8//E01.52W8//E01.53W8//E01.54W8//E01.55W8//E01.56W8//E01.99W8//E01.51W9//" .Or. ;
							VLC_CodES $ "E01.52W9//E01.53W9//E01.54W9//E01.55W9//E01.56W9//E01.51TR//E01.52TR//E01.56TR//"
						Do nfe-sped.FXP
					Case VLC_CodES $ "E01.51W6//E01.52W6//E01.53W6//E01.54W6//E01.55W6//E01.56W6//"
						Do nfe-sped.FXP
*!*						Case VLC_CodES $ "E05.01ES"
*!*							Do nfe-e05_01es.FXP
					Case VLC_CodES $ "E01.30BR"  && Inserido ref. scrum-9745
						Do nfe-e01.30BR.FXP
					Case VLC_CodES $ "E03.14W8"  && Inserido ref. service now: INC0263643
						Do nfe-E03.14W8.FXP
						&&						CASE VLC_CodES $ "E05.11ES"
						&&							DO nfe-e05_11es.FXP
					Case VLC_CodES $ "E01.31ES//"  && Inserido ref. service now: INC0284050
						Do nfe-e01.31ES.FXP
					Case VLC_CodES $ "E10.00W6//"  && Inserido ref. service now: INC0272940 / INC0381492
						Do nfe-E10.00W6.FXP
					Case VLC_CodES $ "E10.00SP//E10.01SP//"  && Inserido ref. service now: INC0381492 / INC0390313
						Do nfe-E10.00SP.FXP						
*!*						Case VLC_CodES $ "E05.01W6//"  && Inserido ref. service now: INC0291381 
*!*							Do nfe-e05.01W6.FXP
*!*						Case VLC_CodES $ "E05.03W6//"  && removido ref. service now:
*!*							Do nfe-e05.03W6.FXP
					Case VLC_CodES $ "E01.57ES//"  && Inserido ref. service now: INC0294395
						Do nfe-e01.57ES.FXP
					Case VLC_CodES $ "E90.04ES//"  && Inserido ref. service now: Incidente - INC0322490 - Rui Santos
						Do nfe-e90.04ES_.FXP
					Case VLC_CodES $ "E01.57W8//"  && Inserido ref. service now: INC0321389 -- Rui Santos 23/12/2015
						Do e01.57W8.FXP
					Case VLC_CodES $ "E01.05ES//"  && Inserido ref. service now: INC0330533 -- PR
						Do nfe-e01.05ES.FXP
					Case VLC_CodES $ "E10.00ES//"  && Inserido ref. service now: INC0330787 -- PR
						Do nfe-E10.00ES.FXP
*!*						Removido ref. chamado service now INC0366354
*!*						Case VLC_CodES $ "E10.01ES//"  && Inserido ref. service now: INC0363005 -- Rui
*!*							Do nfe-E10.01ES.FXP
					Case VLC_CodES $ "E04.04SP//"  && Inserido ref. service now: INC0350924 -- PR
						Do nfe-e04.04sp.FXP
					Case VLC_CodES $ "E01.30F1//"  && Inserido ref. service now: INC0374785 -- PR
						Do nfe-E01.30F1.FXP
					Case VLC_CodES $ "E10.03ES//"  && Inserido ref. service now: INC0411824 -- PR
						Do nfe-E10.03ES.FXP												
					CASE VLC_CodES $ "E10.03W6//E10.03SP//" && Inserido ref. service now: INC0438398 -- Rui Anderson Santos
						Do nfe-E10.03SP.FXP					
					Case VLC_CodES $ "E01.92W6//"  
						Do nfe-E01.92W6.FXP							
					Case VLC_CodES $ "E01.93W8//"  && Inserido ref. service now: INC0433202 - Rui Anderson Santos
						DO nfe-e01.93W8.FXP
					Case VLC_CodES == "E90.04W8"
						Do nfe-E90.04W8.FXP	
					Case VLC_CodES == "E01.97ES"
						Do nfe-E01.97es.FXP						
					Case VLC_CodES == "E01.10W6"  && Inserido ref. service now: INC0469982 -- PR
						Do nfe-E01.10W6.FXP						
					Case VLC_CodES == "E01.10SP"  && Inserido ref. service now: INC0469982 -- PR
						Do nfe-E01.10SP.FXP
					*- PRIME - 1917 - INICIO	
					Case VLC_CodES == "E10.01W8" 
						Do nfe-E10.01W8.FXP
					*-Prime-2279 - Início
*!*						Case VLC_CodES == "E10.06W8"
*!*							Do nfe-E10.06W8.FXP
					*-Prime-2279 - Fim
					Case VLC_CodES == "E05.04ES"
						Do nfe-E05.04ES.FXP
					*- PRIME - 1917 - FIM
					*- PRIME - 2104 - INICIO	
					Case VLC_CodES == "E01.05WV"
						Do nfe-E01.05WV.FXP
					*- PRIME - 2104 - FIM
					*- PRIME-2600 - Inicio
					Case VLC_CodES == "E04.04W8"   
						Do nfe-E04.04W8.FXP						
					*- PRIME-2600 - Fim					
					*- SSA-170 - Inicio
					Case VLC_CodES == "E01.94ES"   
						Do nfe-E01.94ES.FXP						
					*- SSA-170 - Fim
				ENDCASE
				
				******************************************************
				*- Fechamento de período por Conta Contábil - Prime 930
				******************************************************
				If !VGO_Acc.VOL_ERROR
					With VGO_Dat
					  .FOL_SetParameter(1, VGO_Acc.VOC_EntryB06Ukey)
					  .VOA_Index[1] = "b11_ukey"
					  .FOL_Editcursor("B07_FRM", "B07_LAN", "B07TT", "Z", 1, 1)
					ENDWITH
					SELECT B07TT
					GO TOP
					SCAN WHILE !VGO_Acc.VOL_ERROR
						VGO_Acc.VOL_ERROR = FOL_verificaUtilizacaoConta(Alltrim(Nvl(B07TT.b11_ukey,"")))
					EndScan
				ENDIF
				VGO_Gen.FOL_CloseTable("B11CC")

				******************************************************
				*- Fechamento de período por Conta Contábil - Fim
				******************************************************
				
				*-- SCRUM-14543 - inicio
				If !VGO_Acc.VOL_ERROR
					SELECT e11t
					GO top
					VGO_Acc.VOL_ERROR = FOL_VerificaContalidade(Alltrim(Nvl(E11T.t04_ukey,"")),Substr(PLC_Form,1,3), E10.UKEY,PLC_Form,VLC_CodES)
				Endif
				*-- SCRUM-14543 - fim
				
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************
				IF !VGO_Acc.VOL_Error
					VGO_Acc.VOL_Error = FOL_VerificaMoedaIntegracao(VGO_Acc.VOC_EntryB06Ukey)
				ENDIF
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************

			Case PLC_Form = "J10_001"

				*- SSA-79 - INICIO
					SET PROCEDURE TO accint_services.PRG ADDITIVE
				*- SSA-79 - Fim

				Go Top In J11T
				VLC_CodigoES = FLC_CodigoES(J11T.t04_ukey)
				VLC_CodES = Trim(VLC_CodigoES)

				Do Case
										
					Case VLC_CodES $ "E03.13ES"  && Inserido ref. service now: INC0436850 - Rui Anderson Santos - 26/10/2016
						DO nfe-E03.13ES.FXP
					
					&& Rui INC0395929 - 24/06/2016
					Case VLC_CodES $ "E05.04W6"
						Do nfe-e05.04w6.FXP

					*- PRIME - 1963 - Início
					Case VLC_CodES $ "E05.04ES"
						Do nfe-e05.04es.FXP
					*- PRIME - 1963 - Fim

					Case VLC_CodES $ "E02.01//E02.01W6//E02.08W6"
						Do nfe-e02.01_.FXP
					Case VLC_CodES $ "E02.22ES//E02.22ES//E02.01ES//E02.12ES//E02.06ES//E01.20ES//E02.08ES//E02.09ES//E02.95ES//E52.01ES//E52.04ES//E52.01ES//E90.04ES//"
						Do nfe-e02.01ES_.FXP
					Case VLC_CodES == "E02.04ES"
						Do nfe-e02.04ES_.prg
					Case VLC_CodES $ "E02.01SP//E02.55SP//E02.01W8//E02.55W8//E60.01SP//E60.01W8//"
						Do nfe-e02.01_sp.FXP
					Case VLC_CodES $ "E60.04W8//"  && inserido ref. fechamento 02-2015
						Do nfe-e60.04W8.FXP
						&& Inclusão em 04-11-2014 por Rui Santos
						&& SCRUM-11709
					Case VLC_CodES $ "E52.03W8"
						Do nfe-e02.01_sp_SCRUM-11709.FXP
					Case VLC_CodES $ "E03.01//E03.02//E03.09//E90.05//"
						Do nfe-E03.01.FXP
					Case VLC_CodES $ "E03.01ES//E03.01W6//E03.04ES//E03.01W1//E90.05ES//"
						Do nfe-E03.01ES.FXP
					Case VLC_CodES $ "E10.99W6"
						Do nfe-E10.99W6.FXP
					Case VLC_CodES $ "E90.04//E02.04//E02.06RJ//E02.98RJ//"
						Do nfe-e02.01.FXP
					Case VLC_CodES $ "E02.06W1//"
						Do nfe-e02.01ES.FXP
					Case VLC_CodES $ "E02.02//E02.02W1//E02.07W1//" && removido a ces s02.02es conf. scrum-10317
						Do nfe-e02.02.FXP
					Case VLC_CodES == "E02.02ES"
						Do nfe-e02.02ES.FXP
					Case VLC_CodES == "E02.02W8"
						Do nfe-e02.02W8.FXP
					Case VLC_CodES $ "E03.04"
						Do nfe-E03.04.FXP
					Case VLC_CodES $ "E03.05"
						Do nfe-E03.05.FXP
					Case VLC_CodES == "E03.06"
						Do nfe-E03.06.FXP
					Case VLC_CodES == "E03.08"
						Do nfe-E03.08.FXP
					Case VLC_CodES $ "E03.08ES//E03.08W1//E03.05ES//E04.04W1//E03.14ES//E03.12ES//E03.16ES//E53.08ES//E53.14ES//" 
						Do nfe-E03.08ES.prg
					Case VLC_CodES == "E11.01RJ"
						Do nfe-e11.01.FXP
					Case VLC_CodES == "E03.08W8" && adicionado ref. jira:scrum-7007 - 07-03-2014
						Do nfe-E03.08W8.FXP
					Case VLC_CodES == "E11.03ES" && adicionado ref. jira:scrum-7591 - 03/04/2014
						Do nfe-e11.03ess.FXP
					Case VLC_CodES $ "E10.99SP"
						Do nfe-E10.99SP.FXP		&& Inserido ref. scrum-10324
					Case VLC_CodES $ "E02.02W6"
						Do nfe-e02.02W6.FXP		&& inserido ref. scrum-10345
					Case VLC_CodES $ "E09.02"
						Do nfe-e09.02.FXP		&& inserido ref. scrum-10366
					Case VLC_CodES $ "E01.18SP"
						Do nfe-e01.18sp.FXP		&& inserido ref. scrum-14177
					Case VLC_CodES $ "E02.03ES//E02.07ES" 
						Do nfe-e02.03ES.FXP		&& inserido ref. scrum-14177
					Case VLC_CodES $ "E52.06W8"
						Do nfe-E52.06W8.FXP		&& inserido ref. ajuste fechamento 04-2015
					Case VLC_CodES $ "E52.06W6"
						Do nfe-E52.06W6.FXP		&& 						
					Case VLC_CodES $ "E52.06ES"
						Do nfe-E52.06ES.FXP		&& inserido ref. ajuste fechamento 04-2015	
					Case VLC_CodES $ "E03.02W8" && Inserido ref. chamado service now: INC0263429
						Do nfe-E03.02W8.FXP		&& alterado ref. chamado service now: INC0267983
					
					Case VLC_CodES $ "E02.04W6" && Inserido ref. chamado service now: INC0306462
						Do nfe-e02.04W6.FXP
					Case VLC_CodES $ "E10.97ES//"  && Inserido ref. service now: INC0357594
						Do nfe-E10.97ES.FXP
					Case VLC_CodES $ "E10.98ES//"  && Inserido ref. service now: INC0357594
						Do nfe-E10.98ES.FXP
					Case VLC_CodES $ "E10.99ES//"  && Inserido ref. service now: INC0357594
						Do nfe-E10.99ES.FXP
					Case VLC_CodES $ "E53.08W8//"  && Inserido ref. service now: INC0361063
						Do nfe-E53.08W8.FXP
					Case VLC_CodES $ "E10.97F1//"  && Inserido ref. service now: INC0408814
						Do nfe-E10.97F1.FXP
					Case VLC_CodES $ "E10.98F1//"  && Inserido ref. service now: INC0408814
						Do nfe-E10.98F1.FXP
					Case VLC_CodES $ "E10.99F1//"  && Inserido ref. service now: INC0374785
						Do nfe-E10.99F1.FXP
					Case VLC_CodES $ "E10.96ES//"  && Inserido ref. service now: INC0398428
						Do nfe-E10.96ES.FXP										
					Case VLC_CodES == "E90.04W8"
						Do nfe-E90.04W8.FXP
					Case VLC_CodES == "E03.30ES"   && Inserido ref. service now: INC0479990
						Do nfe-E03.30ES.FXP
					*- PRIME - 1917 - INICIO
					Case VLC_CodES == "E01.97ES"
						Do nfe-E01.97es.FXP	
					*- PRIME - 1917 - FIM
					&& PRIME-1569 - Inicio
					Case VLC_CodES == "E53.01ES"   
						Do nfe-E53.01ES.FXP						
					&& PRIME-1569 - Fim
					*- PRIME - 2104 - INICIO	
					Case VLC_CodES == "E52.01WV"
						Do nfe-E52.01WV.FXP
					Case VLC_CodES == "E52.06WV"
						Do nfe-E52.06WV.FXP						
					*- PRIME - 2104 - FIM
					*- PRIME - 2605 - INICIO	
					Case VLC_CodES == "E01.13ES"
						Do nfe-E01.13ES.FXP						
					*- PRIME - 2605 - FIM

				ENDCASE 
				
				SELECT J11T
				Go Top In J11T				
				
				*--SCRUM-15080  - inicio
*				Do Accintj10_001.FXP	
				*-- fim
				
				*-- SCRUM-14543 - inicio
				If !VGO_Acc.VOL_ERROR
					VGO_Acc.VOL_ERROR = FOL_VerificaContalidade(Alltrim(Nvl(J11T.t04_ukey,"")),Substr(PLC_Form,1,3), J10.UKEY,PLC_Form, VLC_CodES)
				Endif
				*-- SCRUM-14543 - fim
				
				******************************************************
				*- Fechamento de período por Conta Contábil - Prime 930
				******************************************************
				If !VGO_Acc.VOL_ERROR
					With VGO_Dat
					  .FOL_SetParameter(1, VGO_Acc.VOC_EntryB06Ukey)
					  .VOA_Index[1] = "b11_ukey"
					  .FOL_Editcursor("B07_FRM", "B07_LAN", "B07TT", "Z", 1, 1)
					ENDWITH
					SELECT B07TT
					GO TOP
					SCAN WHILE !VGO_Acc.VOL_ERROR
						VGO_Acc.VOL_ERROR = FOL_verificaUtilizacaoConta(Alltrim(Nvl(B07TT.b11_ukey,"")))
					EndScan
				ENDIF
				VGO_Gen.FOL_CloseTable("B11CC")

				******************************************************
				*- Fechamento de período por Conta Contábil - Fim
				******************************************************
				
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************
				IF !VGO_Acc.VOL_Error
					VGO_Acc.VOL_Error = FOL_VerificaMoedaIntegracao(VGO_Acc.VOC_EntryB06Ukey)
				ENDIF
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************
				
			Case PLC_Form = "E10_001"
				Go Top In E11T
				VLC_CodigoES = FLC_CodigoES(E11T.t04_ukey)
				VLC_CodES = Trim(VLC_CodigoES)

				Do Case
					Case VLC_CodES $ "S02.01//S02.01W1//S02.01W6//"
						Do nfs-s02.01.FXP
					Case VLC_CodES $ "S02.01ES"
						Do nfs-s02.01ES.FXP
					Case VLC_CodES $ "S04.01//S04.01W1"
						Do nfs-s04.01.FXP
					Case VLC_CodES $ "S04.01W9"  && Inserido ref. INC0423482
						Do nfs-s04.01W9.FXP
					Case VLC_CodES $ "S04.04SP"
						Do nfs-s04.04sp.FXP
					Case VLC_CodES $ "S04.04"					
						Do nfs-s04.04.FXP
					Case VLC_CodES $ "S04.06SP"
						Do nfs-s04.06SP.FXP						
					Case VLC_CodES $ "S04.05"
						Do nfs-s04.05.FXP
					Case VLC_CodES $ "S04.03//"
						Do nfs-s04.03.FXP
					Case VLC_CodES $ "S04.04ES//"  && inserido ref. scrum-10338
						Do nfs-s04.03ES.FXP
					Case VLC_CodES $ "S04.03SP//S03.03SP"
						Do nfs-s04.03sp.FXP
					Case VLC_CodES $ "S04.04"
						Do nfde-de04.04.FXP
					Case VLC_CodES $ "S04.01W8"
						Do nfs-s04.01W8.FXP		&& inserido ref. scrum-
					Case VLC_CodES $ "S11.03W8"
						Do nfs-S11.03W8.FXP
					Case VLC_CodES $ "S01.51ES"
						Do nfs-s01.51ES.FXP
					Case VLC_CodES $ "S01.51SP" && inserido ref. service now: INC0277379
						Do nfs-s01.51sp.FXP
					Case VLC_CodES $ "S01.51W9" && inserido ref. service now: INC0358191
						Do nfs-s01.51W9.FXP					
					Case VLC_CodES $ "S03.16W6" && inserido ref. service now: INC0448908 - Rui - 02/12/2016
						Do nfs-S03.16W6.FXP									
					*-Prime 1978 - Início
					Case VLC_CodES $ "S01.31ES"
						Do nfs-s01.31ES.FXP
					*-Prime 1978 - Fim					
					*-Prime 2062 - Inicio
					Case VLC_CodES == "S03.16W8"
						Do nfs-s03.16W8.FXP
					*-Prime 2062 - Fim
					*-Prime 2012 - Inicio
					Case VLC_CodES == "S04.04W8"
						Do nfs-s04.04W8.FXP
					*-Prime 2612 - Fim									

				Endcase
				*-- SCRUM-14543 - inicio
				If !VGO_Acc.VOL_ERROR
					VGO_Acc.VOL_ERROR = FOL_VerificaContalidade(Alltrim(Nvl(E11T.t04_ukey,"")),Substr(PLC_Form,1,3), E10.UKEY,PLC_Form, VLC_CodES)
				Endif
				*-- SCRUM-14543 - fim
				
				******************************************************
				*- Fechamento de período por Conta Contábil - Prime 930
				******************************************************
				If !VGO_Acc.VOL_ERROR
					With VGO_Dat
					  .FOL_SetParameter(1, VGO_Acc.VOC_EntryB06Ukey)
					  .VOA_Index[1] = "b11_ukey"
					  .FOL_Editcursor("B07_FRM", "B07_LAN", "B07TT", "Z", 1, 1)
					ENDWITH
					SELECT B07TT
					GO TOP
					SCAN WHILE !VGO_Acc.VOL_ERROR
						VGO_Acc.VOL_ERROR = FOL_verificaUtilizacaoConta(Alltrim(Nvl(B07TT.b11_ukey,"")))
					EndScan
				ENDIF
				VGO_Gen.FOL_CloseTable("B11CC")
				******************************************************
				*- Fechamento de período por Conta Contábil - Fim
				******************************************************
				
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************
				IF !VGO_Acc.VOL_Error
					VGO_Acc.VOL_Error = FOL_VerificaMoedaIntegracao(VGO_Acc.VOC_EntryB06Ukey)
				ENDIF
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************
				
				*-Financeiro
				*- Contas a Pagar
			Case PLC_Form == "F11_001" Or Alltrim(Upper(PLC_Form))== "GERA_CONTAS_PAGAR"

				*-Scrum 14699 - Janilson
				VLC_A21_501 = VGO_GEN.FOC_QuickSql("A21_501_N","A21","UKEY","'"+F11.a21_ukey+"'")
				If VLC_A21_501 = 1
					Return .T.
				Endif
				*-Fim Scrum 14699

				VGO_Custom.FOL_CSqlExec("SELECT F48.*, A40.A40_002_C FROM STAR_DATA@F48 (NOLOCK) INNER JOIN STAR_DATA@F11 (NOLOCK) ON F11.UKEY = F48.F11_UKEY INNER"+" JOIN STAR_DATA@A40 (NOLOCK) ON A40.UKEY = F48.A40_UKEY WHERE F11.UKEY = ?f14t.f11_ukey","F48TT")

				Go Top In F48TT
				If !Eof("F48TT")
					* TIpo 08.05 INC0284887
					If (F11.a21_ukey = "STAR_STAR__14313NBP1")
						Do f11_001_0805.prg

					Else
						If Empty(F11.f11_ipar)
							&& Verificação do tipo para integração exclusiva do tipo 02.13 cisco BR
							*-Prime-2330 - Início
							DO CASE 
								CASE (F11.a21_ukey = "STAR_UJ40G_2G70LEEQW")
									Do f11_001y.prg

								CASE (F11.a21_ukey = "20180626LS5C8F0VQZCI")
									DO f11_001_intercomp.prg

								OTHERWISE
									Do f11_001y2014.prg
							ENDCASE
							*-Prime-2330 - Fim							
						Endif
					Endif
				Else
					If Empty(F11.f11_ipar)
						Do f11_001ay.FXP
					Endif
				Endif
				*-- SCRUM-14544 - inicio
				If !VGO_Acc.VOL_ERROR
					*- Somente se for titulo manual
					If Empty(Nvl(F11.f11_iukeyp,""))
						FOL_IntegraContalidade(Alltrim(Nvl(F11.a21_ukey,"")), F11.UKEY,PLC_Form)
					Endif
				Endif
				*-- SCRUM-14544 - fim
				******************************************************
				*- Fechamento de período por Conta Contábil - Prime 930
				******************************************************
				If !VGO_Acc.VOL_ERROR
					With VGO_Dat
					  .FOL_SetParameter(1, VGO_Acc.VOC_EntryB06Ukey)
					  .VOA_Index[1] = "b11_ukey"
					  .FOL_Editcursor("B07_FRM", "B07_LAN", "B07TT", "Z", 1, 1)
					ENDWITH
					SELECT B07TT
					GO TOP
					SCAN WHILE !VGO_Acc.VOL_ERROR
						VGO_Acc.VOL_ERROR = FOL_verificaUtilizacaoConta(Alltrim(Nvl(B07TT.b11_ukey,"")))
					EndScan
				ENDIF
				VGO_Gen.FOL_CloseTable("B11CC")

				******************************************************
				*- Fechamento de período por Conta Contábil - Fim
				******************************************************
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************
				IF !VGO_Acc.VOL_Error
					VGO_Acc.VOL_Error = FOL_VerificaMoedaIntegracao(VGO_Acc.VOC_EntryB06Ukey)
				ENDIF
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************

				*- Comissões a Pagar
			Case PLC_Form == "F11_002" 
				**- Inserido Ref. chamado: INC0484540 
				**- Somente Integra se a comissao nao tiver origem, se tiver já foi integrada pela nota
				IF EMPTY(NVL(F11.F11_IUKEYP,''))				
					VLC_TIPO = Fol_tipo(Nvl(F14T.a21_ukey,''))
					Do Case
						Case Alltrim(VLC_TIPO) $ '15.96//15.97'
							Do f11_002A.FXP
						Case !Alltrim(VLC_TIPO) $ '15.96//15.97'
							Do f11_002y.FXP
					Endcase
					*-- SCRUM-14544 - inicio
					If !VGO_Acc.VOL_ERROR
						FOL_IntegraContalidade(Alltrim(Nvl(F11.a21_ukey,"")), F11.UKEY,"F11_002")
					Endif
					*-- SCRUM-14544 - fim
				ENDIF
				******************************************************
				*- Fechamento de período por Conta Contábil - Prime 930
				******************************************************
				If !VGO_Acc.VOL_ERROR
					With VGO_Dat
					  .FOL_SetParameter(1, VGO_Acc.VOC_EntryB06Ukey)
					  .VOA_Index[1] = "b11_ukey"
					  .FOL_Editcursor("B07_FRM", "B07_LAN", "B07TT", "Z", 1, 1)
					ENDWITH
					SELECT B07TT
					GO TOP
					SCAN WHILE !VGO_Acc.VOL_ERROR
						VGO_Acc.VOL_ERROR = FOL_verificaUtilizacaoConta(Alltrim(Nvl(B07TT.b11_ukey,"")))
					EndScan
				ENDIF
				VGO_Gen.FOL_CloseTable("B11CC")

				******************************************************
				*- Fechamento de período por Conta Contábil - Fim
				******************************************************
				
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************
				IF !VGO_Acc.VOL_Error
					VGO_Acc.VOL_Error = FOL_VerificaMoedaIntegracao(VGO_Acc.VOC_EntryB06Ukey)
				ENDIF
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************

			*- PRIME-1407 - Início	
			Case PLC_Form == "F11_003"
				
				vln_creditMemo = 0
				vln_creditMemo = Fol_isCreditMemo(Nvl(f11.a21_ukey,''))
											
				IF vln_creditMemo = 1
					DO F11_003.FXP
				ENDIF
			*- PRIME-1407 - Fim				

				*-- SCRUM-14544 - inicio
				*- Comissões a Receber
			Case PLC_Form == "F12_002"
				FOL_IntegraContalidade(Alltrim(Nvl(f12.a21_ukey,"")), f12.UKEY,"F12_002")
				*-- SCRUM-14544 - fim
				
				******************************************************
				*- Fechamento de período por Conta Contábil - Prime 930
				******************************************************
				If !VGO_Acc.VOL_ERROR
					With VGO_Dat
					  .FOL_SetParameter(1, VGO_Acc.VOC_EntryB06Ukey)
					  .VOA_Index[1] = "b11_ukey"
					  .FOL_Editcursor("B07_FRM", "B07_LAN", "B07TT", "Z", 1, 1)
					ENDWITH
					SELECT B07TT
					GO TOP
					SCAN WHILE !VGO_Acc.VOL_ERROR
						VGO_Acc.VOL_ERROR = FOL_verificaUtilizacaoConta(Alltrim(Nvl(B07TT.b11_ukey,"")))
					EndScan
				ENDIF
				VGO_Gen.FOL_CloseTable("B11CC")

				******************************************************
				*- Fechamento de período por Conta Contábil - Fim
				******************************************************
				
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************
				IF !VGO_Acc.VOL_Error
					VGO_Acc.VOL_Error = FOL_VerificaMoedaIntegracao(VGO_Acc.VOC_EntryB06Ukey)
				ENDIF
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************

				*- Contas a Receber
			Case PLC_Form == "F12_001"
				If Empty(f12.f12_ipar)
					&& Do f12_001.FXP arquivo corrompido substituido pelo abaixo - Rui Santos 13/10/2016
					Do f12_001_novo.FXP
				Endif

				*-- SCRUM-14544 - inicio
				If !VGO_Acc.VOL_ERROR And Empty(f12.f12_ipar)
					FOL_IntegraContalidade(Alltrim(Nvl(f12.a21_ukey,"")), f12.UKEY,PLC_Form)
				Endif
				*-- SCRUM-14544 - fim
				******************************************************
				*- Fechamento de período por Conta Contábil - Prime 930
				******************************************************
				If !VGO_Acc.VOL_ERROR
					With VGO_Dat
					  .FOL_SetParameter(1, VGO_Acc.VOC_EntryB06Ukey)
					  .VOA_Index[1] = "b11_ukey"
					  .FOL_Editcursor("B07_FRM", "B07_LAN", "B07TT", "Z", 1, 1)
					ENDWITH
					SELECT B07TT
					GO TOP
					SCAN WHILE !VGO_Acc.VOL_ERROR
						VGO_Acc.VOL_ERROR = FOL_verificaUtilizacaoConta(Alltrim(Nvl(B07TT.b11_ukey,"")))
					EndScan
				ENDIF
				VGO_Gen.FOL_CloseTable("B11CC")

				******************************************************
				*- Fechamento de período por Conta Contábil - Fim
				******************************************************
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************
				IF !VGO_Acc.VOL_Error
					VGO_Acc.VOL_Error = FOL_VerificaMoedaIntegracao(VGO_Acc.VOC_EntryB06Ukey)
				ENDIF
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************

				*- Quitação de Documentos a Pagar
			Case PLC_Form == "F18_001"
				
				VGO_Toolbar.VOO_ActiveForm.OOL_SysLog.FOL_ResetLog() &&SCRUM-14544

				If INLIST(Upper(Alltrim(_Screen.ActiveForm.Name)),"F18_026","F18_026_ESP") && Tela de Retorno de CNAB
					Do new_f18_026.FXP
				else
					&& adicionado em 28/03/2016 - chamado INC0362246
					if f18.f18_009_b > 0
						&& Contabilização para moeda internacional
						Do f18_001_inter.FXP				
					else			
						Do f18_001.FXP
						*-- SCRUM-14544 - inicio
						Select f16T
						Scan For !VGO_Acc.VOL_ERROR And f18.f18_004_n = 1
							FOL_IntegraContalidade(Alltrim(Nvl(f16T.a21_ukey,"")), f16T.UKEY,PLC_Form, f18.UKEY)
						Endscan
						*-- SCRUM-14544 - fim
					endif
				Endif	
				
				******************************************************
				*- Fechamento de período por Conta Contábil - Prime 930
				******************************************************
				If !VGO_Acc.VOL_ERROR
					With VGO_Dat
					  .FOL_SetParameter(1, VGO_Acc.VOC_EntryB06Ukey)
					  .VOA_Index[1] = "b11_ukey"
					  .FOL_Editcursor("B07_FRM", "B07_LAN", "B07TT", "Z", 1, 1)
					ENDWITH
					SELECT B07TT
					GO TOP
					SCAN WHILE !VGO_Acc.VOL_ERROR
						VGO_Acc.VOL_ERROR = FOL_verificaUtilizacaoConta(Alltrim(Nvl(B07TT.b11_ukey,"")))
					EndScan
				ENDIF
				VGO_Gen.FOL_CloseTable("B11CC")

				******************************************************
				*- Fechamento de período por Conta Contábil - Fim
				******************************************************
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************
				IF !VGO_Acc.VOL_Error
					VGO_Acc.VOL_Error = FOL_VerificaMoedaIntegracao(VGO_Acc.VOC_EntryB06Ukey)
				ENDIF
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************
							
				*- Quitação de Documentos a Receber
			Case PLC_Form == "F18_002"

				** VGO_Toolbar.VOO_ActiveForm.OOL_SysLog.FOL_ResetLog() &&SCRUM-14544
				** ----------------------------------------------------------------------------------------------------
				** Removido por poder existir log no processo da tela de retorno e ao finalizar esta exibindo em branco
				** ----------------------------------------------------------------------------------------------------

				if !VGO_GEN.VOL_SERVICEMODE AND Upper(Alltrim(_Screen.ActiveForm.Name)) == "F18_025" && Tela de Retorno de CNAB &&Adicionado a verificação do Service Mode para não dar erro no Serviço
					Do new_F18_025.FXP
				ELSE			
					Do f18_002.FXP			
				Endif

				*-- SCRUM-14544 - inicio
				Select f15T
				Scan For !VGO_Acc.VOL_ERROR And f18.f18_004_n = 1
					FOL_IntegraContalidade(Alltrim(Nvl(f15T.a21_ukey,"")), f15T.UKEY,PLC_Form, f18.UKEY)
				Endscan
				*-- SCRUM-14544 - fim
				******************************************************
				*- Fechamento de período por Conta Contábil - Prime 930
				******************************************************
				If !VGO_Acc.VOL_ERROR
					With VGO_Dat
					  .FOL_SetParameter(1, VGO_Acc.VOC_EntryB06Ukey)
					  .VOA_Index[1] = "b11_ukey"
					  .FOL_Editcursor("B07_FRM", "B07_LAN", "B07TT", "Z", 1, 1)
					ENDWITH
					SELECT B07TT
					GO TOP
					SCAN WHILE !VGO_Acc.VOL_ERROR
						VGO_Acc.VOL_ERROR = FOL_verificaUtilizacaoConta(Alltrim(Nvl(B07TT.b11_ukey,"")))
					EndScan
				ENDIF
				VGO_Gen.FOL_CloseTable("B11CC")

				******************************************************
				*- Fechamento de período por Conta Contábil - Fim
				******************************************************
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************
				IF !VGO_Acc.VOL_Error
					VGO_Acc.VOL_Error = FOL_VerificaMoedaIntegracao(VGO_Acc.VOC_EntryB06Ukey)
				ENDIF
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************

				*- Transferência entre Contas Bancárias
			Case PLC_Form == "F18_005"
				VGO_Toolbar.VOO_ActiveForm.OOL_SysLog.FOL_ResetLog() &&SCRUM-14544
				Do f18_005.FXP

				*-- SCRUM-14544 - inicio
				Select f17T
				Scan For !VGO_Acc.VOL_ERROR
					FOL_IntegraContalidade(Alltrim(Nvl(f17T.a21_ukey,"")), f17T.UKEY,PLC_Form, f18.UKEY)
				Endscan
				*-- SCRUM-14544 - fim
				******************************************************
				*- Fechamento de período por Conta Contábil - Prime 930
				******************************************************
				If !VGO_Acc.VOL_ERROR
					With VGO_Dat
					  .FOL_SetParameter(1, VGO_Acc.VOC_EntryB06Ukey)
					  .VOA_Index[1] = "b11_ukey"
					  .FOL_Editcursor("B07_FRM", "B07_LAN", "B07TT", "Z", 1, 1)
					ENDWITH
					SELECT B07TT
					GO TOP
					SCAN WHILE !VGO_Acc.VOL_ERROR
						VGO_Acc.VOL_ERROR = FOL_verificaUtilizacaoConta(Alltrim(Nvl(B07TT.b11_ukey,"")))
					EndScan
				ENDIF
				VGO_Gen.FOL_CloseTable("B11CC")

				******************************************************
				*- Fechamento de período por Conta Contábil - Fim
				******************************************************
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************
				IF !VGO_Acc.VOL_Error
					VGO_Acc.VOL_Error = FOL_VerificaMoedaIntegracao(VGO_Acc.VOC_EntryB06Ukey)
				ENDIF
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************

				*- Movimentação de Entrada em Contas
			Case PLC_Form == "F18_006"
				*- Projeto migração
				*- Trecho comentado por não mais existir a propriedade VOO_ActiveForm para referenciar telas NUC.
				*- Trocado a forma de armazenar o log
				*-VGO_Toolbar.VOO_ActiveForm.OOL_SysLog.FOL_ResetLog() &&SCRUM-14544
				ULIB.PCO.lWriteLoginArray = .T.
				ULIB.PCO.aLogInfo[1,1] = 'F18'
				ULIB.PCO.aLogInfo[1,3] = 'F18'
				ULIB.PCO.aLogInfo[1,4] = f18.ukey
				
				*- Projeto Migração
				*- Tenho que abrir o cursor F17 na mão, pois a tela é NUC e só abre a F18
				VGO_Gen.FOL_SetParameter(1, F18.UKEY)
				VGO_Gen.FOL_ExecuteCursor("F17_F18_UKEY","F17T",1)
				
				Do f18_006.FXP

				*-- SCRUM-14544 - inicio
				Select f17T
				Scan For !VGO_Acc.VOL_ERROR
					FOL_IntegraContalidade(Alltrim(Nvl(f17T.a21_ukey,"")), f17T.UKEY,PLC_Form, f18.UKEY)
				Endscan
				*-- SCRUM-14544 - fim
				
				******************************************************
				*- Fechamento de período por Conta Contábil - Prime 930
				******************************************************
				If !VGO_Acc.VOL_ERROR
					With VGO_Dat
					  .FOL_SetParameter(1, VGO_Acc.VOC_EntryB06Ukey)
					  .VOA_Index[1] = "b11_ukey"
					  .FOL_Editcursor("B07_FRM", "B07_LAN", "B07TT", "Z", 1, 1)
					ENDWITH
					SELECT B07TT
					GO TOP
					SCAN WHILE !VGO_Acc.VOL_ERROR
						VGO_Acc.VOL_ERROR = FOL_verificaUtilizacaoConta(Alltrim(Nvl(B07TT.b11_ukey,"")))
					EndScan
				ENDIF
				VGO_Gen.FOL_CloseTable("B11CC")

				******************************************************
				*- Fechamento de período por Conta Contábil - Fim
				******************************************************
				
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************
				IF !VGO_Acc.VOL_Error
					VGO_Acc.VOL_Error = FOL_VerificaMoedaIntegracao(VGO_Acc.VOC_EntryB06Ukey)
				ENDIF
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************
				
				*- Trecho para finalizar o log
				ulib.UXL.saveArraytoBD()
                ULIB.PCO.lWriteLoginArray = .F.


				*- Movimentação de Saída em Contas
			Case PLC_Form == "F18_007"
				VGO_Toolbar.VOO_ActiveForm.OOL_SysLog.FOL_ResetLog() &&SCRUM-14544
				
				*- SCRUM-1686 - Início
				if used("F18") and !empty(nvl(f18.f18_ukey_qt,''))
					Do f18_007_wht.FXP
				else
					Do f18_007.FXP
				endif
				*- SCRUM-1686 - Fim				
				

				*-- SCRUM-14544 - inicio
				Select f17T
				Scan For !VGO_Acc.VOL_ERROR
					FOL_IntegraContalidade(Alltrim(Nvl(f17T.a21_ukey,"")), f17T.UKEY,PLC_Form, f18.UKEY)
				Endscan
				*-- SCRUM-14544 - fim

				******************************************************
				*- Fechamento de período por Conta Contábil - Prime 930
				******************************************************
				If !VGO_Acc.VOL_ERROR
					With VGO_Dat
					  .FOL_SetParameter(1, VGO_Acc.VOC_EntryB06Ukey)
					  .VOA_Index[1] = "b11_ukey"
					  .FOL_Editcursor("B07_FRM", "B07_LAN", "B07TT", "Z", 1, 1)
					ENDWITH
					SELECT B07TT
					GO TOP
					SCAN WHILE !VGO_Acc.VOL_ERROR
						VGO_Acc.VOL_ERROR = FOL_verificaUtilizacaoConta(Alltrim(Nvl(B07TT.b11_ukey,"")))
					EndScan
				ENDIF
				VGO_Gen.FOL_CloseTable("B11CC")

				******************************************************
				*- Fechamento de período por Conta Contábil - Fim
				******************************************************
				
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************
				IF !VGO_Acc.VOL_Error
					VGO_Acc.VOL_Error = FOL_VerificaMoedaIntegracao(VGO_Acc.VOC_EntryB06Ukey)
				ENDIF
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************

				*- Emissão de Cheques a Pagar
			Case PLC_Form == "F18_014"
				Do f18_014.FXP
				
				******************************************************
				*- Fechamento de período por Conta Contábil - Prime 930
				******************************************************
				If !VGO_Acc.VOL_ERROR
					With VGO_Dat
					  .FOL_SetParameter(1, VGO_Acc.VOC_EntryB06Ukey)
					  .VOA_Index[1] = "b11_ukey"
					  .FOL_Editcursor("B07_FRM", "B07_LAN", "B07TT", "Z", 1, 1)
					ENDWITH
					SELECT B07TT
					GO TOP
					SCAN WHILE !VGO_Acc.VOL_ERROR
						VGO_Acc.VOL_ERROR = FOL_verificaUtilizacaoConta(Alltrim(Nvl(B07TT.b11_ukey,"")))
					EndScan
				ENDIF
				VGO_Gen.FOL_CloseTable("B11CC")

				******************************************************
				*- Fechamento de período por Conta Contábil - Fim
				******************************************************
				
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************
				IF !VGO_Acc.VOL_Error
					VGO_Acc.VOL_Error = FOL_VerificaMoedaIntegracao(VGO_Acc.VOC_EntryB06Ukey)
				ENDIF
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************

				*- Depositos de Cheques a Receber
			Case PLC_Form == "F18_015"
				Do f18_015.FXP
				
				******************************************************
				*- Fechamento de período por Conta Contábil - Prime 930
				******************************************************
				If !VGO_Acc.VOL_ERROR
					With VGO_Dat
					  .FOL_SetParameter(1, VGO_Acc.VOC_EntryB06Ukey)
					  .VOA_Index[1] = "b11_ukey"
					  .FOL_Editcursor("B07_FRM", "B07_LAN", "B07TT", "Z", 1, 1)
					ENDWITH
					SELECT B07TT
					GO TOP
					SCAN WHILE !VGO_Acc.VOL_ERROR
						VGO_Acc.VOL_ERROR = FOL_verificaUtilizacaoConta(Alltrim(Nvl(B07TT.b11_ukey,"")))
					EndScan
				ENDIF
				VGO_Gen.FOL_CloseTable("B11CC")

				******************************************************
				*- Fechamento de período por Conta Contábil - Fim
				******************************************************
				
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************
				IF !VGO_Acc.VOL_Error
					VGO_Acc.VOL_Error = FOL_VerificaMoedaIntegracao(VGO_Acc.VOC_EntryB06Ukey)
				ENDIF
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************

				*- Aplicações Financeiras
			Case PLC_Form == "F18_017"
				Do f18_017.FXP
				
				******************************************************
				*- Fechamento de período por Conta Contábil - Prime 930
				******************************************************
				If !VGO_Acc.VOL_ERROR
					With VGO_Dat
					  .FOL_SetParameter(1, VGO_Acc.VOC_EntryB06Ukey)
					  .VOA_Index[1] = "b11_ukey"
					  .FOL_Editcursor("B07_FRM", "B07_LAN", "B07TT", "Z", 1, 1)
					ENDWITH
					SELECT B07TT
					GO TOP
					SCAN WHILE !VGO_Acc.VOL_ERROR
						VGO_Acc.VOL_ERROR = FOL_verificaUtilizacaoConta(Alltrim(Nvl(B07TT.b11_ukey,"")))
					EndScan
				ENDIF
				VGO_Gen.FOL_CloseTable("B11CC")

				******************************************************
				*- Fechamento de período por Conta Contábil - Fim
				******************************************************
				
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************
				IF !VGO_Acc.VOL_Error
					VGO_Acc.VOL_Error = FOL_VerificaMoedaIntegracao(VGO_Acc.VOC_EntryB06Ukey)
				ENDIF
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************

				*- Resgate de Aplicações Financeiras
			Case PLC_Form == "F18_018"
				Do f18_018.FXP
				
				******************************************************
				*- Fechamento de período por Conta Contábil - Prime 930
				******************************************************
				If !VGO_Acc.VOL_ERROR
					With VGO_Dat
					  .FOL_SetParameter(1, VGO_Acc.VOC_EntryB06Ukey)
					  .VOA_Index[1] = "b11_ukey"
					  .FOL_Editcursor("B07_FRM", "B07_LAN", "B07TT", "Z", 1, 1)
					ENDWITH
					SELECT B07TT
					GO TOP
					SCAN WHILE !VGO_Acc.VOL_ERROR
						VGO_Acc.VOL_ERROR = FOL_verificaUtilizacaoConta(Alltrim(Nvl(B07TT.b11_ukey,"")))
					EndScan
				ENDIF
				VGO_Gen.FOL_CloseTable("B11CC")

				******************************************************
				*- Fechamento de período por Conta Contábil - Fim
				******************************************************
				
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************
				IF !VGO_Acc.VOL_Error
					VGO_Acc.VOL_Error = FOL_VerificaMoedaIntegracao(VGO_Acc.VOC_EntryB06Ukey)
				ENDIF
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************

				*- Efetivação de Adiantamento de Valor a Pagar
			Case PLC_Form == "F18_021"
				VGO_Toolbar.VOO_ActiveForm.OOL_SysLog.FOL_ResetLog() &&SCRUM-14544
				VLC_TIPO = ALLTRIM(Fol_tipo(Nvl(f16T.a21_ukey,'')))

				*- PRIME-1485 - Início
				vln_creditMemo = 0
				vln_creditMemo = Fol_isCreditMemo(Nvl(f16T.a21_ukey,''))
				
				IF vln_creditMemo = 1
					DO f18_021_credit.fxp
				ENDIF
				*- PRIME-1485 - Fim				
				
				&& PRIME 1192 - RUI ANDERSON
				&& Desabilitar integração contábil na efetivação de adiantamento para o tipo 30.35
				
				&& Mudança ocorreu em 19/09/2017 em decorrencia a reunião para definição de contabilização de creditos
				&& onde participaram Rafael, Jorge, Ana Lourdes e Rui Anderson Santos.
				&& só vai contabilizar as efetivações que não forem creditmemo
				IF ALLTRIM(VLC_TIPO) != '30.35' AND vln_creditMemo = 0
				
					If Inlist(Upper(Alltrim(_Screen.ActiveForm.Name)),"F18_026","F18_026_ESP") && Tela de Retorno de CNAB -- incluso por rpaulista - Scrum 14457
						Do f18_021_esp.FXP
					Else
						IF Alltrim(VLC_TIPO) $ '15.98//16.00//15.95//15.94//16.01//16.02//16.03//16.06'	&&SCRUM - 15182
							*- PRIME-1485 - Início
							&& Do f18_021_Tipoesp.FXP
							*- PRIME-1485 - Fim							
						Else
							Do f18_021.FXP
						Endif
					Endif

					*-- SCRUM-14544 - inicio
					If f18.f18_004_n = 1
						Select f16T
						Scan For !VGO_Acc.VOL_ERROR
							FOL_IntegraContalidade(Alltrim(Nvl(f16T.a21_ukey,"")), f16T.UKEY,PLC_Form, f18.UKEY)
						Endscan
					Endif
					*-- SCRUM-14544 - fim
					
					******************************************************
					*- Fechamento de período por Conta Contábil - Prime 930
					******************************************************
					If !VGO_Acc.VOL_ERROR
						With VGO_Dat
						  .FOL_SetParameter(1, VGO_Acc.VOC_EntryB06Ukey)
						  .VOA_Index[1] = "b11_ukey"
						  .FOL_Editcursor("B07_FRM", "B07_LAN", "B07TT", "Z", 1, 1)
						ENDWITH
						SELECT B07TT
						GO TOP
						SCAN WHILE !VGO_Acc.VOL_ERROR
							VGO_Acc.VOL_ERROR = FOL_verificaUtilizacaoConta(Alltrim(Nvl(B07TT.b11_ukey,"")))
						EndScan
					ENDIF
					VGO_Gen.FOL_CloseTable("B11CC")

					******************************************************
					*- Fechamento de período por Conta Contábil - Fim
					******************************************************
					
					****************************************************************
					*- Geração de integração com moeda diferente de Real - Prime 220
					****************************************************************
					IF !VGO_Acc.VOL_Error
						VGO_Acc.VOL_Error = FOL_VerificaMoedaIntegracao(VGO_Acc.VOC_EntryB06Ukey)
					ENDIF
					****************************************************************
					*- Geração de integração com moeda diferente de Real - Prime 220
					****************************************************************
					
				ENDIF
				&& FIM DO IF DA PRIME 1192
				
				*- Efetivação de Adiantamento de Valor a Receber
			Case PLC_Form == "F18_022"
				VGO_Toolbar.VOO_ActiveForm.OOL_SysLog.FOL_ResetLog() &&SCRUM-14544
				Do f18_022.FXP

				*-- SCRUM-14544 - inicio
				If f18.f18_004_n = 1
					Select f15T
					Scan For !VGO_Acc.VOL_ERROR
						FOL_IntegraContalidade(Alltrim(Nvl(f15T.a21_ukey,"")), f15T.UKEY,PLC_Form, f18.UKEY)
					Endscan
				Endif
				*-- SCRUM-14544 - fim
				
				******************************************************
				*- Fechamento de período por Conta Contábil - Prime 930
				******************************************************
				If !VGO_Acc.VOL_ERROR
					With VGO_Dat
					  .FOL_SetParameter(1, VGO_Acc.VOC_EntryB06Ukey)
					  .VOA_Index[1] = "b11_ukey"
					  .FOL_Editcursor("B07_FRM", "B07_LAN", "B07TT", "Z", 1, 1)
					ENDWITH
					SELECT B07TT
					GO TOP
					SCAN WHILE !VGO_Acc.VOL_ERROR
						VGO_Acc.VOL_ERROR = FOL_verificaUtilizacaoConta(Alltrim(Nvl(B07TT.b11_ukey,"")))
					EndScan
				ENDIF
				VGO_Gen.FOL_CloseTable("B11CC")

				******************************************************
				*- Fechamento de período por Conta Contábil - Fim
				******************************************************
				
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************
				IF !VGO_Acc.VOL_Error
					VGO_Acc.VOL_Error = FOL_VerificaMoedaIntegracao(VGO_Acc.VOC_EntryB06Ukey)
				ENDIF
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************

				*- RETORNO DE CNAB A PAGAR
			Case PLC_Form == "F18_026"
				*					browse NORM

				*- Estorno de Títulos a Pagar
			Case PLC_Form == "F18_030"
				VGO_Toolbar.VOO_ActiveForm.OOL_SysLog.FOL_ResetLog() &&SCRUM-14544
				Do f18_030.FXP

				*-- SCRUM-14544 - inicio
				Select f16T
				Scan For !VGO_Acc.VOL_ERROR
					FOL_IntegraContalidade(Alltrim(Nvl(f16T.a21_ukey,"")), f16T.UKEY,PLC_Form, f18.UKEY)
				Endscan
				*-- SCRUM-14544 - fim
				
				******************************************************
				*- Fechamento de período por Conta Contábil - Prime 930
				******************************************************
				If !VGO_Acc.VOL_ERROR
					With VGO_Dat
					  .FOL_SetParameter(1, VGO_Acc.VOC_EntryB06Ukey)
					  .VOA_Index[1] = "b11_ukey"
					  .FOL_Editcursor("B07_FRM", "B07_LAN", "B07TT", "Z", 1, 1)
					ENDWITH
					SELECT B07TT
					GO TOP
					SCAN WHILE !VGO_Acc.VOL_ERROR
						VGO_Acc.VOL_ERROR = FOL_verificaUtilizacaoConta(Alltrim(Nvl(B07TT.b11_ukey,"")))
					EndScan
				ENDIF
				VGO_Gen.FOL_CloseTable("B11CC")

				******************************************************
				*- Fechamento de período por Conta Contábil - Fim
				******************************************************
				
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************
				IF !VGO_Acc.VOL_Error
					VGO_Acc.VOL_Error = FOL_VerificaMoedaIntegracao(VGO_Acc.VOC_EntryB06Ukey)
				ENDIF
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************

				*- Estorno de Títulos a Receber
			Case PLC_Form == "F18_031"
				VGO_Toolbar.VOO_ActiveForm.OOL_SysLog.FOL_ResetLog() &&SCRUM-14544
				Do f18_031.FXP

				*-- SCRUM-14544 - inicio
				Select f15T
				Scan For !VGO_Acc.VOL_ERROR
					FOL_IntegraContalidade(Alltrim(Nvl(f15T.a21_ukey,"")), f15T.UKEY,PLC_Form, f18.UKEY)
				Endscan
				*-- SCRUM-14544 - fim
				
				******************************************************
				*- Fechamento de período por Conta Contábil - Prime 930
				******************************************************
				If !VGO_Acc.VOL_ERROR
					With VGO_Dat
					  .FOL_SetParameter(1, VGO_Acc.VOC_EntryB06Ukey)
					  .VOA_Index[1] = "b11_ukey"
					  .FOL_Editcursor("B07_FRM", "B07_LAN", "B07TT", "Z", 1, 1)
					ENDWITH
					SELECT B07TT
					GO TOP
					SCAN WHILE !VGO_Acc.VOL_ERROR
						VGO_Acc.VOL_ERROR = FOL_verificaUtilizacaoConta(Alltrim(Nvl(B07TT.b11_ukey,"")))
					EndScan
				ENDIF
				VGO_Gen.FOL_CloseTable("B11CC")

				******************************************************
				*- Fechamento de período por Conta Contábil - Fim
				******************************************************
				
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************
				IF !VGO_Acc.VOL_Error
					VGO_Acc.VOL_Error = FOL_VerificaMoedaIntegracao(VGO_Acc.VOC_EntryB06Ukey)
				ENDIF
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************

				*- Estorno de Adiantamentos a Pagar
			Case PLC_Form == "F18_034"
			
				*- PRIME-1560 - Início
				VLC_TIPO = ALLTRIM(Fol_tipo(Nvl(f16T.a21_ukey,'')))
								
				vln_creditMemo = 0
				vln_creditMemo = Fol_isCreditMemo(Nvl(f16T.a21_ukey,''))
							
				IF vln_creditMemo = 1
					DO f18_034_credit.fxp
				ELSE
					Do f18_034.FXP
				endif
				*- PRIME-1560 - Fim			
				
				******************************************************
				*- Fechamento de período por Conta Contábil - Prime 930
				******************************************************
				If !VGO_Acc.VOL_ERROR
					With VGO_Dat
					  .FOL_SetParameter(1, VGO_Acc.VOC_EntryB06Ukey)
					  .VOA_Index[1] = "b11_ukey"
					  .FOL_Editcursor("B07_FRM", "B07_LAN", "B07TT", "Z", 1, 1)
					ENDWITH
					SELECT B07TT
					GO TOP
					SCAN WHILE !VGO_Acc.VOL_ERROR
						VGO_Acc.VOL_ERROR = FOL_verificaUtilizacaoConta(Alltrim(Nvl(B07TT.b11_ukey,"")))
					EndScan
				ENDIF
				VGO_Gen.FOL_CloseTable("B11CC")

				******************************************************
				*- Fechamento de período por Conta Contábil - Fim
				******************************************************
				
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************
				IF !VGO_Acc.VOL_Error
					VGO_Acc.VOL_Error = FOL_VerificaMoedaIntegracao(VGO_Acc.VOC_EntryB06Ukey)
				ENDIF
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************

				*- Estorno de Adiantamentos a Receber
			Case PLC_Form == "F18_035"
				Do f18_035.FXP
				
				******************************************************
				*- Fechamento de período por Conta Contábil - Prime 930
				******************************************************
				If !VGO_Acc.VOL_ERROR
					With VGO_Dat
					  .FOL_SetParameter(1, VGO_Acc.VOC_EntryB06Ukey)
					  .VOA_Index[1] = "b11_ukey"
					  .FOL_Editcursor("B07_FRM", "B07_LAN", "B07TT", "Z", 1, 1)
					ENDWITH
					SELECT B07TT
					GO TOP
					SCAN WHILE !VGO_Acc.VOL_ERROR
						VGO_Acc.VOL_ERROR = FOL_verificaUtilizacaoConta(Alltrim(Nvl(B07TT.b11_ukey,"")))
					EndScan
				ENDIF
				VGO_Gen.FOL_CloseTable("B11CC")

				******************************************************
				*- Fechamento de período por Conta Contábil - Fim
				******************************************************
				
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************
				IF !VGO_Acc.VOL_Error
					VGO_Acc.VOL_Error = FOL_VerificaMoedaIntegracao(VGO_Acc.VOC_EntryB06Ukey)
				ENDIF
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************

				*- Estorno de comissão a pagar
			Case PLC_Form == "F18_032"

				VGO_Toolbar.VOO_ActiveForm.OOL_SysLog.FOL_ResetLog() &&SCRUM-14544
				VLC_TIPO = Fol_tipo(Nvl(f16T.a21_ukey,''))
				
				&& Adicionado por Rui Santos
				&& Não gerar integração quando F18 for proveniente de outro modulo
				&& Pois a integração já terá sido executada.
				IF EMPTY(NVL(F18.F18_IUKEYP,"")) .OR. (! EMPTY(NVL(F18.F18_IUKEYP,"")) .AND. F18.F18_IPAR = "E10")
				
					Do Case
						Case Alltrim(VLC_TIPO) $ '15.96//15.97'
							Do f18_03201.FXP
						Case !Alltrim(VLC_TIPO) $ '15.96//15.97'
							Do f18_032.FXP && mesmo programa estorno a pagar
					Endcase

					*-- SCRUM-14544 - inicio
					Select f16T
					VGO_Acc.VOL_ERROR = .F.
					Scan For !VGO_Acc.VOL_ERROR
						FOL_IntegraContalidade(Alltrim(Nvl(f16T.a21_ukey,"")), f16T.UKEY,PLC_Form, f18.UKEY)
					Endscan
					*-- SCRUM-14544 - fim
					
				ENDIF
				
				******************************************************
				*- Fechamento de período por Conta Contábil - Prime 930
				******************************************************
				If !VGO_Acc.VOL_ERROR
					With VGO_Dat
					  .FOL_SetParameter(1, VGO_Acc.VOC_EntryB06Ukey)
					  .VOA_Index[1] = "b11_ukey"
					  .FOL_Editcursor("B07_FRM", "B07_LAN", "B07TT", "Z", 1, 1)
					ENDWITH
					SELECT B07TT
					GO TOP
					SCAN WHILE !VGO_Acc.VOL_ERROR
						VGO_Acc.VOL_ERROR = FOL_verificaUtilizacaoConta(Alltrim(Nvl(B07TT.b11_ukey,"")))
					EndScan
				ENDIF
				VGO_Gen.FOL_CloseTable("B11CC")

				******************************************************
				*- Fechamento de período por Conta Contábil - Fim
				******************************************************
				
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************
				IF !VGO_Acc.VOL_Error
					VGO_Acc.VOL_Error = FOL_VerificaMoedaIntegracao(VGO_Acc.VOC_EntryB06Ukey)
				ENDIF
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************


				*-- SCRUM-14544 - inicio
				*- Estorno de comissão a receber
			Case PLC_Form == "F18_033"
				Select f15T
				Scan For !VGO_Acc.VOL_ERROR
					FOL_IntegraContalidade(Alltrim(Nvl(f15T.a21_ukey,"")), f15T.UKEY,PLC_Form, f18.UKEY)
				Endscan
				*-- SCRUM-14544 - fim
				
				******************************************************
				*- Fechamento de período por Conta Contábil - Prime 930
				******************************************************
				If !VGO_Acc.VOL_ERROR
					With VGO_Dat
					  .FOL_SetParameter(1, VGO_Acc.VOC_EntryB06Ukey)
					  .VOA_Index[1] = "b11_ukey"
					  .FOL_Editcursor("B07_FRM", "B07_LAN", "B07TT", "Z", 1, 1)
					ENDWITH
					SELECT B07TT
					GO TOP
					SCAN WHILE !VGO_Acc.VOL_ERROR
						VGO_Acc.VOL_ERROR = FOL_verificaUtilizacaoConta(Alltrim(Nvl(B07TT.b11_ukey,"")))
					EndScan
				ENDIF
				VGO_Gen.FOL_CloseTable("B11CC")

				******************************************************
				*- Fechamento de período por Conta Contábil - Fim
				******************************************************
				
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************
				IF !VGO_Acc.VOL_Error
					VGO_Acc.VOL_Error = FOL_VerificaMoedaIntegracao(VGO_Acc.VOC_EntryB06Ukey)
				ENDIF
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************

				*-- SCRUM-14544 - inicio
				*- Reparcelamento de Contas a Pagar
			Case PLC_Form == "F18_027"
				Select f16T
				Scan For !VGO_Acc.VOL_ERROR
					FOL_IntegraContalidade(Alltrim(Nvl(f16T.a21_ukey,"")), f16T.UKEY,PLC_Form, f18.UKEY)
				Endscan
				*-- SCRUM-14544 - fim
				
				******************************************************
				*- Fechamento de período por Conta Contábil - Prime 930
				******************************************************
				If !VGO_Acc.VOL_ERROR
					With VGO_Dat
					  .FOL_SetParameter(1, VGO_Acc.VOC_EntryB06Ukey)
					  .VOA_Index[1] = "b11_ukey"
					  .FOL_Editcursor("B07_FRM", "B07_LAN", "B07TT", "Z", 1, 1)
					ENDWITH
					SELECT B07TT
					GO TOP
					SCAN WHILE !VGO_Acc.VOL_ERROR
						VGO_Acc.VOL_ERROR = FOL_verificaUtilizacaoConta(Alltrim(Nvl(B07TT.b11_ukey,"")))
					EndScan
				ENDIF
				VGO_Gen.FOL_CloseTable("B11CC")

				******************************************************
				*- Fechamento de período por Conta Contábil - Fim
				******************************************************
				
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************
				IF !VGO_Acc.VOL_Error
					VGO_Acc.VOL_Error = FOL_VerificaMoedaIntegracao(VGO_Acc.VOC_EntryB06Ukey)
				ENDIF
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************

				*-- SCRUM-14544 - inicio
				*- Reparcelamento de Contas a Receber
			Case PLC_Form == "F18_028"
				VLC_TIPO = Fol_tipo(Nvl(F12T.a21_ukey,''))

				Do Case
					Case Alltrim(VLC_TIPO) $ '30.11//06.05//'
						Do f18_028.FXP

				Endcase

				Select F12T
				Scan For !VGO_Acc.VOL_ERROR
					FOL_IntegraContalidade(Alltrim(Nvl(F12T.a21_ukey,"")), F12T.UKEY,PLC_Form, f18.UKEY)
				Endscan
				*-- SCRUM-14544 - fim
				
				******************************************************
				*- Fechamento de período por Conta Contábil - Prime 930
				******************************************************
				If !VGO_Acc.VOL_ERROR
					With VGO_Dat
					  .FOL_SetParameter(1, VGO_Acc.VOC_EntryB06Ukey)
					  .VOA_Index[1] = "b11_ukey"
					  .FOL_Editcursor("B07_FRM", "B07_LAN", "B07TT", "Z", 1, 1)
					ENDWITH
					SELECT B07TT
					GO TOP
					SCAN WHILE !VGO_Acc.VOL_ERROR
						VGO_Acc.VOL_ERROR = FOL_verificaUtilizacaoConta(Alltrim(Nvl(B07TT.b11_ukey,"")))
					EndScan
				ENDIF
				VGO_Gen.FOL_CloseTable("B11CC")

				******************************************************
				*- Fechamento de período por Conta Contábil - Fim
				******************************************************
				
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************
				IF !VGO_Acc.VOL_Error
					VGO_Acc.VOL_Error = FOL_VerificaMoedaIntegracao(VGO_Acc.VOC_EntryB06Ukey)
				ENDIF
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************

			*- Movimentação de Entrada em Conta Corrente	
			case PLC_Form == "F18_046CSP"
				do F18_046ws.fxp
				
				******************************************************
				*- Fechamento de período por Conta Contábil - Prime 930
				******************************************************
				If !VGO_Acc.VOL_ERROR
					With VGO_Dat
					  .FOL_SetParameter(1, VGO_Acc.VOC_EntryB06Ukey)
					  .VOA_Index[1] = "b11_ukey"
					  .FOL_Editcursor("B07_FRM", "B07_LAN", "B07TT", "Z", 1, 1)
					ENDWITH
					SELECT B07TT
					GO TOP
					SCAN WHILE !VGO_Acc.VOL_ERROR
						VGO_Acc.VOL_ERROR = FOL_verificaUtilizacaoConta(Alltrim(Nvl(B07TT.b11_ukey,"")))
					EndScan
				ENDIF
				VGO_Gen.FOL_CloseTable("B11CC")

				******************************************************
				*- Fechamento de período por Conta Contábil - Fim
				******************************************************
				
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************
				IF !VGO_Acc.VOL_Error
					VGO_Acc.VOL_Error = FOL_VerificaMoedaIntegracao(VGO_Acc.VOC_EntryB06Ukey)
				ENDIF
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************

			*- PRIME-1407 - Início
			*- Cancelamento de Adiantamento de Valor a Pagar
			Case PLC_Form == "F18_042"
						
				VLC_TIPO = ALLTRIM(Fol_tipo(Nvl(f16T.a21_ukey,'')))
								
				vln_creditMemo = 0
				vln_creditMemo = Fol_isCreditMemo(Nvl(f16T.a21_ukey,''))
							
				IF vln_creditMemo = 1
					DO f18_042.fxp
				endif
			*- PRIME-1407 - Fim
				
			*- Movimentação de Entrada em Conta Corrente	
			case PLC_Form == "F18_046"
				do F18_046ws.fxp	
				
				******************************************************
				*- Fechamento de período por Conta Contábil - Prime 930
				******************************************************
				If !VGO_Acc.VOL_ERROR
					With VGO_Dat
					  .FOL_SetParameter(1, VGO_Acc.VOC_EntryB06Ukey)
					  .VOA_Index[1] = "b11_ukey"
					  .FOL_Editcursor("B07_FRM", "B07_LAN", "B07TT", "Z", 1, 1)
					ENDWITH
					SELECT B07TT
					GO TOP
					SCAN WHILE !VGO_Acc.VOL_ERROR
						VGO_Acc.VOL_ERROR = FOL_verificaUtilizacaoConta(Alltrim(Nvl(B07TT.b11_ukey,"")))
					EndScan
				ENDIF
				VGO_Gen.FOL_CloseTable("B11CC")

				******************************************************
				*- Fechamento de período por Conta Contábil - Fim
				******************************************************
				
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************
				IF !VGO_Acc.VOL_Error
					VGO_Acc.VOL_Error = FOL_VerificaMoedaIntegracao(VGO_Acc.VOC_EntryB06Ukey)
				ENDIF
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************			
			
			*- Movimentação de Saida em Conta Corrente
			*- removido chamada para integração ref. chamado: INC0490883 - Peterson Ricardo - 06/12/2017
*!*				case PLC_Form == "F18_047"
*!*					do F18_047.fxp
*!*					
*!*					******************************************************
*!*					*- Fechamento de período por Conta Contábil - Prime 930
*!*					******************************************************
*!*					If !VGO_Acc.VOL_ERROR
*!*						With VGO_Dat
*!*						  .FOL_SetParameter(1, VGO_Acc.VOC_EntryB06Ukey)
*!*						  .VOA_Index[1] = "b11_ukey"
*!*						  .FOL_Editcursor("B07_FRM", "B07_LAN", "B07TT", "Z", 1, 1)
*!*						ENDWITH
*!*						SELECT B07TT
*!*						GO TOP
*!*						SCAN WHILE !VGO_Acc.VOL_ERROR
*!*							VGO_Acc.VOL_ERROR = FOL_verificaUtilizacaoConta(Alltrim(Nvl(B07TT.b11_ukey,"")))
*!*						EndScan
*!*					ENDIF
*!*					VGO_Gen.FOL_CloseTable("B11CC")

*!*					******************************************************
*!*					*- Fechamento de período por Conta Contábil - Fim
*!*					******************************************************
*!*					
*!*					****************************************************************
*!*					*- Geração de integração com moeda diferente de Real - Prime 220
*!*					****************************************************************
*!*					IF !VGO_Acc.VOL_Error
*!*						VGO_Acc.VOL_Error = FOL_VerificaMoedaIntegracao(VGO_Acc.VOC_EntryB06Ukey)
*!*					ENDIF
*!*					****************************************************************
*!*					*- Geração de integração com moeda diferente de Real - Prime 220
*!*					****************************************************************

*!*					*-Ativo
			Case PLC_Form == "G02"
				If Used("G02I")
					*-W AIT WINDOW "Processando . . " + ALLTRIM(STR(RECNO("G02I"))) + " de " + ALLTRIM(STR(RECCOUNT("G02I"))) NOW AIT
				Endif

				*					do g02-b.FXP
				If !PLL_OnLine
					Do g02-d.FXP
				ENDIF
				
				******************************************************
				*- Fechamento de período por Conta Contábil - Prime 930
				******************************************************
				If !VGO_Acc.VOL_ERROR
					With VGO_Dat
					  .FOL_SetParameter(1, VGO_Acc.VOC_EntryB06Ukey)
					  .VOA_Index[1] = "b11_ukey"
					  .FOL_Editcursor("B07_FRM", "B07_LAN", "B07TT", "Z", 1, 1)
					ENDWITH
					SELECT B07TT
					GO TOP
					SCAN WHILE !VGO_Acc.VOL_ERROR
						VGO_Acc.VOL_ERROR = FOL_verificaUtilizacaoConta(Alltrim(Nvl(B07TT.b11_ukey,"")))
					EndScan
				ENDIF
				VGO_Gen.FOL_CloseTable("B11CC")

				******************************************************
				*- Fechamento de período por Conta Contábil - Fim
				******************************************************
				
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************
				IF !VGO_Acc.VOL_Error
					VGO_Acc.VOL_Error = FOL_VerificaMoedaIntegracao(VGO_Acc.VOC_EntryB06Ukey)
				ENDIF
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************

				*-- SCRUM-14427 - inicio
			Case PLC_Form == "Z10" &&
				Do z10_nfe.prg
				VLL_Z10_Nfe = VGO_Acc.VOL_ERROR
				*-- SCRUM-14427 - fim
				If !VGO_Acc.VOL_ERROR And Alltrim(VGO_GEN.VOC_UserCODE) = "YNDAS"
					VGO_Acc.fol_markintegration( "Z10", "Z10", 'B', .F.)
				ENDIF
				
				******************************************************
				*- Fechamento de período por Conta Contábil - Prime 930
				******************************************************
				If !VGO_Acc.VOL_ERROR
					With VGO_Dat
					  .FOL_SetParameter(1, VGO_Acc.VOC_EntryB06Ukey)
					  .VOA_Index[1] = "b11_ukey"
					  .FOL_Editcursor("B07_FRM", "B07_LAN", "B07TT", "Z", 1, 1)
					ENDWITH
					SELECT B07TT
					GO TOP
					SCAN WHILE !VGO_Acc.VOL_ERROR
						VGO_Acc.VOL_ERROR = FOL_verificaUtilizacaoConta(Alltrim(Nvl(B07TT.b11_ukey,"")))
					EndScan
				ENDIF
				VGO_Gen.FOL_CloseTable("B11CC")

				******************************************************
				*- Fechamento de período por Conta Contábil - Fim
				******************************************************
				
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************
				IF !VGO_Acc.VOL_Error
					VGO_Acc.VOL_Error = FOL_VerificaMoedaIntegracao(VGO_Acc.VOC_EntryB06Ukey)
				ENDIF
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************
			
			*-Estorno da invoice
			Case PLC_Form = "U10_DEVOL"
				Go Top In U10T
				SELECT u10t
				
				VLC_CodigoES = FLC_CodigoES(U10T.t04_ukey)
				VLC_CodES = Alltrim(VLC_CodigoES) + "//"
				
								
				DO case
					Case VLC_CodES $ "I01.03ES//"    && inserido ref. chamado service now: INC0410648
						Do inv-I01.03ES_dev.FXP	
					Case VLC_CodES $ "I01.02//I01.02ES//I01.03//I01.01//" 	
						DO int_invoices_dev.fxp 								
				endcase
			  
				******************************************************
				*- Fechamento de período por Conta Contábil - Prime 930
				******************************************************
				If !VGO_Acc.VOL_ERROR
					With VGO_Dat
					  .FOL_SetParameter(1, VGO_Acc.VOC_EntryB06Ukey)
					  .VOA_Index[1] = "b11_ukey"
					  .FOL_Editcursor("B07_FRM", "B07_LAN", "B07TT", "Z", 1, 1)
					ENDWITH
					SELECT B07TT
					GO TOP
					SCAN WHILE !VGO_Acc.VOL_ERROR
						VGO_Acc.VOL_ERROR = FOL_verificaUtilizacaoConta(Alltrim(Nvl(B07TT.b11_ukey,"")))
					EndScan
				ENDIF
				VGO_Gen.FOL_CloseTable("B11CC")

				******************************************************
				*- Fechamento de período por Conta Contábil - Fim
				******************************************************
				
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************
				IF !VGO_Acc.VOL_Error
					VGO_Acc.VOL_Error = FOL_VerificaMoedaIntegracao(VGO_Acc.VOC_EntryB06Ukey)
				ENDIF
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************

				*- Invoice
			Case PLC_Form = "U10"
				Go Top In U11T
				SELECT u11t
				
				VLC_CodigoES = FLC_CodigoES(U11T.t04_ukey)
				VLC_CodES = Alltrim(VLC_CodigoES) + "//"
								
				DO case
					Case VLC_CodES $ "I02.02ES//"    && inserido ref. chamado: PRIME-1504
						Do inv-I02.02ES.FXP     
				
					Case VLC_CodES $ "I01.03ES//"    && inserido ref. chamado service now: INC0410648
						Do inv-I01.03ES.FXP	
					&& retirada CES em virtude de problema de estoque em transito - Case VLC_CodES $ "I01.02//I01.02ES//I01.03//I01.01//" 	

					**Prime 1954 - Início - Adicionado a chamada das ces I01.06ES e I01.07ES
*!*							Case VLC_CodES $ "I01.02//I01.02ES//I01.03//I01.01//I01.06ES//I01.07ES//" && recolocado e foi retirada a contabilização dentro da função int_invoices.fxp
					** Prime-2017 - Início - Adicionado a CES I01.05ES nesse prg e removido do INV-I01_05ES
					Case VLC_CodES $ "I01.02//I01.02ES//I01.03//I01.01//I01.06ES//I01.07ES//I01.05ES//" && recolocado e foi retirada a contabilização dentro da função int_invoices.fxp						
						DO int_invoices.fxp 								
					**Prime 1954 - Fim
					
					** PRIME-1884 - CCJunior - 20/03/2018 - Início	
					*** Case VLC_CodES $ "I01.05SP//I01.05ES//I01.05W6//I01.06ES//I01.06SP//I01.06W6//I01.07ES//I01.07SP//I01.07W6//I01.08ES//I01.08W6//I01.08ES//I01.08SP//"    && inserido ref. chamado service now: INC0492391
					
*!*						Case VLC_CodES $ "I01.05SP//I01.05ES//I01.05W6//I01.06SP//I01.06W6//I01.07ES//I01.07SP//I01.07W6//I01.08ES//I01.08W6//I01.08ES//I01.08SP//"    && inserido ref. chamado service now: INC0492391
*!*						** PRIME-1884 - CCJunior - 20/03/2018 - Final
*!*	                        Do inv-I01.05ES.FXP     
*!*						
					Case VLC_CodES $ "I01.05SP//I01.05W6//I01.06SP//I01.06W6//I01.07ES//I01.07SP//I01.07W6//I01.08ES//I01.08W6//I01.08ES//I01.08SP//"    && inserido ref. chamado service now: INC0492391
						Do inv-I01.05ES.FXP 
					** PRIME-2017 - Fim	
					
				ENDCASE
				
				***************************************************************************
				*- Verifica se há lançamento contábil, quando se tem integração com estoque
				***************************************************************************
				
				IF !VGO_Acc.VOL_Error
					VGO_Acc.VOL_Error = FOL_VerificaEstoqueContabilidade(VGO_Acc.VOC_EntryB06Ukey)
				ENDIF
				
				***************************************************************************
				*- Verifica se há lançamento contábil, quando se tem integração com estoque
				***************************************************************************
				
				
				******************************************************
				*- Fechamento de período por Conta Contábil - Prime 930
				******************************************************
				If !VGO_Acc.VOL_ERROR
					With VGO_Dat
					  .FOL_SetParameter(1, VGO_Acc.VOC_EntryB06Ukey)
					  .VOA_Index[1] = "b11_ukey"
					  .FOL_Editcursor("B07_FRM", "B07_LAN", "B07TT", "Z", 1, 1)
					ENDWITH
					SELECT B07TT
					GO TOP
					SCAN WHILE !VGO_Acc.VOL_ERROR
						VGO_Acc.VOL_ERROR = FOL_verificaUtilizacaoConta(Alltrim(Nvl(B07TT.b11_ukey,"")))
					EndScan
				ENDIF
				VGO_Gen.FOL_CloseTable("B11CC")

				******************************************************
				*- Fechamento de período por Conta Contábil - Fim
				******************************************************
				
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************
				IF !VGO_Acc.VOL_Error
					VGO_Acc.VOL_Error = FOL_VerificaMoedaIntegracao(VGO_Acc.VOC_EntryB06Ukey)
				ENDIF
				****************************************************************
				*- Geração de integração com moeda diferente de Real - Prime 220
				****************************************************************
			  
				
*!*					Go Top In U11T
*!*					SELECT u11t
*!*					scan
*!*						VLC_CodigoES = FLC_CodigoES(U11T.t04_ukey)
*!*						VLC_CodES = Alltrim(VLC_CodigoES) + "//"
*!*						IF VLC_CodES $ "I01.02ES//"
*!*							EXIT
*!*						ENDIF
*!*					endscan

*!*					Do Case
*!*						Case VLC_CodES $ "I01.02ES//"
*!*							Do inv-i01.02ES.FXP
*!*	*!*						Case VLC_CodES $ "I01.03//"  && inserido ref. chamado service now: INC0363665
*!*	*!*							Do inv-i01.03.FXP
*!*						Case VLC_CodES $ "I02.02ES//"    && inserido ref. chamado service now: INC0366568
*!*							Do inv-I02.02ES.FXP
*!*						Case VLC_CodES $ "I01.03ES//"    && inserido ref. chamado service now: INC0410648
*!*							Do inv-I01.03ES.FXP										
*!*					Endcase
		Endcase
Endcase
*ELSE
Do Case
	Case PLC_Form == "G02" And PLN_Operation = 3
		If Used("G02I")
			*-W AIT WINDOW "Processando " + ALLTRIM(STR(RECNO("G02I"))) + " de " + ALLTRIM(STR(RECCOUNT("G02I"))) NOW AIT
		Endif

		Return .T.
		
	*-PRIME 1796 - INICIO
	Case PLN_Operation = 3
		If !Empty(Nvl(PLC_Ukey, ""))
			DeletaContabilizacao()
			IF ! VGO_Acc.vol_error
				FOL_MakeIntegrationHomeMade(.T.)
			ENDIF
		ENDIF
	*-PRIME 1796 - FIM
Endcase
*-ENDIF

IF !VGO_Acc.VOL_ERROR And Used("B06") And !Eof("B06") And !Inlist(PLC_Form, "BEGIN", "END","U10_DEVOL") AND !VGO_Gen.VOL_ServiceMode &&PRIME-1593
	FOL_FechamentoContabilidade(PLC_Form)
endif

If VGO_GEN.VOL_ExchangeError And VGO_Acc.VOL_ERROR And PLN_Operation <> 3
	VGO_Toolbar.VOO_ActiveForm.OOL_SysLog.FOL_Log("Erro na conversão monetária.", 3)
Endif

If !VGO_Acc.VOL_ERROR And Used("B06") And !Eof("B06") And !Inlist(PLC_Form, "BEGIN", "END") And PLN_Operation == 1 AND !VGO_GEN.VOL_SERVICEMODE
    IF !INLIST(Upper(Alltrim(_Screen.ActiveForm.Name)),"F18_025_ESP","F18_025","F18_026")
		FOL_MakeIntegrationHomeMade(.F.) 
	ENDIF
	
	*-Trecho adicionado para correção do lançamento contábil de reversão do estorno da invoice
	IF !Inlist(PLC_Form, "U10_DEVOL")
		VLO_ObjectTemp = Newobject("CGO_ValidaLancamento_L", "CGO_ValidaLancamento_l.Prg", "", B06.B06_UKEYP, VGO_Toolbar.VOO_ActiveForm.OOL_SysLog)
		Release VLO_ObjectTemp
	ENDIF
Endif


*-Rotina para atualizar o NIT
*-no Lançamento Contábil
*-08/07/2016
if !VGO_Acc.VOL_Error 
	FOL_AtualizaNITLanc(PLC_Form)
endif



Procedure UtilizaPreContabilizacao
	*/----------------------------------------------------------------------------------------/*
	*/ Função      		: UtilizaPreContabilizacao	                                          /*
	*/ Descrição   		: Utiliza os lançamentos pré-contabilizados sumarizados por conta, 	  /*
	*/					data.																  /*
	*/ Retorno     		: VGO_Acc.VOL_Error=.T. exec. com sucesso, .F. c.c.					  /*
	*/----------------------------------------------------------------------------------------/*
	Lparameters PLC_Form

	Local VLD_Date, VLL_Passou, VLO_Thermometer, VLN_Records, VLN_Count, VLC_B25Ukey

	*- Verifica se há numeração automática para a contabilizaçào.
	Do Case
		Case PLC_Form == "BEGIN"
			With VGO_GEN
				.FOL_CloseTable("B25TT")
				.FOL_CloseTable("RDO_B26")
				.FOL_CloseTable("RDO_B04TTT")
			Endwith

		Case PLC_Form == "B25"
			*- Verifica o período do lançamento.
			If VGO_Acc.FOL_ConsistPeriod(b25.b25_002_d)
				With VGO_GEN
					.FOL_Editcursor("B25_ALL_LOCAL", "B25_ALL_LOCAL", "B25TT", "", 0, 0)

					.VOA_Index[1] = "str(array_117, 1)+a36_code0+b11_ukey+dtos(b26_003_d)"
					.VOA_Index[2] = "b11_ukey+a36_code0+dtos(b26_003_d)"
					.FOL_Editcursor("B26_ALL_LOCAL", "B26_ALL_LOCAL", "RDO_B26", "", 2, 0)

					.FOL_Editcursor("B04_ALL_LOCAL", "B04_ALL_LOCAL", "RDO_B04TTT", "", 0, 0)
				Endwith
			Endif

		Case PLC_Form == "END" And Used("B25TT") And Reccount("B25TT")>0
			VGO_Acc.VOL_Contabiliza = .T.

			If !VGO_Acc.VOL_AutoNumberingAccounting
				VGO_Acc.VOL_ERROR = .T.
			Else
				With VGO_GEN

					*- Cursor onde serão gravados os rateios proporcionalizados que serão utilizados na integração.
					.VOA_Index[1] = "b04_par + b04_ukeyp"
					.VOA_Index[2] = "b04_par + b04_ukeyp + b04_004_c + a11_ukey"
					.VOA_Index[3] = "str(b04_005_n, 1) + b04_par + b04_ukeyp + b04_004_c"
					.VOA_Index[4] = "b04_par + b04_004_c"
					.FOL_Editcursor("B04_STRU2", "B04_STRU2", "B04ITTT", "Z", 4, 0)

					.VOA_Index[1] = "b26_003_d"
					.FOL_Editcursor("B26_SUMARIZADO", "B26_SUMARIZADO", "RDO_RDO_B26", "Z", 1, 0)
					Select RDO_RDO_B26
					VLN_Records = Reccount("RDO_RDO_B26")

					*- Objeto de termômetro.
					VLO_Thermometer = Createobject("thermometer", [], [], VLN_Records, 0, .T.)
					VLO_Thermometer.FOL_TaskTitle(VGO_Scx.FOC_Caption("utilizacao dos lancamentos pre-contabilizados"))

					*- Seta as propriedades da integração.
					With VGO_Acc
						VLD_Date 		 = {}
						VLN_Count 		 = 1
						.VON_String		 = 1
						.VOL_GeraCapaB06 = .T.
						.VOL_ERROR = !.FOL_BeginTransaction("B06")
					Endwith
					Select RDO_RDO_B26
					Set Order To Code
					Go Top In RDO_RDO_B26
					*- Varre os lançamentos sumarizados pegando seus respectivos rateios.
					Scan While !VGO_Acc.VOL_ERROR
						VLO_Thermometer.Update(VLN_Count)
						VLL_Passou = .T.
						.FOL_SetParameter(1, RDO_RDO_B26.b11_ukey)
						.FOL_SetParameter(2, RDO_RDO_B26.a36_code0)
						.FOL_SetParameter(3, RDO_RDO_B26.b26_003_d)
						.FOL_SetParameter(4, RDO_RDO_B26.array_117)
						.FOL_Editcursor("B04_B26_SUM", "B04_B26_SUM", "B04TTTS", "Z", 0, 4)

						*- Proporcionaliza os rateios do campo valor do lançamento.
						VGO_Acc.VOL_ERROR = !VGO_Acc.OOL_RateioCapa.FOU_Execute("B26", RDO_RDO_B26.UKEY, "B26_001_B", "B26", "B26_001_B", ;
							RDO_RDO_B26.b26_001_b, 0, RDO_RDO_B26.b26_001_b, "B04TTTS")

						*- Salva os rateios proporcionalizados em um cursor que será utilizado na integração.
						.FOL_SaveCursor(.Null., "B04TTTS", "B04ITTT", "UKEY")

						*- Limpa a string sql para não atualizar os rateios proporcionalizados durante a integração.
						Select B04ITTT
						Replace All B04ITTT.sqlcmd    With "" ,;
							B04ITTT.mycontrol With "" In B04ITTT

						With VGO_Acc
							Select RDO_RDO_B26
							*- Se mudar a data gera uma nova capa.
							If VLD_Date<>RDO_RDO_B26.b26_003_d
								VLD_Date = RDO_RDO_B26.b26_003_d
								.VOC_Historico = "LANÇAMENTO SINTETIZADO"
								*- Gera capa da contabilização (B06).
								.VOC_EntryB06Ukey = .FOC_NewEntry("", "", "", RDO_RDO_B26.a36_code0, RDO_RDO_B26.b26_003_d, RDO_RDO_B26.b26_003_d, "", .T.)
							Endif

							If !.VOL_ERROR
								If VGO_GEN.FOL_FindExpression("B11_UKEY", "RDO_B11", RDO_RDO_B26.b11_ukey)
									.VOC_Historico = Alltrim(rdo_b11.b11_003_c)
								Else
									.VOC_Historico = ""
								Endif
								.FOL_NewItemEntry(.VOC_EntryB06Ukey, RDO_RDO_B26.a36_code0, RDO_RDO_B26.b11_ukey, "B26", RDO_RDO_B26.UKEY, RDO_RDO_B26.b26_001_b, ;
									RDO_RDO_B26.b26_003_d, RDO_RDO_B26.b26_003_d, Iif(RDO_RDO_B26.array_117=1, "D", "C"), ;
									"", "B26", RDO_RDO_B26.UKEY, "B26_001_B", .T., .F.)
							Endif
						Endwith

						If !VGO_Acc.VOL_ERROR
							*- Tráz a ukey da capa dos lançamentos pré-contabilizados que foram sumarizados.
							.FOL_SetParameter(1, RDO_RDO_B26.b11_ukey)
							.FOL_SetParameter(2, RDO_RDO_B26.a36_code0)
							.FOL_SetParameter(3, RDO_RDO_B26.b26_003_d)
							.FOL_ExecuteCursor("B26_ATUALIZA", "B26_ATUALIZA", 3)
							VLC_B25Ukey = ""
							Select B26_ATUALIZA
							Scan
								If VLC_B25Ukey <> B26_ATUALIZA.b25_ukey
									VLC_B25Ukey = B26_ATUALIZA.b25_ukey
									=Seek(B26_ATUALIZA.b25_ukey, "B25TT", "UKEY")
									Select B25TT
									Replace B25TT.b06_ukey  With VGO_Acc.VOC_EntryB06Ukey ,;
										B25TT.b25_006_n With 1 ,;
										B25TT.mycontrol With "1" In B25TT
									.FOL_CreateSqlString("B25TT", "B25", .F., .F.)
								Endif
							Endscan
						Endif

						Select B04ITTT
						Zap In B04ITTT

						VLN_Count  = VLN_Count + 1
					Endscan

					Select RDO_B26
					Set Order To

					If VLL_Passou
						If !VGO_Acc.VOL_ERROR
							VGO_Acc.VOL_ERROR =  !.FOL_SaveCursorSql(.Null., "B25TT", "B25", "UKEY")
							If !VGO_Acc.VOL_ERROR
								VGO_Acc.VOL_ERROR = !.FOL_SaveCursorSql(.Null., "RDO_B26", "B26", "UKEY")
							Endif
						Endif
					Endif

					If VGO_Acc.VOL_ERROR
						VGO_Acc.FOL_RollBack("B06")
					Else
						VGO_Acc.FOL_CommitTrans("B06")
					Endif

					Store .Null. To VLO_Thermo

					.FOL_CloseTable("B25TT")
					.FOL_CloseTable("RDO_B26")
					.FOL_CloseTable("RDO_RDO_B26")
					.FOL_CloseTable("B26_ATUALIZA")
					.FOL_CloseTable("B04TTTS")
					.FOL_CloseTable("B04ITTT")
					.FOL_CloseTable("RDO_B04TTT")
				Endwith
			Endif
	Endcase
Endproc


Procedure DeletaContabilizacao
	*/----------------------------------------------------------------------------------------/*
	*/ Função      		: DeletaContabilizacao	                                        	  /*
	*/ Descrição   		: Apaga os lançamentos integrados na contabilidade.				 	  /*
	*/ Retorno     		: VGO_Acc.VOL_Error=.T. exec. com sucesso, .F. c.c.					  /*
	*/----------------------------------------------------------------------------------------/*
	Local VLL_HaveAccounting, VLL_OldContabiliza

	With VGO_Acc
		VLL_OldContabiliza = VGO_Acc.VOL_Contabiliza

		*- Verifica o que deve ser apagado, se é contabilização ou pré-contabilização
		*- E se pode ser apagado ou não.
		.FOL_BeforeEditDelete(.VOC_PrimaryFile, .VOC_PrimaryUkey, @VLL_HaveAccounting)
		If !.VOL_ERROR
			*- Apaga a integração.
			.FOL_DeleteOldEntry(.VOC_PrimaryFile, .VOC_PrimaryUkey, VLL_HaveAccounting)
			*- INC0313541 (ELCruz - 27/11/15)
			*- Gero o log de deleção do documento
			If !.VOL_ERROR
				If Type("VGO_Toolbar.VOO_ActiveForm.OOL_SysLog") == "O"
					VGO_Toolbar.VOO_ActiveForm.OOL_SysLog.FOL_Log(10003,3)
				Endif
			Endif
		Endif

		VGO_Acc.VOL_Contabiliza = VLL_OldContabiliza
	Endwith
Endproc

Procedure FLC_Account(PLC_Form, PLC_Ukey, PLN_Account)


	Local VLC_UkeyAccount, VLC_Par

	VLC_UkeyAccount = .Null.
	VLC_Par = Substr(PLC_Form, 1, Max(At("_", PLC_Form)-1,3))

	If FLL_Seek("B24_PAR_UKEYP", "B24_LANC", "alltrim(b24_par1)+nvl(b24_ukeyp1, space(20))", "CODE", VLC_Par, Nvl(PLC_Ukey, Space(20)))
		Do Case
			Case PLN_Account = 1
				VLC_UkeyAccount = b11_ukeya
			Case PLN_Account = 2
				VLC_UkeyAccount = b11_ukeyb
			Case PLN_Account = 3
				VLC_UkeyAccount = b11_ukeyc
			Case PLN_Account = 4
				VLC_UkeyAccount = b11_ukeyd
			Case PLN_Account = 5
				VLC_UkeyAccount = b11_ukeye
			Case PLN_Account = 6
				VLC_UkeyAccount = b11_ukeyf
			Case PLN_Account = 7
				VLC_UkeyAccount = b11_ukeyg
			Case PLN_Account = 8
				VLC_UkeyAccount = b11_ukeyh
			Case PLN_Account = 9
				VLC_UkeyAccount = b11_ukeyi
			Otherwise
				VLC_UkeyAccount = b11_ukeyj
		Endcase
	Endif

	*!*	if isnull(VLC_UkeyAccount)
	*!*		this.VOL_Error = .T.
	*!*		with VGO_Toolbar.VOO_ActiveForm.OOL_SysLog
	*!*			*- Cria log avisando que a conta solicitada não foi encontrada.
	*!*			.FOL_Setlogaux(1, 2, 3, alltrim(str(PLN_Account)))
	*!*			.FOL_Setlogaux(2, 2, 2, "form_"+lower(PLC_Form))
	*!*			.FOL_Log(122)
	*!*		endwith
	*!*		VLC_UkeyAccount = ""
	*!*	endif

	Return VLC_UkeyAccount
Endproc

Procedure FLL_Seek(PLC_CursorCatalog, PLC_Cursor, PLC_FieldsToIndex, PLC_Tag, PLU_Par1, PLU_Par2, PLU_Par3, PLU_Par4)


	Local VLN_Parameters, VLN_Count, VLC_Parameter, VLL_Return, VLC_Expression, VLN_IndexQtd

	VLN_Parameters = Parameter() - 4
	VLC_Parameter  = ""
	VLC_Expression = ""
	VLN_IndexQtd = 0

	*- Monta a string a ser procurada baseada no parâmetros recebidos.
	Do Case
		Case VLN_Parameters = 1
			VLC_Expression = PLU_Par1
		Case VLN_Parameters = 2
			VLC_Expression = PLU_Par1+PLU_Par2
		Case VLN_Parameters = 3
			VLC_Expression = PLU_Par1+PLU_Par2+PLU_Par3
		Case VLN_Parameters = 4
			VLC_Expression = PLU_Par1+PLU_Par2+PLU_Par3+PLU_Par4
	Endcase
	*- Se o cursor estiver aberto, executa primeiro um seek para verificar se o registro já existe.
	If Used(PLC_Cursor)
		Select (PLC_Cursor)
		VLL_Return = Seek(VLC_Expression, PLC_Cursor, PLC_Tag)
	Else
		If !Empty(PLC_FieldsToIndex)
			VGO_GEN.VOA_Index[1] = PLC_FieldsToIndex
			VLN_IndexQtd = 1
		Endif
	Endif

	If !VLL_Return
		Do Case
			Case VLN_Parameters = 1
				VGO_GEN.FOL_SetParameter(1, PLU_Par1)
			Case VLN_Parameters = 2
				VGO_GEN.FOL_SetParameter(1, PLU_Par1)
				VGO_GEN.FOL_SetParameter(2, PLU_Par2)
			Case VLN_Parameters = 3
				VGO_GEN.FOL_SetParameter(1, PLU_Par1)
				VGO_GEN.FOL_SetParameter(2, PLU_Par2)
				VGO_GEN.FOL_SetParameter(3, PLU_Par3)
			Case VLN_Parameters = 4
				VGO_GEN.FOL_SetParameter(1, PLU_Par1)
				VGO_GEN.FOL_SetParameter(2, PLU_Par2)
				VGO_GEN.FOL_SetParameter(3, PLU_Par3)
				VGO_GEN.FOL_SetParameter(4, PLU_Par4)
		Endcase

		VGO_GEN.FOL_Editcursor(PLC_CursorCatalog, PLC_CursorCatalog, PLC_Cursor, "Z", VLN_IndexQtd, VLN_Parameters)
		Select (PLC_Cursor)
		Set Order To (PLC_Tag)

		*- Reposiciona caso tenha encontrado.
		VLL_Return=Seek(VLC_Expression, PLC_Cursor, PLC_Tag)
	Endif

	Return VLL_Return

Endproc



Procedure FLC_FieldUkey(PLC_Par,PLC_Field,PLC_Code)

	*/-------------------------------------------------------------------------------------------------/*
	*/ Parametros   : PLC_Par   - código da tabela                                                     /*
	*/                PLC_Field - nome do campo que deseja ter retorno                                 /*
	*/				  PLC_Code  - código que será passado como paramentro	                           /*
	*/-------------------------------------------------------------------------------------------------/*
	Local VLC_Select,VLU_Return
	Private VPC_Code

	VPC_Code = PLC_Code
	VLC_Select = "select " + PLC_Field + " from STAR_DATA@"+PLC_Par+"(nolock) where " +PLC_Par+"_001_c = ?VPC_Code"
	VGO_Custom.FOL_CSqlExec(VLC_Select, "TMP_Result")
	Select TMP_Result
	Go Top
	VLU_Return = Evaluate(PLC_Field)

	Use In TMP_Result

	Return VLU_Return
Endproc

Procedure FOU_FieldPar(PLC_Par, PLC_Ukeyp, PLC_Field, PLC_FieldToFilter)
	Local VLU_Return

	FOL_SetParameter(1, PLC_Par)
	FOL_SetParameter(2, PLC_Ukeyp)
	FOL_SetParameter(3, PLC_Field)
	FOL_SetParameter(4, Iif(Empty(PLC_FieldToFilter), "UKEY", PLC_FieldToFilter))

	FOL_SqlExec("FIELDPAR", "TMP_Result")
	Select TMP_Result

	VLU_Return = TMP_Result.ValueToReturn

	Use In TMP_Result

	Return VLU_Return
Endproc

Procedure FOC_FixAccount(PLC_AccountCode)
	Local VLC_Return

	FOL_SetParameter(1, PLC_AccountCode)
	FOL_SqlExec("B11_FIXACCOUNT", "TMP_Result")
	VLC_Return = UKEY
	Use In TMP_Result

	Return VLC_Return
Endproc


Procedure FOL_SetParameter(PLN_ParNumber, PLU_Value)
	VOA_Parameter[PLN_ParNumber] =  PLU_Value
Endproc

Procedure FOL_SqlExec(PLC_SQLCmdId, PLC_CursorReturn)
	Local VLL_Return

	Private VPA_Parameter[10]

	=Acopy(VOA_Parameter, VPA_Parameter)

	If VGO_Custom.FOL_CSqlExec(FOC_SqlCmdLibrary(PLC_SQLCmdId), PLC_CursorReturn)
		VLL_Return = .T.

		Select (PLC_CursorReturn)
		Go Top

	Endif

	*- Retorna se encontrou algum registro.
	Return VLL_Return And !Eof(PLC_CursorReturn)
Endproc

Procedure Fol_tipo
	Lparameters PLC_Ukey

	VGO_GEN.FOL_SqlExec("SELECT A21_001_C FROM STAR_DATA@A21 (NOLOCK) WHERE UKEY='"+Nvl(PLC_Ukey,'')+"'", "TMP_Result")

	Return TMP_Result.A21_001_C

ENDPROC

Procedure Fol_isCreditMemo
	Lparameters PLC_Ukey

	VGO_GEN.FOL_SqlExec("SELECT A21_503_N FROM STAR_DATA@A21 (NOLOCK) WHERE UKEY='"+Nvl(PLC_Ukey,'')+"'", "TMP_Result2")

	Return TMP_Result2.A21_503_N

Endproc

Procedure FOC_SqlCmdLibrary(PLC_SQLCmdId)
	Local VLC_Select

	VLC_Select = ""

	Do Case
		Case PLC_SQLCmdId = "B11_FIXACCOUNT"
			TEXT to VLC_Select noshow additive text pretext 7

				SELECT UKEY
				FROM STAR_DATA@B11(NOLOCK)
				WHERE B11_001_C = ?VPA_Parameter[1] AND ARRAY_098 = 1

			ENDTEXT

		Case PLC_SQLCmdId = "FIELDPAR"
			TEXT to VLC_Select noshow additive text pretext 7

				SELECT <<VPA_Parameter[3]>> VALUETORETURN
				FROM STAR_DATA@<<VPA_Parameter[1]>>(NOLOCK)
				WHERE <<VPA_Parameter[4]>> = ?VPA_Parameter[2]

			ENDTEXT

		Case PLC_SQLCmdId = "A40_ALL"
			TEXT to VLC_Select noshow additive text pretext 7

				SELECT UKEY, ARRAY_217
				FROM STAR_DATA@A40(NOLOCK) ORDER BY ARRAY_217

			ENDTEXT

		Case PLC_SQLCmdId = "PAISCLIFORN"
			TEXT to VLC_Select noshow additive text pretext 7

				SELECT A22.A22_001_C
				FROM STAR_DATA@A22(NOLOCK)
				JOIN STAR_DATA@<<VPA_Parameter[1]>>(NOLOCK) ON <<VPA_Parameter[1]>>.A22_UKEY = A22.UKEY
				WHERE <<VPA_Parameter[1]>>.UKEY = ?VPA_Parameter[2]

			ENDTEXT

			*- Custom médio do item.
		Case PLC_SQLCmdId = "D15_CUSTOMEDIO"
			TEXT to VLC_Select noshow additive text pretext 7

				SELECT TOP 1 D15.D15_008_B
				FROM STAR_DATA@D15 (NOLOCK)
				WHERE D15.D04_UKEY = ?VPA_Parameter[1] AND D15.D07_UKEY = ?VPA_Parameter[2] AND D15.D15_001_D <= ?VPA_Parameter[3]
				ORDER BY D15_001_D DESC

			ENDTEXT

			*- Custom médio do item.
		Case PLC_SQLCmdId = "D28_CUSTOMEDIO"
			TEXT to VLC_Select noshow additive text pretext 7

				SELECT TOP 1 D28.D28_008_B
				FROM STAR_DATA@D28 (NOLOCK)
				WHERE D28.D28_008_B > 0 AND D28.D04_UKEY = ?VPA_Parameter[1] AND D28.D07_UKEY = ?VPA_Parameter[2] AND D28.D28_001_T <= ?VPA_Parameter[3]
				ORDER BY D28_001_T DESC

			ENDTEXT

		Case PLC_SQLCmdId = "F48_F18_INTEGRACAO"
			TEXT to VLC_Select noshow additive text pretext 7

				SELECT F48.*, A40.A40_002_C
				FROM STAR_DATA@F48(NOLOCK)
				INNER JOIN STAR_DATA@F16(NOLOCK) ON F16.UKEY = F48.F16_UKEY
				INNER JOIN STAR_DATA@F18(NOLOCK) ON F18.UKEY = F16.F18_UKEY
				INNER JOIN STAR_DATA@A40(NOLOCK) ON A40.UKEY = F48.A40_UKEY
				WHERE F18.UKEY = ?VPA_Parameter[1]

			ENDTEXT


		Case PLC_SQLCmdId = "F48_F11_FRM"

			TEXT to VLC_Select noshow additive text pretext 7
				SELECT F48.*,A40.A40_002_C, A40.array_217
				FROM  STAR_DATA@F48 (NOLOCK)
				INNER JOIN STAR_DATA@F11 (NOLOCK)  ON F48.F11_UKEY = F11.UKEY
				INNER JOIN STAR_DATA@A40(NOLOCK) ON F48.A40_UKEY = A40.UKEY
				WHERE F11.UKEY = ?VPA_Parameter[1]

			ENDTEXT

		Otherwise
			VLC_Select = ""

	Endcase

	Return Chrtran(VLC_Select, Chr(13)+Chr(10), " ")
Endproc




Procedure FLC_FieldPar(PLC_Par, PLC_Ukeyp, PLC_Field)
	Local VLC_Select, VLU_Return
	Private VPC_ValueToFilter

	VPC_ValueToFilter = PLC_Ukeyp
	VLC_Select = "select "+PLC_Field+" from STAR_DATA@"+PLC_Par+ "(nolock) where ukey = ?VPC_ValueToFilter"
	VGO_Custom.FOL_CSqlExec(VLC_Select, "TMP_Result")
	Select TMP_Result
	Go Top
	VLU_Return = Evaluate(PLC_Field)

	Use In TMP_Result

	Return VLU_Return
Endproc


Procedure FLC_FixAccount(PLC_AccountCode)
	Local VLC_Select, VLC_Return
	Private VPC_ValueToFilter

	VPC_ValueToFilter = PLC_AccountCode

	VLC_Select = "select ukey from STAR_DATA@B11(nolock) where b11_001_c = ?VPC_ValueToFilter and array_098 = 1"
	VGO_Custom.FOL_CSqlExec(VLC_Select, "TMP_Result")
	Select TMP_Result
	Go Top
	VLC_Return = UKEY
	Use In TMP_Result

	Return VLC_Return
Endproc


Procedure FOL_ConverteIndice1execl(PLC_B07Ukey,VLN_VALUE)

	Local VLL_Return
	VLL_Return = .T.
	*- Só converto se a moeda da nota Não for Peso

	With VGO_GEN
		.FOL_SetParameter(1, PLC_B07Ukey)
		.FOL_Editcursor("B07_UKEY","B07_UKEY","TMP_B07CM","Z",0,1)
		Select TMP_B07CM
		Go Top
		Replace mycontrol With "1" ,;
			TMP_B07CM.b07_007_b With TMP_B07CM.b07_001_b In TMP_B07CM
		.FOL_CreateSqlString("TMP_B07CM","B07")
		VLL_Return = .FOL_SaveRecordSql("TMP_B07CM","B07","UKEY")

		.FOL_CloseTable("TMP_B07CM")
	Endwith
	Return !VLL_Return

Endproc

********************************************************************
* Custo médio de um item na data. - ultima entrada
********************************************************************
Function FLN_AverageCostEntr(PLC_D04Ukey, PLC_D07Ukey, PLT_Date, PLN_J10)

	Local VLC_Select, VLN_Return
	Private VPC_D04Ukey, VPC_D07Ukey, VPT_Date

	VPC_D04Ukey = PLC_D04Ukey
	VPC_D07Ukey = PLC_D07Ukey
	VPT_Date = PLT_Date
	
	vlc_string = "SELECT * FROM STAR_DATA@D07 (NOLOCK) WHERE UKEY = ?VPC_D07UKEY"
	VGO_GEN.FOL_SqlExec(vlc_string, "LOCAL_KARDEX")
	VPC_D07Ukey = LOCAL_KARDEX.D07_UKEY

	VLC_Select = "SELECT TOP 1 D28.D28_008_B FROM D28 (NOLOCK) WHERE D28.D28_008_B > 0 AND D28.D04_UKEY = ?VPC_D04Ukey AND D28.D07_UKEY = ?VPC_D07Ukey AND D28.D28_001_T <= ?VPT_Date AND D28_999_N = 0 ORDER BY D28_001_T DESC"
	
	If VGO_GEN.FOL_SqlExec(VLC_Select, "D28_TMP")
		VLN_Return = d28_tmp.d28_008_b
		Use In d28_tmp

		If VLN_Return = 0
			*- Log avisando que não encontrou o custo médio do item
			VGO_Custom.FOL_CSetLogAux(1, 2, 1, "D04_001_C", "D04", PLC_D04Ukey)
			VGO_Custom.FOL_CSetLogAux(2, 2, 1, "D07_001_C", "D07", PLC_D07Ukey)
			VGO_Custom.FOL_CSetLogAux(3, 2, 3, Dtoc(PLT_Date))
			VGO_Custom.FOL_CLog("Integração não efetuada. Não foi encontrado o custo médio do item @1 no local @2 em @3.", 2)

			VGO_Custom.FOL_CSetLogAux(1, 1, 3, "Integração")
			VGO_Custom.FOL_CSetSource(Iif(Empty(PLN_J10), "E10", "J10"), Iif(Empty(PLN_J10), E10.UKEY, J10.UKEY), Iif(Empty(PLN_J10), "E10", "J10"), 3, 1)
			VGO_Acc.VOL_ERROR = .T.
		Endif
	Else
		VLN_Return = 0
		VGO_Acc.VOL_ERROR = .T.
	ENDIF
	
	VGO_GEN.FOL_CLOSETABLE("LOCAL_KARDEX")
			
	Return VLN_Return
Endfunc

********************************************************************
* Custo médio de um item na data. - servico - ultima saida
********************************************************************
Function FLN_AverageCostSrv(PLC_D04Ukey, PLC_D07Ukey, PLT_Date, PLN_J10)

	Local VLC_Select, VLN_Return
	Private VPC_D04Ukey, VPC_D07Ukey, VPT_Date

	VPC_D04Ukey = PLC_D04Ukey
	VPC_D07Ukey = PLC_D07Ukey
	VPT_Date = PLT_Date
	
	vlc_string = "SELECT * FROM STAR_DATA@D07 (NOLOCK) WHERE UKEY = ?VPC_D07UKEY"
	VGO_GEN.FOL_SqlExec(vlc_string, "LOCAL_KARDEX")
	VPC_D07Ukey = LOCAL_KARDEX.D07_UKEY

	VLC_Select = "SELECT TOP 1 D28.D28_008_B FROM D28 (NOLOCK) WHERE D28.D28_008_B > 0 AND D28.D04_UKEY = ?VPC_D04Ukey AND D28.D07_UKEY = ?VPC_D07Ukey AND CAST(D28.D28_001_T AS DATE) <= ?VPT_Date AND D28_999_N = 1 ORDER BY D28_001_T DESC"
	If VGO_GEN.FOL_SqlExec(VLC_Select, "D28_TMP")
		VLN_Return = d28_tmp.d28_008_b
		Use In d28_tmp

		If VLN_Return = 0
			*- Log avisando que não encontrou o custo médio do item
			VGO_Custom.FOL_CSetLogAux(1, 2, 1, "D04_001_C", "D04", PLC_D04Ukey)
			VGO_Custom.FOL_CSetLogAux(2, 2, 1, "D07_001_C", "D07", PLC_D07Ukey)
			VGO_Custom.FOL_CSetLogAux(3, 2, 3, Dtoc(PLT_Date))
			VGO_Custom.FOL_CLog("Integração não efetuada. Não foi encontrado o custo médio do item @1 no local @2 em @3.", 2)

			VGO_Custom.FOL_CSetLogAux(1, 1, 3, "Integração")
			VGO_Custom.FOL_CSetSource(Iif(Empty(PLN_J10), "E10", "J10"), Iif(Empty(PLN_J10), E10.UKEY, J10.UKEY), Iif(Empty(PLN_J10), "E10", "J10"), 3, 1)
			VGO_Acc.VOL_ERROR = .T.
		Endif
	Else
		VLN_Return = 0
		VGO_Acc.VOL_ERROR = .T.
	ENDIF
	
	VGO_GEN.FOL_CLOSETABLE("LOCAL_KARDEX")
			
	Return VLN_Return
Endfunc

********************************************************************
* Custo médio de um item na data.
********************************************************************
Function FLN_AverageCost(PLC_D04Ukey, PLC_D07Ukey, PLT_Date, PLN_J10)

	Local VLC_Select, VLN_Return
	Private VPC_D04Ukey, VPC_D07Ukey, VPT_Date

	VPC_D04Ukey = PLC_D04Ukey
	VPC_D07Ukey = PLC_D07Ukey
	VPT_Date = PLT_Date


	*- ALTERAÇÃO SOLICITADA  PELO PAULO PEGAR O ULTIMO CUSTO MEDIO DO ITEM 01/10/2012

	**	VLC_Select = "SELECT TOP 1 D15.D15_008_B FROM STAR_DATA@D15 (NOLOCK) WHERE D15.D04_UKEY = ?VPC_D04Ukey AND D15.D07_UKEY = ?VPC_D07Ukey AND D15.D15_001_D = ?VPT_Date ORDER BY D15_001_D DESC"
	VLC_Select = "SELECT TOP 1 D15.D15_008_B FROM STAR_DATA@D15 (NOLOCK) WHERE D15.D04_UKEY = ?VPC_D04Ukey  ORDER BY D15_001_D DESC"

	If VGO_GEN.FOL_SqlExec(VLC_Select, "D15_TMP")
		VLN_Return = d15_tmp.d15_008_b
		Use In d15_tmp

		If VLN_Return = 0
			VLC_Select = "SELECT TOP 1 D28.D28_008_B FROM STAR_DATA@D28 (NOLOCK) WHERE D28.D28_008_B > 0 AND D28.D04_UKEY = ?VPC_D04Ukey AND D28.D07_UKEY = ?VPC_D07Ukey AND CAST(D28.D28_001_T AS DATE) <= ?VPT_Date ORDER BY D28_001_T DESC"

			If VGO_GEN.FOL_SqlExec(VLC_Select, "D28_TMP")
				VLN_Return = d28_tmp.d28_008_b
				Use In d28_tmp

				If VLN_Return = 0
					*- Log avisando que não encontrou o custo médio do item
					VGO_Custom.FOL_CSetLogAux(1, 2, 1, "D04_001_C", "D04", PLC_D04Ukey)
					VGO_Custom.FOL_CSetLogAux(2, 2, 1, "D07_001_C", "D07", PLC_D07Ukey)
					VGO_Custom.FOL_CSetLogAux(3, 2, 3, Dtoc(PLT_Date))
					VGO_Custom.FOL_CLog("Integração não efetuada. Não foi encontrado o custo médio do item @1 no local @2 em @3.", 2)

					VGO_Custom.FOL_CSetLogAux(1, 1, 3, "Integração")
					VGO_Custom.FOL_CSetSource(Iif(Empty(PLN_J10), "E10", "J10"), Iif(Empty(PLN_J10), E10.UKEY, J10.UKEY), Iif(Empty(PLN_J10), "E10", "J10"), 3, 1)
					VGO_Acc.VOL_ERROR = .T.
				Endif
			Else
				VLN_Return = 0
				VGO_Acc.VOL_ERROR = .T.
			Endif
		Endif
	Else
		VLN_Return = 0
		VGO_Acc.VOL_ERROR = .T.
	Endif
	Return VLN_Return
Endfunc

********************************************************************
* Classifica os impostos dos itens da nota de entrada
* conforme o array_217
********************************************************************
Function FLC_IdentificaImpostoCompras()
	Select e12_e10t.a40_ukey, 0 array_217 From e12_e10t Group By a40_ukey, array_217 Into Cursor E12_TMP Readwrite
	Select E12_TMP
	Scan
		VGO_GEN.FOL_SqlExec("SELECT A40.A40_001_C, ARRAY_217 FROM STAR_DATA@A40(NOLOCK) WHERE A40.UKEY = ?E12_TMP.A40_UKEY", "A40_TMP")
		If  !("II" $ Alltrim(a40_tmp.a40_001_c))
			Replace E12_TMP.array_217 With a40_tmp.array_217 In E12_TMP
		Endif

		Use In a40_tmp
	Endscan

	Go Top In E12_TMP
Endfunc


********************************************************************
* Classifica os impostos dos itens da nota de saída
* conforme o array_217
********************************************************************
Function FLC_IdentificaImpostoVendas()
	Select J22_J10T.a40_ukey, 0 array_217 From J22_J10T Group By a40_ukey, array_217 Into Cursor J22_TMP Readwrite
	Select J22_TMP
	Scan
		VGO_GEN.FOL_SqlExec("SELECT A40.A40_001_C, ARRAY_217 FROM STAR_DATA@A40(NOLOCK) WHERE A40.UKEY = ?J22_TMP.A40_UKEY", "A40_TMP")
		If  !("II" $ Alltrim(a40_tmp.a40_001_c))
			Replace J22_TMP.array_217 With a40_tmp.array_217 In J22_TMP
		Endif

		Use In a40_tmp
	Endscan

	Go Top In J22_TMP
Endfunc

********************************************************************
* Retorna o valor de um imposto de um item da nota de entrada
********************************************************************
Function FLN_ImpostoItensE10(PLC_Par, PLC_Ukeyp, PLN_Array217, PLC_CodigoImposto)
	Local VLN_Return, VLC_A40Ukey
	Private VPC_Codigo

	If Empty(PLC_CodigoImposto)

		Select Sum(e12_e10t.e12_004_b) e12_004_b From e12_e10t ;
			join E12_TMP On e12_e10t.a40_ukey = E12_TMP.a40_ukey ;
			where  e12_e10t.e12_par = PLC_Par And e12_e10t.e12_ukeyp = PLC_Ukeyp And E12_TMP.array_217 = PLN_Array217 Group By e12_e10t.a40_ukey, array_217 Into Cursor E12_RDO Readwrite
	Else
		VPC_Codigo = PLC_CodigoImposto

		VLC_Select = "SELECT UKEY FROM STAR_DATA@A40(NOLOCK) WHERE A40.A40_001_C = ?VPC_Codigo"
		If VGO_Custom.FOL_CSqlExec(VLC_Select, "TMP_Result")
			VLC_A40Ukey = Alltrim(TMP_Result.UKEY)
			Use In TMP_Result

			Select Sum(e12_e10t.e12_004_b) e12_004_b From e12_e10t ;
				where  e12_e10t.e12_par = PLC_Par And e12_e10t.e12_ukeyp = PLC_Ukeyp And e12_e10t.a40_ukey = VLC_A40Ukey Group By e12_e10t.a40_ukey Into Cursor E12_RDO Readwrite

		Endif
	Endif
	VLN_Return = E12_RDO.e12_004_b
	Use In E12_RDO

	Return VLN_Return
Endfunc


********************************************************************
* Retorna o valor de um imposto de um item da nota de saída
********************************************************************
Function FLN_ImpostoItensJ10(PLC_Par, PLC_Ukeyp, PLN_Array217)
	Local VLN_Return, VLC_A40Ukey
	Private VPC_Codigo

	Select Sum(J22_J10T.j22_004_b) j22_004_b From J22_J10T ;
		join J22_TMP On J22_J10T.a40_ukey = J22_TMP.a40_ukey ;
		where  J22_J10T.j22_par = PLC_Par And J22_J10T.j22_ukeyp = PLC_Ukeyp And J22_TMP.array_217 = PLN_Array217 Group By J22_J10T.a40_ukey, array_217 Into Cursor j22_RDO Readwrite

	VLN_Return = j22_RDO.j22_004_b
	Use In j22_RDO

	Return VLN_Return
Endfunc


********************************************************************
* Retorna o código de um tipo de entrada e saída.
********************************************************************
Function FLC_CodigoES(PLC_T04Ukey)
	Local VLC_Return
	Private VPC_T04Ukey

	VPC_T04Ukey = PLC_T04Ukey

	VLC_Select = "SELECT T04.T04_001_C FROM STAR_DATA@T04(NOLOCK) WHERE T04.UKEY = ?VPC_T04Ukey"

	If VGO_Custom.FOL_CSqlExec(VLC_Select, "TMP_Result")
		VLC_Return = Alltrim(TMP_Result.t04_001_c)
		Use In TMP_Result
	Endif

	Return VLC_Return
Endfunc


Function FLC_Account(PLC_Par,PLC_Ukeyp,PLN_Account)
	Local VLC_String,VLC_Return
	Private VPC_Par,VPC_Ukeyp

	VPC_Par = PLC_Par
	VPC_Ukeyp = PLC_Ukeyp
	VLC_Return = ""

	If Empty(PLN_Account)
		PLN_Account = 3
	Endif

	VLC_String = "SELECT B24.B11_UKEY"+Chr(64+PLN_Account)+" FROM STAR_DATA@B24(NOLOCK) WHERE B24.B24_PAR1 = ?VPC_PAR AND B24.B24_UKEYP1 = ?VPC_UKEYP"
	VGO_Custom.FOL_CSqlExec(VLC_String,"__TMP_B24")
	Go Top In __tmp_b24
	If !Eof("__TMP_B24")
		VLC_Return = Nvl(Evaluate("__Tmp_b24.b11_ukey"+Chr(64+PLN_Account)), "")
	Endif
	Use In __tmp_b24
	Return VLC_Return
Endfunc

*-- SCRUM-14544 - inicio
Function FOL_IntegraContalidade(PLC_A21_ukey, PLC_ukeypar,PLC_Par, PLC_F18Ukey)
	Local VLL_Return

	VLL_Return = .T.

	If Empty(Nvl(PLC_A21_ukey,""))

		VLL_Return = .F.

		VLC_msg_log = lpack.FOC_Caption("nao foi encontrado tipo de documento associado ao titulo. ",.F.,.F.,.F.)
		With VGO_Toolbar.VOO_ActiveForm.OOL_SysLog
			.FOL_Log(VLC_msg_log,1,.F.)
			.FOL_SetLogAux(1, 1, 3,  lpack.FOC_Caption("integra contabilidade"))
			.FOL_SetSource(PLC_Par,Iif(!Empty(PLC_F18Ukey),PLC_F18Ukey,PLC_ukeypar), PLC_Par, 1, 3,.T.,2)
			VLL_Return = .F.
		Endwith
	Endif

	If VLL_Return
		db.Select("A21", PLC_A21_ukey, "A21_500_N, A21_001_C", "TMPA21")
		If tmpa21.a21_500_n = 1
			If "F18" $ PLC_Par
				cUkeyPar = PLC_F18Ukey
				db.Select('B06', '', 'UKEY', 'TMPB06', 'B06_UKEYP = ?cUkeyPar')
			Else
				VGO_GEN.FOL_FindExpression("B06_B06_UKEYP", "TMPB06", PLC_ukeypar)
			Endif
			VLC_TIPO = Alltrim(tmpa21.A21_001_C)
			If Reccount("tmpb06") = 0
				VLL_Return = .F.
				VLC_msg_log = lpack.FOC_Caption("este documento não podera ser gravado pois não foram configuradas as regras de integracao contabil para o tipo ",.F.,.F.,.F.) + " "+VLC_TIPO +  " "+lpack.FOC_Caption(". favor contactar a contabilidade! ",.F.,.F.,.F.)
			Endif
			VGO_GEN.FOL_CloseTable("tmpb06")
		Endif
		VGO_GEN.FOL_CloseTable("tmpa21")

		If !VLL_Return
			With VGO_Toolbar.VOO_ActiveForm.OOL_SysLog
				.FOL_Log(VLC_msg_log, 1,.F.)
				.FOL_SetLogAux(1, 1, 3,  lpack.FOC_Caption("integra contabilidade"))
				.FOL_SetSource(PLC_Par,Iif(!Empty(PLC_F18Ukey),PLC_F18Ukey,PLC_ukeypar), PLC_Par, 1, 3,.T.,2)
			Endwith
		Endif
	Endif
	VGO_Acc.VOL_ERROR = !VLL_Return

	Return VLL_Return
Endfunc
*-- SCRUM-14544 - fim

******************************************************
*- Verifico se na CES é obrigatório a Integração SCRUM - 14543
******************************************************
Function FOL_VerificaContalidade(PLC_T04_UKEY,PLC_Par, PLC_Ukey,PLC_Form, VLC_CodES)
	Local VLL_Return, VLC_Msg
	VLL_Return = .F.
	If VGO_GEN.FOC_QuickSql("T04_510_N","T04","UKEY",[']+PLC_T04_UKEY+['],.F.) = 1
		VGO_GEN.FOL_SqlExec("SELECT b06.ukey FROM STAR_DATA@B06 (NOLOCK) INNER JOIN STAR_DATA@B07 (NOLOCK) ON B07.B06_UKEY = B06.UKEY WHERE B06_UKEYP = '"+PLC_Ukey+"'","tmpb06")
		If Reccount("tmpb06") = 0
			VLC_Msg = lpack.FOC_Caption('log_00005',VLC_CodES,.F.,.F.)
			Do Case
				Case PLC_Par = "E10"
					With VGO_Toolbar.VOO_ActiveForm.OOL_SysLog
						.FOL_Log(VLC_Msg,1,.F.)
						.FOL_SetLogAux(1, 1, 3,  lpack.FOC_Caption("integra contabilidade"))
						.FOL_SetSource(PLC_Par, PLC_Ukey, PLC_Form, 1, 3,.T.,2)
						.FOL_StoreLog(.T.)
					Endwith
				Otherwise
					With VGO_Toolbar.VOO_ActiveForm.OOL_SysLog
						.FOL_Log(VLC_Msg,1,.F.)
						.FOL_SetLogAux(1, 1, 3,  lpack.FOC_Caption("integra contabilidade"))
						.FOL_SetSource(PLC_Par, PLC_Ukey, PLC_Form, 1, 3,.T.,2)
						.FOL_StoreLog(.T.)
					Endwith

			Endcase


			VLL_Return = .T.
		Endif

	ELSE
	    ** ----------------------------------------------------------------------------
	    ** Inserido ref. chamado service now: INC0475838
	    ** excluir a capa do lancamento contábil quando gerar sem itens
	    ** ----------------------------------------------------------------------------	    
	    VGO_GEN.FOL_SqlExec("SELECT b06.ukey FROM STAR_DATA@B06 (NOLOCK) LEFT JOIN STAR_DATA@B07 (NOLOCK) ON B07.B06_UKEY = B06.UKEY WHERE B07.UKEY IS NULL AND B06_UKEYP = '"+PLC_Ukey+"'","tmpb06")
	    IF USED("TMPB06") AND !EOF("TMPB06")
	        IF VGO_GEN.FOL_FINDEXPRESSION("B06_UKEY","B06Y",TMPB06.UKEY,.F.,.T.)
	           REPLACE MYCONTROL WITH "1" IN B06Y
	           VGO_GEN.FOL_DELETERECORDSQL("B06Y","B06","UKEY")
	        ENDIF
	    ENDIF	    
	    VGO_GEN.FOL_CLOSETABLE("B06Y")
	    VGO_GEN.FOL_CLOSETABLE("TMPB06")	    
	ENDIF

	Return VLL_Return
Endfunc

******************************************************
*- FIM SCRUM - 14543
******************************************************

Procedure FOB_CalcTotImp
	Lparameters PLN_Id, PLC_T08Id, PLC_U08Par, PLC_U08UkeyP, PLN_Moeda

	Local VLN_Id, VLC_T08Id, VLC_U08Par, VLC_U08UkeyP, VLB_Return

	VLN_Id	 	 = PLN_Id
	VLC_T08Id	 = Upper(PLC_T08Id)
	VLC_U08Par	 = Upper(PLC_U08Par)
	VLC_U08UkeyP = PLC_U08UkeyP

	If VLN_Id = 0
		With VGO_GEN
			.FOL_SetParameter(1, VLC_T08Id)
			.FOL_SetParameter(2, VLC_U08Par)
			.FOL_SetParameter(3, VLC_U08UkeyP)
			.FOL_ExecuteCursor("U08_TINV2", "U08TT", 3)
		Endwith
	Else
		With VGO_GEN
			.FOL_SetParameter(1, VLN_Id)
			.FOL_SetParameter(2, VLC_U08Par)
			.FOL_SetParameter(3, VLC_U08UkeyP)
			.FOL_ExecuteCursor("U08_TINV1", "U08TT", 3)
		Endwith
	Endif
	VLB_Return = Iif(PLN_Moeda = 1,u08tt.u08_001_b,u08tt.u08_002_b)
	Use In Select("U08TT")

	Return VLB_Return
Endproc





*- Corrige a diferença causada pela conversão monetária
Procedure FOL_FixExchangeDifference

	Lparameters PLC_B06Ukey ,;
		PLC_AccountUkey && Conta que deverá ser lançado a diferença

	Local VLL_Return

	VLL_Return = .T.

	*- Lançamentos
	With VGO_Dat
		.FOL_SetParameter(1, PLC_B06Ukey)
		.VOA_Index[1] = "b11_ukey"
		.FOL_Editcursor("B07_FRM", "B07_LAN", "TMP_B07", "Z", 1, 1)
	Endwith

	*- Verifico se tem diferença entre débitos e créditos
	Select Sum(Round(b07_001_b * b07_011_n,2)) As debito, Sum(Round(b07_001_b * b07_012_n,2)) As credito From TMP_B07 Into Cursor TMP_DIF

	If TMP_DIF.debito <> TMP_DIF.credito And Abs(TMP_DIF.debito - TMP_DIF.credito) < 0.05

		*- Busco a conta que devo aplicar a diferenca
		If Seek(PLC_AccountUkey,"TMP_B07","CODE")
			*- Diferença
			VLN_Dif = TMP_DIF.debito - TMP_DIF.credito
			*- Verifico se a conta é de debito, então inverto o lançamento
			If TMP_B07.b07_011_n = 1
				VLN_Dif = VLN_Dif * -1
			Endif

			*- Atualizo o valor no lançamento
			Select TMP_B07
			Scatter Memvar Memo
			m.b07_001_b = m.b07_001_b + VLN_Dif
			m.b07_007_b = m.b07_007_b + VLN_Dif
			m.mycontrol = "1"
			Gather Memvar Memo

			VGO_GEN.FOL_CreateSqlString("TMP_B07","B07")
			VLL_Return = VGO_GEN.FOL_SaveRecordSql("TMP_B07","B07","UKEY")
			If VLL_Return
				*- Atulizo o rateio dos campos alterados
				With VGO_GEN
					*- Busco os rateio do lançamento
					.FOL_SetParameter(1, PLC_B06Ukey)
					.VOA_Index[1] = "b04_par + b04_ukeyp"
					.VOA_Index[2] = "b04_par + b04_ukeyp + b04_004_c"
					.FOL_Editcursor("B04_FRMB06", "B04_TMP", "B04TTT", "Z", 2, 1)

					*- Cursor para a tela de centro de custo 1
					.FOL_SetParameter(1, TMP_B07.UKEY)
					.VOA_Index[1] = "b04_par + b04_ukeyp + b04_004_c"
					.VOA_Index[2] = "b04_par + b04_ukeyp + b04_004_c + a11_ukey"
					.FOL_Editcursor("B04_FRM2", "B04_FRM", "B04TT", "Z", 2, 1)

					*- Cursor para a tela de centro de custo 2
					.FOL_SetParameter(1, TMP_B07.UKEY)
					.VOA_Index[1] = "ukey"
					.VOA_Index[2] = "b04_par + b04_ukeyp"
					.FOL_Editcursor("B04_CC2", "B04_FRM", "B04_002TTT", "Z", 2, 1)

					*- Recalculo o rateio com o novo valor
					VGO_Acc.OOL_RecalculateRateio.FOU_Execute("B04TT", "B07", TMP_B07.UKEY, "B07_001_B", "B04_002TTT", TMP_B07.b07_001_b, .F., "a11_001_c,a11_003_c,a56_001_c,a56_003_c,a11_005_n,a11_008_n,a56_005_n,a56_008_n")
					VGO_Acc.OOL_RecalculateRateio.FOU_Execute("B04TT", "B07", TMP_B07.UKEY, "B07_007_B", "B04_002TTT", TMP_B07.b07_007_b, .F., "a11_001_c,a11_003_c,a56_001_c,a56_003_c,a11_005_n,a11_008_n,a56_005_n,a56_008_n")

					*- Salvo as informações recalculadas
					VLL_Return = .FOL_SaveCursorSql(Null,"B04TT","B04","UKEY")
					VLL_Return = VLL_Return And .FOL_SaveCursorSql(Null,"B04_002TTT","B04","UKEY")

					Use In Select("B04TT")
					Use In Select("B04TTT")
					Use In Select("B04_002TTT")
				Endwith
			Endif
		Endif
	Endif
	Use In Select("TMP_DIF")
	Use In Select("TMP_B07")

	Return VLL_Return

Endproc



PROCEDURE FOL_MakeIntegrationHomeMade
	LPARAMETERS PLL_NotMark
	
	if VGO_Gen.FOL_FindExpression(ALLTRIM(VGO_Acc.VOC_PrimaryFile) + "_UKEY", "TMPINTE", VGO_Acc.VOC_PrimaryUkey, .F., .T.)
		SELECT TMPINTE
		VGO_ACC.FOL_MArkIntegration("TMPINTE", VGO_Acc.VOC_PrimaryFile, "B", PLL_NotMark)
		
		IF VGO_Gen.FOL_FindExpression(ALLTRIM(VGO_Acc.VOC_PrimaryFile) + "_UKEY", "TMPINTE", VGO_Acc.VOC_PrimaryUkey, .F., .T.)
			IF !EMPTY(NVL(VGO_Acc.VOC_PrimaryFile, "")) AND USED(VGO_Acc.VOC_PrimaryFile)
				SELECT (VGO_Acc.VOC_PrimaryFile)
				Replace Timestamp With TMPINTE.Timestamp In (VGO_Acc.VOC_PrimaryFile)
			ENDIF 		
		ENDIF 
		VGO_Gen.FOL_CloseTable("TMPINTE")
	ENDIF
ENDPROC 



*/----------------------------------------------------------------------------------------------------/*
*/ Programa             : FOL_AtualizaNITLanc                                                   	  /*
*/ Descrição            : Atualiza informações do NIT no lançamento contábil conforme                 /*
*/                        a origem 																      /*
*/ Última alteração     : 08/07/2016                                                                  /*
*/ Alterado por   		: Marcelo Ayabe                                                               /*
*/ Versão               : 1                                                                           /*
*/----------------------------------------------------------------------------------------------------/*
procedure FOL_AtualizaNITLanc
      Lparameters PLC_Form
      Local PLC_UkeyOrigem    
		
      do case
            *-NF Venda
            Case PLC_Form == "J10" or PLC_Form = "J10_001" or PLC_Form = "J10_CAN" 

                  PLC_UkeyOrigem = j10.j10_ukeyp
                  FOL_TransportNITGeral(VGO_Acc.VOC_EntryB06Ukey,PLC_UkeyOrigem)
                  
            *-INVOICE
            Case PLC_Form = "U10"
                  PLC_UkeyOrigem = u10.u10_ukeyp
                  FOL_TransportNITGeral(VGO_Acc.VOC_EntryB06Ukey,PLC_UkeyOrigem)

            *-Compra/Devolução
            Case PLC_Form == "E10" or PLC_Form = "E10_001" or PLC_Form = "E10_CAN" 
				  PLC_UkeyOrigem = e10.e10_ukeyp
                  FOL_TransportNITGeral(VGO_Acc.VOC_EntryB06Ukey,PLC_UkeyOrigem)
                  
            *- Quitações a Pagar//Efetivação de adiantamentos a pagar//Estorno de Títulos a Pagar//Estorno de adiantamentos a pagar//Reparcelamento de Contas a Pagar
            Case PLC_Form == "F18_001" or PLC_Form == "F18_021" or PLC_Form == "F18_030" or PLC_Form == "F18_034" or PLC_Form == "F18_027" or PLC_Form == "F18_032" &&SCRUM-15529
                  if used("f16t")
                        go top in f16t
                        select f16t
                        scan
                             && PLC_UkeyOrigem = f16t.f11_ukeyp trecho retirado em 08/03/2017 por Rui Santos
                             && incluido trecho abaixo como correção para poder pegar o fornecerdor e passar para função.
                             PLC_UkeyOrigem = FLC_FieldPar("F11", f16t.f11_ukey, "F11_UKEYP") 
                             FOL_TransportNITGeral(VGO_Acc.VOC_EntryB06Ukey,PLC_UkeyOrigem,f16t.ukey)
                        endscan     
                  endif
				*-  SCRUM-15529 - INICIO
                  if used("F18_f16t2")
                        go top in F18_f16t2
                        select F18_f16t2
                        scan
                             PLC_UkeyOrigem = F18_f16t2.f11_ukeyp
                              FOL_TransportNITGeral(VGO_Acc.VOC_EntryB06Ukey,PLC_UkeyOrigem,F18_f16t2.ukey)
                        endscan     
                  endif
				*-  SCRUM-15529 - FIM
                  
            *- Quitações a Receber//Efetivação de adiantamentos a receber//Estorno de Títulos a Receber//Estorno de adiantamentos a receber//Estorno de comissão a receber//Reparcelamento de Contas a Receber
            Case PLC_Form == "F18_002" or PLC_Form == "F18_022" or PLC_Form == "F18_031" or PLC_Form == "F18_035" or PLC_Form == "F18_033" or PLC_Form == "F18_028"
                  if used("f15t")
                        go top in f15t
                        select f15t
                        SCAN
                        	&& alterado por Rui Santos - 14/12/2016
                             PLC_UkeyOrigem = FLC_FieldPar("F12", f15t.f12_ukey, "F12_UKEYP") 
                             FOL_TransportNITGeral(VGO_Acc.VOC_EntryB06Ukey,PLC_UkeyOrigem,f15t.ukey)
                        endscan     
                  ENDIF
				*-  SCRUM-15529 - INICIO
                  if used("F18_f15t2")
                        go top in F18_f15t2
                        select F18_f15t2
                        scan
                             PLC_UkeyOrigem = FLC_FieldPar("F12", F18_f15t2.f12_ukey, "F12_UKEYP") 
                             FOL_TransportNITGeral(VGO_Acc.VOC_EntryB06Ukey,PLC_UkeyOrigem,F18_f15t2.ukey)
                        endscan     
                  endif
				*-  SCRUM-15529 - FIM
                  
                  
            *- Contas a Pagar
            Case PLC_Form == "F11_001"
                  PLC_UkeyOrigem = f11.f11_ukeyp
                  FOL_TransportNITGeral(VGO_Acc.VOC_EntryB06Ukey,PLC_UkeyOrigem)

            *- Transferência bancária//Movimentação de entrada bancária//Movimentação de saída bancária
            *!*Case PLC_Form == "F18_005" or PLC_Form == "F18_006" or PLC_Form == "F18_007"
            Case PLC_Form == "F18_005" or PLC_Form == "F18_006"
                  if used("f17t")
                        go top in f17t    
                        PLC_UkeyOrigem = f17t.f17_ukeypw
                        FOL_TransportNITGeral(VGO_Acc.VOC_EntryB06Ukey,PLC_UkeyOrigem)
                  endif
      endcase
endproc

*** SSA-79 - Inicio

Procedure FON_CM

	Lparameters PLC_D04Ukey, PLC_D07Ukey, PLD_Data, PLN_Moeda
	
	Local VLN_Valor

	*- Busca o local que cálcula o estoque
	VLO_FindLocalCM = Createobject("CGO_LocalCm_c")

	with VGO_Gen
		.FOL_SetParameter(2, VLO_FindLocalCM.FOU_Execute(PLC_D07Ukey))
		*- Esse parâmetro tem que ser definido aqui porque a função OOC_LocalCm
		*- utiliza o o parâmetro 1.
		.FOL_SetParameter(1, PLC_D04Ukey)
		.FOL_SetParameter(3, PLD_Data)
		*- Procura o último custo médio do item
		.FOL_ExecuteCursor("D15_D04_D07_D_3", "TMP_D15", 3)
		
		If PLN_Moeda = 1
			VLN_Valor = tmp_d15.d15_008_b
		Else
			VLN_Valor = tmp_d15.d15_009_b
		Endif
		Use In Select("TMP_D15")
		
		Return VLN_Valor
	endwith

Endproc
*** SSA-79 - Fim


*/------------------------------------------------------------------------------------------/*
*/ Programa             : FOL_TransportNITGeral                                             /*
*/ Descrição            : Atualiza informações do NIT no lançamento contábil conforme       /*
*/                        a origem (Quando existe + de um documento é considerado o 1º)		/*
*/ Última alteração     : 08/01/2016                                                        /*
*/ Alterado por   : Marcelo Ayabe                                                           /*
*/ Versão               : 1                                                                 /*
*/------------------------------------------------------------------------------------------/*
Procedure FOL_TransportNITGeral
      Lparameters PLC_B06Ukey ,;
                        PLC_UkeyOrigem ,;
                        PLC_UkeyParcela
                        
      Local VLC_Par, VLL_Return
      
      VLL_Return = .T.  
      VLC_Par = ""
      
      With VGO_Gen                 
            *- Verifico se é um fornecedor
            If !.FOL_FindExpression("A08_UKEY","TMP_ORIGEM",PLC_UkeyOrigem)
                  *- Verifico se é um Cliente
                  If !.FOL_FindExpression("A03_UKEY","TMP_ORIGEM",PLC_UkeyOrigem)
                        Use In Select("TMP_ORIGEM")
                        
                        Return .T.
                  Else
                        VLC_Par = "A03"
                  Endif
            Else
                  VLC_Par = "A08"
            Endif

            *- Busco o lançamento contábil           
            .FOL_SetParameter(1, PLC_B06Ukey)
            .VOA_Index[1] = "ukey"
            .VOA_Index[2] = "b07_004_c"
            .VOA_Index[3] = "b06_ukey + b07_004_c"
            .VOA_Index[4] = "b07_013_c"
            .FOL_EditCursor("B07_FRM", "B07_LAN", "TMP_B07T", "Z", 4, 1)

            if used("TMP_B07T")          
                  *-Para Lançamentos onde na Origem não existem parcelas
                  if empty(PLC_UkeyParcela)
                        select TMP_B07T
                        scan
                             replace mycontrol 	 With "1" ,;
                             		 b07_500_c   With Substr(Evaluate("tmp_origem." + VLC_Par + "_010_c"),1,8) ,;
                                     a03_ukey    With Iif(VLC_Par=="A03",tmp_origem.ukey,null) ,;
                                     a08_ukey    With Iif(VLC_Par=="A08",tmp_origem.ukey,null) ,;
                                     b07_par0    with VLC_Par ,;
                                     b07_ukeyp0  with nvl(tmp_b07t.a08_ukey,nvl(tmp_b07t.a03_ukey,"")) In TMP_B07T
                                         
                             .FOL_CreateSqlString("TMP_B07T","B07")
                             
                             VLL_Return = .FOL_SaveRecordSql("TMP_B07T","B07","UKEY")
                        endscan
                  else
                        *-Para Lançamentos onde existe parcelas (F18_001,F18_002,etc)    
                        select TMP_B07T
                        scan 
	                        if alltrim(tmp_b07t.b07_ukeyp) = alltrim(PLC_UkeyParcela)  
	                             replace mycontrol 	 With "1" ,;
	                             		 b07_500_c   With Substr(Evaluate("tmp_origem." + VLC_Par + "_010_c"),1,8) ,;
	                                     a03_ukey    With Iif(VLC_Par=="A03",tmp_origem.ukey,null) ,;
	                                     a08_ukey    With Iif(VLC_Par=="A08",tmp_origem.ukey,null) ,;
	                                     b07_par0    with VLC_Par ,;
	                                     b07_ukeyp0  with nvl(tmp_b07t.a08_ukey,nvl(tmp_b07t.a03_ukey,"")) In TMP_B07T
	                                         
	                             .FOL_CreateSqlString("TMP_B07T","B07")
	                             
	                             VLL_Return = .FOL_SaveRecordSql("TMP_B07T","B07","UKEY")
                           endif 
                        endscan
                  endif 
            endif 
            
            Use In Select("TMP_ORIGEM")
            Use In Select("TMP_B07T")
      endwith
      
      Return VLL_Return
Endproc
******************************************************
*- Adaptação Contabilização do Custo para HW - Prime 931
******************************************************
Function fol_verificacontabilizacusto(plc_t04_ukey)
	
	With vgo_gen
		.fol_setparameter(1, plc_t04_ukey)
		.fol_editcursor("T04_UKEY","T04_UKEY","T04CC","Z",0,1)
	Endwith

	If Reccount("T04CC") > 0
		Select t04cc
		If t04cc.t04_601_n == 1
			Return 1
		Else
			Return 0
		ENDIF
	ELSE
		vgo_gen.fon_msg('msg_9312')
		Return 0
	Endif
Endfunc
******************************************************
*- Adaptação Contabilização do Custo para HW - Prime 931
******************************************************

****************************************************************
*- Geração de integração com moeda diferente de Real - Prime 220
****************************************************************
Function fol_verificamoedaintegracao(plc_b06ukey)
    IF ! EMPTY(ALLTRIM(NVL(plc_b06ukey,'')))
		With vgo_gen
			.fol_setparameter(1, plc_b06ukey)
			.fol_editcursor("B06_UKEY","B06_UKEY","B06MC","Z",0,1)
		Endwith

		If Reccount("B06MC") > 0
			Select b06mc
			If ALLTRIM(SUBSTR(b06mc.a36_code0,1,5)) <> 'R$'
				VGO_Custom.FOL_CLog("Não é permitido e a contabilização de um documento com moeda diferente de Real. Favor entrar em contato com a contabilidade.")
				
				VGO_Custom.FOL_CSetLogAux(1, 1, 3, "Moeda da Contabilização")
				Return .T.
			Else
				Return .F.
			ENDIF
		ELSE
		   Return .F.
		ENDIF
	ELSE
		RETURN .f.
	Endif
Endfunc
****************************************************************
*- Geração de integração com moeda diferente de Real - Prime 220
****************************************************************



******************************************************
*- Fechamento de período por Conta Contábil - Prime 930
******************************************************
Function fol_verificautilizacaoconta(plc_b07b11_ukey)
	With vgo_gen
		.fol_setparameter(1, plc_b07b11_ukey)
		.fol_editcursor("B11_UKEY","B11_UKEY","B11CC","Z",0,1)
	Endwith

	If Reccount("B11CC") > 0
		Select b11cc
		If b11cc.b11_503_d > b06.b06_002_d
			VGO_Custom.FOL_CSetLogAux(1, 2, 1, "b11_001_c", "B11", plc_b07b11_ukey)
			VGO_Custom.FOL_CSetLogAux(2, 2, 1, "b11_003_c", "B11", plc_b07b11_ukey)
			VGO_Custom.FOL_CLog("A conta contábil @1 - @2 está bloqueada para lançamentos. Favor entrar em contato com a contabilidade.", 2)

			VGO_Custom.FOL_CSetLogAux(1, 1, 3, "Conta Contábil")

			Return .T.
		Else
			Return .F.
		Endif
	Endif
Endfunc
******************************************************
*- Fechamento de período por Conta Contábil - Prime 930
******************************************************

***************************************************************************
*- Verifica se há lançamento contábil, quando se tem integração com estoque
***************************************************************************
PROCEDURE FOL_VerificaEstoqueContabilidade
	Lparameters pB06Ukey 

	LOCAL cD13Ukey, VLL_Return
	
	VLL_Return = .F.
		
	cD13Ukey = db.getvalue("D13", "ALL!", "UKEY", "D13_IUKEYP = '" + u10.ukey + "'AND D13_IPAR = 'U10'")
	IF !EMPTY(cD13Ukey)
		IF	EMPTY(NVL(pB06Ukey, ""))
			VGO_Custom.FOL_CLog("A Invoice possui integração com o estoque, mas não gerou lançamento contábil.")
			VGO_Custom.FOL_CSetLogAux(1, 1, 3, "Lançamento Contábil.")

			VLL_Return = .T.

		ENDIF
	ENDIF

	RETURN VLL_Return

ENDPROC

***************************************************************************
*- Verifica se há lançamento contábil, quando se tem integração com estoque
***************************************************************************


*--------------------------------------------------------------------------*
*- Verifica se o paramêtro de fechamento do módulo contábil direto no banco.
*--------------------------------------------------------------------------*

PROCEDURE FOL_FechamentoContabilidade
		
	LPARAMETERS cForm
		
	LOCAL dData, dDatFechContabil, lReturn, dDatFechModulo
	lReturn = .T.
	dData = {}	
	dDatFechContabil = db.getvalue("Y41", "ALL!", "Y41_004_D", "Y08_UKEY = 'STARPAR-D-00007'")
		
	IF INLIST(cForm, "E10", "E10_001")
		dData = e10.e10_014_d
		dDatFechModulo = db.getvalue("Y41", "ALL!", "Y41_004_D", "Y08_UKEY = 'STARPAR-D-00014'")
		cModulo = "Compras"
	ENDIF
	
	IF INLIST(cForm, "J10", "J10_001")
		dData = j10.j10_014_d
		dDatFechModulo = db.getvalue("Y41", "ALL!", "Y41_004_D", "Y08_UKEY = 'STARPAR-D-00140'")
		cModulo = "Vendas"
	ENDIF
			
	IF INLIST(cForm, "F11_001", "F11_002", "GERA_CONTAS_PAGAR")
		dData = f11.f11_002_d
		dDatFechModulo = db.getvalue("Y41", "ALL!", "Y41_004_D", "Y08_UKEY = 'STARPAR-D-00154'")
		cModulo = "Financeiro"
	ENDIF

	IF INLIST(cForm, "F12_001", "F12_002")
		dData = f12.f12_002_d
		dDatFechModulo = db.getvalue("Y41", "ALL!", "Y41_004_D", "Y08_UKEY = 'STARPAR-D-00154'")
		cModulo = "Financeiro"
	ENDIF

	IF INLIST(cForm, "F18_001", "F18_002", "F18_005", "F18_006", "F18_007", "F18_014", "F18_015", "F18_017", "F18_018", "F18_021", "F18_022") 
		dData = f18.f18_003_d
		dDatFechModulo = db.getvalue("Y41", "ALL!", "Y41_004_D", "Y08_UKEY = 'STARPAR-D-00154'")
		cModulo = "Financeiro"
	ENDIF

	IF INLIST(cForm, "F18_027", "F18_028", "F18_030", "F18_031", "F18_032", "F18_033", "F18_034", "F18_035", "F18_046", "F18_046CSP", "F18_047")
		dData = f18.f18_003_d
		dDatFechModulo = db.getvalue("Y41", "ALL!", "Y41_004_D", "Y08_UKEY = 'STARPAR-D-00154'")
		cModulo = "Financeiro"
	ENDIF
	
	IF INLIST(cForm, "U10", "U10_DEVOL")
		dData = u10.u10_004_d
		dDatFechModulo = db.getvalue("Y41", "ALL!", "Y41_004_D", "Y08_UKEY = 'STARPAR-D-00370'")
		cModulo = "Importação"
	ENDIF
	
	IF INLIST(cForm, "Z10")
		dData = z10.z10_029_d
		dDatFechModulo = db.getvalue("Y41", "ALL!", "Y41_004_D", "Y08_UKEY = 'STARPAR-D-00140'")
		cModulo = "Vendas"
	endif

	IF !EMPTY(ALLTRIM(DTOS(dData))) AND !INLIST(cForm, "BEGIN", "END")
		IF !(dData > dDatFechContabil)
	  		VGO_Custom.FOL_CLog("Módulo contábil foi fechado, não é permitido alterar documentos. Favor entrar em contato com a contabilidade.")
		    VGO_Custom.FOL_CSetLogAux(1, 1, 3, "Lançamento Contábil.")

			lReturn = .F.
		    VGO_Acc.VOL_Error = .T.
	  	ENDIF
  	endif

	RETURN lReturn

ENDPROC

*--------------------------------------------------------------------------*
*- Verifica se o paramêtro de fechamento do módulo contábil direto no banco.
*--------------------------------------------------------------------------*