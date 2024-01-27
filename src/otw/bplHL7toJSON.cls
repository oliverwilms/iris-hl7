/// 
Class otw.bplHL7toJSON Extends Ens.BusinessProcessBPL
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='EnsLib.HL7.Message' response='Ens.Response' height='2000' width='2000' >
<context>
<property name='JSONMessage' type='%Library.String' instantiate='0' />
</context>
<sequence xend='200' yend='450' >
<assign name="JSONMessage" property="context.JSONMessage" value="##class(otw.parseHL7).zParseHL7(request)" action="set" xpos='200' ypos='250' />
<call name='HTTP Operation' target='HTTP Operation' async='1' xpos='200' ypos='350' >
<request type='Ens.Request' >
<assign property="callrequest" value="##class(EnsLib.HTTP.GenericMessage).%New(context.JSONMessage)" action="set" />
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
