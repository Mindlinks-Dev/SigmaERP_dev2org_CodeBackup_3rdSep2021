({ 
    doInit:function(component, event, helper){
        // helper.getVerticles(component);
        
    },
    PickTemplateName:function(component, event, helper){
         helper.fetchTemplate(component);
        
    },
    viewTemplate:function(component, event, helper){
         helper.getTemplateData(component);    
    },
    closeTemplate:  function (component, event, helper) {
        component.set("v.createContactFlag",false);
    },
    Uploadfile : function(component, event, helper) {
        helper.save(component);
    },
    handleFilesChange: function(component, event, helper) {
        helper.DisplayFileName(component, event, helper);
    },
    
    downloadError : function(component, event, helper) {
        helper.download(component, event, helper);
    },
    OkayConform:function(component, event , helper){
        component.set("v.footer",true);
    },
    SavePO:function(component, event, helper){
        helper.POHelper(component);
    },
    cancel:function(component, event, helper){
        component.set("v.Next",false);
        helper.CancelUpload(component);
        //location.reload();
    },
    ok:function(component, event, helper){
        location.reload();
    }
})