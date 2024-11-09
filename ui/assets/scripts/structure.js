// navigation menu

menu_items = [
  { name: "Início", slug: "index" },
  { name: "Login", slug: "login" },
  { name: "Criar conta", slug: "signup" },
  { name: "Cursos", slug: "course" },
]

body = document.getElementsByTagName('body')[0]

menu = document.createElement('nav')
list = document.createElement('ul')

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
