#Include 'Totvs.ch'
#Include 'RestFul.ch'

Class adapterprd From FWAdapterBaseV2

    Method New()
    Method GetListProd()
    Method GetProduct()

EndClass

Method New(cVerbo, lList) Class adapterprd

    _Super:New(cVerbo, lList)

Return

Method GetListProd() Class adapterprd

    Local cWhere := "SB1.D_E_L_E_T_ = ' '"

    AddMapFields(self)

    //:: - Entende que é o self
    //self:SetQuery(GetQuery())

    ::SetQuery(GetQuery())

    ::SetWhere(cWhere)

    ::SetOrder('B1_COD')

    If ::Execute()
        ::FillGetResponse()
    EndIf

Return

Method GetProduct(cId) Class adapterprd

    Local cWhere := "SB1.B1_COD = '"+ cId+ "' AND SB1.D_E_L_E_T_ = ' '"

    AddMapFields(self)

    ::SetQuery(GetQuery())

    ::SetWhere(cWhere)

    ::SetOrder('B1_COD')

    If ::Execute()
        ::FillGetResponse()
    EndIf

Return 

Static Function AddMapFields(oSelf)

    Local oTamField := TamSx3('B1_FILIAL')[1] + TamSx3('B1_COD')[1]

    oSelf:AddMapFields( 'INTERNALID'            , 'INTERNALID' , .T., .T., {'INTERNALID', 'C', oTamField, 0}, 'B1_FILIAL + B1_COD')
    oSelf:AddMapFields( 'CODE'                  , 'B1_COD'     , .T., .T., {'B1_COD', 'C', TamSx3('B1_COD')[1], 0} )
    oSelf:AddMapFields( 'DESCRIPTION'           , 'B1_DESC'    , .T., .F., {'B1_DESC', 'C', TamSx3('B1_DESC')[1], 0} )
    oSelf:AddMapFields( 'GROUP'                 , 'B1_GRUPO'   , .T., .F., {'B1_GRUPO', 'C', TamSx3('B1_GRUPO')[1], 0} )
    oSelf:AddMapFields( 'GROUPDESCRIPTION'      , 'BM_DESC'    , .T., .F., {'BM_DESC', 'C', TamSx3('BM_DESC')[1], 0} )

Return

Static Function GetQuery()
    Local cQuery := ''

    cQuery += " SELECT #QueryFields# "
    cQuery += " FROM "+RetSqlName("SB1")+" SB1 " 
    cQuery += " LEFT JOIN "+RetSqlName("SBM")+" SBM " 
    cQuery += " ON B1_GRUPO = BM_GRUPO "
    cQuery += " AND BM_FILIAL = '" + FWxFilial('SBM') + "'"
    cQuery += " AND SBM.D_E_L_E_T_ = ' ' "
    cQuery += " WHERE #QueryWhere# "

Return cQuery
