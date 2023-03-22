Class otw.dynq
{

ClassMethod prepareQ() As %Status
{
    Set result=##class(%ResultSet).%New("%DynamicQuery:SQL")
    Set sc=result.Prepare("SELECT %ID, Name, Salary FROM Sample.Employee WHERE Salary > ?")
    If $$$ISERR(sc) {
        // here I want to capture the error details in trace , log , that I can see in production web page
        Try {
            Set x = $System.Status.GetOneStatusText(sc)
            Do ##class(%SYS.System).WriteToConsoleLog("otw.dynq prepareQ: "_x)
        } Catch exception {
            Do BACK^%ETN // Log error in error log
        }
    }
    Quit sc
}

}
