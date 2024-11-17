open Browser

%%private(let body = getBody())

// navigation menu

type menu_item = { name: string, slug: string }

let create_menu = () => {

  let menu_items = [
    { name: "Início", slug: "index" },
    { name: "Login", slug: "login" },
    { name: "Criar conta", slug: "signup" },
    { name: "Cursos", slug: "course" },
    ]

  let menu = createElement(doc, "nav")
  let list = createElement(doc, "ul")

  Array.forEach(menu_items, item => {
    let list_item = createElement(doc, "li")
    let anchor = createElement(doc, "a")
    anchor.innerText = Some(item.name)
    anchor.href = Some(item.slug ++ ".html")
    appendChild(list_item, anchor)
    appendChild(list, list_item)
  })

  appendChild(menu, list)
  prepend(body, menu)
}

// main

let create_main = () => {
  let main = createElement(doc, "main")
  appendChild(body, main)
}

// footer

let create_footer = () => {
  let footer = createElement(doc, "footer")
  let hr = createElement(doc, "hr")
  let status_dialog = createElement(doc, "p")
  status_dialog.id = Some("status")
  status_dialog.innerText = Some("Conectando...")
  appendChild(footer, hr)
  appendChild(footer, status_dialog)
  appendChild(body, footer)
}

// user dialog

let create_user_dialog = () => {
  let footer = Option.getExn(getElementsByTagName(doc, "footer")[0], ~message="footer not found")
  let user_dialog = createElement(doc, "p")
  user_dialog.id = Some("user_dialog" )
  before(footer, user_dialog)
}

let main = () => {
  create_menu()
  create_main()
  create_footer()
  create_user_dialog()
}

