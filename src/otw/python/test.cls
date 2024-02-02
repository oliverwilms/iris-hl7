/// https://github.com/intersystems-community/iris-embedded-python-template/blob/master/src/dc/python/test.cls
Class dc.python.test
{

ClassMethod jsonschema() As %Status
{
    Set tSC = $$$OK
    Set path=##class(%File).NormalizeDirectory("dev", ##class(%File).GetDirectory($zu(86)))_"hl7jsonschema.yml"
    Zw path
    //Set json = '{"message_type":"MFN","message_event_type":"Z01","message_activity_type":"Item Record Update","hl7_version":"2.3","site_id":"688","segment":[{"name":"MSH","sequence":{"1":"MSH","2":"~^\\&","3":"PRCP_SS_VISTA","5":"PRCP_SSTATION","7":"20240125141848-0500","9":"MFN~Z01","10":"442464384179","11":"T","12":"2.3","15":"AL","16":"NE","17":"USA"}},{"name":"MFI","sequence":{"1":"445","3":"UPD","4":"20240125141848","6":"NE"}},{"name":"MFE","sequence":{"1":"MUP","4":"278~STRAW,DRINKING,PLSTC,L 7 3/4IN,FLEX,WRAPPED,SUPER JUMBO,WHT"}},{"name":"ZIM","sequence":{"1":"278~STRAW-DRINK-1I12","2":"~442-TEST092","3":"10","4":"5","5":"2","6":"BX","7":"1","8":"3.224"}}]}'
    Set dobj = {"message_type":"MFN","message_event_type":"Z01","message_activity_type":"Item Record Update","hl7_version":"2.3","site_id":"688","segment":[{"name":"MSH","sequence":{"1":"MSH","2":"~^\\&","3":"PRCP_SS_VISTA","5":"PRCP_SSTATION","7":"20240125141848-0500","9":"MFN~Z01","10":"442464384179","11":"T","12":"2.3","15":"AL","16":"NE","17":"USA"}},{"name":"MFI","sequence":{"1":"445","3":"UPD","4":"20240125141848","6":"NE"}},{"name":"MFE","sequence":{"1":"MUP","4":"278~STRAW,DRINKING,PLSTC,L 7 3/4IN,FLEX,WRAPPED,SUPER JUMBO,WHT"}},{"name":"ZIM","sequence":{"1":"278~STRAW-DRINK-1I12","2":"~442-TEST092","3":"10","4":"5","5":"2","6":"BX","7":"1","8":"3.224"}}]}
    Set json = dobj.%ToJSON
    Set schema = ##class(Feeder.Util).ReadJsonFile(path)
    zw schema
    Set js = ##class(%SYS.Python).Import("jsonschema")
    Do js.validate(json, schema)
    Quit tSC
}

ClassMethod HelloWorld() As %Status
{
  Set sc = $$$OK
  Set b = ##class(%SYS.Python).Import("builtins")
  Do b.print("Hello world")
  Return sc
}

ClassMethod Today() As %Status
{
  Set sc = $$$OK
  Set dt = ##class(%SYS.Python).Import("datetime")
  write dt.date.today().isoformat()
  Return sc
}

ClassMethod Hello() As %Status
{
  Set sc = $$$OK
  Set sm = ##class(%SYS.Python).Import("sample")
  write sm.hello()
  Return sc
}

/// Titanic
ClassMethod TitanicMeanAge() As %Status
{
    Set sc = $$$OK
    set tt=##class(%SYS.Python).Import("sample")
    set path=##class(%File).NormalizeDirectory("lib", ##class(%File).GetDirectory($zu(86)))_"data/iris-python-template/titanic.csv"
    write "mean age="_tt.meanage(path)
    Return sc
}

}
