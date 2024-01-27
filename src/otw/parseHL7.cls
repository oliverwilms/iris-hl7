Include EnsHL7

Class otw.parseHL7
{

Parameter Category = 2.3;

Parameter Separators = "|~^\&";

/*
MSH|~^\&|PRCP_SSTATION||PRCP_SS_VISTA||20000811161615||OSR~Q06|97|D|2.3|97||AL|NE 
MSA|AA|9993780|MESSAGE ACCEPTED 
QRD|20000811161615|R|D|QOH|||||STA|||S 
ORC|OK|||~999-MY STATION|||||20000811161615 
NTE|1|O|104~KIT SHAVING-SURG PREP~25 
NTE|2|O|12002~CATS~111 
NTE|3|O|12013~WOOZLES~43 
NTE|4|O|31~SOAP ANTISEP BAR 5C~150 
NTE|5|O|47~STERI PEEL 6 IN X 10 IN~1129 
NTE|6|O|7~ARM BOARD 9 INCH LONG~5 
NTE|7|O|9999~Huffalumps~10 
*/
ClassMethod zParseHL7() As %Status
{
	#Dim hl7 As otw.HL7.Message
	#Dim hl7Seg As otw.HL7.Segment
	Set test = "MSH|~^\&|PRCP_SSTATION||PRCP_SS_VISTA||20000811161615||OSR~Q06|97|D|2.3|97||AL|NE"
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
	//Set tSC = hl7.PokeTypeCategory()
	zw tSC
	#Dim pIOStream As %IO.I.CharacterStream = ##class(%Stream.GlobalCharacter).%New()
	Set pToDevice = 1
	Set tSC = hl7.toEasyXML(.pIOStream,.schema,pToDevice)
	Set pSegName = "*"
	Set pIndex = ""
	Set hl7Seg = hl7.FindSegment(pSegName,.pIndex,.pStatus)
	zw hl7Seg.Separators
	Set pSeparators = hl7Seg.Separators
	Set pSegNum = ""
	Set pSegPath = ""
	Set pParentDoc = hl7
	//Set tSC = hl7Seg.OutputToIOStream(pIOStream,pSeparators,,pSegNum,pSegPath,pParentDoc)
	zw pStatus
	//Set tSC = hl7Seg.GetContentArray(.pContents/*,pMode,pDocType,pLevel,pIncludeBase*/)
	//Set tSC = hl7Seg.OutputHTML()
	zw pContents
	Quit $$$OK
}

/*
ClassMethod SegmentToIOStream(
	pIOStream As %IO.I.CharacterStream,
	pSeparators As %String,
	pSequenceNumber As %String = "",
	pSegNum As %String,
	pSegPath As %String,
	pParentDoc As EnsLib.EDI.Document,
	pIOFormatClassname As %String = "") As %Status
{
	Set tSeparators=$S(""=$G(pSeparators):..#Separators, 1:pSeparators)
	Quit:""'=pIOFormatClassname&&$classmethod(pIOFormatClassname,"OutputSegment",$this,.tSC,pIOStream,tSeparators,.pSegNum,.pSegPath,.pParentDoc,.pSequenceNumber) tSC

	Set tSegTerminator=$$$SEGTERM(tSeparators)  Set:""=tSegTerminator tSegTerminator=$C($$$HL7DefSegTerminatorAscii)
	/*
	If (..Name="MSH")&&(pSequenceNumber'="") {
		Set tSeparators=$E(tSeparators,1,5)
		If $E(tSeparators_$C(0,0,0,0),5)?1C {
			Set tSeparators=$E(tSeparators,1,5)_$E($C(17,18,19,20),$L(tSeparators),4)
			Set tShowSeparators=$ZStrip(tSeparators,">C")
		} Else { Set tShowSeparators=tSeparators }

		Set tFS=$$$FSSEP(tSeparators)
		Do pIOStream.Write(..Name_tShowSeparators_..TC,0,.tSC)  Quit:$$$ISERR(tSC) tSC
		For i=3:1:12 Do pIOStream.Write(tFS_..GetValueAt(i,tSeparators),0,.tSC)  Quit:$$$ISERR(tSC)
		Quit:$$$ISERR(tSC) tSC
		Do pIOStream.Write(tFS_pSequenceNumber,0,.tSC)  Quit:$$$ISERR(tSC) tSC
		For i=14:1:..Count Do pIOStream.Write(tFS_..GetValueAt(i,tSeparators),0,.tSC)  Quit:$$$ISERR(tSC)
		Do pIOStream.Write(tSegTerminator,0,.tSC)  Quit:$$$ISERR(tSC) tSC
	} Else {
		*/

/*	Set data=..GetValueAt("",.pSeparators)
		If data'="" {
			If (..ID="")||$D(..DataArray)||'$D($$$vaSegmentExt(..ID,1)) {
				Do pIOStream.Write(data_tSegTerminator,0,.tSC)  Quit:$$$ISERR(tSC) tSC
			} Else {
				Do pIOStream.Write(data,0,.tSC)  Quit:$$$ISERR(tSC) tSC
				For i=1:1 { Quit:'$D($$$vaSegmentExt(..ID,i),data)
					Do pIOStream.Write(data,0,.tSC)  Quit:$$$ISERR(tSC)
				}
				Quit:$$$ISERR(tSC) tSC
				Do pIOStream.Write(tSegTerminator,0,.tSC)  Quit:$$$ISERR(tSC) tSC
			}
		}
	/*}
	Quit $$$OK
}
*/
}
