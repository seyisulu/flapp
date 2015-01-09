var app = angular.module('Flapp', [
  'ngRoute',
  'mobile-angular-ui',
  'ngProgress',  
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
app.config(function($routeProvider) {
  $routeProvider.when('/',            {templateUrl: 'home.html', reloadOnSearch: false});  
  $routeProvider.when('/random',      {templateUrl: 'random.html', reloadOnSearch: false});
  $routeProvider.when('/suggest',     {templateUrl: 'suggest.html', reloadOnSearch: false});
});

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

app.controller('MainController', function($rootScope, $scope){

  // User agent displayed in home page
  $scope.userAgent = navigator.userAgent;
  
  // Needed for the loading screen
  $rootScope.$on('$routeChangeStart', function(){
    $rootScope.loading = true;
  });

  $rootScope.$on('$routeChangeSuccess', function(){
    $rootScope.loading = false;
  });

  // 
  // 'Scroll' screen
  // 
  var scrollItems = [];

  for (var i=1; i<=100; i++) {
    scrollItems.push('Item ' + i);
  }

  $scope.scrollItems = scrollItems;

  $scope.bottomReached = function() {
    alert('Congrats you scrolled to the end of the list!');
  }

  //
  // 'Forms' screen
  //  
  $scope.rememberMe = true;
  $scope.email = 'me@example.com';
  
  $scope.login = function() {
    alert('You submitted the login form');
  };

  // 
  // 'Drag' screen
  // 
  $scope.notices = [];
  
  for (var j = 0; j < 10; j++) {
    $scope.notices.push({icon: 'envelope', message: 'Notice ' + (j + 1) });
  }

  $scope.deleteNotice = function(notice) {
    var index = $scope.notices.indexOf(notice);
    if (index > -1) {
      $scope.notices.splice(index, 1);
    }
  };
});

app.factory('foodSvc', ['$http', '$rootScope', 'config', '$q', function ($http, $rootScope, config, $q) {
	return {
        foods: function (id) {
        	var deferred = $q.defer();
        	$http({method: 'GET', url: config.basePath + 'foods?callback=JSON_CALLBACK', cache: true}).
            	success(function (data, status, headers, config) {
            		deferred.resolve(data);
            	}).
            	error(function(data, status, headers, config) {
            		deferred.reject({status:400,payload:[]});
            	});
            return deferred.promise;
        },
        modifiers: function (id) {
        	var deferred = $q.defer();
        	$http({method: 'GET', url: config.basePath + 'modifiers?callback=JSON_CALLBACK', cache: true}).
            	success(function (data, status, headers, config) {
            		deferred.resolve(data);
            	}).
            	error(function(data, status, headers, config) {
            		deferred.reject({status:400,payload:[]});
            	});
            return deferred.promise;
        },
        getr: function (url) {
        	var deferred = $q.defer();
        	$http({method: 'GET', url: url, cache: true}).
            	success(function (data, status, headers, config) {
            		deferred.resolve(data);
            	}).
            	error(function(data, status, headers, config) {
            		deferred.reject({question:{},answers:[]});
            	});
            return deferred.promise;
        },
        saveAnswerAsync: function (point,data) {
            var deferred = $q.defer();
        	$http({method: 'GET', url: point, cache: false, data: data}).
            	success(function (data, status, headers, config) {
            		deferred.resolve(data);
            	}).
            	error(function(data, status, headers, config) {
            		deferred.reject({status:500,payload:{}});
            	});
            return deferred.promise;
        }
    };
}]);