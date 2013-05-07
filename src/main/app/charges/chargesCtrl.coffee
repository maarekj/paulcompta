nameListCtrl = 'charges.chargesListViewCtrl'
nameListEditCtrl = 'charges.chargesListEditViewCtrl'
nameEditCtrl = 'charges.chargeEditViewCtrl'

angular.module(nameListCtrl, []).controller(nameListCtrl, [
    '$scope'
    'common.services.weeksRepo'
    'common.services.gdriveService'
    ($scope, weeksRepo, gdrive) ->        
        $scope.weeks = weeksRepo.getAll()
        $scope.chargesItems = weeksRepo.getChargesItems()
        
        $scope.files = gdrive.files((data, status) ->
            console.log(data, status)
        )

        $scope.getTotalOfCharge = (week) ->
            return weeksRepo.getTotalOfCharge(week)
	])
    

angular.module(nameListEditCtrl, []).controller(nameListEditCtrl, [
    '$scope'
    '$window'
    '$location'
    'common.services.weeksRepo'
    ($scope, $window, $location, weeksRepo) ->        
        $scope.weeks = weeksRepo.getAll()
        $scope.chargesItems = weeksRepo.getChargesItems()
        
        $scope.getTotalOfCharge = (week) ->
            return weeksRepo.getTotalOfCharge(week)
            
        $scope.removeChargeAtIndex = (index) ->
            if ($window.confirm('Voulez-vous vraiment supprimé la ligne ?'))
                weeksRepo.removeAtIndex(index)
                
        $scope.editChargeAtIndex = (index) ->
            $location.path("/charges/edit/#{index}")
                
        $scope.addCharge = () ->
            $location.path('/charges/new')
	])

angular.module(nameEditCtrl, []).controller(nameEditCtrl, [
    '$scope'
    '$window'
    '$location'
    '$routeParams'
    'common.services.weeksRepo'
    ($scope, $window, $location, $routeParams, weeksRepo) ->

        $scope.chargesItems = weeksRepo.getChargesItems()

        index = $routeParams.index
        if index?
            $scope.isNew = false
            $scope.week = weeksRepo.get(index)
        else
            $scope.isNew = true
            $scope.week = weeksRepo.create()
        
        $scope.getTotal = () ->
            return weeksRepo.getTotalOfCharge($scope.week)
            
        $scope.addChargeItem = () ->
            item = $window.prompt('Quel est le nom du poste de dépense à ajouter ?')
            $scope.chargesItems.push(item)
            
        $scope.save = () ->
            if ($scope.isNew)
                weeksRepo.add($scope.week)
            else
                weeksRepo.save(index, $scope.week)

            $location.path('/charges/edit')
            
        $scope.cancel = () ->
            $location.path('/charges/edit')
    ])


