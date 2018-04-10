###

Materia
It's a thing

Widget: Privilege Walk

###

# Create an angular module to house our controller
PrivilegeWalk = angular.module 'PrivilegeWalkCreator', ['ngMaterial', 'ngSanitize']

PrivilegeWalk.config ($mdThemingProvider) ->
		$mdThemingProvider.theme('toolbar-dark', 'default')
			.primaryPalette('indigo')
			.dark()

PrivilegeWalk.controller 'PrivilegeWalkController', ($scope, $mdToast, $sanitize, $compile, Resource) ->

	$scope.rangeOptions = {
		0: {text:'Very Often', value: 1}
		1: {text:'Often', value: 2}
		2: {text:'Sometimes', value: 3}
		3: {text:'Rarely', value: 4}
		4: {text:'Never', value: 5}
	}

	$scope.sizes = [
		"small (12-inch)",
		"medium (14-inch)",
		"large (16-inch)",
		"insane (42-inch)",
	]

	$scope.questionTypes = [
		"Preset: Yes / No",
		"Preset: Scale",
		"Custom"
	]

	$scope.title = "My Privilege Walk Widget"
	$scope.cards = []

	questionCount = 0

	$scope.initNewWidget = (widget) ->
		$scope.$apply ->
			setup()

	$scope.initExistingWidget = (title,widget,qset) ->
		$scope.$apply ->
			$scope.title = title
			for item in qset.items
				$scope.cards.push
					question: item.questions[0].text
					isRange: item.options.isRange

				questionCount++

	setup = ->
		$scope.addQuestion()

	$scope.addQuestion = ->
		questionCount++
		rangeOptions = JSON.parse(JSON.stringify($scope.rangeOptions))
		$scope.cards.push {
			'question': 'Question '+questionCount
			'questionType': 0
			'customOptions': {
				'options': rangeOptions
				'dropdown': false
			}
		}

	$scope.changeQuestionType = (index) ->
		prev = $scope.cards[index].questionType
		numTypes = $scope.questionTypes.length
		$scope.cards[index].questionType = (prev + 1) % numTypes

	$scope.deleteQuestion = (index) ->
		if $scope.cards.length <= 1
			$scope.showToast("Must have at least one question.")
			return
		$scope.cards.splice index, 1

	$scope.showToast = (message) ->
		$mdToast.show(
			$mdToast.simple()
				.textContent(message)
				.position('bottom right')
				.hideDelay(3000)
		)

	$scope.onSaveClicked = ->
		_isValid = $scope.validation()

		if _isValid
			qset = Resource.buildQset $scope.title, $scope.cards
			if qset then Materia.CreatorCore.save $scope.title, qset
		else
			Materia.CreatorCore.cancelSave "Please make sure every question is complete"
			return false

	$scope.validation = ->
		$scope.invalid = false

		for card in $scope.cards
			if !card.question
				$scope.invalid = true
				return false
		return true

	$scope.onQuestionImportComplete = (items) ->
		for i in [0...items.length]
			$scope.cards.push
				question: items[i].questions[0].text
				questionType: items[i].options.questionType

	Materia.CreatorCore.start $scope

PrivilegeWalk.factory 'Resource', ($sanitize) ->
	buildQset: (title, questions) ->
		qsetItems = []
		qset = {}

		if title is ''
			Materia.CreatorCore.cancelSave 'Please enter a title.'
			return false

		for question in questions
			item = @processQsetItem question
			if item then qsetItems.push item

		qset.items = qsetItems
		return qset

	processQsetItem: (item, index) ->
		question = $sanitize item.question
		questionType = $sanitize item.questionType

		materiaType: "question"
		id: null
		type: 'MC'
		options: {
			questionType: questionType
		}
		questions: [{ text: question }]
		answers: [
			text: '[No Answer]'
			value: 0
		]