body = document.getElementsByTagName('body')[0]

// navigation menu

{
  let menu_items = [
    { name: "Início", slug: "index" },
    { name: "Login", slug: "login" },
    { name: "Criar conta", slug: "signup" },
    { name: "Cursos", slug: "course" },
  ]

  let menu = document.createElement('nav')
  let list = document.createElement('ul')

  menu_items.forEach(item => {
    list_item = document.createElement('li')
    anchor = document.createElement('a')
    anchor.innerText = item.name
    anchor.href = item.slug + '.html'
    list_item.appendChild(anchor)
    list.appendChild(list_item)
  })

  menu.appendChild(list)
  body.prepend(menu)
}

// footer

{
  let footer = document.createElement('footer')
  let hr = document.createElement('hr')
  let status_dialog = document.createElement('p')
  status_dialog.id = 'status'
  status_dialog.innerText = 'Conectando...'
  footer.append(hr, status_dialog)
  body.appendChild(footer)
}

// user dialog

{
  let footer = document.getElementsByTagName('footer')[0]
  let user_dialog = document.createElement('p')
  user_dialog.id = 'user_dialog'
  footer.before(user_dialog)
}
