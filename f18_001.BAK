*- Novo BRANCH

*/--------------------------------------------------------------------------------------------------/*
*/ Procedimento		: f18_001		                            				     	  			/*
*/ Descrição   		: Gera lançamento contábil da Quitação de Títulos a Pagar - Tela F18_001		/*
*/ Retorno     		: VGO_Acc.VOL_Error = .T. Se a operação foi bem sucedida, =.F. c.c.   			/*
*/--------------------------------------------------------------------------------------------------/*
LOCAL VLC_ContaDebito, VLC_ContaCredito, VLC_UkeyBanco,VLC_UkeyConta,;
	VLL_Pis,VLC_Pis,VLC_Imposto,VLN_ValorImposto,VLC_ContaCredito1,VLC_UkeyBanco, VLN_TotalImposto, VLN_Liquido, VLN_Multa, VLN_Desconto, VLN_AuxTotal
VLN_ValorImposto = 0
VLN_TotalImposto = 0

STORE 0 TO VLN_Liquido, VLN_Multa, VLN_Desconto, VLN_ValorImposto , VLN_AuxTotal
SET STEP ON 
*- Verifica se foi efetuada a quitação.
IF f18.f18_004_n = 1
	IF ALLTRIM(f16t.a21_ukey) <> "STAR_STAR__14313NBGD"	
		WITH VGO_Acc
			
			VLC_ContaDiferencaConversao = ""	
			
			*- P A R C E L A S   A   P A G A R
			SELECT f16t
			GO TOP
			
			SCAN WHILE !.VOL_Error
				IF .VOL_GeraCapaB06
					*- Gera a capa do Lançamento
					.FOC_NewEntry(f18.f18_001_c, "F18", f18.ukey, f18.a36_code0, f18.f18_003_d, f18.f18_003_d, "", .T.)
				ENDIF
				IF !.VOL_Error

					VLC_Par   = FOU_FieldPar("F11", f16t.f11_ukey, "F11_PAR")
					VLC_Ukeyp = FOU_FieldPar("F11", f16t.f11_ukey, "F11_UKEYP")
					
					*- Scrum 15876 || Melhoria na contabilização da quitação a pagar.
					*- Danielle Santos - 24/03/2017
					vgo_gen.fol_setparameter(1, f16t.a21_ukey)
					vgo_gen.fol_executecursor("A21_UKEY", "A21TT", 1)
					
					if a21tt.a21_502_n == 1
						*- CONTA 2 DO TIPO DE DOCUMENTO
						vlc_contadebito = .foc_account("A21", f16t.a21_ukey, 2)
					else
						if !empty(alltrim(nvl(.foc_account("A08", vlc_ukeyp, 1),"")))
							*-Conta 1 do Fornecedor
							vlc_contadebito = .foc_account("A08", vlc_ukeyp, 1)
						else

							.vol_error = .f.
							*- Conta 2 do Tipo de Documento
							vlc_contadebito = .foc_account("A21", f16t.a21_ukey, 2)

						endif
					endif
					

					
*!*						if !empty(alltrim(nvl(.FOC_Account("A08", VLC_Ukeyp, 1),"")))
*!*							*-Conta 1 do Fornecedor
*!*							VLC_ContaDebito = .FOC_Account("A08", VLC_Ukeyp, 1)
*!*						ELSE
*!*						
*!*							.VOL_Error = .F.
*!*							*- Conta 2 do Tipo de Documento
*!*							VLC_ContaDebito = .FOC_Account("A21", f16t.a21_ukey, 2)
*!*							
*!*						ENDIF
					*- Fim 15876
					
					&&
					VLC_ContaDiferencaConversao = VLC_ContaDebito 

					IF !.VOL_Error
						*- Converte o valor para a moeda da capa da quitação.
						VLN_ConvertValue = .FON_Vm(f16t.f16_013_b, f16t.a36_code0, f18.a36_code0, f18.f18_003_d)
						*!*						VLN_Liquido = VLN_Liquido + VLN_ConvertValue
						IF !.VOL_Error
							*-Prime-2520-Início
							.VOA_Answer[1] = ALLTRIM(F18.F18_001_C) + " - " + ALLTRIM(f16t.titulo)
							.VOA_Answer[2] = FOU_FieldPar(VLC_Par, VLC_Ukeyp, ALLTRIM(VLC_Par) + "_003_C")
							.VOA_Answer[3] = f18.usr_note
							*-Prime-2520-Fim							
							*- Lançamento a débito.
							.FOL_NewItemEntry(.VOC_EntryB06Ukey, f18.a36_code0, VLC_ContaDebito, "F16", f16t.ukey, VLN_ConvertValue, f18.f18_003_d, f18.f18_003_d, "D", "0003", "F16", F16T.UKEY, "F16_003_B")

							*- J U R O S  D A   P A R C E L A
							IF !.VOL_Error
								VLC_ContaDebito = .FOC_Account("CIA",Vgo_Gen.VOC_CompanyCode, 1)
								IF !.VOL_Error
									*- Converte o valor para a moeda da capa da quitação.
									VLN_ConvertValue = .FON_Vm(f16t.f16_018_b, f16t.a36_code0, f18.a36_code0, f18.f18_003_d)
									IF !.VOL_Error
										*-Prime-2520-Início
										.VOA_Answer[1] = ALLTRIM(F18.F18_001_C) + " - " + ALLTRIM(f16t.titulo)
										.VOA_Answer[2] = FOU_FieldPar(VLC_Par, VLC_Ukeyp, ALLTRIM(VLC_Par) + "_003_C")
										.VOA_Answer[3] = f18.usr_note
										*-Prime-2520-Fim

										*- Lançamento a débito.
										.FOL_NewItemEntry(.VOC_EntryB06Ukey, f18.a36_code0, VLC_ContaDebito, "F16", f16T.ukey, VLN_ConvertValue, f18.f18_003_d, f18.f18_003_d, "D", "0003")

										*-M U L T A   D A   P A R C E L A
										IF !.VOL_Error
											VLC_ContaDebito = .FOC_Account("CIA",Vgo_Gen.VOC_CompanyCode, 2)
											IF !.VOL_Error
												*- Converte o valor para a moeda da capa da quitação.
												VLN_ConvertValue = .FON_Vm(f16t.f16_006_b, f16t.a36_code0, f18.a36_code0, f18.f18_003_d)

												IF !.VOL_Error
													*-Prime-2520-Início
													.VOA_Answer[1] = ALLTRIM(F18.F18_001_C) + " - " + ALLTRIM(f16t.titulo)
													.VOA_Answer[2] = FOU_FieldPar(VLC_Par, VLC_Ukeyp, ALLTRIM(VLC_Par) + "_003_C")
													.VOA_Answer[3] = f18.usr_note
													*-Prime-2520-Fim
													*- Lançamento a débito.
													.FOL_NewItemEntry(.VOC_EntryB06Ukey, f18.a36_code0, VLC_ContaDebito, "F16", f16T.ukey, VLN_ConvertValue, f18.f18_003_d, f18.f18_003_d, "D", "0003")

													*- D E S C O N T O  D A   P A R C E L A
													IF !.VOL_Error
														VLC_ContaCredito = .FOC_Account("CIA",Vgo_Gen.VOC_CompanyCode, 3)
														IF !.VOL_Error
															*- Converte o valor para a moeda da capa da quitação.
															VLN_ConvertValue = .FON_Vm(f16t.f16_008_b, f16t.a36_code0, f18.a36_code0, f18.f18_003_d)

															IF !.VOL_Error
																*-Prime-2520-Início
																.VOA_Answer[1] = ALLTRIM(F18.F18_001_C) + " - " + ALLTRIM(f16t.titulo)
																.VOA_Answer[2] = FOU_FieldPar(VLC_Par, VLC_Ukeyp, ALLTRIM(VLC_Par) + "_003_C")
																.VOA_Answer[3] = f18.usr_note
																*-Prime-2520-Fim

																*- Lançamento a crédito.
																.FOL_NewItemEntry(.VOC_EntryB06Ukey, f18.a36_code0, VLC_ContaCredito, "F16", f16T.ukey, VLN_ConvertValue, f18.f18_003_d, f18.f18_003_d, "C", "0003")
																*-Abatimento
																IF !.VOL_Error
																	VLC_ContaCredito = .FOC_Account("CIA",Vgo_Gen.VOC_CompanyCode, 9)
																	IF !.VOL_Error
																		*- Converte o valor para a moeda da capa da quitação.
																		VLN_ConvertValue = .FON_Vm(f16t.f16_027_b, f16t.a36_code1, f18.a36_code0, f18.f18_003_d)

																		IF !.VOL_Error
																			*-Prime-2520-Início
																			.VOA_Answer[1] = ALLTRIM(F18.F18_001_C) + " - " + ALLTRIM(f16t.titulo)
																			.VOA_Answer[2] = FOU_FieldPar(VLC_Par, VLC_Ukeyp, ALLTRIM(VLC_Par) + "_003_C")
																			.VOA_Answer[3] = f18.usr_note
																			*-Prime-2520-Fim

																			*- Lançamento a crédito.
																			.FOL_NewItemEntry(.VOC_EntryB06Ukey, f18.a36_code0, VLC_ContaCredito, "F16", f16T.ukey, VLN_ConvertValue, f18.f18_003_d, f18.f18_003_d, "C", "0003")
																			*-Acrescimo
																			IF !.VOL_Error
																				VLC_ContaDebito = .FOC_Account("CIA",Vgo_Gen.VOC_CompanyCode, 10)
																				IF !.VOL_Error
																					*- Converte o valor para a moeda da capa da quitação.
																					VLN_ConvertValue = .FON_Vm(f16t.f16_009_b, f16t.a36_code1, f18.a36_code0, f18.f18_003_d)

																					IF !.VOL_Error
																						*-Prime-2520-Início
																						.VOA_Answer[1] = ALLTRIM(F18.F18_001_C) + " - " + ALLTRIM(f16t.titulo)
																						.VOA_Answer[2] = FOU_FieldPar(VLC_Par, VLC_Ukeyp, ALLTRIM(VLC_Par) + "_003_C")
																						.VOA_Answer[3] = f18.usr_note
																						*-Prime-2520-Fim
																						*- Lançamento a crédito.
																						.FOL_NewItemEntry(.VOC_EntryB06Ukey, f18.a36_code0, VLC_ContaDebito, "F16", f16T.ukey, VLN_ConvertValue, f18.f18_003_d, f18.f18_003_d, "D", "0003")
																					ENDIF
																				ENDIF
																			ENDIF
																		ENDIF
																	ENDIF
																ENDIF
															ENDIF
														ENDIF
													ENDIF
												ENDIF
											ENDIF
										ENDIF
									ENDIF
								ENDIF
							ENDIF
						ENDIF
					ENDIF
				ENDIF
			ENDSCAN

			*- C O N T A   B A N C Á R I A
			*--------------------------------------------------------------------------------------------------------
			SELECT F17T
			GO TOP
			SCAN WHILE !.VOL_Error
				*- Conta 1 do banco.
				VLC_ContaCredito = .FOC_Account("A39", F17T.a39_ukey, 2)
				IF !.VOL_Error
					*-Valor Convertido
					VLN_ConvertValue = .FON_Vm(F17T.f17_001_b, F17T.a36_code0, f18.a36_code0, f18.f18_003_d)-VLN_TotalImposto
					.VOA_Answer[1] = ALLTRIM(f18.f18_001_c) &&f16t.titulo
					.VOA_Answer[2] = FOU_FieldPar(VLC_Par, VLC_Ukeyp, ALLTRIM(VLC_Par) + "_003_C")
					.VOA_Answer[3] = f18.usr_note
					IF !.VOL_Error
						*-Lançamento da Conta do Banco em Movimentação
						.FOL_NewItemEntry(.VOC_EntryB06Ukey, f18.a36_code0, VLC_ContaCredito, "F17", f17T.ukey, VLN_ConvertValue, f18.f18_003_d, f18.f18_003_d, "C", "0003")
					ENDIF
				ENDIF
			ENDSCAN


			*- C H E Q U E S   A   PAGAR
			*-------------------------------------------------------------------------------------------------------
			SELECT F07T
			GO TOP
			SCAN WHILE !.VOL_Error
				*-Ukey do banco do cheque a pagar
				VLC_UkeyBanco = FLC_FieldPar("F06", F07T.f06_ukey, "A01_UKEY")

				IF !.VOL_Error
					*- Conta 1 do banco do cheque
					VLC_ContaDebito = .FOC_Account("A01", VLC_UkeyBanco, 2)

					IF !.VOL_Error
						*-Valor Convertido
						VLN_ConvertValue = .FON_Vm(F07T.f07_002_b, F07T.a36_code0, f18.a36_code0, f18.f18_003_d)

						IF !.VOL_Error
							.VOA_Answer[1] = ALLTRIM(f18.f18_001_c) &&.FOC_TitleNumber(f18.ukey, "F16", .F.)
							.VOA_Answer[2] = FOU_FieldPar(VLC_Par, VLC_Ukeyp, ALLTRIM(VLC_Par) + "_003_C")
							.VOA_Answer[3] = f18.usr_note

							*-Lançamento da Conta do Banco do Cheque a Pagar
							.FOL_NewItemEntry(.VOC_EntryB06Ukey, f18.a36_code0, VLC_ContaDebito, "F07", f07T.ukey, VLN_ConvertValue, f18.f18_003_d, f18.f18_003_d, "C", "0003")
						ENDIF
					ENDIF
				ENDIF
			ENDSCAN


			*- A D I A N T A M E N T O
			SELECT F18_F16T2
			GO TOP
			SCAN WHILE !.VOL_Error
				*-Conta 1 do Tipo de Documento do Adiantamento
				VLC_ContaCredito = .FOC_Account("A21", F18_F16T2.a21_ukey, 1)
				IF !.VOL_Error
					*-Valor Convertido
					VLN_ConvertValue = .FON_Vm(F18_F16T2.f16_003_b, F18_F16T2.a36_code0, f18.a36_code0, f18.f18_003_d)
					IF !.VOL_Error
						.VOA_Answer[1] = ALLTRIM(f18.f18_001_c) &&f16t.titulo
						.VOA_Answer[2] = FOU_FieldPar(VLC_Par, VLC_Ukeyp, ALLTRIM(VLC_Par) + "_003_C")
						.VOA_Answer[3] = f18.usr_note

						*-Lançamento da Conta 1 do Tipo de Documento do Adiantamento
						.FOL_NewItemEntry(.VOC_EntryB06Ukey, f18.a36_code0, VLC_ContaCredito, "F16", F18_F16T2.ukey, VLN_ConvertValue, f18.f18_003_d, f18.f18_003_d, "C", "0003", "F16", F18_F16T2.ukey, "F16_003_B")
					ENDIF
				ENDIF
			ENDSCAN
		
			IF !.VOL_ERROR
			*- Corrige a diferença causada pela conversão monetária
			FOL_FixExchangeDifference(.VOC_Entryb06ukey,VLC_ContaDiferencaConversao)
		Endif
		ENDWITH
	ENDIF
ENDIF

