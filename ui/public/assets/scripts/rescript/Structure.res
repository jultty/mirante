open Browser

%%private(let body = getBody())

// navigation menu

type menu_item = { name: string, slug?: string, handler?: (BrowserTypes.event) => promise<unit> }

let create_menu = () => {

  let entities = Meta.schema.entity

  let menu_items = [
    { name: "Início", slug: "/" },
    { name: "Criar conta", handler: Signup.structure },
    { name: "Login", handler: Login.structure },
    { name: "Cursos", handler: View.make_nav_handler(entities.course) },
    { name: "Conjuntos", handler: View.make_nav_handler(entities.exercise_set) },
    { name: "Exercícios", handler: View.make_nav_handler(entities.exercise) },
    { name: "Alternativas", handler: View.make_nav_handler(entities.option) },
    { name: "Responder", handler: Responder.structure },
    { name: "Métricas", handler: Metrics.structure },
  ]

  let menu = makeElement("nav")
  let list = makeElement("ul")

  Array.forEach(menu_items, item => {

    let list_item = makeElement("li")
    let anchor = makeElement("a")
    anchor.innerText = Some(item.name)

    if Option.isSome(item.slug) {
      anchor.href = Some(Option.getOr(item.slug, ""))
    }

    anchor.onclick = switch item.handler {
    | Some(handler) => Some(handler)
    | None => None
    }

    appendChild(list_item, anchor)
    appendChild(list, list_item)

  })

  appendChild(menu, list)
  prepend(body, menu)
}

// main

let create_main = () => {
  let main = makeElement("main")
  appendChild(body, main)
}

// footer

let create_footer = () => {

  let footer = makeElement("footer")
  let hr = makeElement("hr")
  let status_dialog = makeElement("p")
  status_dialog.id = Some("status")
  status_dialog.innerText = Some("Conectando...")

  appendChild(footer, hr)
  appendChild(footer, status_dialog)
  appendChild(body, footer)

}

// user dialog

let create_user_dialog = () => {

  let footer = getElementByTag("footer", "Structure.create_user_dialog")

  let user_dialog = makeElement("p")
  user_dialog.id = Some("user_dialog" )
  before(footer, user_dialog)
}

let main = () => {

  create_menu()
  create_main()
  create_footer()
  create_user_dialog()

}

