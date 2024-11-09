const form = document.getElementById('course_form')
const table = document.getElementById('course_table')
const dialog = document.getElementById('user_dialog')

// AUTHENTICATION

function authenticate() {
  const stored_credentials = sessionStorage.getItem("mirante_credentials")

  if (stored_credentials)
    return JSON.parse(stored_credentials).token
}

// GET

async function update(_) {

  clearChildren(table.id)

  const token = authenticate()

  try {
    const response = await fetch('http://localhost:3031/course', {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${token}`,
      },
    }).then(response => response.json())
  } catch(error) {
    console.log(error)
    dialog.innerText = 'Erro ao obter cursos'
    return
  }

  response.forEach(course => {
    const new_row = document.createElement('tr')
    const new_cell = document.createElement('td')
    new_cell.innerText = course.name
    new_row.appendChild(new_cell)
    table.appendChild(new_row)
  })

}

window.addEventListener('load', update)

// POST

async function create(event) {

  event.preventDefault();
  dialog.innerText = ''

  const token = authenticate()
  const form_data = Object.fromEntries(new FormData(form))

  try {
    const response = await fetch('http://localhost:3031/course', {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${token}`,
      },
      body: JSON.stringify(form_data),
    })
  } catch(error) {
    console.log(error)
    dialog.innerText = 'Erro na requisição'
    return
  }

  update()

  if (response) {
    console.dir(response)
    response_json = await response.json()
  }

  if (response.status == '403') {
    dialog.innerText = 'Permissão negada: ' + response_json.message
    return
  } else if (response.status == '201') {
    dialog.innerText = 'Curso criado com sucesso'
    update(event)
  } else {
    dialog.innerText = 'Erro inesperado: ' + response_json.message
  }
}

form.addEventListener('submit', create)
