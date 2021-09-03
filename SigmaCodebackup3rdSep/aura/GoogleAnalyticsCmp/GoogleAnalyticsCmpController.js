({
    afterScriptsLoaded : function(component, event, helper) {
       // alert('loaded');
        window.dataLayer = window.dataLayer || [];
        function gtag() {
            dataLayer.push(arguments);
        }
        gtag("js", new Date());
        gtag("config", "269219619");
        //alert('end');
    }
})