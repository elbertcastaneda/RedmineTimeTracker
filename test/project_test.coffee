expect = chai.expect

describe 'project.coffee', ->

  SHOW = { DEFAULT: 0, NOT: 1, SHOW: 2 }

  Project = null
  Chrome = null

  prj1 = null
  prj2 = null
  prj3 = null


  beforeEach () ->
    angular.mock.module('timeTracker')
    inject (_Project_, _Chrome_, _TestData_) ->
      Project = _Project_   # underscores are a trick for resolving references.
      Chrome = _Chrome_
      TestData = _TestData_()
      prj1 = TestData.prj1
      prj2 = TestData.prj2
      prj3 = TestData.prj3


  it 'shoud have working Project service', () ->
    expect(Project.add).not.to.equal null


  ###
   test for get()
  ###
  describe 'get()', ->

    it 'be empty', () ->
      projects = Project.get()
      expect(projects).to.be.empty


  ###
   test for getSelectable()
  ###
  describe 'getSelectable()', ->

    it 'be empty', () ->
      projects = Project.getSelectable()
      expect(projects).to.be.empty

    it 'SHOW.NOT expect to be empty', () ->
      prj =
        url: "https://github.com/ujiro99/RedmineTimeTracker"
        urlIndex: 0
        id: 0
        text: ""
        show: SHOW.NOT
      Project.add(prj)

      projects = Project.getSelectable()
      expect(projects).to.be.empty

    it 'SHOW.DEFAULT expect to not be empty', () ->
      prj =
        url: "https://github.com/ujiro99/RedmineTimeTracker"
        urlIndex: 0
        id: 0
        text: ""
        show: SHOW.DEFAULT
      Project.add(prj)

      projects = Project.getSelectable()
      expect(projects).to.not.be.empty

    it 'SHOW.SHOW expect to not be empty', () ->
      prj =
        url: "https://github.com/ujiro99/RedmineTimeTracker"
        urlIndex: 0
        id: 0
        text: ""
        show: SHOW.SHOW
      Project.add(prj)

      projects = Project.getSelectable()
      expect(projects).to.not.be.empty


  ###
   test for set(newProjects)
  ###
  describe 'set(newProjects)', ->

    it 'set 1 project to empty project', () ->
      expect(Project.get()).to.be.empty
      prj =
        "http://redmine.com" :
          index: 0
          0:
            text: "prj1_0"
            show: SHOW.DEFAULT
      Project.set(prj)
      added = Project.get()
      expect(added[prj1[0].url].index).to.be.equal(prj1[0].urlIndex)
      expect(added[prj1[0].url][prj1[0].id].text).to.be.equal(prj1[0].text)
      expect(added[prj1[0].url][prj1[0].id].show).to.be.equal(prj1[0].show)

    it 'set 1 project to not empty project', () ->
      prePrj =
        "http://redmine.com/projects" :
          index: 2
          0:
            text: "prj1_1"
            show: SHOW.NOT
      Project.set(prePrj)
      expect(Project.get()).to.not.be.empty
      prj =
        "http://redmine.com" :
          index: 0
          0:
            text: "prj1_0"
            show: SHOW.DEFAULT
      Project.set(prj)
      added = Project.get()
      expect(added[prj1[0].url].index).to.be.equal(prj1[0].urlIndex)
      expect(added[prj1[0].url][prj1[0].id].text).to.be.equal(prj1[0].text)
      expect(added[prj1[0].url][prj1[0].id].show).to.be.equal(prj1[0].show)

    it 'set 2 different server\'s project', () ->
      expect(Project.get()).to.be.empty
      prj =
        "http://redmine.com" :
          index: 0
          0:
            text: "prj1_0"
            show: SHOW.DEFAULT
        "http://redmine.com2" :
          index: 1
          0:
            text: "prj2_0"
            show: SHOW.DEFAULT
      Project.set(prj)
      added = Project.get()
      expect(added[prj1[0].url].index).to.be.equal(prj1[0].urlIndex)
      expect(added[prj1[0].url][prj1[0].id].text).to.be.equal(prj1[0].text)
      expect(added[prj1[0].url][prj1[0].id].show).to.be.equal(prj1[0].show)
      expect(added[prj2[0].url].index).to.be.equal(prj2[0].urlIndex)
      expect(added[prj2[0].url][prj2[0].id].text).to.be.equal(prj2[0].text)
      expect(added[prj2[0].url][prj2[0].id].show).to.be.equal(prj2[0].show)

    it 'set 2 different server\'s project', () ->
      expect(Project.get()).to.be.empty
      prj =
        "http://redmine.com" :
          index: 0
          0:
            text: "prj1_0"
            show: SHOW.DEFAULT
        "http://redmine.com2" :
          index: 1
          0:
            text: "prj2_0"
            show: SHOW.DEFAULT
          1:
            text: "prj2_1"
            show: SHOW.DEFAULT
      Project.set(prj)
      added = Project.get()
      expect(added[prj1[0].url].index).to.be.equal(prj1[0].urlIndex)
      expect(added[prj1[0].url][prj1[0].id].text).to.be.equal(prj1[0].text)
      expect(added[prj1[0].url][prj1[0].id].show).to.be.equal(prj1[0].show)
      expect(added[prj2[0].url].index).to.be.equal(prj2[0].urlIndex)
      expect(added[prj2[0].url][prj2[0].id].text).to.be.equal(prj2[0].text)
      expect(added[prj2[0].url][prj2[0].id].show).to.be.equal(prj2[0].show)
      expect(added[prj2[1].url].index).to.be.equal(prj2[1].urlIndex)
      expect(added[prj2[1].url][prj2[1].id].text).to.be.equal(prj2[1].text)
      expect(added[prj2[1].url][prj2[1].id].show).to.be.equal(prj2[1].show)

    it 'set 3 different server\'s project', () ->
      expect(Project.get()).to.be.empty
      prj =
        "http://redmine.com" :
          index: 0
          0:
            text: "prj1_0"
            show: SHOW.DEFAULT
        "http://redmine.com3" :
          index: 2
          0:
            text: "prj3_0"
            show: SHOW.DEFAULT
        "http://redmine.com2" :
          index: 1
          0:
            text: "prj2_0"
            show: SHOW.DEFAULT
      Project.set(prj)
      added = Project.get()
      expect(added[prj1[0].url].index).to.be.equal(prj1[0].urlIndex)
      expect(added[prj1[0].url][prj1[0].id].text).to.be.equal(prj1[0].text)
      expect(added[prj1[0].url][prj1[0].id].show).to.be.equal(prj1[0].show)
      expect(added[prj2[0].url].index).to.be.equal(prj2[0].urlIndex)
      expect(added[prj2[0].url][prj2[0].id].text).to.be.equal(prj2[0].text)
      expect(added[prj2[0].url][prj2[0].id].show).to.be.equal(prj2[0].show)
      expect(added[prj3[0].url].index).to.be.equal(prj3[0].urlIndex)
      expect(added[prj3[0].url][prj3[0].id].text).to.be.equal(prj3[0].text)
      expect(added[prj3[0].url][prj3[0].id].show).to.be.equal(prj3[0].show)


  ###
   test for setParam(url, id, params)
  ###
  describe 'setParam(url, id, params)', ->



  ###
   test for add()
  ###
  describe 'add()', ->

    it 'add 1 project', () ->
      expect(Project.get()).to.be.empty
      Project.add(prj1[0])
      added = Project.get()
      expect(added[prj1[0].url].index).to.be.equal(prj1[0].urlIndex)
      expect(added[prj1[0].url][prj1[0].id].text).to.be.equal(prj1[0].text)
      expect(added[prj1[0].url][prj1[0].id].show).to.be.equal(prj1[0].show)

    it 'update a project', () ->
      expect(Project.get()).to.be.empty

      # create test data
      updated =
        url: "http://redmine.com"
        urlIndex: 0   # same url and urlIndex
        id: 0         # same id
        text: "prj_updated"
        show: SHOW.SHOW

      # execute
      Project.add(prj1[0])
      Project.add(updated)

      # assert
      added = Project.get()
      expect(added[prj1[0].url].index).to.be.equal(prj1[0].urlIndex)
      expect(added[prj1[0].url][prj1[0].id].text).to.not.be.equal(prj1[0].text)
      expect(added[prj1[0].url][prj1[0].id].show).to.not.be.equal(prj1[0].show)
      expect(added[updated.url].index).to.be.equal(updated.urlIndex)
      expect(added[updated.url][updated.id].text).to.be.equal(updated.text)
      expect(added[updated.url][updated.id].show).to.be.equal(updated.show)

    it 'add 2 projects on same redmine server', () ->
      expect(Project.get()).to.be.empty

      # execute
      Project.add(prj1[0])
      Project.add(prj1[1])

      # assert
      added = Project.get()
      expect(added[prj1[0].url].index).to.be.equal(prj1[0].urlIndex)
      expect(added[prj1[0].url][prj1[0].id].text).to.be.equal(prj1[0].text)
      expect(added[prj1[0].url][prj1[0].id].show).to.be.equal(prj1[0].show)
      expect(added[prj1[1].url].index).to.be.equal(prj1[1].urlIndex)
      expect(added[prj1[1].url][prj1[1].id].text).to.be.equal(prj1[1].text)
      expect(added[prj1[1].url][prj1[1].id].show).to.be.equal(prj1[1].show)

    it 'add 2 projects on different redmine server', () ->
      expect(Project.get()).to.be.empty

      # execute
      Project.add(prj1[0])
      Project.add(prj2[0])

      # assert
      added = Project.get()
      expect(added[prj1[0].url].index).to.be.equal(prj1[0].urlIndex)
      expect(added[prj1[0].url][prj1[0].id].text).to.be.equal(prj1[0].text)
      expect(added[prj1[0].url][prj1[0].id].show).to.be.equal(prj1[0].show)
      expect(added[prj2[0].url].index).to.be.equal(prj2[0].urlIndex)
      expect(added[prj2[0].url][prj2[0].id].text).to.be.equal(prj2[0].text)
      expect(added[prj2[0].url][prj2[0].id].show).to.be.equal(prj2[0].show)

    it 'add 3 projects on same redmine server', () ->
      expect(Project.get()).to.be.empty

      # execute
      Project.add(prj1[0])
      Project.add(prj1[1])
      Project.add(prj1[2])

      # assert
      added = Project.get()
      expect(added[prj1[0].url].index).to.be.equal(prj1[0].urlIndex)
      expect(added[prj1[0].url][prj1[0].id].text).to.be.equal(prj1[0].text)
      expect(added[prj1[0].url][prj1[0].id].show).to.be.equal(prj1[0].show)
      expect(added[prj1[1].url].index).to.be.equal(prj1[1].urlIndex)
      expect(added[prj1[1].url][prj1[1].id].text).to.be.equal(prj1[1].text)
      expect(added[prj1[1].url][prj1[1].id].show).to.be.equal(prj1[1].show)
      expect(added[prj1[2].url].index).to.be.equal(prj1[2].urlIndex)
      expect(added[prj1[2].url][prj1[2].id].text).to.be.equal(prj1[2].text)
      expect(added[prj1[2].url][prj1[2].id].show).to.be.equal(prj1[2].show)

    it 'add 3 projects on same/different redmine server', () ->
      expect(Project.get()).to.be.empty

      # execute
      Project.add(prj1[0])
      Project.add(prj2[0])
      Project.add(prj1[1])

      # assert
      added = Project.get()
      expect(added[prj1[0].url].index).to.be.equal(prj1[0].urlIndex)
      expect(added[prj1[0].url][prj1[0].id].text).to.be.equal(prj1[0].text)
      expect(added[prj1[0].url][prj1[0].id].show).to.be.equal(prj1[0].show)
      expect(added[prj2[0].url].index).to.be.equal(prj2[0].urlIndex)
      expect(added[prj2[0].url][prj2[0].id].text).to.be.equal(prj2[0].text)
      expect(added[prj2[0].url][prj2[0].id].show).to.be.equal(prj2[0].show)
      expect(added[prj1[1].url].index).to.be.equal(prj1[1].urlIndex)
      expect(added[prj1[1].url][prj1[1].id].text).to.be.equal(prj1[1].text)
      expect(added[prj1[1].url][prj1[1].id].show).to.be.equal(prj1[1].show)

    it 'add 3 projects on different redmine server', () ->
      expect(Project.get()).to.be.empty

      # execute
      Project.add(prj1[0])
      Project.add(prj2[0])
      Project.add(prj3[0])

      # assert
      added = Project.get()
      expect(added[prj1[0].url].index).to.be.equal(prj1[0].urlIndex)
      expect(added[prj1[0].url][prj1[0].id].text).to.be.equal(prj1[0].text)
      expect(added[prj1[0].url][prj1[0].id].show).to.be.equal(prj1[0].show)
      expect(added[prj2[0].url].index).to.be.equal(prj2[0].urlIndex)
      expect(added[prj2[0].url][prj2[0].id].text).to.be.equal(prj2[0].text)
      expect(added[prj2[0].url][prj2[0].id].show).to.be.equal(prj2[0].show)
      expect(added[prj3[0].url].index).to.be.equal(prj3[0].urlIndex)
      expect(added[prj3[0].url][prj3[0].id].text).to.be.equal(prj3[0].text)
      expect(added[prj3[0].url][prj3[0].id].show).to.be.equal(prj3[0].show)


  ###
   test for remove()
  ###
  describe 'remove()', ->

    it 'should be empty, when remove 1 project from 1 project', () ->
      expect(Project.get()).to.be.empty

      # execute
      Project.add(prj1[0])
      Project.remove(prj1[0].url, prj1[0].id)

      # assert
      added = Project.get()
      expect(added).to.be.empty


    it 'should leaves 2 projects, when remove 1 project from same url 3 projects', () ->
      expect(Project.get()).to.be.empty

      # execute
      Project.add(prj1[0])
      Project.add(prj1[1])  # be removed
      Project.add(prj1[2])
      Project.remove(prj1[1].url, prj1[1].id)

      # assert
      added = Project.get()
      expect(added[prj1[0].url].index).to.be.equal(prj1[0].urlIndex)
      expect(added[prj1[0].url][prj1[0].id].text).to.be.equal(prj1[0].text)
      expect(added[prj1[0].url][prj1[0].id].show).to.be.equal(prj1[0].show)
      expect(added[prj1[1].url][prj1[1].id]).to.be.empty  # removed
      expect(added[prj1[2].url].index).to.be.equal(prj1[2].urlIndex)
      expect(added[prj1[2].url][prj1[2].id].text).to.be.equal(prj1[2].text)
      expect(added[prj1[2].url][prj1[2].id].show).to.be.equal(prj1[2].show)


    it 'should leaves 2 projects, when remove 1 project from different url 3 projects', () ->
      expect(Project.get()).to.be.empty

      # execute
      Project.add(prj1[0])
      Project.add(prj2[0])  # be removed
      Project.add(prj3[0])
      Project.remove(prj2[0].url, prj2[0].id)

      # assert
      added = Project.get()
      expect(added[prj1[0].url].index).to.be.equal(prj1[0].urlIndex)
      expect(added[prj1[0].url][prj1[0].id].text).to.be.equal(prj1[0].text)
      expect(added[prj1[0].url][prj1[0].id].show).to.be.equal(prj1[0].show)
      expect(added[prj2[0].url]).to.be.empty  # removed
      expect(added[prj3[0].url].index).to.be.equal(prj3[0].urlIndex - 1) # update index
      expect(added[prj3[0].url][prj3[0].id].text).to.be.equal(prj3[0].text)
      expect(added[prj3[0].url][prj3[0].id].show).to.be.equal(prj3[0].show)


  ###
   test for removeUrl(url)
  ###
  describe 'removeUrl(url)', ->

    it 'should be empty, when remove 1 project from 3 same url projects.', () ->
      expect(Project.get()).to.be.empty

      # execute
      Project.add(prj1[0])
      Project.add(prj1[1])
      Project.add(prj1[2])
      Project.removeUrl(prj1[0].url)

      # assert
      added = Project.get()
      expect(added).to.be.empty


    it 'should leaves 2 project, when remove 1 url from 3 different url projects.', () ->
      expect(Project.get()).to.be.empty

      # execute
      Project.add(prj1[0])
      Project.add(prj2[0])  # be removed
      Project.add(prj3[0])
      Project.removeUrl(prj2[0].url)

      # assert
      added = Project.get()
      expect(added[prj1[0].url].index).to.be.equal(prj1[0].urlIndex)
      expect(added[prj1[0].url][prj1[0].id].text).to.be.equal(prj1[0].text)
      expect(added[prj1[0].url][prj1[0].id].show).to.be.equal(prj1[0].show)
      expect(added[prj2[0].url]).to.be.empty  # removed
      expect(added[prj3[0].url].index).to.be.equal(prj3[0].urlIndex-1) # updated
      expect(added[prj3[0].url][prj3[0].id].text).to.be.equal(prj3[0].text)
      expect(added[prj3[0].url][prj3[0].id].show).to.be.equal(prj3[0].show)


  ###
   test for load(callback)
  ###
  describe 'load(callback)', ->

    it 'load data.', () ->
      expect(Project.get()).to.be.empty

      # put test data.
      prj =
        "http://redmine.com" :
          index: 0
          0:
            text: "prj1_0"
            show: SHOW.DEFAULT
        "http://redmine.com2" :
          index: 0
          0:
            text: "prj2_0"
            show: SHOW.DEFAULT
        "http://redmine.com3" :
          index: 0
          0:
            text: "prj3_0"
            show: SHOW.DEFAULT
      sinon.stub(Chrome.storage.local, 'get', (arg1, callback) ->
        callback PROJECT: prj
        return true
      )

      Project.load () ->
        loaded = Project.get()
        expect(loaded[prj1[0].url].index).to.be.equal(prj1[0].urlIndex)
        expect(loaded[prj1[0].url][prj1[0].id].text).to.be.equal(prj1[0].text)
        expect(loaded[prj1[0].url][prj1[0].id].show).to.be.equal(prj1[0].show)
        expect(loaded[prj2[0].url].index).to.be.equal(prj2[0].urlIndex)
        expect(loaded[prj2[0].url][prj2[0].id].text).to.be.equal(prj2[0].text)
        expect(loaded[prj2[0].url][prj2[0].id].show).to.be.equal(prj2[0].show)
        expect(loaded[prj3[0].url].index).to.be.equal(prj3[0].urlIndex)
        expect(loaded[prj3[0].url][prj3[0].id].text).to.be.equal(prj3[0].text)
        expect(loaded[prj3[0].url][prj3[0].id].show).to.be.equal(prj3[0].show)


    it 'compatibility: index start changed.', () ->
      expect(Project.get()).to.be.empty

      # put test data.
      # this data is old format.
      prj =
        "http://redmine.com" :
          index: 2
          0:
            text: "prj1_0"
            show: SHOW.DEFAULT
        "http://redmine.com2" :
          index: 3
          0:
            text: "prj2_0"
            show: SHOW.DEFAULT
        "http://redmine.com3" :
          index: 4
          0:
            text: "prj3_0"
            show: SHOW.DEFAULT
      sinon.stub(Chrome.storage.local, 'get', (arg1, callback) ->
        callback PROJECT: prj
        return true
      )

      Project.load () ->
        loaded = Project.get()
        expect(loaded[prj1[0].url].index).to.be.equal(prj1[0].urlIndex)
        expect(loaded[prj1[0].url][prj1[0].id].text).to.be.equal(prj1[0].text)
        expect(loaded[prj1[0].url][prj1[0].id].show).to.be.equal(prj1[0].show)
        expect(loaded[prj2[0].url].index).to.be.equal(prj2[0].urlIndex)
        expect(loaded[prj2[0].url][prj2[0].id].text).to.be.equal(prj2[0].text)
        expect(loaded[prj2[0].url][prj2[0].id].show).to.be.equal(prj2[0].show)
        expect(loaded[prj3[0].url].index).to.be.equal(prj3[0].urlIndex)
        expect(loaded[prj3[0].url][prj3[0].id].text).to.be.equal(prj3[0].text)
        expect(loaded[prj3[0].url][prj3[0].id].show).to.be.equal(prj3[0].show)


