var app = angular.module('Flapp', [
  'ng',
  'ngRoute',
  'ngResource',
  'mobile-angular-ui',
  'ngProgress',
  'akoenig.deckgrid',
  'mobile-angular-ui.components',
  // touch/drag feature: this is from 'mobile-angular-ui.gestures.js'
  // to integrate gestures into default ui interactions like 
  // opening sidebars, turning switches on/off ..
  'mobile-angular-ui.gestures'
]);

// 
// You can configure ngRoute as always, but to take advantage of SharedState location
// feature (i.e. close sidebar on backbutton) you should setup 'reloadOnSearch: false' 
// in order to avoid unwanted routing.
// 
app.config(['$routeProvider', '$httpProvider', function($routeProvider, $httpProvider) {
  $routeProvider.when('/',            {templateUrl: 'home.html', reloadOnSearch: false});  
  $routeProvider.when('/add',         {templateUrl: 'add.html', reloadOnSearch: false});
  $routeProvider.when('/random',      {templateUrl: 'random.html', reloadOnSearch: false});
  $routeProvider.when('/suggest',     {templateUrl: 'suggest.html', reloadOnSearch: false});   
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

app.controller('MainController', ['$rootScope', '$scope', 'dataBank', 'ngProgress',function($rootScope, $scope, dataBank, ngProgress){
  // User agent displayed in home page
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
  
  $scope.randomFoods = function(limit) {
  	limit=limit?limit:6;
  	dataBank.Food.query(function(foods){
	  	dataBank.shuffleArray(foods);
	  	var fdx = foods.splice(0,limit);
	  	for (i=0;i<limit;i++){
	  		fdx[i]['toggled']=false;
	  		fdx[i]['mod_id']=0;
	  	}
	  	$scope.fdx = fdx;
	  });
  };
  $scope.getMod=function (dd){
  	var md = $filter('filter')($scope.mods, { id: dd }, true)[0];
  	return md.name;
  };
  $scope.addSelected = function(yo){
  	yo['toggled']=false;
  	$scope.fdx.push(yo);
  	console.log(yo);
  };
  $scope.addSelection = function(){
  	var payload = { fid: [], mid: [] };
  	for(i=0,l=$scope.fdx.length;i<l;i++) {
  		if($scope.fdx[i].toggled==true) {
  			payload.fid.push($scope.fdx[i].id);
  			payload.mid.push($scope.fdx[i].mod_id==undefined||$scope.fdx[i].mod_id=='?'?1:$scope.fdx[i].mod_id);
  			$scope.fdx[i].toggled=false;
  			var modText = $scope.fdx[i].mod_id, foodText=$scope.fdx[i].name;
  			payload.txt=i==0?modText+' '+foodText:', '+modText+' '+foodText;
  		}
  	}
  	$scope.store=payload;
  	$scope.stores.push(payload);
  	console.log(payload);
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