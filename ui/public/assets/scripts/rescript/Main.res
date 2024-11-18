let main = () => {

  Structure.main()
  Browser.addListener(Browser.window, "load", Status.setStatus)
  ()
}

main()
