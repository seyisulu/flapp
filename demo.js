var app = angular.module('Flapp', [
  'ng',
  'ngRoute',
  'ngResource',
  'mobile-angular-ui',
  'ngProgress',
  'akoenig.deckgrid',
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
  $routeProvider.when('/random',      {templateUrl: 'random.html', reloadOnSearch: false});
  $routeProvider.when('/suggest',     {templateUrl: 'suggest.html', reloadOnSearch: false});
  /*
  $httpProvider.defaults.transformRequest = function(data){
        if (data === undefined) {
            return data;
        }
        return $.param(data, false);
   };
   $httpProvider.defaults.headers.post['Content-Type'] = 'application/x-www-form-urlencoded; charset=UTF-8';
   */   
}]);
// Prevent sending of JSON to server using jQuery's param format
// Set the Content-Type header globally


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

app.controller('MainController', ['$rootScope','$scope','dataBank',function($rootScope, $scope, dataBank){
  // User agent displayed in home page
  $scope.userAgent = navigator.userAgent;
  $scope.combos = dataBank.Combo.query();
  $scope.foods = dataBank.Food.query();
  $scope.mods = dataBank.Mod.query();
  $scope.modx = dataBank.Mod.query();
    $scope.md = new dataBank.Mod({name:' Deep Fried'});
    $scope.md.$save();
  $scope.saveMod = function() {
    $scope.md = new dataBank.Mod({name:' Deep Fried'});
    $scope.md.$save();
  };
  $scope.startApp = function() {
    window.location.hash='/random';
  };
  //
  // 'Forms' screen
  //  
  $scope.rememberMe = true;
  $scope.email = 'me@example.com';  
  $scope.login = function() {
    alert('You submitted the login form');
  };

  $scope.deleteNotice = function(notice) {
    var index = $scope.notices.indexOf(notice);
    if (index > -1) {
      $scope.notices.splice(index, 1);
    }
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
		})
    };
}]);