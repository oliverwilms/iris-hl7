Class otw.NewProduction Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="otw.NewProduction" LogGeneralTraceEvents="true">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="MsgRouter" Category="" ClassName="EnsLib.HL7.MsgRouter.RoutingEngine" PoolSize="1" Enabled="true" Foreground="false" Comment="This handles message routing logic." LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="Validation"></Setting>
    <Setting Target="Host" Name="BusinessRuleName">otw.NewProduction.RoutingRule</Setting>
    <Setting Target="Host" Name="BadMessageHandler">BadMessageHandler</Setting>
  </Item>
  <Item Name="BadMessageHandler" Category="" ClassName="EnsLib.HL7.Operation.FileOperation" PoolSize="1" Enabled="false" Foreground="false" Comment="Bad messages are sent to this operation." LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="Ens.Alert" Category="" ClassName="EnsLib.MsgRouter.RoutingEngine" PoolSize="0" Enabled="true" Foreground="false" Comment="This handles Alert routing logic." LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="BusinessRuleName">otw.NewProduction.AlertRule</Setting>
  </Item>
  <Item Name="EMailAlert" Category="" ClassName="EnsLib.EMail.AlertOperation" PoolSize="1" Enabled="false" Foreground="false" Comment="This sends alerts via e-mail." LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="PagerAlert" Category="" ClassName="EnsLib.EMail.AlertOperation" PoolSize="1" Enabled="false" Foreground="false" Comment="This sends alerts to a pager via e-mail." LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HL7 HTTP Service" Category="" ClassName="EnsLib.HL7.Service.HTTPService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="MessageSchemaCategory">2.3</Setting>
    <Setting Target="Host" Name="EnableStandardRequests">1</Setting>
    <Setting Target="Host" Name="TargetConfigNames">HL7 to JSON</Setting>
    <Setting Target="Host" Name="ArchiveIO">1</Setting>
  </Item>
  <Item Name="HL7FileService" Category="" ClassName="EnsLib.HL7.Service.FileService" PoolSize="1" Enabled="true" Foreground="false" Comment="This is a default HL7 File Service." LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigNames">HL7 to JSON</Setting>
    <Setting Target="Adapter" Name="FilePath">/usr/irissys/mgr/hl7/</Setting>
    <Setting Target="Host" Name="MessageSchemaCategory">2.3</Setting>
  </Item>
  <Item Name="HL7FileOperation" Category="" ClassName="EnsLib.HL7.Operation.FileOperation" PoolSize="1" Enabled="false" Foreground="false" Comment="This is a default HL7 File Operation." LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="JSONFileService" Category="" ClassName="EnsLib.File.PassthroughService" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="TargetConfigNames">JSON2HL7</Setting>
    <Setting Target="Adapter" Name="FilePath">/tmp/</Setting>
  </Item>
  <Item Name="JSON2HL7" Category="" ClassName="otw.bplJSON2HL7" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="HL7 to JSON" Category="" ClassName="otw.bplHL7toJSON" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="HTTP Operation" Category="" ClassName="EnsLib.HTTP.GenericOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="JSON File Operation" Category="" ClassName="EnsLib.File.PassthroughOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="FilePath">/tmp/</Setting>
  </Item>
</Production>
}

}
