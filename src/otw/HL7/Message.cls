Class otw.HL7.Message Extends EnsLib.HL7.Message
{

/// Gets the next segment after index <var>pIndex</var> with name <var>pSegName</var>.
/// Supports <var>pSegName</var> = '*' to match any segment.
Method FindSegment(
	pSegName As %String,
	ByRef pIndex As %String = "",
	Output pStatus As %Status) As otw.HL7.Segment
{
	Set pStatus=$$$OK, tId=..%Id()  Set:'tId tId=..%ClonedId
	Do:'$D($$$vaM("runtimeIndex")) ..buildRuntimeIndexFromPath()
	Set seg=""  For index=+pIndex+1:1:$$$vaM("runtimeIndex") { Set seg=$$$vaSegLookthru(index,tId)  Continue:""=seg
		If $$$vaIsOref(seg) {
			Set tSegObj=..%maps("orefs",index)
			If (pSegName="*")||(tSegObj.Name=pSegName) Set pIndex=index  Quit
		} Else {
			Set segid=$P(seg,"|"), data=$G($$$vaSegment(segid))
			If (pSegName="*")||(pSegName=$$$vaDataSegName(data)) {
				#; Same code as in getSegmentByIndex
				Set pIndex=index
				Set tSegObj=##class(EnsLib.HL7.Segment).%New($LB(segid,(..IsMutable&&(tId=..%ClonedId)),$P(seg,"|",2)))
				Set ..%maps("orefs",pIndex)=tSegObj
				Set $$$vaM("runtimeIndex",pIndex)="@"
				Set path=$G($$$vaM("bidirectionalLink",pIndex)) Set:""'=path $$$vaM("runtimePath",path)="@"_pIndex
				Quit
			}
		}
	}
	If +pIndex<index Set pIndex=""  Quit $$$NULLOREF
	Quit tSegObj
}

Method getSegmentByIndex(
	pIndex As %Integer,
	Output pStatus As %Status) As EnsLib.HL7.Segment [ Internal ]
{
	Do:'$D($$$vaM("runtimeIndex")) ..buildRuntimeIndexFromPath()
	Set pStatus=$$$OK, tId=..%Id()  Set:'tId tId=..%ClonedId
	Set seg=$$$vaSegLookthru(pIndex,tId)
	If seg="" Set pStatus=$$$ERROR($$$EnsErrGeneral,"Segment Index "_pIndex_" is out of bounds") Quit $$$NULLOREF
	Quit:$$$vaIsOref(seg) ..%maps("orefs",pIndex)
	Set tSegObj=##class(otw.HL7.Segment).%New($LB($P(seg,"|"),(..IsMutable&&..CacheSegsGotten&&(tId=..%ClonedId)),$P(seg,"|",2)))
	If ..CacheSegsGotten {
		Set ..%maps("orefs",pIndex)=tSegObj
		Set $$$vaM("runtimeIndex",pIndex)="@"
		Set path=$G($$$vaM("bidirectionalLink",pIndex)) Set:""'=path $$$vaM("runtimePath",path)="@"_pIndex
	}
	Quit tSegObj
}

Method toJSON(
	ByRef xml As %GlobalCharacterStream,
	ByRef schema,
	pToDevice As %Boolean = 0) As %DynamicObject
{
#define APPEND(%x,%s) If pToDevice { Write %s,! } Else { Do %x.WriteLine(%s) }

	Set xml = $S(pToDevice:$$$NULLOREF,1:##class(%GlobalCharacterStream).%New())

	Set name = $ZCVT(..GetMsgType(..Name),"O","XML")
	Set base = ..DocType
	Set:base'="" base=$G($$$vaSchemaGbl($P(..DocType,":"),"base"))
	Set:base="" base=$P(..DocType,":")
	Set dObjMessage = {}
	set dObjMessage.Segment = ##class(%DynamicArray).%New()
	$$$APPEND(xml,"<?xml version=""1.0"" encoding=""UTF-16""?>")
	$$$APPEND(xml,"<"_name_" docType="""_$ZCVT($P(..DocType,":"),"O","XML")_""">")
	For i = 1:1:..SegCount {
		Set segment = ..getSegmentByIndex(i)
		
		Set dObjSegment = segment.toJSON(.xml,i,base,.schema,pToDevice)
		//Write dObjSegment.%ToJSON(),!
		Do dObjMessage.Segment.%Push(dObjSegment)
	}
	$$$APPEND(xml,"</"_name_">")
	Do:'pToDevice xml.Rewind()
	//Write dObjMessage.%ToJSON(),!
	Quit dObjMessage
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
