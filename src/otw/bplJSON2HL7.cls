/// 
Class otw.bplJSON2HL7 Extends Ens.BusinessProcessBPL
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Ens.Request' response='Ens.Response' height='2000' width='2000' >
<sequence xend='200' yend='550' >
<trace name='request.Stream.Read()' value='request.Stream.Read()' xpos='200' ypos='250' />
<transform name='otw.dtlJSON2HL7' class='otw.dtlJSON2HL7' source='request' target='response' xpos='200' ypos='350' />
<call name='HL7FileOperation' target='HL7FileOperation' async='1' xpos='200' ypos='450' >
<request type='Ens.Request' >
<assign property="callrequest" value="response" action="set" />
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
