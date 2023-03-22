/// 
Class otw.bplJSON2HL7 Extends Ens.BusinessProcessBPL
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Ens.Request' response='Ens.Response' height='2000' width='2000' >
<context>
<property name='dynPrepareStatus' type='%Library.Status' instantiate='0' />
</context>
<sequence xend='200' yend='750' >
<trace name='request.Stream.Read()' value='request.Stream.Read()' xpos='200' ypos='250' />
<assign name="dynPrepareStatus" property="context.dynPrepareStatus" value="##class(otw.dynq).prepareQ()" action="set" xpos='200' ypos='350' />
<trace name='dynPrepareStatus' value='$System.Status.GetOneStatusText(context.dynPrepareStatus)' xpos='200' ypos='450' />
<transform name='otw.dtlJSON2HL7' class='otw.dtlJSON2HL7' source='request' target='response' xpos='200' ypos='550' />
<call name='HL7FileOperation' target='HL7FileOperation' async='1' xpos='200' ypos='650' >
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
