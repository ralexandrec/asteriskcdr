var app = angular.module('app', ['ngMaterial', 'angularUtils.directives.dirPagination']);
app.controller('listdata',function($http){
    var vm = this;
    var token = document.getElementById("TOKEN").value;
    var data_url = document.getElementById("DATA_URL").value;
    vm.calls = [];
    vm.pageno = 1;
    vm.total_count = 0;
    vm.itemsPerPage = 10;
    vm.src = vm.dst = '';
    vm.start_date = moment().subtract(5, 'days').toDate();
    vm.end_date = moment().toDate();
    vm.getData = function(pageno){
        var offset = vm.itemsPerPage * (pageno - 1);
        vm.calls = [];
        $http({
            url: data_url,
            method: "get",
            params: {
                start_date: vm.start_date,
                end_date: vm.end_date,
                src: vm.src,
                dst: vm.dst,
                token: token,
                offset: offset,
                limit: vm.itemsPerPage
            }
        }).success(function(response){
            vm.calls = response.data;
            vm.total_count = response.total_count;
        });
    };
    vm.getXlsx = function(){
        window.location.href = 
        data_url+
        '/xlsx?start_date='+vm.start_date+
        '&end_date='+vm.end_date+
        '&src='+vm.src+
        '&dst='+vm.dst;
    }
    vm.getData(vm.pageno);
});
angular.module('app').config(function($mdDateLocaleProvider) {
   $mdDateLocaleProvider.formatDate = function(date) {
       return moment(date).format('DD/MM/YYYY');
   };
   $mdDateLocaleProvider.parseDate = function(dateString) {
       var m = moment(dateString, 'DD/MM/YYYY', true);
       return m.isValid() ? m.toDate() : new Date(NaN);
   };
});