function clearChildren(id) {
  element = document.getElementById(id)

  while (element.lastElementChild) {
    element.removeChild(element.lastElementChild)
  }
}
