#Include 'Totvs.ch'
#Include 'RestFul.ch'
#include "topconn.ch"

// Abertura da API
WSRestFul produtos Description 'API Crud Produtos' Format 'application/json, text/html'
    
    WSData Page     As Integer Optional 
    WSData PageSize As Integer Optional
    WSData product  As String 

    // Estrutura dos verbos
    WSMethod GET listaProdutos;
    Description 'Retornar uma lista com todos os Produtos'; // Descrição dos verbos
    WSSyntax 'api/v1/produtos';
    Path 'api/v1/produtos';
    Produces APPLICATION_JSON

    WSMethod POST crudProduto;
    Description 'Incluir um Produto'; // Descrição dos verbos
    WSSyntax 'api/v1/produtos';
    Path 'api/v1/produtos';
    Produces APPLICATION_JSON

    WSMethod PUT crudProduto;
    Description 'Alterar um Produto'; // Descrição dos verbos
    WSSyntax 'api/v1/produtos/{product}';
    Path 'api/v1/produtos/{product}';
    Produces APPLICATION_JSON

    WSMethod DELETE crudProduto;
    Description 'Deletar um Produto'; // Descrição dos verbos
    WSSyntax 'api/v1/produtos/{product}';
    Path 'api/v1/produtos/{product}';
    Produces APPLICATION_JSON

    WSMethod GET produto;
    Description 'Retornar um Produto'; // Descrição dos verbos
    WSSyntax 'api/v1/produtos/{product}';
    Path 'api/v1/produtos/{product}';
    Produces APPLICATION_JSON

    
End WSRestFul

//WSMethod Get listaProdutos QUERYPARAM Page, PageSize WSService produtos 
WSMethod GET listaProdutos WSService produtos 

Return listaProd(self)

WSMethod POST crudProduto WSService produtos 
                   //nOpc
Return crudProduto(3, self)

WSMethod PUT crudProduto PathParam product WSService produtos 
                  
Return crudProduto(4, self, self:product)

WSMethod DELETE crudProduto PathParam product WSService produtos 
                   
Return crudProduto(5, self, self:product)

WSMethod GET produto PathParam product WSService produtos 

Return getProduto(self, self:product)

Static Function listaProd(oWs)
    
    Local oProd as Object 

    Default oWs:Page := 1
    Default oWs:PageSize := 10
                        //TIPO DE VERBO / LISTA OU NAO
    oProd := adapterprd():New('GET', .T.)

    oProd:SetPage(oWs:Page)
    oProd:SetPageSize(oWs:PageSize)
    //oProd:SetUrlFilter(oWs:aQueryString) tenta trata qualquer paramentro que eu passar na url

    oProd:GetListProd()

    If oProd:lOk
        oWs:SetResponse(oProd:GetJsonResponse())
    Else
        SetRestFault(oProd:GetCode(), oProd:GetMessage())
    EndIf

    oProd:DeActivate()

Return .T.

Static Function getProduto(oWs, cProduto)

    Local oProd as Object 
                        //TIPO DE VERBO / LISTA OU NAO
    oProd := adapterprd():New('GET', .F.)

    oProd:GetProduct(cProduto)

    If oProd:lOk
        oWs:SetResponse(oProd:GetJsonResponse())
    Else
        SetRestFault(oProd:GetCode(), oProd:GetMessage())
    EndIf

    oProd:DeActivate()

Return .T.

Static Function crudProduto(nOpc, oWs, cProduto)

    Local cBody := oWs:GetContent()
    Local oJson := JsonObject():New()
    Local cQuery := ''
    Local lRet := ''
    Local cMsg := ''

    Private lMsErroAuto := .F.

    oJson:FromJson(cBody)

    If nOpc == 3

         aArray := {{ "B1_COD"    , oJson['CODE']           , NIL },;
                    { "B1_DESC"   , oJson['DESCRIPTION']    , NIL },;
                    { "B1_GRUPO"  , oJson['GROUP']          , NIL },;
                    { "B1_TIPO"   , oJson['TIPO']           , NIL },;
                    { "B1_UM"     , oJson['UM']             , NIL },;
                    { "B1_LOCPAD" , oJson['ARMAZEM']        , NIL }} 

        MsExecAuto( { |x,y| MATA010(x,y)}, aArray, 3)

        oJson:SetResponse('{')
		oJson:SetResponse('"Retorno" : '	+ IIF(lRet, "true", "false")	+ ',')
		oJson:SetResponse('"Mensagem" : "' 	+ EncodeUtf8(cMsg) 				+ '"')
		oJson:SetResponse('}')

    ElseIf nOpc == 4
        
        cQuery+= "SELECT R_E_C_N_O_ RECNO FROM "+RetSqlName("SB1")+" "
        cQuery+= "WHERE B1_COD = '" + cProduto + "' AND D_E_L_E_T_=' '"

        tcQuery cQuery new Alias TSE2

        SB1->(dbGoto(TSE2->RECNO))

        TSE2->(dbCloseArea())

        aArray := { { "B1_COD"    , SB1->B1_COD             , NIL },;
                    { "B1_DESC"   , oJson['DESCRIPTION']    , NIL },;
                    { "B1_GRUPO"  , oJson['GROUP']          , NIL },;
                    { "B1_TIPO"   , oJson['TIPO']           , NIL },;
                    { "B1_UM"     , oJson['UM']             , NIL },;
                    { "B1_LOCPAD" , oJson['ARMAZEM']        , NIL }} 

        MsExecAuto( { |x,y| MATA010(x,y)}, aArray, 4)



    ElseIf nOpc == 5

        cQuery+= "SELECT R_E_C_N_O_ RECNO FROM "+RetSqlName("SB1")+" "
        cQuery+= "WHERE B1_COD = '" + cProduto + "' AND D_E_L_E_T_=' '"

        tcQuery cQuery new Alias TSE2

        SB1->(dbGoto(TSE2->RECNO))

        TSE2->(dbCloseArea())

        aArray := { { "B1_COD"    , SB1->B1_COD  , NIL }} 

        MsExecAuto( { |x,y| MATA010(x,y)}, aArray, 5)


    EndIf


Return .T.
