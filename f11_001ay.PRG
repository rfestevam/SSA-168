*/--------------------------------------------------------------------------------------------------/*
*/ Procedimento		: f11_001a	 	                            				            		/*
*/ Descrição   		: Gera lançamento contábil para a tela de Contas a Pagar - Tela F11_001			/*
*/ Retorno     		: VGO_Acc.VOL_Error = .T. Se a operação foi bem sucedida, =.F. c.c.   			/*
*/--------------------------------------------------------------------------------------------------/*
LOCAL VLC_ContaDebito, VLC_ContaCredito, VLC_NomeFornecedor, VLN_ConvertValue

VLN_ConvertValue = 0
VLN_Imposto = 0 
VLC_NomeFornecedor = ""

SET STEP ON  

with VGO_Acc

	*----------------------------------------------------------
	*- seleciona as contas de débito e crédito ref. as parcelas 
	*----------------------------------------------------------
	SELECT *,SPACE(20) AS CONTA_DEBITO, SPACE(20) AS CONTA_CREDITO FROM F14T WHERE F11_UKEY = F11.UKEY INTO CURSOR TMP_DADOS READWRITE
	SELECT TMP_DADOS
	GO TOP
	SCAN
		VLC_ContaDebito = .FOC_Account("A21", TMP_DADOS.a21_ukey, 1)
		IF !.VOL_Error
			Replace CONTA_DEBITO WITH VLC_ContaDebito IN TMP_DADOS
			VLC_ContaCredito = .FOC_Account("A08", f11.f11_ukeyp, 1)			
			IF EMPTY(NVL(VLC_ContaCredito,''))			
				.VOL_Error = .F.
				VLC_ContaCredito = .FOC_Account("A21", f14t.a21_ukey, 2)
				IF !.VOL_Error
					Replace CONTA_CREDITO WITH VLC_ContaCredito IN TMP_DADOS
				ENDIF
			*- IHL 5372 - INICIO
			ELSE
				Replace CONTA_CREDITO WITH VLC_ContaCredito IN TMP_DADOS
			*- IHL 5372 - FIM				
			ENDIF		
		ENDIF
	ENDSCAN

	IF !.VOL_Error

		*----------------------------------------------------------------------------------------------------------------------------------------
		*- Agrupo os valores a debito por conta contabil
		*----------------------------------------------------------------------------------------------------------------------------------------
		SELECT UKEY,SUM(F14_010_B) AS F14_010_B,A36_CODE0,CONTA_DEBITO,CONTA_CREDITO FROM TMP_DADOS GROUP BY CONTA_DEBITO INTO CURSOR TMP_DEBITOS

		IF .VOL_GeraCapaB06
			.FOC_NewEntry(f11.f11_001_c, "F11", f11.ukey, VGO_Gen.VOC_Currency + DTOS(f11.f11_002_d), f11.f11_002_d, f11.f11_002_d, "", .T.)
			VLC_NomeFornecedor = .FOC_ClientSupplier(f11.f11_par, f11.f11_ukeyp)
		ENDIF
		
		IF !.VOL_Error
			*--------------------------------
			*- Gera os lançamentos de débito
			*--------------------------------
			*-Prime-2519-Início - Alteração das partidas a débito para retornar a contabilizar por parcela, devido a necessidade de apropriação pelo crd da parcela em cada partida do lançamento contábil
*!*			SELECT TMP_DEBITOS
			SELECT F14T
			GO TOP
			SCAN
				*- PRIME - 2632 - INICIO
				IF !.VOL_Error AND F14T.F11_UKEY = F11.UKEY
				*- PRIME - 2632 - FIM
*!*						VLN_ConvertValue = .FON_Vm(TMP_DEBITOS.f14_010_b, TMP_DEBITOS.a36_code0,  VGO_Gen.VOC_Currency + DTOS(f11.f11_002_d), f11.f11_002_d)
					VLC_ContaDebito = .FOC_Account("A21", F14T.a21_ukey, 1)
					VLN_ConvertValue = .FON_Vm(F14T.f14_010_b, F14T.a36_code0,  VGO_Gen.VOC_Currency + DTOS(f11.f11_002_d), f11.f11_002_d)
					IF !.VOL_Error
						.VOA_Answer[1] = alltrim(f11.f11_001_c)
						.VOA_Answer[2] = VLC_NomeFornecedor
						.VOA_Answer[3] = f11.usr_note
						VLC_PAR = f11.f11_par 
						VLC_UKEYP = f11.f11_ukeyp 

*!*							.FOL_NewItemEntry(.VOC_EntryB06Ukey, VGO_Gen.VOC_Currency + DTOS(f11.f11_002_d), TMP_DEBITOS.CONTA_DEBITO, "F11", F11.ukey, VLN_ConvertValue, F11.F11_002_D, F11.F11_002_D, "D", "0003", "F14", f14t.ukey, "F14_010_B")
						.FOL_NewItemEntry(.VOC_EntryB06Ukey, VGO_Gen.VOC_Currency + DTOS(f11.f11_002_d), VLC_ContaDebito , "F11", F11.ukey, VLN_ConvertValue, F11.F11_002_D, F11.F11_002_D, "D", "0003", "F14", f14t.ukey, "F14_010_B")
					ENDIF			
				ENDIF
			ENDSCAN	
			*-Prime-2519-Fim					
			*----------------------------------------------------------------------------------------------------------------------------------------
			*- Agrupo os valores a debito por conta contabil
			*----------------------------------------------------------------------------------------------------------------------------------------
			SELECT UKEY,SUM(F14_010_B) AS F14_010_B,A36_CODE0,CONTA_CREDITO FROM TMP_DADOS GROUP BY CONTA_CREDITO INTO CURSOR TMP_CREDITOS

			*--------------------------------
			*- Gera os lançamentos de Crédito
			*--------------------------------
			SELECT TMP_CREDITOS
			GO TOP
			SCAN
				IF !.VOL_Error
				
					VLN_ConvertValue = .FON_Vm(TMP_CREDITOS.f14_010_b, TMP_CREDITOS.a36_code0,  VGO_Gen.VOC_Currency + DTOS(f11.f11_002_d), f11.f11_002_d)
					
					IF !.VOL_Error
						.VOA_Answer[1] = alltrim(f11.f11_001_c)
						.VOA_Answer[2] = VLC_NomeFornecedor
						.VOA_Answer[3] = f11.usr_note

						VLC_PAR = f11.f11_par 
						VLC_UKEYP = f11.f11_ukeyp

						.FOL_NewItemEntry(.VOC_EntryB06Ukey, VGO_Gen.VOC_Currency + DTOS(f11.f11_002_d), TMP_CREDITOS.CONTA_CREDITO, "F11", F11.ukey, VLN_ConvertValue, F11.F11_002_D, F11.F11_002_D, "C", "0003", "F14", f14t.ukey, "F14_010_B")
					ENDIF
					
				ENDIF				
			ENDSCAN			
		ENDIF
	ENDIF

	VGO_GEN.FOL_CLOSETABLE("TMP_DADOS")
	VGO_GEN.FOL_CLOSETABLE("TMP_DEBITOS")
	VGO_GEN.FOL_CLOSETABLE("TMP_CREDITOS")

	*!*	select F14T
	*!*	go top
	*!*	SCAN WHILE !.VOL_Error
	*!*		VLC_Controle = FLC_Account("A21", f14t.a21_ukey, 1)
	*!*		IF F14T.F11_UKEY = F11.UKEY
	*!*			IF !EMPTY(NVL(VLC_Controle,""))
	*!*				if .VOL_GeraCapaB06
	*!*					*- Gera capa do lançamento
	*!*					.FOC_NewEntry(f11.f11_001_c, "F11", f11.ukey, VGO_Gen.VOC_Currency + DTOS(f11.f11_002_d), f11.f11_002_d, f11.f11_002_d, "", .T.)
	*!*					VLC_NomeFornecedor = .FOC_ClientSupplier(f11.f11_par, f11.f11_ukeyp)
	*!*				endif

	*!*				if !.VOL_Error
	*!*					*- Conta 1 do Tipo de Documento
	*!*					VLC_ContaDebito = .FOC_Account("A21", f14t.a21_ukey, 1)
	*!*					if !.VOL_Error
	*!*						*- Valor Convertido
	*!*						VLN_ConvertValue = .FON_Vm(f14t.f14_010_b, f14t.a36_code0,  VGO_Gen.VOC_Currency + DTOS(f11.f11_002_d), f11.f11_002_d)
	*!*						if !.VOL_Error
	*!*							.VOA_Answer[1] = alltrim(f11.f11_001_c)
	*!*							.VOA_Answer[2] = VLC_NomeFornecedor
	*!*							.VOA_Answer[3] = f11.usr_note

	*!*							VLC_PAR = f11.f11_par 
	*!*							VLC_UKEYP = f11.f11_ukeyp

	*!*							*- Lançamento da conta 1 do tipo de documento - Débito.
	*!*							.FOL_NewItemEntry(.VOC_EntryB06Ukey, VGO_Gen.VOC_Currency + DTOS(f11.f11_002_d), VLC_ContaDebito, "F11", f11.ukey, VLN_ConvertValue, f11.f11_002_d, f11.f11_002_d, "D", "0003", "F14", f14t.ukey, "F14_010_B")
	*!*						endif
	*!*					endif
	*!*				endif
	*!*			ELSE
	*!*				.VOL_Error = .F.
	*!*				vlc_integra = .f.
	*!*			endif		
	*!*		ENDIF
	*!*	endscan
	*!*	if !.VOL_Error

	*!*		IF vlc_integra

	*!*			select F14T
	*!*			go top
	*!*				SCAN
	*!*					IF F14T.F11_UKEY = F11.UKEY	
	*!*							VLC_String = "SELECT B24.B11_UKEYA FROM STAR_DATA@B24 B24 (NOLOCK) WHERE B24.B24_PAR1 = ?VLC_PAR AND B24.B24_UKEYP1 = ?VLC_UKEYP"
	*!*							VGO_Custom.FOL_CSqlExec(VLC_String, "TMP_B24")
	*!*				            
	*!*					            VLC_conta_debito = ""

	*!*								go top in TMP_B24
	*!*								if ! eof("TMP_B24")
	*!*									*-Conta 1 do Fornecedor       
	*!*									VLC_contadebito = .FOC_Account("A08", f11.f11_ukeyp, 1)			
	*!*									ENDIF
	*!*								
	*!*								use in TMP_B24			
	*!*								
	*!*								IF EMPTY(NVL(VLC_conta_debito,''))			
	*!*							       .VOL_Error = .F.
	*!*								   *- Conta 2 do Tipo de Documento				   
	*!*									VLC_ContaDebito = .FOC_Account("A21", f14t.a21_ukey, 2)
	*!*								ENDIF					

	*!*								if !.VOL_Error
	*!*									&& **********************************************************************************				
	*!*									&& PRIME - 1643 - INICIO
	*!*									&& **********************************************************************************
	*!*									VLN_ConvertValue = .FON_Vm(f14t.f14_010_b, f14t.a36_code0,  VGO_Gen.VOC_Currency + DTOS(f11.f11_002_d), f11.f11_002_d)
	*!*									

	*!*									if !.VOL_Error
	*!*										.VOA_Answer[1] = alltrim(f11.f11_001_c)
	*!*										.VOA_Answer[2] = VLC_NomeFornecedor
	*!*										.VOA_Answer[3] = f11.usr_note
	*!*										.FOL_NewItemEntry(.VOC_EntryB06Ukey, VGO_Gen.VOC_Currency + DTOS(f11.f11_002_d), VLC_ContaDebito, "F11", f11.ukey, VLN_ConvertValue, f11.f11_002_d, f11.f11_002_d, "C", "0003")

	*!*									endif
	*!*								ENDIF
	*!*					 ENDIF
	*!*					 
	*!*				ENDSCAN
	*!*								&& **********************************************************************************				
	*!*								&& PRIME - 1643 - FIM
	*!*								&& **********************************************************************************
	*!*		endif
	*!*	ENDIF		

ENDWITH
