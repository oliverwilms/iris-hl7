Class otw.HL7.Segment Extends EnsLib.HL7.Segment
{

ClassMethod GetContentArray(
	Output pContents,
	pMode As %String,
	pDocType As %String,
	pLevel As %Integer,
	pIncludeBase As %Boolean = 0) As %Status
{
	Set tRef=$G(pContents)
	If ("%"=$E(tRef)||("^"=$E(tRef))) {
		Set tSC=##class(otw.HL7.Schema).getFieldsContentArray(.local,.pMode,$P(pDocType,":",1),$P(pDocType,":",2),$S('pLevel:0,1:pLevel+2))
		Merge @tRef=local
		Quit tSC
	} Else {
		Quit ##class(otw.HL7.Schema).getFieldsContentArray(.pContents,.pMode,$P(pDocType,":",1),$P(pDocType,":",2),$S('pLevel:0,1:pLevel+2))
	}
}

/// Convert segments back to Stream, using sequence number
Method OutputToIOStream(
	pIOStream As %IO.I.CharacterStream,
	pSeparators As %String,
	pSequenceNumber As %String = "",
	pSegNum As %String,
	pSegPath As %String,
	pParentDoc As EnsLib.EDI.Document,
	pIOFormatClassname As %String = "") As %Status
{
	Set tSeparators=$S(""=$G(pSeparators):..Separators, 1:pSeparators)
	Quit:""'=pIOFormatClassname&&$classmethod(pIOFormatClassname,"OutputSegment",$this,.tSC,pIOStream,tSeparators,.pSegNum,.pSegPath,.pParentDoc,.pSequenceNumber) tSC

	Set tSegTerminator=$$$SEGTERM(tSeparators)  Set:""=tSegTerminator tSegTerminator=$C($$$HL7DefSegTerminatorAscii)
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
		Set data=..GetValueAt("",.pSeparators)
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
	}
	Quit $$$OK
}

/// Deprecated - to be removed - only used by deprecated toEasyXML
ClassMethod buildSchema(
	pType As %String,
	pTag As %String,
	ByRef schema) As %Status
{
	Set pCategory = $P(pTag,":")
	Set pName = $P(pTag,":",2)

	Set schema(pType,pTag) = $G($$$vaSchemaGbl(pCategory,pType,pName))
	Quit:schema(pType,pTag)="" $$$ERROR($$$EnsErrGeneral,"No schema for segment '"_pName_"' in "_pType)

	// Build a reverse index, keyed by field number
	Set name=""  For { Set name=$O($$$vaSchemaGbl(pCategory,pType,pName,"names",name),1,i)  Quit:""=name
		Set schema(pType,pTag,i)=name
	}
	Quit $$$OK
}

/// Deprecated - to be removed
Method toEasyXML(
	ByRef xml As %String,
	id As %Integer,
	baseDocType As %String,
	ByRef schema = "",
	pToDevice As %Boolean = 0) As %Status [ Internal ]
{
#define APPEND(%x,%s) If +$G(pToDevice) { Write %s,! } Else { Do %x.WriteLine(%s) }
#define BLDSCHEMA(%t,%x,%s) Do:'$D(%s(%t,%x)) ..buildSchema(%t,%x,.%s)
#define SETTYPE(%l,%r,%b) Set %l=$S(%r[":":%r,1:%b_":"_%r)

	Set:..DocType="" ..DocType=baseDocType_":"_..Name
	$$$SETTYPE(sstype,..DocType,baseDocType)
	Set sstag   = $ZCVT($P(sstype,":",2),"O","XML")
	Set type    = $ZCVT($P(sstype,":"),"O","XML")

	$$$BLDSCHEMA("SS",sstype,schema)

	$$$APPEND(xml,"<"_sstag_" docType="""_type_""">")

	Set pData = $$$vaSegment(..ID)	
	Set FS=$E(pData,1), CS=$E(pData,2), RS=$E(pData,3), ESC=$E(pData,4), SS=$E(pData,5), data1=$E(pData,6,*)
	Set offset = $S(..Name="MSH":0,1:1)
	For i=1+offset:1:$L(data1,FS) {

		Set idx = i - offset

		// Process each field in turn
		Set data2=$P(data1,FS,i)
		If data2'="" {
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
					$$$APPEND(xml,"<"_fstag_">")

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
							$$$APPEND(xml,"<"_cstag_">")
							For l=1:1:$L(data4,SS) {
								Set data5=$P(data4,SS,l)
								If data5="" Continue

								Set sctag = $ZCVT($G(schema("DT",$G(sctype,-1),l),"SS"_l),"O","XML")
								$$$APPEND(xml,"<"_sctag_">"_$ZCVT(data5,"O","XML")_"</"_sctag_">")
							}
							$$$APPEND(xml,"</"_cstag_">")
						} Else {
							$$$APPEND(xml,"<"_cstag_">"_$ZCVT(data4,"O","XML")_"</"_cstag_">")
						}
					}
					$$$APPEND(xml,"</"_fstag_">")
				} Else {
					$$$APPEND(xml,"<"_fstag_">"_$ZCVT(data3,"O","XML")_"</"_fstag_">")
				}
			}
		}
	}
	$$$APPEND(xml,"</"_sstag_">")
}

Method toJSON(
	ByRef json As %String,
	id As %Integer,
	baseDocType As %String,
	ByRef schema = "",
	pToDevice As %Boolean = 0) As %DynamicObject [ Internal ]
{
#define APPEND(%x,%s) If +$G(pToDevice) { Write %s,! } Else { Do %x.WriteLine(%s) }
#define BLDSCHEMA(%t,%x,%s) Do:'$D(%s(%t,%x)) ..buildSchema(%t,%x,.%s)
#define SETTYPE(%l,%r,%b) Set %l=$S(%r[":":%r,1:%b_":"_%r)

	Set:..DocType="" ..DocType=baseDocType_":"_..Name
	$$$SETTYPE(sstype,..DocType,baseDocType)
	Set sstag   = $ZCVT($P(sstype,":",2),"O","XML")
	Set type    = $ZCVT($P(sstype,":"),"O","XML")

	$$$BLDSCHEMA("SS",sstype,schema)
	
	//$$$APPEND(json,"<"_sstag_" docType="""_type_""">")
	Set dObjSequence = {}

	Set pData = $$$vaSegment(..ID)	
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
	$$$APPEND(json,dObjSegment.%ToJSON())
	//$$$APPEND(json,"</"_sstag_">")
	Quit dObjSegment
}

}
