var app = angular.module('Flapp', [
  'ng',
  'ngRoute',
  'ngResource',
  'mobile-angular-ui',
  'ngProgress',
  'mobile-angular-ui.gestures'
]);

app.config(['$routeProvider', '$httpProvider', function($routeProvider, $httpProvider) {
  $routeProvider.when('/',            {templateUrl: 'home.html', reloadOnSearch: false});  
  $routeProvider.when('/random',      {templateUrl: 'random.html', reloadOnSearch: false});
}]);

app.value('config', {
    basePath: '/api/v1/'
  });

app.run(function($rootScope, ngProgress) {
  $rootScope.$on('$routeChangeStart', function() {
    ngProgress.reset();
    ngProgress.start();
  });

  $rootScope.$on('$routeChangeSuccess', function() {
    ngProgress.complete();
  });

  $rootScope.$on('$routeChangeError', function() {
    ngProgress.complete();
  });
});

app.controller('MainController', ['$rootScope', '$scope', 'dataBank', 'ngProgress', '$filter',function($rootScope, $scope, dataBank, ngProgress, $filter){
  $scope.userAgent = navigator.userAgent;
  $scope.combos = dataBank.Combo.query();
  $scope.foods = dataBank.Food.query();
  $scope.mods = dataBank.Mod.query(function(moddata){
  	$scope.mods=moddata;
  });  
  $scope.fdx = [];//Shuffled and limited array
  $scope.addedFdx={};
  $scope.store={};
  $scope.stores=[];
  
  $scope.startApp = function() {
    window.location.hash='/random';
  };
  
  $rootScope.$on('$routeChangeSuccess', function(args) {    
    console.log(location.hash);
    if(location.hash=='#/random') {
    	$scope.randomFoods(6);
    }
  });
  
  $scope.randomFoods = function(limit) {
  	limit=limit?limit:6;
  	dataBank.Food.query(function(foods){
	  	dataBank.shuffleArray(foods);
	  	var fdx = foods.splice(0,limit);
	  	for (i=0;i<limit;i++){
	  		fdx[i]['toggled']=false;
	  		fdx[i]['opened']=false;
	  		fdx[i]['mod_id']=1;
	  	}
	  	$scope.fdx = fdx;
	  });
  };
  $scope.getMod=function (dd){
  	var md = $filter('filter')($scope.mods, { id: dd }, true)[0];
  	return md?md.name:"";
  };
  $scope.addSelected = function(yo){
  	yo['toggled']=false;
  	yo['opened']=false;
  	yo['mod_id']=1;
  	$scope.fdx.push(yo);
  };
  $scope.addSelection = function(){
  	var payload = { fid: [], mid: [], name: "", saved: false };
  	for(i=0,l=$scope.fdx.length;i<l;i++) {
  		if($scope.fdx[i].toggled==true) {
  			payload.fid.push($scope.fdx[i].id);
  			payload.mid.push(isNaN(parseInt($scope.fdx[i].mod_id * 1))||parseInt($scope.fdx[i].mod_id * 1)==0?1:$scope.fdx[i].mod_id);
  			var modText = $scope.getMod($scope.fdx[i].mod_id), foodText=$scope.fdx[i].name;
  			payload.name+=payload.name==""?(modText+' '+foodText).trim():(', '+modText+' '+foodText).trim();  			
  			$scope.fdx[i].mod_id=1;
  			$scope.fdx[i].toggled=false;
  		}
  	}
  	$scope.store=payload;
  	$scope.stores.push(payload);
    dataBank.Combo.save({},{ fids: payload.fid, mids: payload.mid }, function(dat){
	}, function(){
	});
  };    
}]);
//{ 'get':{method:'GET'},'save':{method:'POST'},'query':{method:'GET', isArray:true},'remove':{method:'DELETE'},'delete':{method:'DELETE'} };
app.factory('dataBank', ['$cacheFactory', '$resource', '$rootScope', 'config', '$q', function ($cacheFactory, $resource, $rootScope, config, $q) {
	//var Food = { 'foods':$cacheFactory('food'), 'mods':$cacheFactory('mod'), 'combos':$cacheFactory('combo') };
	return {
		Combo: $resource(config.basePath + 'combo/:comboId', {comboId:'@id'},
		{
			get: { method:'GET', cache: $cacheFactory },
			food: { method:'GET', cache: $cacheFactory, params:{food:'food'} },
        	query: { method:'GET', cache: $cacheFactory, isArray:true },
        	save: { method:'POST' }
		}),
		Food: $resource(config.basePath + 'food/:foodId', {foodId:'@id'},
		{
			get: { method:'GET', cache: $cacheFactory },
        	query: { method:'GET', cache: $cacheFactory, isArray:true },
        	save: { method:'POST' }
		}),
		Mod: $resource(config.basePath + 'mod/:modId', {modId:'@id'},
		{
			get: { method:'GET', cache: $cacheFactory },
        	query: { method:'GET', cache: $cacheFactory, isArray:true },
        	save: { method:'POST' }
		}),
		// -> Fisher–Yates shuffle algorithm
		shuffleArray: function(array) {
		  var m = array.length, t, i;		
		  // While there remain elements to shuffle
		  while (m) {
		    // Pick a remaining element…
		    i = Math.floor(Math.random() * m--);		
		    // And swap it with the current element.
		    t = array[m];
		    array[m] = array[i];
		    array[i] = t;
		  }		
		  return array;
		},
    };
}]);
