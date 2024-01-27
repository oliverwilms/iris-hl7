/// 
Class otw.bplHL7toJSON Extends Ens.BusinessProcessBPL
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='EnsLib.HL7.Message' response='Ens.Response' height='2000' width='2000' >
<context>
<property name='StreamContainer' type='Ens.StreamContainer' instantiate='0' />
</context>
<sequence xend='200' yend='650' >
<assign name="StreamContainer" property="context.StreamContainer" value="##class(otw.parseHL7).hl7ToJSONStreamContainer(request)" action="set" xpos='200' ypos='450' />
<call name='JSON Operation' target='JSON File Operation' async='1' xpos='200' ypos='550' >
<request type='Ens.StreamContainer' >
<assign property="callrequest" value="context.StreamContainer" action="set" />
</request>
<response type='Ens.Response' />
</call>
</sequence>
</process>
}
Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
