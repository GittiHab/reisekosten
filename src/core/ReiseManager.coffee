class ReiseManager

  constructor: () ->
    @reisen = []
    @observerList = []

  observe: (observer) => @observerList.push observer

  _notify: () =>
    for observer in @observerList
      observer.update()

  add: (reise) =>
    @reisen.push reise
    @_notify()
    return

  remove: (reise) =>
    index = @reisen.indexOf reise
    @reisen.slice index, 1
    @_notify()
    return