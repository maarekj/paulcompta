angular.module('common.directives.chart', [])
.directive('chart', ['$timeout', ($timeout) ->
    return {
        restrict: 'EA'
        scope:
            title: '@title'
            width: '@width'
            height: '@height'
            data: '=data'
            type: '@type'
            selectFn: '&select'
        link: ($scope, $elm, $attr) ->

            chart = null
            
            $scope.$watch 'type', () ->
                if $scope.type == 'column'
                    chart = new google.visualization.ColumnChart($elm[0])
                else if $scope.type == 'pie'
                    chart = new google.visualization.PieChart($elm[0])
                else
                    chart = new google.visualization.LineChart($elm[0])
                
                #Chart selection handler
                google.visualization.events.addListener chart, 'select', () ->
                    selectedItem = chart.getSelection()[0]
                    if selectedItem
                        $scope.$apply () ->
                            $scope.selectFn({selectedRowIndex: selectedItem.row});                    

            draw = () ->
                if !draw.triggered && chart != null
                    draw.triggered = true;
                    $timeout(() ->
                        draw.triggered = false;
                        data = new google.visualization.arrayToDataTable($scope.data)
                        options =
                            'title': $scope.title
                            'width': $scope.width
                            'height': $scope.height

                        chart.draw(data, options)

                        #No raw selected
                        $scope.selectFn({selectedRowIndex: undefined})
                    , 0, true)

            draw()
            
            #Watches, to refresh the chart when its data, title or dimensions change
            $scope.$watch('data', (() -> draw()), true) #true is for deep object equality checking
            $scope.$watch('title', () -> draw())
            $scope.$watch('width', () -> draw())
            $scope.$watch('height', () -> draw())
    }
])