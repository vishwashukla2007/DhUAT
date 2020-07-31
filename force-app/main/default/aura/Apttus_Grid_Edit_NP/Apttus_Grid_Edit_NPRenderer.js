({
    rerender : function(component, event, helper){
        this.superRerender();
        console.log('Entered JS Init');
        if(component.get("v.isJqueryLoaded") && component.get("v.needToProcessReRenderLogic")) {
            
            $("table").each(function() {
        var $this = $(this);
        var newrows = [];
        $this.find("tr").each(function(){
            var i = 0;
            $(this).find("td").each(function(){
                i++;
                if(newrows[i] === undefined) { newrows[i] = $("<tr></tr>"); }
                newrows[i].append($(this));
            });
        });
        $this.find("tr").remove();
        $.each(newrows, function(){
            $this.append(this);
        });
    });
    
            
            component.set("v.needToProcessReRenderLogic",false); // this will not fire rerender again
        }
        
    }
})