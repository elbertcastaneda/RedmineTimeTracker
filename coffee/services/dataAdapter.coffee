timeTracker.factory("DataAdapter", (Analytics, EventDispatcher) ->


  ###*
  ###
  class DataModel

    constructor: () ->
      ###*
      # @property account
      # @type AccountModel
      ###
      @account = {}

      ###*
      # @property projects
      # @type Array of ProjectModel
      ###
      @projects = []

      ###*
      # @property tickets
      # @type Array of TicketModel
      ###
      @tickets = []

      ###*
      # @property Activities
      # @type Array of ActivityModel
      ###
      @activities = []

      ###*
      # @property Queries
      # @type Array of QueryModel
      ###
      @queries = []


  class DataAdapter extends EventDispatcher

    ## instance variables

    # event
    ACCOUNT_ADDED:            "account_added"
    ACCOUNT_REMOVED:          "account_removed"
    SELECTED_ACCOUNT_CHANGED: "selected_account_changed"
    SELECTED_PROJECT_CHANGED: "selected_project_changed"
    SELECTED_TICKET_CHANGED:  "selected_ticket_changed"
    SELECTED_QUERY_CHANGED:   "selected_query_changed"

    ###*
    # all data.
    # @param {DataModel}  data's url
    ###
    _data: {}

    # selected ticket.
    selectedTicket: null

    # filtered data.
    _filteredData: []
    @property 'accounts',
      get: -> @_filteredData

    # selected account.
    _selectedAccount: null
    @property 'selectedAccount',
      get: -> @_selectedAccount
      set: (n) ->
        if @_selectedAccount isnt n
          @_selectedAccount = n
          @selectedActivity = @_data[n.url].activities[0]
          @selectedQuery    = @_data[n.url].queries[0]
          @fireEvent(@SELECTED_ACCOUNT_CHANGED, @, n)

    # selected project.
    _selectedProject: null
    @property 'selectedProject',
      get: -> @_selectedProject
      set: (n) ->
        if @_selectedProject isnt n
          @_selectedProject = n
          @selectedAccount = @_data[n.url].account
          @fireEvent(@SELECTED_PROJECT_CHANGED, @, n)

    # selected ticket.
    _selectedTicket: null
    @property 'selectedTicket',
      get: -> @_selectedTicket
      set: (n) ->
        if @_selectedTicket isnt n
          @_selectedTicket = n
          @fireEvent(@SELECTED_TICKET_CHANGED, @, n)

    # selected activity.
    _selectedActivity: null
    @property 'selectedActivity',
      get: -> @_selectedActivity
      set: (n) -> @_selectedActivity = n

    # selected query.
    _selectedQuery: null
    @property 'selectedQuery',
      get: -> @_selectedQuery
      set: (n) ->
        if @_selectedQuery isnt n
          @_selectedQuery = n
          @fireEvent(@SELECTED_QUERY_CHANGED, @, n)


    # query string for projects
    _projectQuery: ""
    @property 'projectQuery',
      get: () -> return @_projectQuery
      set: (query) ->
        # console.time('projectQuery\t')
        @_projectQuery = query
        @_filteredData = []
        if not query? or query.isBlank()
          for url, dataModel of @_data
            @_filteredData.push dataModel.account
            dataModel.account.projects = dataModel.projects
        else
          substrRegexs = query.split(' ').map (q) -> new RegExp(q, 'i')
          for url, dataModel of @_data
            filtered = dataModel.projects.filter (n) ->
              text = n.id + " " + n.text
              return substrRegexs.every (r) -> r.test(text)
            if filtered.length > 0
              @_filteredData.push dataModel.account
              dataModel.account.projects = filtered
        # console.timeEnd('projectQuery\t')

    ###*
    # add accounts
    # @param {Array} accounts - array of AccountModel.
    ###
    addAccounts: (accounts) ->
      if not accounts? or accounts.length is 0 then return
      for a in accounts
        @_data[a.url] = new DataModel()
        @_data[a.url].account = a
      @_filteredData.add(accounts)
      @fireEvent(@ACCOUNT_ADDED, @, accounts)

    ###*
    # remove accounts
    # @param {Array} accounts - array of AccountModel.
    ###
    removeAccounts: (accounts) ->
      if not accounts? or accounts.length is 0 then return
      for a in accounts
        delete @_data[a.url]
        @_filteredData.remove((n) -> return n.url is a.url)
        if @selectedProject.url is a.url
          @selectedProject = @_filteredData[0].projects[0]
      @fireEvent(@ACCOUNT_REMOVED, @, accounts)

    ###*
    # add project to account.
    # if project is already loaded, overwrites by new project.
    # @param {Array} projects - array of ProjectModel.
    ###
    addProjects: (projects) ->
      if not projects? or projects.length is 0 then return
      if not @selectedProject then @selectedProject = projects[0]
      for p in projects
        @_data[projects[0].url].projects.remove((n) -> return n.equals(p))
      @_data[projects[0].url].projects.add(projects)
      for a in @_filteredData when a.url is projects[0].url
        a.projects = a.projects or []
        a.projects.add(projects)

    ###*
    # remove project from account.
    # @param {Array} projects - array of ProjectModel
    ###
    removeProjects: (projects) ->
      if not projects? or projects.length is 0 then return
      for p in projects
        @_data[projects[0].url].projects.remove((n) -> return n.equals(p))
      for a in @_filteredData when a.url is projects[0].url
        a.projects.remove((n) -> return n.equals(p))

    ###*
    # set activites.
    # @param {String} url        - url of redmine server.
    # @param {Array}  activities - array of activiy. activiy: { id: Number, name: String }.
    ###
    setActivities: (url, activities) ->
      if not url? or not activities? then return
      @_data[url].activities = activities


    ###*
    # set queries.
    # @param {String} url      - url of redmine server.
    # @param {Array}  queries  - array of query. query: { id: Number, name: String }.
    ###
    setQueries: (url, queries) ->
      if not url? or not queries? then return
      @_data[url].queries = queries

  return new DataAdapter

)
