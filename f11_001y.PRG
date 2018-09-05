*/--------------------------------------------------------------------------------------------------/*
*/ Procedimento		: f11_001	 	                            				            		/*
*/ Descrição   		: Gera lançamento contábil para a tela de Contas a Pagar - Tela F11_001			/*
*/ Retorno     		: VGO_Acc.VOL_Error = .T. Se a operação foi bem sucedida, =.F. c.c.   			/*
*/--------------------------------------------------------------------------------------------------/*
Local VLC_ContaDebito, VLC_ContaCredito, VLC_NomeFornecedor, VLN_ConvertValue, VLC_UkeyINSS

VLN_ConvertValue = 0
VLN_Imposto = 0
VLC_NomeFornecedor = ""

SET STEP ON 

With VGO_Acc
	Select F14T
	Go Top
	If !.VOL_Error
		VLC_Controle = FLC_Account("A21", F14T.a21_ukey, 1)
		If !Empty(Nvl(VLC_Controle,""))
			If .VOL_GeraCapaB06
				*- Gera capa do lançamento
				.FOC_NewEntry(f11.f11_001_c, "F11", f11.ukey, f11.a36_code0, f11.f11_002_d, f11.f11_002_d, "", .T.)
				VLC_NomeFornecedor = .FOC_ClientSupplier(f11.f11_par, f11.f11_ukeyp)
			Endif
			VGO_Custom.FOL_CSqlExec("SELECT F48.*, A40.A40_002_C FROM STAR_DATA@F48(NOLOCK) INNER JOIN STAR_DATA@F11(NOLOCK) ON F11.UKEY = F48.F11_UKEY INNER"+" JOIN STAR_DATA@A40(NOLOCK) ON A40.UKEY = F48.A40_UKEY WHERE F11.UKEY = ?f14t.f11_ukey","F48TT")
			Select F48TT
			Go Top

			Scan
				VLN_Imposto = VLN_Imposto + F48TT.f48_004_b
			Endscan

			If !.VOL_Error
				*- Conta 1 do Tipo de Documento
				VLC_ContaDebito = .FOC_Account("A21", F14T.a21_ukey, 1)
				If !.VOL_Error
					*- Valor Convertido
					VLN_Total = f11.f11_012_b + VLN_Imposto
					VLN_TotalComImposto = f11.f11_012_b + VLN_Imposto
					VLN_ConvertValue = .FON_Vm(VLN_Total, F14T.a36_code0, f11.a36_code0, f11.f11_002_d)
					If !.VOL_Error
						.VOA_Answer[1] = Alltrim(f11.f11_001_c)
						.VOA_Answer[2] = VLC_NomeFornecedor
						.VOA_Answer[3] = f11.usr_note

						VLC_PAR = f11.f11_par
						VLC_UKEYP = f11.f11_ukeyp

						*- Lançamento da conta 1 do tipo de documento - Débito.
						.FOL_NewItemEntry(.VOC_EntryB06Ukey, f11.a36_code0, VLC_ContaDebito, "F11", f11.ukey, VLN_ConvertValue, f11.f11_002_d, f11.f11_002_d, "D", "0003", "F14", F14T.ukey, "F14_010_B",.F.)
						If !.VOL_Error

							*!*								VLC_String = "SELECT B24.B11_UKEYA FROM STAR_DATA@B24 B24 (NOLOCK) WHERE B24.B24_PAR1 = ?VLC_PAR AND B24.B24_UKEYP1 = ?VLC_UKEYP"
							*!*								VGO_Custom.FOL_CSqlExec(VLC_String, "TMP_B24")

							*!*								GO TOP IN TMP_B24
							*!*								IF !EOF("TMP_B24")
							*!*									*-Conta 1 do Fornecedor
							*!*									VLC_ContaDebito = .FOC_Account("A08", f11.f11_ukeyp, 1)
							*!*								ELSE
							*!*									*- Conta 2 do Tipo de Documento
							*!*									VLC_ContaDebito = .FOC_Account("A21", F14T.a21_ukey, 2)
							*!*								ENDIF
							*!*								USE IN TMP_B24

							*-Conta 1 do Fornecedor
							VLC_ContaDebito = .FOC_Account("A08", f11.f11_ukeyp, 1)

							If .VOL_Error
								.VOL_Error = .F.
								*- Conta 2 do Tipo de Documento
								VLC_ContaDebito = .FOC_Account("A21", F14T.a21_ukey, 2)
							Endif


							If !.VOL_Error
								VLN_ConvertValue = .FON_Vm(f11.f11_012_b, F14T.a36_code0, f11.a36_code0, f11.f11_002_d) &&- VLN_Imposto
								If !.VOL_Error
									.VOA_Answer[1] = Alltrim(f11.f11_001_c)
									.VOA_Answer[2] = VLC_NomeFornecedor
									.VOA_Answer[3] = f11.usr_note
									.FOL_NewItemEntry(.VOC_EntryB06Ukey, f11.a36_code0, VLC_ContaDebito, "F11", f11.ukey, VLN_ConvertValue, f11.f11_002_d, f11.f11_002_d, "C", "0003","F14", F14T.ukey, "F14_010_B",.F.)
									If !.VOL_Error

										Select F48TT
										Go Top
										If !Eof()
											*- I M P O S T O S
											VLN_TotalIRRF = 0
											VLN_TotalISS_TERC = 0
											VLN_TotalISS = 0
											VLN_TotalINSS = 0
											VLN_TotalPIS = 0
											VLN_TotalCOFINS = 0
											VLN_TotalPISRET = 0
											VLN_TotalCOFINSRET = 0
											VLN_TotalCSLL = 0
											VLN_TotalPISCOFCSLL = 0
											VLN_TotalINNS = 0

											VLC_UkeyIRRF = FOU_FieldPar("A40", "IRRF", "UKEY", "A40_001_C")
											VLC_UkeyISS_TERC  = FOU_FieldPar("A40", "ISS-TERC", "UKEY", "A40_001_C")
											VLC_UkeyISS  = FOU_FieldPar("A40", "ISS", "UKEY", "A40_001_C")
											VLC_UkeyINSS = FOU_FieldPar("A40", "INNS", "UKEY", "A40_001_C")
											VLC_UkeyPIS = FOU_FieldPar("A40", "PIS", "UKEY", "A40_001_C")
											VLC_UkeyCOFINS = FOU_FieldPar("A40", "COFINS", "UKEY", "A40_001_C")
											VLC_UkeyCSLL = FOU_FieldPar("A40", "CSLL", "UKEY", "A40_001_C")
											VLC_UkeyPISRET = FOU_FieldPar("A40", "PIS-RET", "UKEY", "A40_001_C")
											VLC_UkeyCOFINSRET = FOU_FieldPar("A40", "COFINS-RET", "UKEY", "A40_001_C")
											*VLC_UkeyPISCOFCSLL = FOU_FieldPar("A40", "PIS/COF/CS", "UKEY", "A40_001_C")
											VLC_UkeyPISCOFCSLL = FOU_FieldPar("A40", "PCC", "UKEY", "A40_001_C")

											Select F48TT
											Go Top

											Scan

												If Alltrim(F48TT.a40_ukey) = "STAR_STAR__12C0L1C3N"

													VLC_UkeyINSS = "STAR_STAR__12C0L1C3N"

												Endif

											Endscan

											Select F48TT
											Go Top

											Do While !Eof() And !.VOL_Error

												*- Acumula o total do IRRF
												If Alltrim(F48TT.a40_ukey) = Alltrim(VLC_UkeyIRRF)
													VLN_TotalIRRF = VLN_TotalIRRF + .FON_Vm(F48TT.f48_004_b,  f11.a36_code0, VGO_Gen.VOC_Currency, f11.f11_002_d) - VLN_TotalIRRF  &&- VLN_Imposto
												Else

													*- Acumula o total do PIS/COFINS/CSLL
													If Alltrim(F48TT.a40_ukey) = Alltrim(VLC_UkeyPISCOFCSLL)
														VLN_TotalPISCOFCSLL = VLN_TotalPISCOFCSLL + .FON_Vm(F48TT.f48_004_b,  f11.a36_code0, VGO_Gen.VOC_Currency, f11.f11_002_d)
														*
													Else

														*- Acumula o total do ISS_TERC
														If Alltrim(F48TT.a40_ukey) = Alltrim(VLC_UkeyISS_TERC)
															VLN_TotalISS_TERC = VLN_TotalISS_TERC + .FON_Vm(F48TT.f48_004_b,  f11.a36_code0, VGO_Gen.VOC_Currency, f11.f11_002_d) &&- VLN_TotalISS

														Else

															*- Acumula o total do ISS
															If Alltrim(F48TT.a40_ukey) = Alltrim(VLC_UkeyISS)
																VLN_TotalISS = VLN_TotalISS + .FON_Vm(F48TT.f48_004_b,  f11.a36_code0, VGO_Gen.VOC_Currency, f11.f11_002_d) &&- VLN_TotalISS

															Else
																*- Acumula o total do pis
																If Alltrim(F48TT.a40_ukey) = Alltrim(VLC_UkeyPIS)
																	VLN_TotalPIS = VLN_TotalPIS + .FON_Vm(F48TT.f48_004_b,  f11.a36_code0, VGO_Gen.VOC_Currency, f11.f11_002_d)
																	*															VLN_TotalPIS = VLN_TotalPIS + .FON_Vm(F48TT.f48_004_b,  f11.a36_code0, VGO_Gen.VOC_Currency, f11.f11_002_d)
																Else

																	*- Acumula o total do cofins
																	If Alltrim(F48TT.a40_ukey) = Alltrim(VLC_UkeyCOFINS)
																		VLN_TotalCOFINS = VLN_TotalCOFINS + .FON_Vm(F48TT.f48_004_b,  f11.a36_code0, VGO_Gen.VOC_Currency, f11.f11_002_d)
																		*																VLN_TotalCOFINS = VLN_TotalCOFINS + .FON_Vm(F48TT.f48_004_b,  f11.a36_code0, VGO_Gen.VOC_Currency, f11.f11_002_d)
																	Else
																		*- Acumula o total do pisret
																		If Alltrim(F48TT.a40_ukey) = Alltrim(VLC_UkeyPISRET)
																			VLN_TotalPISRET = VLN_TotalPISRET + .FON_Vm(F48TT.f48_004_b,  f11.a36_code0, VGO_Gen.VOC_Currency, f11.f11_002_d)
																			*																	VLN_TotalPISRET = VLN_TotalPISRET + .FON_Vm(F48TT.f48_004_b,  f11.a36_code0, VGO_Gen.VOC_Currency, f11.f11_002_d)
																		Else

																			*- Acumula o total do cofinsret
																			If Alltrim(F48TT.a40_ukey) = Alltrim(VLC_UkeyCOFINSRET)
																				VLN_TotalCOFINSRET = VLN_TotalCOFINSRET + .FON_Vm(F48TT.f48_004_b,  f11.a36_code0, VGO_Gen.VOC_Currency, f11.f11_002_d)
																				*																VLN_TotalCOFINSRET = VLN_TotalCOFINSRET + .FON_Vm(F48TT.f48_004_b,  f11.a36_code0, VGO_Gen.VOC_Currency, f11.f11_002_d)
																			Else

																				*- Acumula o total do csll
																				If Alltrim(F48TT.a40_ukey) = Alltrim(VLC_UkeyCSLL)
																					VLN_TotalCSLL = VLN_TotalCSLL + .FON_Vm(F48TT.f48_004_b,  f11.a36_code0, VGO_Gen.VOC_Currency, f11.f11_002_d)
																					*																	VLN_TotalCSLL = VLN_TotalCSLL + .FON_Vm(F48TT.f48_004_b,  f11.a36_code0, VGO_Gen.VOC_Currency, f11.f11_002_d)
																				Else
																					*- Acumula o total do INSS
																					If Alltrim(F48TT.a40_ukey) = Alltrim(VLC_UkeyINSS)
																						VLN_TotalINNS = VLN_TotalINNS + .FON_Vm(F48TT.f48_004_b,  f11.a36_code0, VGO_Gen.VOC_Currency, f11.f11_002_d)
																						*																VLN_TotalINNS = VLN_TotalINSS + .FON_Vm(F48TT.f48_004_b,  f11.a36_code0, VGO_Gen.VOC_Currency, f11.f11_002_d)
																					Endif
																				Endif
																			Endif
																		Endif
																	Endif
																Endif
															Endif
														Endif
													Endif
												Endif

												Select F48TT
												Skip

											Enddo
											Go Top

											If !.VOL_Error And !Empty(VLC_UkeyIRRF)
												*- Conta 2 imposto.
												VLC_ContaCredito = .FOC_Account("A40", VLC_UkeyIRRF, 2)
												If !.VOL_Error
													*-Valor Convertido
													VLN_ConvertValue = VLN_TotalIRRF
													*-Lançamento da Conta do imposto
													.VOA_Answer[1] = Alltrim(f11.f11_001_c)
													.VOA_Answer[2] = VLC_NomeFornecedor
													.VOA_Answer[3] = f11.usr_note
													.FOL_NewItemEntry(.VOC_EntryB06Ukey, f11.a36_code0, VLC_ContaCredito, "F11", f11.ukey, VLN_ConvertValue, f11.f11_002_d, f11.f11_002_d, "C", "0003","F14", F14T.ukey, "F14_010_B",.F.)
												Endif
											Endif


											If !.VOL_Error And !Empty(VLC_UkeyISS_TERC)
												*- Conta 1 imposto.
												VLC_ContaCredito = .FOC_Account("A40", VLC_UkeyISS_TERC, 1)
												If !.VOL_Error
													*-Valor Convertido
													VLN_ConvertValue = VLN_TotalISS_TERC
													*-Lançamento da Conta do imposto
													.VOA_Answer[1] = Alltrim(f11.f11_001_c)
													.VOA_Answer[2] = VLC_NomeFornecedor
													.VOA_Answer[3] = f11.usr_note
													.FOL_NewItemEntry(.VOC_EntryB06Ukey, f11.a36_code0, VLC_ContaCredito, "F11", f11.ukey, VLN_ConvertValue, f11.f11_002_d, f11.f11_002_d, "C", "0003","F14", F14T.ukey, "F14_010_B",.F.)
												Endif
											Endif


											If !.VOL_Error And !Empty(VLC_UkeyISS)
												*- Conta 4 imposto.
												VLC_ContaCredito = .FOC_Account("A40", VLC_UkeyISS, 4)
												If !.VOL_Error
													*-Valor Convertido
													VLN_ConvertValue = VLN_TotalISS
													*-Lançamento da Conta do imposto
													.VOA_Answer[1] = Alltrim(f11.f11_001_c)
													.VOA_Answer[2] = VLC_NomeFornecedor
													.VOA_Answer[3] = f11.usr_note
													.FOL_NewItemEntry(.VOC_EntryB06Ukey, f11.a36_code0, VLC_ContaCredito, "F11", f11.ukey, VLN_ConvertValue, f11.f11_002_d, f11.f11_002_d, "C", "0003","F14", F14T.ukey, "F14_010_B",.F.)
												Endif
											Endif



											If !.VOL_Error And !Empty(VLC_UkeyINSS)
												*- Conta 1 relacionada ao imposto
												VLC_ContaCredito = .FOC_Account("A40", VLC_UkeyINSS, 1)
												If !.VOL_Error
													*-Valor Convertido
													VLN_ConvertValue =  VLN_TotalINNS
													*-Lançamento da Conta do Imposto
													.VOA_Answer[1] = Alltrim(f11.f11_001_c)
													.VOA_Answer[2] = VLC_NomeFornecedor
													.VOA_Answer[3] = f11.usr_note
													.FOL_NewItemEntry(.VOC_EntryB06Ukey, f11.a36_code0, VLC_ContaCredito, "F11", f11.ukey, VLN_ConvertValue, f11.f11_002_d, f11.f11_002_d, "C", "0003","F14", F14T.ukey, "F14_010_B",.F.)
												Endif
											Endif


											If !.VOL_Error And !Empty(VLC_UkeyPIS)
												*- Conta 1 relacionada ao imposto
												VLC_ContaCredito = .FOC_Account("A40", VLC_UkeyPIS, 1)
												If !.VOL_Error
													*-Valor Convertido
													VLN_ConvertValue = VLN_TotalPIS
													.VOA_Answer[1] = Alltrim(f11.f11_001_c)
													.VOA_Answer[2] = VLC_NomeFornecedor
													.VOA_Answer[3] = f11.usr_note
													*-Lançamento da Conta do Imposto
													.FOL_NewItemEntry(.VOC_EntryB06Ukey, f11.a36_code0, VLC_ContaCredito, "F11", f11.ukey, VLN_ConvertValue, f11.f11_002_d, f11.f11_002_d, "C", "0003","F14", F14T.ukey, "F14_010_B",.F.)
												Endif

											Endif

											If !.VOL_Error And !Empty(VLC_UkeyCOFINS)
												*- Conta 1 relacionada ao imposto
												VLC_ContaCredito = .FOC_Account("A40", VLC_UkeyCOFINS, 1)
												If !.VOL_Error
													*-Valor Convertido
													VLN_ConvertValue = VLN_TotalCOFINS
													.VOA_Answer[1] = Alltrim(f11.f11_001_c)
													.VOA_Answer[2] = VLC_NomeFornecedor
													.VOA_Answer[3] = f11.usr_note
													*-Lançamento da Conta do Imposto
													.FOL_NewItemEntry(.VOC_EntryB06Ukey, f11.a36_code0, VLC_ContaCredito, "F11", f11.ukey, VLN_ConvertValue, f11.f11_002_d, f11.f11_002_d, "C", "0003","F14", F14T.ukey, "F14_010_B",.F.)
												Endif

											Endif

											If !.VOL_Error And !Empty(VLC_UkeyPISRET)
												*- Conta 2 relacionada ao imposto
												VLC_ContaCredito = .FOC_Account("A40", VLC_UkeyPISRET, 2)
												If !.VOL_Error
													*-Valor Convertido
													VLN_ConvertValue = VLN_TotalPISRET
													.VOA_Answer[1] = Alltrim(f11.f11_001_c)
													.VOA_Answer[2] = VLC_NomeFornecedor
													.VOA_Answer[3] = f11.usr_note
													*-Lançamento da Conta do Imposto
													.FOL_NewItemEntry(.VOC_EntryB06Ukey, f11.a36_code0, VLC_ContaCredito, "F11", f11.ukey, VLN_ConvertValue, f11.f11_002_d, f11.f11_002_d, "C", "0003","F14", F14T.ukey, "F14_010_B",.F.)
												Endif

											Endif

											If !.VOL_Error And !Empty(VLC_UkeyCOFINSRET)
												*- Conta 2 relacionada ao imposto
												VLC_ContaCredito = .FOC_Account("A40", VLC_UkeyCOFINSRET, 2)
												If !.VOL_Error
													*-Valor Convertido
													VLN_ConvertValue = VLN_TotalCOFINSRET
													.VOA_Answer[1] = Alltrim(f11.f11_001_c)
													.VOA_Answer[2] = VLC_NomeFornecedor
													.VOA_Answer[3] = f11.usr_note
													*-Lançamento da Conta do Imposto
													.FOL_NewItemEntry(.VOC_EntryB06Ukey, f11.a36_code0, VLC_ContaCredito, "F11", f11.ukey, VLN_ConvertValue, f11.f11_002_d, f11.f11_002_d, "C","0003","F14", F14T.ukey, "F14_010_B",.F.)
												Endif

											Endif

											If !.VOL_Error And !Empty(VLC_UkeyCSLL)
												*- Conta 2 relacionada ao imposto
												VLC_ContaCredito = .FOC_Account("A40", VLC_UkeyCSLL, 2)
												If !.VOL_Error
													*-Valor Convertido
													VLN_ConvertValue = VLN_TotalCSLL
													.VOA_Answer[1] = Alltrim(f11.f11_001_c)
													.VOA_Answer[2] = VLC_NomeFornecedor
													.VOA_Answer[3] = f11.usr_note
													*-Lançamento da Conta do Imposto
													.FOL_NewItemEntry(.VOC_EntryB06Ukey, f11.a36_code0, VLC_ContaCredito, "F11", f11.ukey, VLN_ConvertValue, f11.f11_002_d, f11.f11_002_d, "C", "0003","F14", F14T.ukey, "F14_010_B",.F.)
												Endif

											Endif

											If !.VOL_Error And !Empty(VLC_UkeyPISCOFCSLL)
												*- Conta 2 relacionada ao imposto
												VLC_ContaCredito = .FOC_Account("A40", VLC_UkeyPISCOFCSLL, 1)
												If !.VOL_Error
													*-Valor Convertido
													VLN_ConvertValue = VLN_TotalPISCOFCSLL
													.VOA_Answer[1] = Alltrim(f11.f11_001_c)
													.VOA_Answer[2] = VLC_NomeFornecedor
													.VOA_Answer[3] = f11.usr_note
													*-Lançamento da Conta do Imposto
													.FOL_NewItemEntry(.VOC_EntryB06Ukey, f11.a36_code0, VLC_ContaCredito, "F11", f11.ukey, VLN_ConvertValue, f11.f11_002_d, f11.f11_002_d, "C", "0003","F14", F14T.ukey, "F14_010_B",.F.)
												Endif

											ENDIF
											
											*************************************************************************************************************************************************
											** Alteração de contas conf. scrum-10466
											*************************************************************************************************************************************************
											
											*** Lancamento do pis 
											VLN_Total = ROUND((VLN_TotalComImposto * 0.0165),2)											
											
											If !.VOL_Error
												*- Conta 3 do Tipo de Documento
												VLC_ContaDebito = .FOC_Account("A40", VLC_UkeyPIS, 2)
											Endif
											
											If !.VOL_Error 

													*-Valor Convertido
													.VOA_Answer[1] = Alltrim(f11.f11_001_c)
													.VOA_Answer[2] = VLC_NomeFornecedor
													.VOA_Answer[3] = f11.usr_note
													*-Lançamento da Conta do Imposto
													.FOL_NewItemEntry(.VOC_EntryB06Ukey, f11.a36_code0, VLC_ContaDebito, "F11", f11.ukey, VLN_Total, f11.f11_002_d, f11.f11_002_d, "D", "0003","F14", F14T.ukey, "F14_010_B",.F.)

											ENDIF
											
											****
											
											If !.VOL_Error
												*- Conta 1 do Tipo de Documento
												*VLC_ContaCredito = .FOC_Account("A40", VLC_UkeyPIS, 8)
												VLC_ContaCredito = .FOC_Account("A21", F14T.a21_ukey, 3)
											Endif
											
											If !.VOL_Error 

													*-Valor Convertido
													.VOA_Answer[1] = Alltrim(f11.f11_001_c)
													.VOA_Answer[2] = VLC_NomeFornecedor
													.VOA_Answer[3] = f11.usr_note
													*-Lançamento da Conta do Imposto
													.FOL_NewItemEntry(.VOC_EntryB06Ukey, f11.a36_code0, VLC_ContaCredito, "F11", f11.ukey, VLN_Total, f11.f11_002_d, f11.f11_002_d, "C", "0003","F14", F14T.ukey, "F14_010_B",.F.)

											ENDIF

											*** Lancamento do cofins
											VLN_Total = ROUND((VLN_TotalComImposto * 0.0760),2)											
											
											If !.VOL_Error
												*- Conta 3 do Tipo de Documento
												VLC_ContaDebito = .FOC_Account("A40", VLC_UkeyCOFINS, 2)
											Endif
											
											If !.VOL_Error 

													*-Valor Convertido
													.VOA_Answer[1] = Alltrim(f11.f11_001_c)
													.VOA_Answer[2] = VLC_NomeFornecedor
													.VOA_Answer[3] = f11.usr_note
													*-Lançamento da Conta do Imposto
													.FOL_NewItemEntry(.VOC_EntryB06Ukey, f11.a36_code0, VLC_ContaDebito, "F11", f11.ukey, VLN_Total, f11.f11_002_d, f11.f11_002_d, "D", "0003","F14", F14T.ukey, "F14_010_B",.F.)

											ENDIF
											
											If .VOL_Error
												.VOL_Error = .F.
												*- Conta 1 do Tipo de Documento
												VLC_ContaCredito = .FOC_Account("A40", VLC_UkeyCOFINS, 8)
											Endif
											
											If !.VOL_Error 

													*-Valor Convertido
													.VOA_Answer[1] = Alltrim(f11.f11_001_c) 
													.VOA_Answer[2] = VLC_NomeFornecedor
													.VOA_Answer[3] = f11.usr_note
													*-Lançamento da Conta do Imposto
													.FOL_NewItemEntry(.VOC_EntryB06Ukey, f11.a36_code0, VLC_ContaCredito, "F11", f11.ukey, VLN_Total, f11.f11_002_d, f11.f11_002_d, "C", "0003","F14", F14T.ukey, "F14_010_B",.F.)

											ENDIF											
																						
											
											
*****************************************************************************************************************************************************************************************************************											
*** removido conforme solicitacao da usuaria louise - sera reavaliado a integracao pois a conta  de credito do pis e cofins é do grupo com rateio obrigatorio											
*****************************************************************************************************************************************************************************************************************											
*!*												*** Lancamento do pis 
*!*												VLN_Total = ROUND((f11.f11_012_b * 0.0165),2)											
*!*												
*!*												If .VOL_Error
*!*													.VOL_Error = .F.
*!*													*- Conta 3 do Tipo de Documento
*!*													VLC_ContaDebito = .FOC_Account("A21", F14T.a21_ukey, 4)
*!*												Endif
*!*												
*!*												If !.VOL_Error 
*!*													If !.VOL_Error
*!*														*-Valor Convertido
*!*														.VOA_Answer[1] = Alltrim(f11.f11_001_c)
*!*														.VOA_Answer[2] = VLC_NomeFornecedor
*!*														.VOA_Answer[3] = f11.usr_note
*!*														*-Lançamento da Conta do Imposto
*!*														.FOL_NewItemEntry(.VOC_EntryB06Ukey, f11.a36_code0, VLC_ContaDebito, "F11", f11.ukey, VLN_Total, f11.f11_002_d, f11.f11_002_d, "D", "0003")
*!*													Endif
*!*												ENDIF
*!*												
*!*												If .VOL_Error
*!*													.VOL_Error = .F.
*!*													*- Conta 1 do Tipo de Documento
*!*													VLC_ContaCredito = .FOC_Account("A21", F14T.a21_ukey, 3)
*!*												Endif
*!*												
*!*												If !.VOL_Error 
*!*													If !.VOL_Error
*!*														*-Valor Convertido
*!*														.VOA_Answer[1] = Alltrim(f11.f11_001_c)
*!*														.VOA_Answer[2] = VLC_NomeFornecedor
*!*														.VOA_Answer[3] = f11.usr_note
*!*														*-Lançamento da Conta do Imposto
*!*														.FOL_NewItemEntry(.VOC_EntryB06Ukey, f11.a36_code0, VLC_ContaCredito, "F11", f11.ukey, VLN_Total, f11.f11_002_d, f11.f11_002_d, "C", "0003")
*!*													Endif
*!*												ENDIF

*!*												*** Lancamento do cofins
*!*												VLN_Total = ROUND((f11.f11_012_b * 0.0760),2)											
*!*												
*!*												If .VOL_Error
*!*													.VOL_Error = .F.
*!*													*- Conta 3 do Tipo de Documento
*!*													VLC_ContaDebito = .FOC_Account("A21", F14T.a21_ukey, 5)
*!*												Endif
*!*												
*!*												If !.VOL_Error 
*!*													If !.VOL_Error
*!*														*-Valor Convertido
*!*														.VOA_Answer[1] = Alltrim(f11.f11_001_c)
*!*														.VOA_Answer[2] = VLC_NomeFornecedor
*!*														.VOA_Answer[3] = f11.usr_note
*!*														*-Lançamento da Conta do Imposto
*!*														.FOL_NewItemEntry(.VOC_EntryB06Ukey, f11.a36_code0, VLC_ContaDebito, "F11", f11.ukey, VLN_Total, f11.f11_002_d, f11.f11_002_d, "D", "0003")
*!*													Endif
*!*												ENDIF
*!*												
*!*												If .VOL_Error
*!*													.VOL_Error = .F.
*!*													*- Conta 1 do Tipo de Documento
*!*													VLC_ContaCredito = .FOC_Account("A21", F14T.a21_ukey, 3)
*!*												Endif
*!*												
*!*												If !.VOL_Error 
*!*													If !.VOL_Error
*!*														*-Valor Convertido
*!*														.VOA_Answer[1] = Alltrim(f11.f11_001_c) 
*!*														.VOA_Answer[2] = VLC_NomeFornecedor
*!*														.VOA_Answer[3] = f11.usr_note
*!*														*-Lançamento da Conta do Imposto
*!*														.FOL_NewItemEntry(.VOC_EntryB06Ukey, f11.a36_code0, VLC_ContaCredito, "F11", f11.ukey, VLN_Total, f11.f11_002_d, f11.f11_002_d, "C", "0003")
*!*													Endif
*!*												ENDIF
*****************************************************************************************************************************************************************************************************************


										Endif
									Endif
								Endif
							Endif
						Endif
					Endif
				Endif
			Endif
		Else
			.VOL_Error = .F.
		Endif
	Endif
Endwith

