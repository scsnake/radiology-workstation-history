JQuery_Load( docObj, JQueryPath:="", JQueryUIPath:="" ) {
    window := docObj.parentWindow
    if ( JQueryPath && JQuery_IsLoaded( docObj ) = 0 ) {
        FileRead jq, % JQueryPath
        window.execScript( jq )
        if ( JQueryUIPath && JQuery_IsLoaded( docObj ) = 1 ) {
            FileRead jqUI, % JQueryUIPath
            window.execScript( jqUI )
    }}
    return JQuery_IsLoaded( docObj )
}
 
JQuery_IsLoaded( docObj ) {
    window := docObj.parentWindow
    try window.jQuery
    catch
        return 0
    try window.jQuery.ui
    catch
        return 1
    return 2
}
 
JQuery_Execute( docObj, selector, method, text* ) {
    window := docObj.parentWindow
    for i,t in text
        out .= t
    window.execScript( "$(" selector ")." method "(" out ");" )
}