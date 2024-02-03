Class otw.util
{

ClassMethod DebugTEST(strMessage As %String = "") As %Status
{
	Set ^TESTunit($I(^TESTunit)) = $ZDateTime($NOW(),8,1,3)_" : "_$JOB_" : "_strMessage
	Quit $$$OK
}

ClassMethod ReadFile(pFile As %String, pDebug = 0) As %String
{
	Write:pDebug "ReadFile",!
	Do:pDebug ..DebugTEST("ReadFile")
	If ($Get(pFile) = "") Quit ""
	Write:pDebug pFile,!
	Set tReturn = ""
	Set timeout = 2
	Try {
		Open pFile:("R"):timeout  // read
		If $test {
			Write:pDebug "Open",!
			Do:pDebug ..DebugTEST("Open")
			Use pFile
			Do:pDebug ..DebugTEST("Use")
			Set pos = $ZPOS
			Do:pDebug ..DebugTEST(pos)
			Set pos = $ZSEEK(0,0)
			Do:pDebug ..DebugTEST(pos)
			Set tEOF = 0
			For {
				Set pos = $ZPOS
				Do:pDebug ..DebugTEST(pos)
				Try {
					Read tText
				} Catch {
					Set tEOF = 1
				}
				Do:pDebug ..DebugTEST($Get(tText))
				Set:pDebug ^DEBUG($I(DEBUG))=$GET(tText)
				If tEOF { Quit }
				Set tReturn = tReturn_$Get(tText)_$Char(10)
			}
			Close pFile
		}
	}
	Catch exception {
		Do:pDebug ..DebugTEST("Catch")
		If exception.%IsA("%Exception.SystemException") {
			Do BACK^%ETN // Log error in error log
		} Else {
			//Throw exception // We will just throw these to outer error handler
		}
		Close pFile
	}
	//Use 0
	//Write:pDebug tReturn,!
	//Set tReturn = $Translate($Get(tReturn),$Char(9)," ")
	Quit tReturn
}

}
