Class otw.dtlJSON2HL7 Extends Ens.DataTransformDTL [ DependsOn = (Ens.StreamContainer, EnsLib.HL7.Message) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='Ens.StreamContainer' targetClass='EnsLib.HL7.Message' targetDocType='2.8:ADT_A01' create='new' language='objectscript' >
<assign value='##class(%DynamicAbstractObject).%FromJSON(source.{Stream})' property='dao' action='set' />
<assign value='$Get(dao.PatientId)' property='target.{PID:PatientID}' action='set' />
<assign value='$Get(dao.PatientName)' property='target.{PID:PatientName().GivenName}' action='set' />
</transform>
}

}
