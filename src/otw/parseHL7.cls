Include EnsHL7

Class otw.parseHL7
{

Parameter Category = 2.3;

Parameter Separators = "|~^\&";

ClassMethod testMessage() As %String
{
	Set delim = $Char(10)
	Set m = ""
	Set m = m_"MSH|~^\&|PRCP_SSTATION||PRCP_SS_VISTA||20000811161615||OSR~Q06|97|D|2.3|97||AL|NE"_delim
	Set m = m_"MSA|AA|9993780|MESSAGE ACCEPTED"_delim
	Set m = m_"QRD|20000811161615|R|D|QOH|||||STA|||S"_delim
	Set m = m_"ORC|OK|||~999-MY STATION|||||20000811161615"_delim
	Set m = m_"NTE|1|O|104~KIT SHAVING-SURG PREP~25"_delim
	Set m = m_"NTE|2|O|12002~CATS~111"_delim
	Set m = m_"NTE|3|O|12013~WOOZLES~43"_delim
	Set m = m_"NTE|4|O|31~SOAP ANTISEP BAR 5C~150"_delim
	Set m = m_"NTE|5|O|47~STERI PEEL 6 IN X 10 IN~1129"_delim
	Set m = m_"NTE|6|O|7~ARM BOARD 9 INCH LONG~5"_delim
	Set m = m _"NTE|7|O|9999~Huffalumps~10"
	Quit m
}

ClassMethod zParseHL7() As %Status
{
	#Dim hl7 As otw.HL7.Message
	#Dim hl7Seg As otw.HL7.Segment
	Set test = "MSH|~^\&|PRCP_SSTATION||PRCP_SS_VISTA||20000811161615||OSR~Q06|97|D|2.3|97||AL|NE"
	Set test = ..testMessage()
	Set hl7 = ##class(otw.HL7.Message).ImportFromString(test,.pStatus)
	zw pStatus
	Set pKeepParsingAfterError = 1
	Set pReportMissingLoopAsFirstSeg = 0
	Set tSC = hl7.BuildMap(pKeepParsingAfterError,pReportMissingLoopAsFirstSeg)
	zw tSC
	Set tSegCount = hl7.SegCount
	zw tSegCount
	Set pDocType = hl7.TypeVersion
	zw pDocType
	Set tSC = hl7.PokeDocType(pDocType)
	zw tSC
	Set pMessageTypeCategory = hl7.MessageTypeCategory
	Set pName = hl7.Name
	Set tSC = hl7.PokeTypeCategory(pMessageTypeCategory)
	zw tSC
	#Dim pIOStream As %IO.I.CharacterStream = ##class(%Stream.GlobalCharacter).%New()
	Set pToDevice = 0
	Set dObjMessage = hl7.toJSON(.pIOStream,.schema,pToDevice)
	Set tReturn = dObjMessage.%ToJSON()
	Quit tReturn
	Write dObjMessage.%ToJSON(),!
	Quit $$$OK
	Set pSegName = "*"
	Set pIndex = ""
	Set hl7Seg = hl7.FindSegment(pSegName,.pIndex,.pStatus)
	//zw hl7Seg.Separators
	Set pSeparators = hl7Seg.Separators
	Set pSegNum = ""
	Set pSegPath = ""
	Set pParentDoc = hl7
	//Set tSC = hl7Seg.OutputToIOStream(pIOStream,pSeparators,,pSegNum,pSegPath,pParentDoc)
	//zw pStatus
	Set pMode = ""
	Set pDocType = hl7.TypeVersion_":"_hl7.Name
	Set pLevel = 0
	Set pIncludeBase = 0
	//Set tSC = hl7Seg.GetContentArray(.pContents,pMode,pDocType,pLevel,pIncludeBase)
	//Set tSC = hl7Seg.OutputHTML()
	zw pContents
	Quit $$$OK
}

}
