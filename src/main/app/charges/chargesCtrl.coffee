nameListCtrl = 'charges.chargesListViewCtrl'
nameListEditCtrl = 'charges.chargesListEditViewCtrl'
nameEditCtrl = 'charges.chargeEditViewCtrl'

angular.module(nameListCtrl, []).controller(nameListCtrl, [
    '$scope'
    'common.services.env'
    'common.services.chargesRepo'
    ($scope, env, chargesRepo) ->        
        $scope.charges = chargesRepo.getAll()
        $scope.outlaysItems = chargesRepo.getOutlaysItems()
        $scope.google = env.google

        $scope.getTotalOfCharge = (charge) ->
            return chargesRepo.getTotalOfCharge(charge)
	])
    

angular.module(nameListEditCtrl, []).controller(nameListEditCtrl, [
    '$scope'
    '$window'
    '$location'
    'common.services.chargesRepo'
    ($scope, $window, $location, chargesRepo) ->        
        $scope.charges = chargesRepo.getAll()
        $scope.outlaysItems = chargesRepo.getOutlaysItems()
        
        $scope.getTotalOfCharge = (charge) ->
            return chargesRepo.getTotalOfCharge(charge)
            
        $scope.removeChargeAtIndex = (index) ->
            if ($window.confirm('Voulez-vous vraiment supprimé la ligne ?'))
                chargesRepo.removeAtIndex(index)
                
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
    'common.services.chargesRepo'
    ($scope, $window, $location, $routeParams, chargesRepo) ->

        $scope.outlaysItems = chargesRepo.getOutlaysItems()

        index = $routeParams.index
        if index?
            $scope.isNew = false
            $scope.charge = chargesRepo.get(index)
        else
            $scope.isNew = true
            $scope.charge = chargesRepo.create()
        
        $scope.getTotal = () ->
            return chargesRepo.getTotalOfCharge($scope.charge)
            
        $scope.addOutlayItem = () ->
            item = $window.prompt('Quel est le nom du poste de dépense à ajouter ?')
            $scope.outlaysItems.push(item)
            
        $scope.save = () ->
            if ($scope.isNew)
                chargesRepo.add($scope.charge)
            else
                chargesRepo.save(index, $scope.charge)

            $location.path('/charges/edit')
            
        $scope.cancel = () ->
            $location.path('/charges/edit')
    ])


