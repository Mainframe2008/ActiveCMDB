$(document).ready(function(){
	
	jQuery("#processTable").jqGrid({ 
		url:'/process/api?oper=list', 
		datatype: "json",
		colNames:['Name', 'Server', 'Instance','Status','Activity','Started','PID','PPID','Updated'],
		colModel: [
		           	{
		           		name:'name',
		           		index:'name', 
		           		width:64, 
		           		editable:false, 
		           		searchoptions: {sopt:['eq','ne','cn']}, 
		           		required:true, 
		           	}, 
		           	{
		           		name:'server_id',
		           		index:'server_id',
		           		width:54, 
		           		editable:false,
		           		
		           	},
		           	{
		           		name:'instance',
		           		index:'instance', 
		           		width:54, 
		           		editable:false, 
		           		required:false, 
		           	},
		           	{
		           		name:'status',
		           		index:'status',
		           		width:64,
		           		editable:false
		           	},
		           	{
		           		name:'activity',
		           		index:'activity', 
		           		width:128, 
		           		editable:false,
		           		required:true,
		           	},
		           	{
		           		name:'activity',
		           		index:'activity', 
		           		width:128, 
		           		editable:false, 
		           		
		           	},
		           	{
		           		name:'pid',
		           		index:'pid',
		           		width:54,
		           		editable:false,
		           		required:true,
		           	},
		           	{
		           		name:'ppid',
		           		index:'ppid',
		           		width:54,
		           		editable:false,
		           	},
		           	{
		           		name:'updated_at',
		           		index:'updated_at',
		           		width:128,
		           		editable:false
		           	}
		          ],
		rowNum:10, 
		rowList:[10,20,30], 
		pager: '#processPager', 
		sortname: 'server_id', 
		viewrecords: true, 
		sortorder: "asc", 
		editurl: "/process/api", 
		caption: "Process management",
		ondblClickRow: function(id) {
			$.colorbox({iframe:true,width:512,height:381,initialWidth:480,initialHeight:220,href:'/process/view?id=' + id});
		}
	});
	
	jQuery("#processTable").jqGrid('navGrid',"#processPager",
			{view:true, edit:false, add:false, save:false, del:false},
			{height:350,reloadAfterSubmit:false, jqModal:false, closeOnEscape:true, bottominfo:"Fields marked with (*) are required"},
			{height:350,reloadAfterSubmit:true,jqModal:false, closeOnEscape:true,bottominfo:"Fields marked with (*) are required", closeAfterAdd: true},
			{reloadAfterSubmit:false,jqModal:false, closeOnEscape:true},
			{closeOnEscape:true},
			{height:350,jqModal:false,closeOnEscape:true}
	); 
	
	jQuery("#processTable").jqGrid('inlineNav',"#processPager", {edit: false, add:false, cancel:false, save:false});
	
	
	jQuery("#updateProcess").click(function() {
		var data = $( '#procForm' ).serialize();
		$.post('/process/manage',
				data,
				function(data) {
					$('#response').html(data).show();
				},
				'html'
		);
	});
});


