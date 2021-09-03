({
    init: function (cmp) {
        var items = [
            {
                label: 'MORNING',
                name: '1',
                disabled: false,
                expanded: false,
                items: [
                    {
                        label: '9:00 AM',
                        name: '1.1',
                        expanded: true,
                        disabled: false,
                        items: []
                    }
                ]
            }
        ];
        
        cmp.set('v.items', items);
    },
    handleSelect: function (cmp, event) {
        event.preventDefault();
        var mapping = { '1.1' : '9:00 AM'};
        cmp.set('v.selected', mapping[event.getParam('name')]);
    }
})