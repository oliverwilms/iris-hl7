Include EnsHL7

Class otw.parseHL7
{

Parameter Category = 2.3;

Parameter DEBUG As COSEXPRESSION = 2;

Parameter Separators = "|~^\&";

ClassMethod DebugMerge(strMessage As %String = "", ByRef pArray) As %Status
{
    If ..#DEBUG = 0 Quit $$$OK
	Merge ^TESTutil($I(^TESTutil)) = pArray
	Set tValue = ""
	If $Get(pArray) '= "" Set tValue = " = "_pArray
	Set ^TESTutil(^TESTutil) = $ZDateTime($NOW(),8,1,3)_" : "_$JOB_" : "_strMessage_tValue
	Quit $$$OK
}

ClassMethod DebugTEST(strMessage As %String = "") As %Status
{
    If ..#DEBUG = 0 Quit $$$OK
	Set ^TESTutil($I(^TESTutil)) = $ZDateTime($NOW(),8,1,3)_" : "_$JOB_" : "_strMessage
	Quit $$$OK
}

ClassMethod hl7ToJSONStreamContainer(ByRef hl7 As EnsLib.HL7.Message) As Ens.StreamContainer
{
	Do ..DebugTEST("hl7ToJSONStreamContainer")
	//Set name = $ZCVT(hl7.GetMsgType(hl7.Name),"O","XML")
	Set pToDevice = 0
	Set base = hl7.DocType
	Set:base'="" base=$G($$$vaSchemaGbl($P(hl7.DocType,":"),"base"))
	Set:base="" base=$P(hl7.DocType,":")
	Set dObjMessage = {}
	set dObjMessage.Segment = ##class(%DynamicArray).%New()
	For i = 1:1:hl7.SegCount {
		Set segment = hl7.getSegmentByIndex(i)
		Set dObjSegment = ..SegmentToJSON(.segment,i,base,.schema,pToDevice)
		Do dObjMessage.Segment.%Push(dObjSegment)
	}
	Set tReturn = dObjMessage.%ToJSON()
	Do ..DebugTEST(tReturn)
	Set tStreamContainer = ##class(Ens.StreamContainer).%New()
	Set tStreamContainer.Stream = ##class(%Stream.GlobalCharacter).%New()
	Set tSC = tStreamContainer.Stream.Write(tReturn)
	Quit tStreamContainer
}

ClassMethod SegmentToJSON(ByRef hl7Seg As EnsLib.HL7.Segment, id As %Integer, baseDocType As %String, ByRef schema = "", pToDevice As %Boolean = 0) As %DynamicObject [ Internal ]
{
#define APPEND(%x,%s) If +$G(pToDevice) { Write %s,! } Else { Do %x.WriteLine(%s) }
#define BLDSCHEMA(%t,%x,%s) Do:'$D(%s(%t,%x)) hl7Seg.buildSchema(%t,%x,.%s)
#define SETTYPE(%l,%r,%b) Set %l=$S(%r[":":%r,1:%b_":"_%r)

	Set:hl7Seg.DocType="" hl7Seg.DocType=baseDocType_":"_hl7Seg.Name
	$$$SETTYPE(sstype,hl7Seg.DocType,baseDocType)
	Set sstag   = $ZCVT($P(sstype,":",2),"O","XML")
	Set type    = $ZCVT($P(sstype,":"),"O","XML")

	$$$BLDSCHEMA("SS",sstype,schema)
	
	Set dObjSequence = {}

	Set pData = $$$vaSegment(hl7Seg.ID)	
	Set FS=$E(pData,1), CS=$E(pData,2), RS=$E(pData,3), ESC=$E(pData,4), SS=$E(pData,5), data1=$E(pData,6,*)
	//Set offset = $S(..Name="MSH":0,1:1)
	Set offset = 1
	For i=1+offset:1:$L(data1,FS) {

		Set idx = i - offset

		// Process each field in turn
		Set data2=$P(data1,FS,i)
		If data2'="" {
			Do dObjSequence.%Set(i-1,data2)
			Continue
			// Generate a wrapping tag for this field
			If $D(schema("SS",sstype,idx)) {
				Set fstag  = $ZCVT(schema("SS",sstype,idx),"O","XML")
				Set fsinfo = $LI(schema("SS",sstype),idx)
			} Else {
				Set fstag = sstag_"."_idx
				Set fsinfo = ""
			}

			If $LG(fsinfo,1)'="" {
				// Dig up the information for the component
				$$$SETTYPE(cstype,$LI(fsinfo,1),baseDocType)
				$$$BLDSCHEMA("DT",cstype,schema)
				Set csinfo = schema("DT",cstype)
			} Else {
				Set (cstype,csinfo)=""
			}

			// Now, look for repetitions
			For j=1:1:$L(data2,RS) {
				// Process each repetition
				Set data3=$P(data2,RS,j)
				If data3="" Continue

				If $G(cstype)'="" {
					$$$APPEND(json,"<"_fstag_">")

					// Process each component
					For k=1:1:$L(data3,CS) {
						Set data4=$P(data3,CS,k)
						If data4="" Continue

						If $LG(csinfo,k)'="" {
							$$$SETTYPE(sctype,$LI(csinfo,k),baseDocType)
							$$$BLDSCHEMA("DS",sctype,schema)
						} Else {
							Set sctype=""
						}

						Set cstag = $ZCVT($G(schema("DT",$G(cstype,-1),k),"CS"_k),"O","XML")
						If $G(sctype)'="",data4[SS {
							$$$APPEND(json,"<"_cstag_">")
							For l=1:1:$L(data4,SS) {
								Set data5=$P(data4,SS,l)
								If data5="" Continue

								Set sctag = $ZCVT($G(schema("DT",$G(sctype,-1),l),"SS"_l),"O","XML")
								$$$APPEND(json,"<"_sctag_">"_$ZCVT(data5,"O","XML")_"</"_sctag_">")
							}
							$$$APPEND(json,"</"_cstag_">")
						} Else {
							$$$APPEND(json,"<"_cstag_">"_$ZCVT(data4,"O","XML")_"</"_cstag_">")
						}
					}
					$$$APPEND(json,"</"_fstag_">")
				} Else {
					$$$APPEND(json,"<"_fstag_">"_$ZCVT(data3,"O","XML")_"</"_fstag_">")
				}
			}
		}
	}
	Set dObjSegment = {}
	Set dObjSegment.name = sstag
	Set dObjSegment.sequence = dObjSequence
	Quit dObjSegment
}

ClassMethod toJSON(ByRef hl7 As EnsLib.HL7.Message, ByRef schema, pToDevice As %Boolean = 0) As %String
{
	Do ..DebugTEST("toJSON")
	Set name = $ZCVT(hl7.GetMsgType(hl7.Name),"O","XML")
	Set base = hl7.DocType
	Set:base'="" base=$G($$$vaSchemaGbl($P(hl7.DocType,":"),"base"))
	Set:base="" base=$P(hl7.DocType,":")
	Set dObjMessage = {}
	set dObjMessage.Segment = ##class(%DynamicArray).%New()
	For i = 1:1:hl7.SegCount {
		Set segment = hl7.getSegmentByIndex(i)
		
		Set dObjSegment = ..SegmentToJSON(.segment,i,base,.schema,pToDevice)
		//Write dObjSegment.%ToJSON(),!
		Do dObjMessage.Segment.%Push(dObjSegment)
	}
	Do ..DebugTEST(dObjMessage.%ToJSON())
	Set tReturn = dObjMessage.%ToJSON()
	Quit tReturn
}

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

}
