let main = () => {

  Structure.main()
  Browser.listenFromWindow(BrowserTypes.window, "load", Status.setStatus)
  ()
}

main()
