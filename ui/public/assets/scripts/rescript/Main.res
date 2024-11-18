let main = () => {

  Structure.main()
  Browser.listenFromWindow(Browser.window, "load", Status.setStatus)
  ()
}

main()
