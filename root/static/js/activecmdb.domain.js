
$(document).ready(function(){
	var domain_id= $("#id").val();
	jQuery("#netTable").jqGrid({ 
		
		url:'/ipdomain/network?oper=list&domain_id=' + domain_id, 
		datatype: "json", 
		colNames:['Network', 'Mask', 'Mask length','Active','Read Comm','Write Comm','User','Password','AuthUser','AuthKey','AuthProto','PrivKey', 'PrivProto'], 
		colModel:[
		         
		          {name:'ip_network',index:'ip_network', width:132, editable:true, searchoptions: {sopt:['eq','ne','cn']}, required:true, formoptions:{ elmsuffix:" (*)"}}, 
		          {name:'ip_mask',index:'ip_mask', width:80,editable:true, search:false, required:false}, 
		          {name:'ip_masklen',index:'ip_masklen', width:70, align:"right",editable:true, search:false}, 
		          {name:'active',index:'active', width:50, align:"right",editable:true,edittype:"checkbox", value:"1", offval:"0", formatter:"checkbox", search:false}, 
		          {name:'snmp_ro',index:'snmp_ro', width:80,hidden:false,align:"right",editable:true,editrules: { edithidden: true }}, 
		          {name:'snmp_rw',index:'snmp_rw', width:80,hidden:true, sortable:false,editable:true,editrules: { edithidden: true }},
		          {name:'telnet_user',index:'telnet_user',width:80, sortable:false,editable:true, search:false},
		          {name:'telnet_pwd',index:'telnet_pwd',width:80,hidden:true, sortable:false, editable:true, search:false,editrules: { edithidden: true }},
		          {name:'snmpv3_user', index:'snmpv3_user',width:80,hidden:false, sortable:false,editable:true,editrules: { edithidden: true }},
		          {name:'snmpv3_pass1',index:'snmpv3_pass1',width:80,hidden:true,sortable:false,editable:true,editrules: { edithidden: true }},
		          {name:'snmpv3_proto1',index:'snmpv3_proto1',width:60,hidden:true,edittype:"select",editoptions:{value:"sha:SHA;md5:MD5"},editable:true,editrules: { edithidden: true }},
		          {name:'snmpv3_pass2',index:'snmpv3_pass2',width:80,hidden:true,sortable:false,editable:true,editrules: { edithidden: true }},
		          {name:'snmpv3_proto2',index:'snmpv3_proto2',width:60,hidden:true,edittype:"select",editoptions:{value:"des:DES;aes:AES"},editable:true,editrules: { edithidden: true }}
		          ], 
		          rowNum:10, rowList:[10,20,30], 
		          pager: '#netPager', 
		          sortname: 'domain_id', 
		          viewrecords: true, 
		          sortorder: "desc", 
		          editurl: "/ipdomain/network?domain_id=" + domain_id, 
		          caption: "Networks"
	}); 

	jQuery("#netTable").jqGrid('navGrid',"#netPager",
			{view:true},
			{height:350,reloadAfterSubmit:false, jqModal:false, closeOnEscape:true, bottominfo:"Fields marked with (*) are required"},
			{height:350,reloadAfterSubmit:true,jqModal:false, closeOnEscape:true,bottominfo:"Fields marked with (*) are required", closeAfterAdd: true},
			{reloadAfterSubmit:false,jqModal:false, closeOnEscape:true},
			{closeOnEscape:true},
			{height:350,jqModal:false,closeOnEscape:true}
	); 
	jQuery("#netTable").jqGrid('inlineNav',"#netPager", {edit: false, add:false, cancel:false, save:false});
	
});